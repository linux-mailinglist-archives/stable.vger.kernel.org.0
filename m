Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 265E6595285
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 08:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbiHPG3J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 02:29:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbiHPG26 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 02:28:58 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3065635DEB6
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 17:42:53 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id 202so7907952pgc.8
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 17:42:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=V6YniOSdScg3PfIHw1JFyxsGrkEUrJGt2JTlGgjgZBw=;
        b=1uoMR3AtW7jfr3XavNQHvFOvzCWrSL2r5nSgF3qNEdFtilqG7NoIlVD2cFQcUnqwVX
         4+uHZ0NN/pWofec6DVGitXxyGFoiJ/zm73EEmEl/fGxNNstvpyAq2OA1ZxLrQP97x6GM
         63sJ4Ok6a+oUu3P9mA4bctmA6Bown4KMoLxfR0zRAcuzOK0K3aW658eZLcMwfnIdqzt4
         aMT6NFXFeRtPW2uKebYekJEyvWJy6GPSgth4czsEzSYqQ9MED+BewNITGQHXrTmf+tsv
         iWQHsNg1ACrgiGrRqfmk+AT3wSJ3onArMLj56ay+HNlyxpmf6wume0yy/SzCw4bVNFjF
         fRSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=V6YniOSdScg3PfIHw1JFyxsGrkEUrJGt2JTlGgjgZBw=;
        b=jljHbG/G6VDOAreJIwlglOrn6pNnWea6SVX9EYR6tPdJxiR397WiCKJw8jjFQ3QhGn
         Uk/SNiT7awj1OsPaE4rqWB182LTLyl/MhnoOdoZNkBBreD6NKW9McZEfYGRXI7Dpc8Je
         YbagGs2X8w31L97nA+Q61FzDPV9vyfeWovYSoKOgEFHvtaT02p67Qnb4/rqCF8FWsvNo
         rGQ/dxGUkdqOfd6tdGrMdm8Y28wy45lHXS63YoRXh0svikj/CM51xfGRxBfqEjWquSX4
         fxEiilh/VXH7dNi4bGOmgLaNw8MQGIpukBBn4rIIduQ9z8+yVv6GclBWLnzlDGoiiDuY
         iAew==
X-Gm-Message-State: ACgBeo1WBqfQsSheCVRg6Sc7Wn3sGdYmhg24fkj0F7+DiGvvbgTO4bbT
        I8Zt2NZvgOFLG8pxd2v+O2KbMssoCYaOAOyV
X-Google-Smtp-Source: AA6agR5UnNKDE3bwPmdFK+3fY4Tp9efRGw2XytmxDImGoq4XcUUkVZAohRNVRH/WZNt/M9QrHQ6SQw==
X-Received: by 2002:a05:6a00:cc7:b0:52f:2ada:11c5 with SMTP id b7-20020a056a000cc700b0052f2ada11c5mr18545536pfv.19.1660610571308;
        Mon, 15 Aug 2022 17:42:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l13-20020a17090ac58d00b001f2fa09786asm5176665pjt.19.2022.08.15.17.42.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 17:42:50 -0700 (PDT)
Message-ID: <62fae80a.170a0220.442c3.868f@mx.google.com>
Date:   Mon, 15 Aug 2022 17:42:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.136-544-gb1f7647ff9507
Subject: stable-rc/queue/5.10 baseline: 149 runs,
 49 regressions (v5.10.136-544-gb1f7647ff9507)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 149 runs, 49 regressions (v5.10.136-544-gb1f=
7647ff9507)

Regressions Summary
-------------------

platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
at91sam9g20ek                | arm   | lab-broonie     | gcc-10   | at91_dt=
_defconfig          | 1          =

bcm2711-rpi-4-b              | arm64 | lab-collabora   | gcc-10   | defconf=
ig                  | 1          =

cubietruck                   | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =

fsl-ls1028a-rdb              | arm64 | lab-nxp         | gcc-10   | defconf=
ig                  | 1          =

imx6dl-riotboard             | arm   | lab-pengutronix | gcc-10   | imx_v6_=
v7_defconfig        | 1          =

imx6dl-riotboard             | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig         | 1          =

imx6q-sabrelite              | arm   | lab-collabora   | gcc-10   | multi_v=
7_defconfig         | 1          =

imx6qp-sabresd               | arm   | lab-nxp         | gcc-10   | imx_v6_=
v7_defconfig        | 1          =

imx6sx-sdb                   | arm   | lab-nxp         | gcc-10   | imx_v6_=
v7_defconfig        | 1          =

imx6sx-sdb                   | arm   | lab-nxp         | gcc-10   | multi_v=
7_defconfig         | 1          =

imx6ul-14x14-evk             | arm   | lab-nxp         | gcc-10   | imx_v6_=
v7_defconfig        | 1          =

imx6ul-14x14-evk             | arm   | lab-nxp         | gcc-10   | multi_v=
7_defconfig         | 1          =

imx6ul-pico-hobbit           | arm   | lab-pengutronix | gcc-10   | imx_v6_=
v7_defconfig        | 1          =

imx6ul-pico-hobbit           | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig         | 1          =

imx7d-sdb                    | arm   | lab-nxp         | gcc-10   | imx_v6_=
v7_defconfig        | 1          =

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

meson-gxl-s905x-khadas-vim   | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

meson-gxl-s905x-libretech-cc | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

meson-gxl-s905x-libretech-cc | arm64 | lab-broonie     | gcc-10   | defconf=
ig                  | 1          =

meson-gxm-khadas-vim2        | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

meson-sm1-khadas-vim3l       | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

meson-sm1-sei610             | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-broonie     | gcc-10   | defconf=
ig                  | 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-broonie     | gcc-10   | defconf=
ig+arm64-chromebook | 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-collabora   | gcc-10   | defconf=
ig                  | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie     | gcc-10   | defconf=
ig                  | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie     | gcc-10   | defconf=
ig+arm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-broonie     | gcc-10   | defconf=
ig                  | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-broonie     | gcc-10   | defconf=
ig+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie     | gcc-10   | defconf=
ig                  | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie     | gcc-10   | defconf=
ig+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =

rk3288-rock2-square          | arm   | lab-collabora   | gcc-10   | multi_v=
7_defconfig         | 1          =

rk3399-gru-kevin             | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =

sun5i-a13-olinuxino-micro    | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =

sun7i-a20-cubieboard2        | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =

sun7i-a20-cubieboard2        | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig            | 1          =

sun8i-a33-olinuxino          | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig            | 1          =

sun8i-h2-plus-orangepi-r1    | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =

sun8i-h3-orangepi-pc         | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.136-544-gb1f7647ff9507/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.136-544-gb1f7647ff9507
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b1f7647ff950714d3eb2ef0f32c7f84050dd6192 =



Test Regressions
---------------- =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
at91sam9g20ek                | arm   | lab-broonie     | gcc-10   | at91_dt=
_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/62fab072fb799070b2355642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: at91_dt_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91s=
am9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91s=
am9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fab072fb799070b2355=
643
        failing since 2 days (last pass: v5.10.136-25-g54da4071add59, first=
 fail: v5.10.136-78-gf8cc9c11edf75) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
bcm2711-rpi-4-b              | arm64 | lab-collabora   | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fab2cdd39aa9ef54355675

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm64/defconfig/gcc-10/lab-collabora/baseline-bcm2711-r=
pi-4-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm64/defconfig/gcc-10/lab-collabora/baseline-bcm2711-r=
pi-4-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fab2cdd39aa9ef54355=
676
        failing since 2 days (last pass: v5.10.136-25-g54da4071add59, first=
 fail: v5.10.136-78-gf8cc9c11edf75) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
cubietruck                   | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/62fabca806dfd207d135564b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-cubiet=
ruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-cubiet=
ruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fabca806dfd207d1355=
64c
        failing since 2 days (last pass: v5.10.136-25-g54da4071add59, first=
 fail: v5.10.136-78-gf8cc9c11edf75) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
fsl-ls1028a-rdb              | arm64 | lab-nxp         | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fab3258da5c443ed35565f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls1028a-rdb=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls1028a-rdb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fab3258da5c443ed355=
660
        failing since 2 days (last pass: v5.10.136-25-g54da4071add59, first=
 fail: v5.10.136-78-gf8cc9c11edf75) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6dl-riotboard             | arm   | lab-pengutronix | gcc-10   | imx_v6_=
v7_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/62fab53193abf0fedf355649

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline=
-imx6dl-riotboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline=
-imx6dl-riotboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fab53193abf0fedf355=
64a
        failing since 2 days (last pass: v5.10.136-25-g54da4071add59, first=
 fail: v5.10.136-78-gf8cc9c11edf75) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6dl-riotboard             | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62fab274355ef1d5ca35564e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6dl-riotboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6dl-riotboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fab274355ef1d5ca355=
64f
        failing since 2 days (last pass: v5.10.136-25-g54da4071add59, first=
 fail: v5.10.136-78-gf8cc9c11edf75) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6q-sabrelite              | arm   | lab-collabora   | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62fab008c3321f649f355678

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-im=
x6q-sabrelite.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-im=
x6q-sabrelite.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fab008c3321f649f355=
679
        failing since 2 days (last pass: v5.10.136-25-g54da4071add59, first=
 fail: v5.10.136-78-gf8cc9c11edf75) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6qp-sabresd               | arm   | lab-nxp         | gcc-10   | imx_v6_=
v7_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/62fab0f16a3f58bc9735566d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6qp-=
sabresd.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6qp-=
sabresd.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fab0f16a3f58bc97355=
66e
        failing since 2 days (last pass: v5.10.136-25-g54da4071add59, first=
 fail: v5.10.136-78-gf8cc9c11edf75) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6sx-sdb                   | arm   | lab-nxp         | gcc-10   | imx_v6_=
v7_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/62fab1f6f3566abd2e355654

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6sx-=
sdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6sx-=
sdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fab1f6f3566abd2e355=
655
        failing since 2 days (last pass: v5.10.136-25-g54da4071add59, first=
 fail: v5.10.136-78-gf8cc9c11edf75) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6sx-sdb                   | arm   | lab-nxp         | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62fab07bf2eb94efb1355649

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6sx-s=
db.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6sx-s=
db.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fab07bf2eb94efb1355=
64a
        failing since 2 days (last pass: v5.10.136-25-g54da4071add59, first=
 fail: v5.10.136-78-gf8cc9c11edf75) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6ul-14x14-evk             | arm   | lab-nxp         | gcc-10   | imx_v6_=
v7_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/62fab1f9f3566abd2e35566f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul-=
14x14-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul-=
14x14-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fab1f9f3566abd2e355=
670
        failing since 2 days (last pass: v5.10.136-25-g54da4071add59, first=
 fail: v5.10.136-78-gf8cc9c11edf75) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6ul-14x14-evk             | arm   | lab-nxp         | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62fab079f2eb94efb1355643

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul-1=
4x14-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul-1=
4x14-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fab079f2eb94efb1355=
644
        failing since 2 days (last pass: v5.10.136-25-g54da4071add59, first=
 fail: v5.10.136-78-gf8cc9c11edf75) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6ul-pico-hobbit           | arm   | lab-pengutronix | gcc-10   | imx_v6_=
v7_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/62facae9848e691a2435565d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline=
-imx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline=
-imx6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62facae9848e691a24355=
65e
        failing since 2 days (last pass: v5.10.136-25-g54da4071add59, first=
 fail: v5.10.136-78-gf8cc9c11edf75) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6ul-pico-hobbit           | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62fac819fb8f2bfd05355655

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fac819fb8f2bfd05355=
656
        failing since 2 days (last pass: v5.10.136-25-g54da4071add59, first=
 fail: v5.10.136-78-gf8cc9c11edf75) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx7d-sdb                    | arm   | lab-nxp         | gcc-10   | imx_v6_=
v7_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/62fab1059b20c833df355666

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-s=
db.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-s=
db.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fab1059b20c833df355=
667
        failing since 2 days (last pass: v5.10.136-25-g54da4071add59, first=
 fail: v5.10.136-78-gf8cc9c11edf75) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx8mn-ddr4-evk              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fab33289d7c9f343355671

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-ddr=
4-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-ddr=
4-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fab33289d7c9f343355=
672
        failing since 2 days (last pass: v5.10.136-25-g54da4071add59, first=
 fail: v5.10.136-78-gf8cc9c11edf75) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
jetson-tk1                   | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62fadd8f074260dc00355655

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jet=
son-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jet=
son-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fadd8f074260dc00355=
656
        failing since 2 days (last pass: v5.10.136-25-g54da4071add59, first=
 fail: v5.10.136-78-gf8cc9c11edf75) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
jetson-tk1                   | arm   | lab-baylibre    | gcc-10   | tegra_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/62fad82a73f468fa4a35567f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fad82a73f468fa4a355=
680
        failing since 2 days (last pass: v5.10.136-25-g54da4071add59, first=
 fail: v5.10.136-453-gca8ab62d0916d) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-g12a-sei510            | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fab2c7d39aa9ef54355669

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a=
-sei510.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a=
-sei510.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fab2c7d39aa9ef54355=
66a
        failing since 2 days (last pass: v5.10.136-25-g54da4071add59, first=
 fail: v5.10.136-78-gf8cc9c11edf75) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-g12a-u200              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fab2e3aeba4377f4355676

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a=
-u200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a=
-u200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fab2e3aeba4377f4355=
677
        failing since 2 days (last pass: v5.10.136-25-g54da4071add59, first=
 fail: v5.10.136-78-gf8cc9c11edf75) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-g12a-x96-max           | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fab2dbaeba4377f4355661

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a=
-x96-max.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a=
-x96-max.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fab2dbaeba4377f4355=
662
        failing since 2 days (last pass: v5.10.136-25-g54da4071add59, first=
 fail: v5.10.136-78-gf8cc9c11edf75) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fab2cbd39aa9ef54355672

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b=
-a311d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b=
-a311d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fab2cbd39aa9ef54355=
673
        failing since 2 days (last pass: v5.10.136-25-g54da4071add59, first=
 fail: v5.10.136-78-gf8cc9c11edf75) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-collabora   | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fabc0f25243813d6355658

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm64/defconfig/gcc-10/lab-collabora/baseline-meson-g12=
b-a311d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm64/defconfig/gcc-10/lab-collabora/baseline-meson-g12=
b-a311d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fabc0f25243813d6355=
659
        failing since 2 days (last pass: v5.10.136-25-g54da4071add59, first=
 fail: v5.10.136-78-gf8cc9c11edf75) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-g12b-odroid-n2         | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fab47f620de335d7355682

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b=
-odroid-n2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b=
-odroid-n2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fab47f620de335d7355=
683
        failing since 2 days (last pass: v5.10.136-25-g54da4071add59, first=
 fail: v5.10.136-78-gf8cc9c11edf75) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-gxl-s905x-khadas-vim   | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fab2dfaeba4377f435566a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-=
s905x-khadas-vim.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-=
s905x-khadas-vim.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fab2dfaeba4377f4355=
66b
        failing since 2 days (last pass: v5.10.136-25-g54da4071add59, first=
 fail: v5.10.136-78-gf8cc9c11edf75) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62faccb2460a4bba23355664

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-=
s905x-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-=
s905x-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62faccb2460a4bba23355=
665
        failing since 2 days (last pass: v5.10.136-25-g54da4071add59, first=
 fail: v5.10.136-78-gf8cc9c11edf75) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-broonie     | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fab2fc35ca5f17d035564a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s=
905x-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s=
905x-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fab2fc35ca5f17d0355=
64b
        failing since 2 days (last pass: v5.10.136-25-g54da4071add59, first=
 fail: v5.10.136-78-gf8cc9c11edf75) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-gxm-khadas-vim2        | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fab2e0aeba4377f4355670

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm-=
khadas-vim2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm-=
khadas-vim2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fab2e0aeba4377f4355=
671
        failing since 2 days (last pass: v5.10.136-25-g54da4071add59, first=
 fail: v5.10.136-78-gf8cc9c11edf75) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-sm1-khadas-vim3l       | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fab2e1aeba4377f4355673

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-sm1-=
khadas-vim3l.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-sm1-=
khadas-vim3l.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fab2e1aeba4377f4355=
674
        failing since 2 days (last pass: v5.10.136-25-g54da4071add59, first=
 fail: v5.10.136-78-gf8cc9c11edf75) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-sm1-sei610             | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fab2c8d39aa9ef5435566f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-sm1-=
sei610.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-sm1-=
sei610.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fab2c8d39aa9ef54355=
670
        failing since 2 days (last pass: v5.10.136-25-g54da4071add59, first=
 fail: v5.10.136-78-gf8cc9c11edf75) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
qemu_arm64-virt-gicv2        | arm64 | lab-broonie     | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fab2f535ca5f17d0355644

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fab2f535ca5f17d0355=
645
        failing since 20 days (last pass: v5.10.101-110-ge437828b3a54, firs=
t fail: v5.10.133-85-g4c4562ba4bd5) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
qemu_arm64-virt-gicv2        | arm64 | lab-broonie     | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fab612edec5a73fb355648

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fab612edec5a73fb355=
649
        failing since 97 days (last pass: v5.10.113-129-g2a88b987a070, firs=
t fail: v5.10.113-199-g20397cd2a67b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
qemu_arm64-virt-gicv2        | arm64 | lab-collabora   | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fab2d0d39aa9ef5435567a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm6=
4-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm6=
4-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fab2d0d39aa9ef54355=
67b
        failing since 20 days (last pass: v5.10.101-110-ge437828b3a54, firs=
t fail: v5.10.133-85-g4c4562ba4bd5) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie     | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fab2f42871fa9df1355642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fab2f42871fa9df1355=
643
        failing since 97 days (last pass: v5.10.113-129-g2a88b987a070, firs=
t fail: v5.10.113-195-g7c30a988fd24) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie     | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fab6112bdc5f3e0b355648

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fab6112bdc5f3e0b355=
649
        failing since 97 days (last pass: v5.10.113-129-g2a88b987a070, firs=
t fail: v5.10.113-199-g20397cd2a67b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fab7de9d6385564d35564a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fab7de9d6385564d355=
64b
        failing since 97 days (last pass: v5.10.113-129-g2a88b987a070, firs=
t fail: v5.10.113-199-g20397cd2a67b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-broonie     | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fab2ddaeba4377f4355664

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fab2ddaeba4377f4355=
665
        failing since 97 days (last pass: v5.10.113-129-g2a88b987a070, firs=
t fail: v5.10.113-195-g7c30a988fd24) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-broonie     | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fab628d051d42b0935565c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fab628d051d42b09355=
65d
        failing since 97 days (last pass: v5.10.113-129-g2a88b987a070, firs=
t fail: v5.10.113-199-g20397cd2a67b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie     | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fab2f14ac9d552b735565f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fab2f14ac9d552b7355=
660
        failing since 97 days (last pass: v5.10.113-129-g2a88b987a070, firs=
t fail: v5.10.113-195-g7c30a988fd24) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie     | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fab6272bdc5f3e0b35564e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fab6272bdc5f3e0b355=
64f
        failing since 97 days (last pass: v5.10.113-129-g2a88b987a070, firs=
t fail: v5.10.113-199-g20397cd2a67b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fab97dc499a35f21355648

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fab97dc499a35f21355=
649
        failing since 97 days (last pass: v5.10.113-129-g2a88b987a070, firs=
t fail: v5.10.113-199-g20397cd2a67b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
rk3288-rock2-square          | arm   | lab-collabora   | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62fabdf727d98210e835566d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk=
3288-rock2-square.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk=
3288-rock2-square.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fabdf727d98210e8355=
66e
        failing since 2 days (last pass: v5.10.136-25-g54da4071add59, first=
 fail: v5.10.136-78-gf8cc9c11edf75) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
rk3399-gru-kevin             | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fab99a520def3bf6355663

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62fab99a520def3bf6355685
        failing since 160 days (last pass: v5.10.103-56-ge5a40f18f4ce, firs=
t fail: v5.10.103-105-gf074cce6ae0d)

    2022-08-15T21:20:38.150380  <8>[  123.857497] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-08-15T21:20:39.171434  /lava-7042918/1/../bin/lava-test-case
    2022-08-15T21:20:39.182055  <8>[  124.890209] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun5i-a13-olinuxino-micro    | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/62fabe454a75e8b8a435565a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun5i-=
a13-olinuxino-micro.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun5i-=
a13-olinuxino-micro.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fabe454a75e8b8a4355=
65b
        failing since 2 days (last pass: v5.10.136-25-g54da4071add59, first=
 fail: v5.10.136-78-gf8cc9c11edf75) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun7i-a20-cubieboard2        | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/62fab0d96a3f58bc97355668

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7i-=
a20-cubieboard2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7i-=
a20-cubieboard2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fab0d96a3f58bc97355=
669
        failing since 2 days (last pass: v5.10.136-25-g54da4071add59, first=
 fail: v5.10.136-78-gf8cc9c11edf75) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun7i-a20-cubieboard2        | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/62fab0c9bda647a04335564f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun7i-a2=
0-cubieboard2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun7i-a2=
0-cubieboard2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fab0c9bda647a043355=
650
        failing since 2 days (last pass: v5.10.136-25-g54da4071add59, first=
 fail: v5.10.136-78-gf8cc9c11edf75) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-a33-olinuxino          | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/62fab0b5bda647a043355643

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a3=
3-olinuxino.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a3=
3-olinuxino.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fab0b5bda647a043355=
644
        failing since 2 days (last pass: v5.10.136-25-g54da4071add59, first=
 fail: v5.10.136-78-gf8cc9c11edf75) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-h2-plus-orangepi-r1    | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/62fabb0306683cb06c355662

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-=
h2-plus-orangepi-r1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-=
h2-plus-orangepi-r1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fabb0306683cb06c355=
663
        failing since 2 days (last pass: v5.10.136-25-g54da4071add59, first=
 fail: v5.10.136-78-gf8cc9c11edf75) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-h3-orangepi-pc         | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/62fab281355ef1d5ca35565a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3=
-orangepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.136=
-544-gb1f7647ff9507/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3=
-orangepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fab281355ef1d5ca355=
65b
        failing since 2 days (last pass: v5.10.136-25-g54da4071add59, first=
 fail: v5.10.136-78-gf8cc9c11edf75) =

 =20
