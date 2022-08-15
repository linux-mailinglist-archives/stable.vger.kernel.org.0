Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C39E5933C9
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 19:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231309AbiHOREQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 13:04:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229701AbiHOREP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 13:04:15 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8572F27CCC
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 10:04:12 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id gj1so7463683pjb.0
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 10:04:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=skU3OYZ1lu4I5SpVRW4dRtF65gehktrdVzhdEqGm3R8=;
        b=g0Ce94Yi6JGqXe9UMGfvTONkBWU7OUYw93JbmqFSzonRCLVCyZIACoWBb9GEgi4DI0
         0SNjrtl8MvevSHN8evoAy5j2T3cPCvv3H6q90+Dq2LI6VTQfDV960kBpEse23RG6sa0+
         q6nLIZjL7isMUdUMMJFKJnggFxwueEcCYZjWpCcYqJN+1jeEHU5zZqyZAI2Om/SVmanu
         LF6mSSPGkO2JdcUbkl39kwY0QWBWH/2JSCF32Ase3mbfDcvmNQbKqTo6mOTRBbu4uMJp
         6t3fdgCAqRKAEquV8M0KZGvLT5/y8YaHXgkiUXAUXE4vSJtJSZt8LEU7d35cmvi6nmU8
         StUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=skU3OYZ1lu4I5SpVRW4dRtF65gehktrdVzhdEqGm3R8=;
        b=FWkOB/pu76QFdCxME2KEnD5FTFTbEGhNv+oTNoJknC4Es2XS88j0JT+BikUoZ+ZRYf
         1YhKiznhKP/uZucw39X4sDnWSDbvNg9rJCbeibtcSRvfEHWvBw35CfC89KHTi+omb+qi
         kIJ+fD77jsuB1ki2wnlCfDck087yPWtPRAmQEqO97PZcB9UAZfhIKSqhtk28a3H/oB7S
         Kk9TG+TWYsnUEHBK20nW4L8dGj3bnaYtbyBAyYzK/7YKxrFjxmiKAeJOLqoexqLODJEZ
         YGMtibQxlpIjkdz/ZHza+5/fyU6+ZvjT9eNmvDyZd33uihxby0b1VgTK8G78tXU2iHfS
         3rOA==
X-Gm-Message-State: ACgBeo2gtwZZSD6u+eo+RPFkfjSp99ETrnacQINNdKKFxRPyjcCTqYMy
        HII1OemmqRkw1xczsm4OqPvv95ELkpNbrpwe
X-Google-Smtp-Source: AA6agR50UPFTRbQlMmtXXgtc1D4dCNSoSlwDt5WTX2d3ajnseAf8/jDblcynwGHY9AH4xtcn6WL/fQ==
X-Received: by 2002:a17:902:f352:b0:172:661f:b1b with SMTP id q18-20020a170902f35200b00172661f0b1bmr8647664ple.62.1660583051216;
        Mon, 15 Aug 2022 10:04:11 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id nd10-20020a17090b4cca00b001f260b1954bsm4959843pjb.13.2022.08.15.10.04.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 10:04:10 -0700 (PDT)
Message-ID: <62fa7c8a.170a0220.9e062.7f41@mx.google.com>
Date:   Mon, 15 Aug 2022 10:04:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.136-517-g9e37063f15dd9
Subject: stable-rc/linux-5.10.y baseline: 158 runs,
 46 regressions (v5.10.136-517-g9e37063f15dd9)
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

stable-rc/linux-5.10.y baseline: 158 runs, 46 regressions (v5.10.136-517-g9=
e37063f15dd9)

Regressions Summary
-------------------

platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
at91sam9g20ek                | arm   | lab-broonie     | gcc-10   | at91_dt=
_defconfig   | 1          =

bcm2711-rpi-4-b              | arm64 | lab-collabora   | gcc-10   | defconf=
ig           | 1          =

cubietruck                   | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig     | 1          =

fsl-ls1028a-rdb              | arm64 | lab-nxp         | gcc-10   | defconf=
ig           | 1          =

imx6dl-riotboard             | arm   | lab-pengutronix | gcc-10   | imx_v6_=
v7_defconfig | 1          =

imx6dl-riotboard             | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig  | 1          =

imx6q-sabrelite              | arm   | lab-collabora   | gcc-10   | multi_v=
7_defconfig  | 1          =

imx6qp-sabresd               | arm   | lab-nxp         | gcc-10   | imx_v6_=
v7_defconfig | 1          =

imx6sx-sdb                   | arm   | lab-nxp         | gcc-10   | imx_v6_=
v7_defconfig | 1          =

imx6sx-sdb                   | arm   | lab-nxp         | gcc-10   | multi_v=
7_defconfig  | 1          =

imx6ul-14x14-evk             | arm   | lab-nxp         | gcc-10   | imx_v6_=
v7_defconfig | 1          =

imx6ul-14x14-evk             | arm   | lab-nxp         | gcc-10   | multi_v=
7_defconfig  | 1          =

imx6ul-pico-hobbit           | arm   | lab-pengutronix | gcc-10   | imx_v6_=
v7_defconfig | 1          =

imx6ul-pico-hobbit           | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig  | 1          =

imx7d-sdb                    | arm   | lab-nxp         | gcc-10   | imx_v6_=
v7_defconfig | 1          =

imx7ulp-evk                  | arm   | lab-nxp         | gcc-10   | imx_v6_=
v7_defconfig | 1          =

imx7ulp-evk                  | arm   | lab-nxp         | gcc-10   | multi_v=
7_defconfig  | 1          =

imx8mn-ddr4-evk              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig           | 1          =

imx8mn-ddr4-evk              | arm64 | lab-nxp         | gcc-10   | defconf=
ig           | 1          =

jetson-tk1                   | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig  | 1          =

jetson-tk1                   | arm   | lab-baylibre    | gcc-10   | tegra_d=
efconfig     | 1          =

meson-g12a-sei510            | arm64 | lab-baylibre    | gcc-10   | defconf=
ig           | 1          =

meson-g12a-u200              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig           | 1          =

meson-g12a-x96-max           | arm64 | lab-baylibre    | gcc-10   | defconf=
ig           | 1          =

meson-g12b-a311d-khadas-vim3 | arm64 | lab-baylibre    | gcc-10   | defconf=
ig           | 1          =

meson-g12b-a311d-khadas-vim3 | arm64 | lab-collabora   | gcc-10   | defconf=
ig           | 1          =

meson-g12b-odroid-n2         | arm64 | lab-baylibre    | gcc-10   | defconf=
ig           | 1          =

meson-gxbb-p200              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig           | 1          =

meson-gxl-s905x-khadas-vim   | arm64 | lab-baylibre    | gcc-10   | defconf=
ig           | 1          =

meson-gxl-s905x-libretech-cc | arm64 | lab-baylibre    | gcc-10   | defconf=
ig           | 1          =

meson-gxl-s905x-libretech-cc | arm64 | lab-broonie     | gcc-10   | defconf=
ig           | 1          =

meson-gxm-khadas-vim2        | arm64 | lab-baylibre    | gcc-10   | defconf=
ig           | 1          =

meson-sm1-khadas-vim3l       | arm64 | lab-baylibre    | gcc-10   | defconf=
ig           | 1          =

meson-sm1-sei610             | arm64 | lab-baylibre    | gcc-10   | defconf=
ig           | 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-broonie     | gcc-10   | defconf=
ig           | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie     | gcc-10   | defconf=
ig           | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-broonie     | gcc-10   | defconf=
ig           | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie     | gcc-10   | defconf=
ig           | 1          =

rk3288-rock2-square          | arm   | lab-collabora   | gcc-10   | multi_v=
7_defconfig  | 1          =

sun5i-a13-olinuxino-micro    | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig     | 1          =

sun7i-a20-cubieboard2        | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig     | 1          =

sun7i-a20-cubieboard2        | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig     | 1          =

sun8i-a33-olinuxino          | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig     | 1          =

sun8i-h2-plus-orangepi-r1    | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig     | 1          =

sun8i-h2-plus-orangepi-zero  | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig     | 1          =

sun8i-h3-orangepi-pc         | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.136-517-g9e37063f15dd9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.136-517-g9e37063f15dd9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9e37063f15dd9f7858ff0377097a0394b2cd326b =



Test Regressions
---------------- =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
at91sam9g20ek                | arm   | lab-broonie     | gcc-10   | at91_dt=
_defconfig   | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa4544ac26a302f8daf07a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: at91_dt_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at9=
1sam9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at9=
1sam9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa4544ac26a302f8daf=
07b
        new failure (last pass: v5.10.135-24-gcf6f87a93412e) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
bcm2711-rpi-4-b              | arm64 | lab-collabora   | gcc-10   | defconf=
ig           | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa48f0e55d707dfbdaf05f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm64/defconfig/gcc-10/lab-collabora/baseline-bcm2711=
-rpi-4-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm64/defconfig/gcc-10/lab-collabora/baseline-bcm2711=
-rpi-4-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa48f0e55d707dfbdaf=
060
        new failure (last pass: v5.10.135-24-gcf6f87a93412e) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
cubietruck                   | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig     | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa5350e5be1c34cbdaf056

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa5350e5be1c34cbdaf=
057
        new failure (last pass: v5.10.135-24-gcf6f87a93412e) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
fsl-ls1028a-rdb              | arm64 | lab-nxp         | gcc-10   | defconf=
ig           | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa4968282ca0817adaf075

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls1028a-r=
db.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls1028a-r=
db.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa4968282ca0817adaf=
076
        new failure (last pass: v5.10.135-24-gcf6f87a93412e) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
imx6dl-riotboard             | arm   | lab-pengutronix | gcc-10   | imx_v6_=
v7_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa54fc4c93f8d741daf05b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseli=
ne-imx6dl-riotboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseli=
ne-imx6dl-riotboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa54fc4c93f8d741daf=
05c
        new failure (last pass: v5.10.133-168-g4f874431e68c8) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
imx6dl-riotboard             | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa56502e464b6ae1daf05e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baselin=
e-imx6dl-riotboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baselin=
e-imx6dl-riotboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa56502e464b6ae1daf=
05f
        new failure (last pass: v5.10.135-24-gcf6f87a93412e) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
imx6q-sabrelite              | arm   | lab-collabora   | gcc-10   | multi_v=
7_defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa4868969a4aefe2daf0b0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-=
imx6q-sabrelite.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-=
imx6q-sabrelite.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa4868969a4aefe2daf=
0b1
        new failure (last pass: v5.10.135-24-gcf6f87a93412e) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
imx6qp-sabresd               | arm   | lab-nxp         | gcc-10   | imx_v6_=
v7_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa48682b882c7d9cdaf08c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6q=
p-sabresd.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6q=
p-sabresd.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa48682b882c7d9cdaf=
08d
        new failure (last pass: v5.10.133-168-g4f874431e68c8) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
imx6sx-sdb                   | arm   | lab-nxp         | gcc-10   | imx_v6_=
v7_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa49be6bf6729febdaf1ae

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6s=
x-sdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6s=
x-sdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa49be6bf6729febdaf=
1af
        new failure (last pass: v5.10.133-168-g4f874431e68c8) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
imx6sx-sdb                   | arm   | lab-nxp         | gcc-10   | multi_v=
7_defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa4b82eb2ac3cd0fdaf083

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6sx=
-sdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6sx=
-sdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa4b82eb2ac3cd0fdaf=
084
        new failure (last pass: v5.10.135-24-gcf6f87a93412e) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
imx6ul-14x14-evk             | arm   | lab-nxp         | gcc-10   | imx_v6_=
v7_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa49a09200c56d8ddaf08e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6u=
l-14x14-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6u=
l-14x14-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa49a09200c56d8ddaf=
08f
        new failure (last pass: v5.10.128-85-g29ca824cd19a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
imx6ul-14x14-evk             | arm   | lab-nxp         | gcc-10   | multi_v=
7_defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa4b321c77dc6a51daf073

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul=
-14x14-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul=
-14x14-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa4b321c77dc6a51daf=
074
        new failure (last pass: v5.10.135-24-gcf6f87a93412e) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
imx6ul-pico-hobbit           | arm   | lab-pengutronix | gcc-10   | imx_v6_=
v7_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa63c0651538a4da35564e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseli=
ne-imx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseli=
ne-imx6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa63c0651538a4da355=
64f
        new failure (last pass: v5.10.133-168-g4f874431e68c8) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
imx6ul-pico-hobbit           | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa667d1938ca61ca355659

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baselin=
e-imx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baselin=
e-imx6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa667d1938ca61ca355=
65a
        new failure (last pass: v5.10.135-24-gcf6f87a93412e) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
imx7d-sdb                    | arm   | lab-nxp         | gcc-10   | imx_v6_=
v7_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa4a2d9a6d71e219daf056

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d=
-sdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d=
-sdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa4a2d9a6d71e219daf=
057
        new failure (last pass: v5.10.133-168-g4f874431e68c8) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
imx7ulp-evk                  | arm   | lab-nxp         | gcc-10   | imx_v6_=
v7_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa4a7ca92921ece6daf05c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7u=
lp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7u=
lp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa4a7ca92921ece6daf=
05d
        new failure (last pass: v5.10.133-168-g4f874431e68c8) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
imx7ulp-evk                  | arm   | lab-nxp         | gcc-10   | multi_v=
7_defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa4c2016f3c99e4fdaf069

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ul=
p-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ul=
p-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa4c2016f3c99e4fdaf=
06a
        new failure (last pass: v5.10.135-24-gcf6f87a93412e) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
imx8mn-ddr4-evk              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig           | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa4a5da7647692b3daf059

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-d=
dr4-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-d=
dr4-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa4a5da7647692b3daf=
05a
        new failure (last pass: v5.10.135-24-gcf6f87a93412e) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
imx8mn-ddr4-evk              | arm64 | lab-nxp         | gcc-10   | defconf=
ig           | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa49297f79e4cd2ddaf05e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mn-ddr4-e=
vk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mn-ddr4-e=
vk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa49297f79e4cd2ddaf=
05f
        new failure (last pass: v5.10.135-24-gcf6f87a93412e) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
jetson-tk1                   | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa721e3202cbb006355642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-j=
etson-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-j=
etson-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa721e3202cbb006355=
643
        new failure (last pass: v5.10.135-24-gcf6f87a93412e) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
jetson-tk1                   | arm   | lab-baylibre    | gcc-10   | tegra_d=
efconfig     | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa6b3c9630ff56f635568f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jets=
on-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jets=
on-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa6b3c9630ff56f6355=
690
        new failure (last pass: v5.10.132-149-g00d1152b11625) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
meson-g12a-sei510            | arm64 | lab-baylibre    | gcc-10   | defconf=
ig           | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa48deadc3076c60daf07a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g1=
2a-sei510.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g1=
2a-sei510.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa48deadc3076c60daf=
07b
        new failure (last pass: v5.10.135-24-gcf6f87a93412e) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
meson-g12a-u200              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig           | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa48ece55d707dfbdaf059

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g1=
2a-u200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g1=
2a-u200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa48ece55d707dfbdaf=
05a
        new failure (last pass: v5.10.135-24-gcf6f87a93412e) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
meson-g12a-x96-max           | arm64 | lab-baylibre    | gcc-10   | defconf=
ig           | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa490440db622931daf073

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g1=
2a-x96-max.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g1=
2a-x96-max.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa490440db622931daf=
074
        new failure (last pass: v5.10.135-24-gcf6f87a93412e) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-baylibre    | gcc-10   | defconf=
ig           | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa4a6ca92921ece6daf057

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g1=
2b-a311d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g1=
2b-a311d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa4a6ca92921ece6daf=
058
        new failure (last pass: v5.10.135-24-gcf6f87a93412e) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-collabora   | gcc-10   | defconf=
ig           | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa56ebdff60871b6daf056

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm64/defconfig/gcc-10/lab-collabora/baseline-meson-g=
12b-a311d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm64/defconfig/gcc-10/lab-collabora/baseline-meson-g=
12b-a311d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa56ebdff60871b6daf=
057
        new failure (last pass: v5.10.135-24-gcf6f87a93412e) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
meson-g12b-odroid-n2         | arm64 | lab-baylibre    | gcc-10   | defconf=
ig           | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa492e7f79e4cd2ddaf086

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g1=
2b-odroid-n2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g1=
2b-odroid-n2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa492e7f79e4cd2ddaf=
087
        new failure (last pass: v5.10.135-24-gcf6f87a93412e) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
meson-gxbb-p200              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig           | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa49a249f2ebdb9fdaf0ad

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gx=
bb-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gx=
bb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa49a249f2ebdb9fdaf=
0ae
        new failure (last pass: v5.10.135-24-gcf6f87a93412e) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
meson-gxl-s905x-khadas-vim   | arm64 | lab-baylibre    | gcc-10   | defconf=
ig           | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa48ef40db622931daf062

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gx=
l-s905x-khadas-vim.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gx=
l-s905x-khadas-vim.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa48ef40db622931daf=
063
        new failure (last pass: v5.10.135-24-gcf6f87a93412e) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-baylibre    | gcc-10   | defconf=
ig           | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa513427491cf77fdaf06b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gx=
l-s905x-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gx=
l-s905x-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa513427491cf77fdaf=
06c
        new failure (last pass: v5.10.135-24-gcf6f87a93412e) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-broonie     | gcc-10   | defconf=
ig           | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa494bc6c34ac530daf06e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl=
-s905x-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl=
-s905x-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa494bc6c34ac530daf=
06f
        new failure (last pass: v5.10.135-24-gcf6f87a93412e) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
meson-gxm-khadas-vim2        | arm64 | lab-baylibre    | gcc-10   | defconf=
ig           | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa48db3f55a3ccd2daf069

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gx=
m-khadas-vim2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gx=
m-khadas-vim2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa48db3f55a3ccd2daf=
06a
        new failure (last pass: v5.10.135-24-gcf6f87a93412e) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
meson-sm1-khadas-vim3l       | arm64 | lab-baylibre    | gcc-10   | defconf=
ig           | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa490040db622931daf06d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-sm=
1-khadas-vim3l.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-sm=
1-khadas-vim3l.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa490040db622931daf=
06e
        new failure (last pass: v5.10.135-24-gcf6f87a93412e) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
meson-sm1-sei610             | arm64 | lab-baylibre    | gcc-10   | defconf=
ig           | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa490201570e4ef1daf058

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-sm=
1-sei610.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-sm=
1-sei610.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa490201570e4ef1daf=
059
        new failure (last pass: v5.10.135-24-gcf6f87a93412e) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
qemu_arm64-virt-gicv2        | arm64 | lab-broonie     | gcc-10   | defconf=
ig           | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa50d542d2cc2e9adaf077

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm6=
4-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm6=
4-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa50d542d2cc2e9adaf=
078
        failing since 97 days (last pass: v5.10.113-130-g0412f4bd3360, firs=
t fail: v5.10.113-187-g3dca4fac0d16) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie     | gcc-10   | defconf=
ig           | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa5112d6331ef8c1daf056

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm6=
4-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm6=
4-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa5112d6331ef8c1daf=
057
        failing since 97 days (last pass: v5.10.113-130-g0412f4bd3360, firs=
t fail: v5.10.113-187-g3dca4fac0d16) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-broonie     | gcc-10   | defconf=
ig           | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa511303e38996addaf075

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm6=
4-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm6=
4-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa511303e38996addaf=
076
        failing since 97 days (last pass: v5.10.113-130-g0412f4bd3360, firs=
t fail: v5.10.113-187-g3dca4fac0d16) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie     | gcc-10   | defconf=
ig           | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa50fd4cb1931d2edaf05e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm6=
4-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm6=
4-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa50fd4cb1931d2edaf=
05f
        failing since 97 days (last pass: v5.10.113-130-g0412f4bd3360, firs=
t fail: v5.10.113-187-g3dca4fac0d16) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
rk3288-rock2-square          | arm   | lab-collabora   | gcc-10   | multi_v=
7_defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa61988b619da832355642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-=
rk3288-rock2-square.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-=
rk3288-rock2-square.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa61988b619da832355=
643
        new failure (last pass: v5.10.135-24-gcf6f87a93412e) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
sun5i-a13-olinuxino-micro    | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig     | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa569c3220288bd0daf06b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun5=
i-a13-olinuxino-micro.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun5=
i-a13-olinuxino-micro.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa569c3220288bd0daf=
06c
        new failure (last pass: v5.10.135-24-gcf6f87a93412e) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
sun7i-a20-cubieboard2        | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig     | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa45f67a2556ed30daf076

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7=
i-a20-cubieboard2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7=
i-a20-cubieboard2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa45f67a2556ed30daf=
077
        new failure (last pass: v5.10.135-24-gcf6f87a93412e) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
sun7i-a20-cubieboard2        | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig     | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa4578111857c120daf080

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun7i-=
a20-cubieboard2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun7i-=
a20-cubieboard2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa4578111857c120daf=
081
        new failure (last pass: v5.10.135-24-gcf6f87a93412e) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
sun8i-a33-olinuxino          | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig     | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa458d6fc0f69d91daf056

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-=
a33-olinuxino.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-=
a33-olinuxino.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa458d6fc0f69d91daf=
057
        new failure (last pass: v5.10.135-24-gcf6f87a93412e) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
sun8i-h2-plus-orangepi-r1    | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig     | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa535a9b55516e3adaf06c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h2-plus-orangepi-r1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h2-plus-orangepi-r1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa535a9b55516e3adaf=
06d
        new failure (last pass: v5.10.131) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
sun8i-h2-plus-orangepi-zero  | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig     | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa761489e579d836355642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h2-plus-orangepi-zero.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h2-plus-orangepi-zero.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa761489e579d836355=
643
        new failure (last pass: v5.10.135-24-gcf6f87a93412e) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
sun8i-h3-orangepi-pc         | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig     | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa46cc77e5fb70bbdaf092

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-=
h3-orangepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-517-g9e37063f15dd9/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-=
h3-orangepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa46cc77e5fb70bbdaf=
093
        new failure (last pass: v5.10.135-24-gcf6f87a93412e) =

 =20
