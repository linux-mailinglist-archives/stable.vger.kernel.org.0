Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D3CD595345
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 09:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231556AbiHPHC2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 03:02:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbiHPHBe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 03:01:34 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E40DC14A1C2
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 19:54:47 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id q19so8215409pfg.8
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 19:54:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=/UbIVE6CalJIYdMutFCGuWnBLTnFIySdAj1wlkv4dAo=;
        b=VjphRVE/BSJUiCll6djxqGKiKw5Qu2Sm14XMYg3NE57dj4emPYW3lNfm0eD0vGvrfz
         srNjsp1DysMw/+8k+yKawGktQiaJB8KbqyyZfmtSzWvaAFkAbsOt/QyZVh8yFisqkZ+S
         H5DWdl6InISZ+FsMLpAkrJLxdwyeIleT0tJf3Yf3T+A6f7d28oMa4bNQmV2HUfWB0Isg
         VXyoE4tnUVeXolvSg4gXoAflP4K6S405oA8V/u99M7DeymaLWOWLt+YH/OlwW/d3xZTU
         dAnw0fzoRzpYoyviae2XpNM3a3l3CuTI8E67hokWWEGYm0PCQBjz5mwfkAU+0tetzbRH
         XuMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=/UbIVE6CalJIYdMutFCGuWnBLTnFIySdAj1wlkv4dAo=;
        b=EW8ps4alKbevnwsIFQADUZvJt299NNEAnKPVMh9bia7HxMfM30+bffJr6jVyqBUI24
         38pEZTT6Nvn48SCvflc3v7Bc9yxQH2adfkHZeA+X4Kw8dApx/3i8lElsEoBvrxk+mQqf
         iXCexQ6kAJoaFiC3BxVQm+mpDqm1zTR/phqrBvEoU6ce642xtmU/K6pibEGPFBRKIhAu
         M3j8S6pfqeg8ZWOp90zc87iNsQBtK2hcUSKcU6HB+qJCEpLltj5Yz0IEbaSfXqTFPAGL
         9PPSwptnvPgBxXpStYIheRfmDBdGnFks71cabjVqSX3VNQ6scHs3L/zC7vEBMC60HsLe
         fGmQ==
X-Gm-Message-State: ACgBeo1QyxumXjvoek2R6PuXjwVESRu3AB2f6/jN4F1pxb9RuoHcibUn
        KTKJbqrupzhsSOnU9rhz7c15H8Y7EVjHa3da
X-Google-Smtp-Source: AA6agR4LkrKq+fDoz6Y8Alwo2gEaVvBe04VLbUEZtCo0ycQKzeF+Ta94UlpsmTt34qlUmzhFHmaOBA==
X-Received: by 2002:a63:6884:0:b0:415:b761:efa4 with SMTP id d126-20020a636884000000b00415b761efa4mr16657515pgc.274.1660618486748;
        Mon, 15 Aug 2022 19:54:46 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id gb10-20020a17090b060a00b001f4e0c71af4sm5277905pjb.28.2022.08.15.19.54.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 19:54:46 -0700 (PDT)
Message-ID: <62fb06f6.170a0220.bc751.8805@mx.google.com>
Date:   Mon, 15 Aug 2022 19:54:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.18.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.17-1096-g56bd9e4c28e9e
Subject: stable-rc/linux-5.18.y baseline: 151 runs,
 41 regressions (v5.18.17-1096-g56bd9e4c28e9e)
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

stable-rc/linux-5.18.y baseline: 151 runs, 41 regressions (v5.18.17-1096-g5=
6bd9e4c28e9e)

Regressions Summary
-------------------

platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
at91sam9g20ek                | arm   | lab-broonie     | gcc-10   | at91_dt=
_defconfig          | 1          =

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

imx6qp-wandboard-revd1       | arm   | lab-pengutronix | gcc-10   | imx_v6_=
v7_defconfig        | 1          =

imx6qp-wandboard-revd1       | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig         | 1          =

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

imx7d-sdb                    | arm   | lab-nxp         | gcc-10   | imx_v6_=
v7_defconfig        | 1          =

imx7d-sdb                    | arm   | lab-nxp         | gcc-10   | multi_v=
7_defconfig         | 1          =

imx8mn-ddr4-evk              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

imx8mn-ddr4-evk              | arm64 | lab-nxp         | gcc-10   | defconf=
ig                  | 1          =

kontron-bl-imx8mm            | arm64 | lab-kontron     | gcc-10   | defconf=
ig                  | 1          =

kontron-pitx-imx8m           | arm64 | lab-kontron     | gcc-10   | defconf=
ig                  | 1          =

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

mt8183-kukui-...uniper-sku16 | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =

panda                        | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 1          =

rk3288-rock2-square          | arm   | lab-collabora   | gcc-10   | multi_v=
7_defconfig         | 1          =

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.18.y/ker=
nel/v5.18.17-1096-g56bd9e4c28e9e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.18.y
  Describe: v5.18.17-1096-g56bd9e4c28e9e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      56bd9e4c28e9ed65e07e7148e65adfdf1f1c5524 =



Test Regressions
---------------- =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
at91sam9g20ek                | arm   | lab-broonie     | gcc-10   | at91_dt=
_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/62fad2af9905880e523556ab

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: at91_dt_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at9=
1sam9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at9=
1sam9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fad2af9905880e52355=
6ac
        failing since 0 day (last pass: v5.18.16, first fail: v5.18.17-1079=
-gb280aa862bc2b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
cubietruck                   | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/62faddf485ac5b62e8355661

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62faddf485ac5b62e8355=
662
        failing since 0 day (last pass: v5.18.16, first fail: v5.18.17-1079=
-gb280aa862bc2b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
fsl-ls1028a-rdb              | arm64 | lab-nxp         | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fad4fa3cd86f40ea355645

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls1028a-r=
db.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls1028a-r=
db.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fad4fa3cd86f40ea355=
646
        new failure (last pass: v5.18.14-248-g7e8a7b1c98057) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6dl-riotboard             | arm   | lab-pengutronix | gcc-10   | imx_v6_=
v7_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/62fad561e38166106e35564f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseli=
ne-imx6dl-riotboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseli=
ne-imx6dl-riotboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fad561e38166106e355=
650
        failing since 0 day (last pass: v5.18.16, first fail: v5.18.17-1079=
-gb280aa862bc2b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6dl-riotboard             | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62fadad9adcee74ee0355646

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baselin=
e-imx6dl-riotboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baselin=
e-imx6dl-riotboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fadad9adcee74ee0355=
647
        failing since 0 day (last pass: v5.18.14-248-g7e8a7b1c98057, first =
fail: v5.18.17-1079-gb280aa862bc2b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6q-sabrelite              | arm   | lab-collabora   | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62fad68a02118fcad035564b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-=
imx6q-sabrelite.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-=
imx6q-sabrelite.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fad68a02118fcad0355=
64c
        failing since 0 day (last pass: v5.18.14-248-g7e8a7b1c98057, first =
fail: v5.18.17-1079-gb280aa862bc2b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6qp-sabresd               | arm   | lab-nxp         | gcc-10   | imx_v6_=
v7_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/62fad2da9f46981e8835567c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6q=
p-sabresd.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6q=
p-sabresd.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fad2da9f46981e88355=
67d
        failing since 0 day (last pass: v5.18.16, first fail: v5.18.17-1079=
-gb280aa862bc2b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6qp-wandboard-revd1       | arm   | lab-pengutronix | gcc-10   | imx_v6_=
v7_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/62fad241947f10496e355648

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseli=
ne-imx6qp-wandboard-revd1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseli=
ne-imx6qp-wandboard-revd1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fad241947f10496e355=
649
        failing since 0 day (last pass: v5.18.16, first fail: v5.18.17-1079=
-gb280aa862bc2b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6qp-wandboard-revd1       | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62fad562e38166106e355655

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baselin=
e-imx6qp-wandboard-revd1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baselin=
e-imx6qp-wandboard-revd1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fad562e38166106e355=
656
        failing since 0 day (last pass: v5.18.14-248-g7e8a7b1c98057, first =
fail: v5.18.17-1079-gb280aa862bc2b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6sx-sdb                   | arm   | lab-nxp         | gcc-10   | imx_v6_=
v7_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/62fad2b72551a6922d355645

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6s=
x-sdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6s=
x-sdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fad2b72551a6922d355=
646
        failing since 0 day (last pass: v5.18.16, first fail: v5.18.17-1079=
-gb280aa862bc2b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6sx-sdb                   | arm   | lab-nxp         | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62fad64a2ca1cec27c355661

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6sx=
-sdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6sx=
-sdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fad64a2ca1cec27c355=
662
        failing since 0 day (last pass: v5.18.14-248-g7e8a7b1c98057, first =
fail: v5.18.17-1079-gb280aa862bc2b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6ul-14x14-evk             | arm   | lab-nxp         | gcc-10   | imx_v6_=
v7_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/62fad2ee9f3e8c0c97355645

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6u=
l-14x14-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6u=
l-14x14-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fad2ee9f3e8c0c97355=
646
        failing since 0 day (last pass: v5.18.8-7-g2c9a64b3a872, first fail=
: v5.18.17-1079-gb280aa862bc2b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6ul-14x14-evk             | arm   | lab-nxp         | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62fad672c0c5989fef355649

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul=
-14x14-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul=
-14x14-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fad672c0c5989fef355=
64a
        failing since 0 day (last pass: v5.18.8-7-g2c9a64b3a872, first fail=
: v5.18.17-1079-gb280aa862bc2b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6ul-pico-hobbit           | arm   | lab-pengutronix | gcc-10   | imx_v6_=
v7_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/62faf2d6dffc0c2ba0355669

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseli=
ne-imx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseli=
ne-imx6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62faf2d6dffc0c2ba0355=
66a
        failing since 14 days (last pass: v5.18.14, first fail: v5.18.14-24=
8-g7e8a7b1c98057) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx7d-sdb                    | arm   | lab-nxp         | gcc-10   | imx_v6_=
v7_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/62fad2f09f3e8c0c97355653

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d=
-sdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d=
-sdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fad2f09f3e8c0c97355=
654
        failing since 0 day (last pass: v5.18.16, first fail: v5.18.17-1079=
-gb280aa862bc2b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx7d-sdb                    | arm   | lab-nxp         | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62fad6365b21e89bf235564e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-=
sdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-=
sdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fad6365b21e89bf2355=
64f
        failing since 0 day (last pass: v5.18.14-248-g7e8a7b1c98057, first =
fail: v5.18.17-1079-gb280aa862bc2b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx8mn-ddr4-evk              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fad4f93cd86f40ea355642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-d=
dr4-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-d=
dr4-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fad4f93cd86f40ea355=
643
        new failure (last pass: v5.18.14-248-g7e8a7b1c98057) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx8mn-ddr4-evk              | arm64 | lab-nxp         | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fad4f7fd2ea9c1a8355674

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mn-ddr4-e=
vk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mn-ddr4-e=
vk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fad4f7fd2ea9c1a8355=
675
        new failure (last pass: v5.18.14-248-g7e8a7b1c98057) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
kontron-bl-imx8mm            | arm64 | lab-kontron     | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fad48487a18a7d9e35565a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-b=
l-imx8mm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-b=
l-imx8mm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fad48487a18a7d9e355=
65b
        new failure (last pass: v5.18.14-248-g7e8a7b1c98057) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
kontron-pitx-imx8m           | arm64 | lab-kontron     | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fad4704ffa5105e435568f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-p=
itx-imx8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-p=
itx-imx8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fad4704ffa5105e4355=
690
        new failure (last pass: v5.18.14-248-g7e8a7b1c98057) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-g12a-sei510            | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fad44f54faf054a8355647

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g1=
2a-sei510.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g1=
2a-sei510.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fad44f54faf054a8355=
648
        new failure (last pass: v5.18.14) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-g12a-u200              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fad48787a18a7d9e35567b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g1=
2a-u200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g1=
2a-u200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fad48787a18a7d9e355=
67c
        new failure (last pass: v5.18.11-62-g18f94637a014) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-g12a-x96-max           | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fad4634ffa5105e4355650

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g1=
2a-x96-max.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g1=
2a-x96-max.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fad4634ffa5105e4355=
651
        new failure (last pass: v5.18.14) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fad672365eed96ce35565f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g1=
2b-a311d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g1=
2b-a311d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fad672365eed96ce355=
660
        new failure (last pass: v5.18.11-62-g18f94637a014) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-collabora   | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fade0135dc755d5b355661

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm64/defconfig/gcc-10/lab-collabora/baseline-meson-g=
12b-a311d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm64/defconfig/gcc-10/lab-collabora/baseline-meson-g=
12b-a311d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fade0135dc755d5b355=
662
        new failure (last pass: v5.18.11-62-g18f94637a014) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-g12b-odroid-n2         | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fad6074ff8394c6535564d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g1=
2b-odroid-n2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g1=
2b-odroid-n2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fad6074ff8394c65355=
64e
        new failure (last pass: v5.18.14) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-gxl-s905x-khadas-vim   | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fad46a4ffa5105e4355683

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gx=
l-s905x-khadas-vim.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gx=
l-s905x-khadas-vim.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fad46a4ffa5105e4355=
684
        new failure (last pass: v5.18.9-103-g7622cfa48fbd) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fb04480fd326b934355648

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gx=
l-s905x-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gx=
l-s905x-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fb04480fd326b934355=
649
        new failure (last pass: v5.18.14-248-g7e8a7b1c98057) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-broonie     | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fad45d8bc3d8a03d35564d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl=
-s905x-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl=
-s905x-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fad45d8bc3d8a03d355=
64e
        new failure (last pass: v5.18.14-248-g7e8a7b1c98057) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-gxm-khadas-vim2        | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fad4684ffa5105e4355680

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gx=
m-khadas-vim2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gx=
m-khadas-vim2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fad4684ffa5105e4355=
681
        new failure (last pass: v5.18.9-103-g7622cfa48fbd) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-sm1-khadas-vim3l       | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fad48580aba4d0df355650

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-sm=
1-khadas-vim3l.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-sm=
1-khadas-vim3l.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fad48580aba4d0df355=
651
        new failure (last pass: v5.18.12-232-ga04b1a5cb7d28) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-sm1-sei610             | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fad46d4ffa5105e4355686

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-sm=
1-sei610.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-sm=
1-sei610.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fad46d4ffa5105e4355=
687
        new failure (last pass: v5.18.14) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
mt8183-kukui-...uniper-sku16 | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fad3cebdeac8c5f4355656

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora=
/baseline-mt8183-kukui-jacuzzi-juniper-sku16.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora=
/baseline-mt8183-kukui-jacuzzi-juniper-sku16.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fad3cfbdeac8c5f4355=
657
        new failure (last pass: v5.18.16) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
panda                        | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62fad901506c71ccf3355649

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-p=
anda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-p=
anda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fad901506c71ccf3355=
64a
        failing since 0 day (last pass: v5.18.14, first fail: v5.18.17-1079=
-gb280aa862bc2b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
rk3288-rock2-square          | arm   | lab-collabora   | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62faf65a2a2896d3fc355659

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-=
rk3288-rock2-square.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-=
rk3288-rock2-square.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62faf65a2a2896d3fc355=
65a
        failing since 0 day (last pass: v5.18.14-248-g7e8a7b1c98057, first =
fail: v5.18.17-1079-gb280aa862bc2b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun5i-a13-olinuxino-micro    | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/62fad0684e98d93c7435565a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun5=
i-a13-olinuxino-micro.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun5=
i-a13-olinuxino-micro.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fad0684e98d93c74355=
65b
        failing since 0 day (last pass: v5.18.14, first fail: v5.18.17-1079=
-gb280aa862bc2b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun7i-a20-cubieboard2        | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/62fad01ea57deed490355660

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7=
i-a20-cubieboard2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7=
i-a20-cubieboard2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fad01ea57deed490355=
661
        failing since 0 day (last pass: v5.18.16, first fail: v5.18.17-1079=
-gb280aa862bc2b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun7i-a20-cubieboard2        | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/62fad00df5aee2bd2c355643

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun7i-=
a20-cubieboard2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun7i-=
a20-cubieboard2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fad00df5aee2bd2c355=
644
        failing since 0 day (last pass: v5.18.16, first fail: v5.18.17-1079=
-gb280aa862bc2b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-a33-olinuxino          | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/62fad0218461324e8f35565b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-=
a33-olinuxino.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-=
a33-olinuxino.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fad0218461324e8f355=
65c
        failing since 0 day (last pass: v5.18.16, first fail: v5.18.17-1079=
-gb280aa862bc2b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-h2-plus-orangepi-r1    | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/62fad944c9d5fc59d135565f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h2-plus-orangepi-r1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h2-plus-orangepi-r1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fad944c9d5fc59d1355=
660
        failing since 0 day (last pass: v5.18.16, first fail: v5.18.17-1079=
-gb280aa862bc2b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-h3-orangepi-pc         | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/62fad16149784ec537355650

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-=
h3-orangepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.1=
7-1096-g56bd9e4c28e9e/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-=
h3-orangepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fad16149784ec537355=
651
        failing since 0 day (last pass: v5.18.16, first fail: v5.18.17-1079=
-gb280aa862bc2b) =

 =20
