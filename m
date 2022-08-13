Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5982591CA8
	for <lists+stable@lfdr.de>; Sat, 13 Aug 2022 23:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240389AbiHMVEy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Aug 2022 17:04:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240382AbiHMVEx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Aug 2022 17:04:53 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03D6E11A2E
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 14:04:50 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id m2so3458774pls.4
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 14:04:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=T98S+yWVaIZfcr8lRGYBm3fUlmJ65nDH2RvzzbIsDHA=;
        b=b3Zpu7kwrKDrdVwJQcLIiOHNrvjP+hjFmf7Vfz1G9saC0tyVdWRdLn1faZjUjT502s
         +LCIjgKJS2IEBPY91Kfw4USqdTKS/QlskUIok093tVLuw/LxfTvVDVfzike48mrG3edN
         mjFtL54Hdg47bMlkoMoVrXPo62CG0/iFOXVYqidNp593iRDJ/Yh/SDufsJ9v9aJOFlcK
         dF6RAfJXrV6n+ZGEEWaHInt21NzojIAJs0oZ3cCbLGjBs+hJAkOo0dmL+kPoddt8u6Bi
         4HFvGtgHic9Cqx2/jLFuOAo0LLj7cJo/lunv4+v/LoCgaG++51DGkVbbHRgcNAiwyRNz
         7kxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=T98S+yWVaIZfcr8lRGYBm3fUlmJ65nDH2RvzzbIsDHA=;
        b=NQeCQqtDF3Pafen/6FZrQXgW17fQFkTYezbd0mPzWwXzaUQSCK5q7YVpFZxQxKPP39
         7sbRmvz1sF28QNQfw3g7P2NN3tTpI/9MYmZcQxHnys56jKZooUczdo8MIw2oQscPv13Q
         YxtWYKEjOXPazJSQnoGkTnF8oLDXQDWJyBDQVGHddk5O3Z3ZFuuyq24WoznWSmCPiRo+
         4L3sBUaJh5/oQ1V1Jj1AHfoKgxi8cq0uYfE3ghTqhWg+zlhSebngzpiCJGm4wdGoPNdh
         tuIiWNttgthgYj+PxR10WnTFYLZJx0ogJac/5xEcTUefpA9TiCXghVpuwr8YTYsF2KYl
         XZ+A==
X-Gm-Message-State: ACgBeo2xxgNDTYqySTy02sBB4hUZxpl1tddDjl0GEvUbxQTGGC0a0c0E
        d9Qrb5yCivDChYHkrHdgMbvueWslMFNxfj1i
X-Google-Smtp-Source: AA6agR7BScaXXZPUeb5POXkhajFjZN4/KLDJTvSvgb9M5fc/2ps6ijXsCdtesf3Yc9BVihDqz40dhw==
X-Received: by 2002:a17:902:dac7:b0:16f:13c6:938d with SMTP id q7-20020a170902dac700b0016f13c6938dmr10072909plx.11.1660424688888;
        Sat, 13 Aug 2022 14:04:48 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p9-20020a1709028a8900b0016be5f24aaesm4099241plo.163.2022.08.13.14.04.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Aug 2022 14:04:48 -0700 (PDT)
Message-ID: <62f811f0.170a0220.8954b.6ac9@mx.google.com>
Date:   Sat, 13 Aug 2022 14:04:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.60-110-g5a4012ec04fef
Subject: stable-rc/queue/5.15 baseline: 136 runs,
 39 regressions (v5.15.60-110-g5a4012ec04fef)
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

stable-rc/queue/5.15 baseline: 136 runs, 39 regressions (v5.15.60-110-g5a40=
12ec04fef)

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

bcm2711-rpi-4-b              | arm64 | lab-linaro-lkft | gcc-10   | defconf=
ig           | 1          =

beagle-xm                    | arm   | lab-baylibre    | gcc-10   | omap2pl=
us_defconfig | 1          =

cubietruck                   | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig     | 1          =

fsl-ls1028a-rdb              | arm64 | lab-nxp         | gcc-10   | defconf=
ig           | 1          =

imx6dl-riotboard             | arm   | lab-pengutronix | gcc-10   | imx_v6_=
v7_defconfig | 1          =

imx6qp-sabresd               | arm   | lab-nxp         | gcc-10   | imx_v6_=
v7_defconfig | 1          =

imx6qp-wandboard-revd1       | arm   | lab-pengutronix | gcc-10   | imx_v6_=
v7_defconfig | 1          =

imx6sx-sdb                   | arm   | lab-nxp         | gcc-10   | imx_v6_=
v7_defconfig | 1          =

imx6ul-14x14-evk             | arm   | lab-nxp         | gcc-10   | imx_v6_=
v7_defconfig | 1          =

imx6ul-pico-hobbit           | arm   | lab-pengutronix | gcc-10   | imx_v6_=
v7_defconfig | 1          =

imx7d-sdb                    | arm   | lab-nxp         | gcc-10   | imx_v6_=
v7_defconfig | 1          =

imx7ulp-evk                  | arm   | lab-nxp         | gcc-10   | imx_v6_=
v7_defconfig | 1          =

imx8mn-ddr4-evk              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig           | 1          =

imx8mn-ddr4-evk              | arm64 | lab-nxp         | gcc-10   | defconf=
ig           | 1          =

kontron-bl-imx8mm            | arm64 | lab-kontron     | gcc-10   | defconf=
ig           | 1          =

kontron-pitx-imx8m           | arm64 | lab-kontron     | gcc-10   | defconf=
ig           | 1          =

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

meson-gxl-s905x-khadas-vim   | arm64 | lab-baylibre    | gcc-10   | defconf=
ig           | 1          =

meson-gxl-s905x-libretech-cc | arm64 | lab-baylibre    | gcc-10   | defconf=
ig           | 1          =

meson-gxl-s905x-libretech-cc | arm64 | lab-broonie     | gcc-10   | defconf=
ig           | 1          =

meson-gxl-s905x-libretech-cc | arm64 | lab-clabbe      | gcc-10   | defconf=
ig           | 1          =

meson-gxm-khadas-vim2        | arm64 | lab-baylibre    | gcc-10   | defconf=
ig           | 1          =

meson-sm1-khadas-vim3l       | arm64 | lab-baylibre    | gcc-10   | defconf=
ig           | 1          =

meson-sm1-sei610             | arm64 | lab-baylibre    | gcc-10   | defconf=
ig           | 1          =

sun4i-a10-olinuxino-lime     | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig     | 1          =

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.60-110-g5a4012ec04fef/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.60-110-g5a4012ec04fef
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5a4012ec04fef4dc71b490c78915c450959acd80 =



Test Regressions
---------------- =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
at91sam9g20ek                | arm   | lab-broonie     | gcc-10   | at91_dt=
_defconfig   | 1          =


  Details:     https://kernelci.org/test/plan/id/62f7de217397d681d7daf061

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: at91_dt_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sa=
m9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sa=
m9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f7de217397d681d7daf=
062
        new failure (last pass: v5.15.60-48-g789367af88749) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
bcm2711-rpi-4-b              | arm64 | lab-collabora   | gcc-10   | defconf=
ig           | 1          =


  Details:     https://kernelci.org/test/plan/id/62f7e20d43179beecedaf08b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm64/defconfig/gcc-10/lab-collabora/baseline-bcm2711-rp=
i-4-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm64/defconfig/gcc-10/lab-collabora/baseline-bcm2711-rp=
i-4-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f7e20d43179beecedaf=
08c
        new failure (last pass: v5.15.60-48-g789367af88749) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
bcm2711-rpi-4-b              | arm64 | lab-linaro-lkft | gcc-10   | defconf=
ig           | 1          =


  Details:     https://kernelci.org/test/plan/id/62f7e1f043179beecedaf072

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm64/defconfig/gcc-10/lab-linaro-lkft/baseline-bcm2711-=
rpi-4-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm64/defconfig/gcc-10/lab-linaro-lkft/baseline-bcm2711-=
rpi-4-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f7e1f043179beecedaf=
073
        new failure (last pass: v5.15.60-48-g789367af88749) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
beagle-xm                    | arm   | lab-baylibre    | gcc-10   | omap2pl=
us_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62f7dfb95ac1d5e1f4daf056

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f7dfb95ac1d5e1f4daf=
057
        failing since 135 days (last pass: v5.15.31-2-g57d4301e22c2, first =
fail: v5.15.31-3-g4ae45332eb9c) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
cubietruck                   | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig     | 1          =


  Details:     https://kernelci.org/test/plan/id/62f7dc36de4f32f24cdaf069

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-cubietr=
uck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-cubietr=
uck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f7dc36de4f32f24cdaf=
06a
        new failure (last pass: v5.15.60-48-g789367af88749) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
fsl-ls1028a-rdb              | arm64 | lab-nxp         | gcc-10   | defconf=
ig           | 1          =


  Details:     https://kernelci.org/test/plan/id/62f7e27096dea44792daf056

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls1028a-rdb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls1028a-rdb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f7e27096dea44792daf=
057
        new failure (last pass: v5.15.60-48-g789367af88749) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
imx6dl-riotboard             | arm   | lab-pengutronix | gcc-10   | imx_v6_=
v7_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62f7df2bead95b05a9daf065

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6dl-riotboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6dl-riotboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f7df2bead95b05a9daf=
066
        new failure (last pass: v5.15.60-34-gdab49837d475c) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
imx6qp-sabresd               | arm   | lab-nxp         | gcc-10   | imx_v6_=
v7_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62f7df7737e5b805d6daf082

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6qp-s=
abresd.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6qp-s=
abresd.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f7df7737e5b805d6daf=
083
        new failure (last pass: v5.15.60-34-gdab49837d475c) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
imx6qp-wandboard-revd1       | arm   | lab-pengutronix | gcc-10   | imx_v6_=
v7_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62f7df2cead95b05a9daf068

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6qp-wandboard-revd1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6qp-wandboard-revd1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f7df2cead95b05a9daf=
069
        new failure (last pass: v5.15.60-34-gdab49837d475c) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
imx6sx-sdb                   | arm   | lab-nxp         | gcc-10   | imx_v6_=
v7_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62f7df8737e5b805d6daf096

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6sx-s=
db.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6sx-s=
db.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f7df8737e5b805d6daf=
097
        new failure (last pass: v5.15.60-34-gdab49837d475c) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
imx6ul-14x14-evk             | arm   | lab-nxp         | gcc-10   | imx_v6_=
v7_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62f7df8537e5b805d6daf093

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul-1=
4x14-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul-1=
4x14-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f7df8537e5b805d6daf=
094
        new failure (last pass: v5.15.60-34-gdab49837d475c) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
imx6ul-pico-hobbit           | arm   | lab-pengutronix | gcc-10   | imx_v6_=
v7_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62f7e0a707895564b3daf05c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f7e0a707895564b3daf=
05d
        new failure (last pass: v5.15.60-34-gdab49837d475c) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
imx7d-sdb                    | arm   | lab-nxp         | gcc-10   | imx_v6_=
v7_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62f7df8937e5b805d6daf099

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sd=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sd=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f7df8937e5b805d6daf=
09a
        new failure (last pass: v5.15.60-34-gdab49837d475c) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
imx7ulp-evk                  | arm   | lab-nxp         | gcc-10   | imx_v6_=
v7_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62f7df75bc4a94ab11daf072

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-=
evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-=
evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f7df75bc4a94ab11daf=
073
        new failure (last pass: v5.15.60-34-gdab49837d475c) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
imx8mn-ddr4-evk              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig           | 1          =


  Details:     https://kernelci.org/test/plan/id/62f7e27400643abbd5daf057

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-ddr4=
-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-ddr4=
-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f7e27400643abbd5daf=
058
        new failure (last pass: v5.15.60-48-g789367af88749) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
imx8mn-ddr4-evk              | arm64 | lab-nxp         | gcc-10   | defconf=
ig           | 1          =


  Details:     https://kernelci.org/test/plan/id/62f7e26edafe20ca60daf080

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mn-ddr4-evk.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mn-ddr4-evk.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f7e26edafe20ca60daf=
081
        new failure (last pass: v5.15.60-48-g789367af88749) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
kontron-bl-imx8mm            | arm64 | lab-kontron     | gcc-10   | defconf=
ig           | 1          =


  Details:     https://kernelci.org/test/plan/id/62f7e20e97f2d84875daf059

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-bl-i=
mx8mm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-bl-i=
mx8mm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f7e20e97f2d84875daf=
05a
        new failure (last pass: v5.15.60-48-g789367af88749) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
kontron-pitx-imx8m           | arm64 | lab-kontron     | gcc-10   | defconf=
ig           | 1          =


  Details:     https://kernelci.org/test/plan/id/62f7e3dbb9f72b9866daf05f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx=
-imx8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx=
-imx8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f7e3dbb9f72b9866daf=
060
        new failure (last pass: v5.15.60-48-g789367af88749) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
meson-g12a-sei510            | arm64 | lab-baylibre    | gcc-10   | defconf=
ig           | 1          =


  Details:     https://kernelci.org/test/plan/id/62f7e1f343179beecedaf079

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-=
sei510.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-=
sei510.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f7e1f343179beecedaf=
07a
        new failure (last pass: v5.15.60-48-g789367af88749) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
meson-g12a-u200              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig           | 1          =


  Details:     https://kernelci.org/test/plan/id/62f7e217dafe20ca60daf068

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-=
u200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-=
u200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f7e217dafe20ca60daf=
069
        new failure (last pass: v5.15.60-48-g789367af88749) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
meson-g12a-x96-max           | arm64 | lab-baylibre    | gcc-10   | defconf=
ig           | 1          =


  Details:     https://kernelci.org/test/plan/id/62f7e21a97f2d84875daf069

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-=
x96-max.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-=
x96-max.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f7e21a97f2d84875daf=
06a
        new failure (last pass: v5.15.60-48-g789367af88749) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-baylibre    | gcc-10   | defconf=
ig           | 1          =


  Details:     https://kernelci.org/test/plan/id/62f7e21197f2d84875daf05d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-=
a311d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-=
a311d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f7e21197f2d84875daf=
05e
        new failure (last pass: v5.15.60-48-g789367af88749) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-collabora   | gcc-10   | defconf=
ig           | 1          =


  Details:     https://kernelci.org/test/plan/id/62f7eaf7198c57ac0edaf070

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm64/defconfig/gcc-10/lab-collabora/baseline-meson-g12b=
-a311d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm64/defconfig/gcc-10/lab-collabora/baseline-meson-g12b=
-a311d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f7eaf7198c57ac0edaf=
071
        new failure (last pass: v5.15.60-48-g789367af88749) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
meson-g12b-odroid-n2         | arm64 | lab-baylibre    | gcc-10   | defconf=
ig           | 1          =


  Details:     https://kernelci.org/test/plan/id/62f7e21305c8af2966daf05c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-=
odroid-n2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-=
odroid-n2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f7e21305c8af2966daf=
05d
        new failure (last pass: v5.15.60-48-g789367af88749) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
meson-gxl-s905x-khadas-vim   | arm64 | lab-baylibre    | gcc-10   | defconf=
ig           | 1          =


  Details:     https://kernelci.org/test/plan/id/62f7e1fa04ff8d0a69daf063

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s=
905x-khadas-vim.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s=
905x-khadas-vim.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f7e1fa04ff8d0a69daf=
064
        new failure (last pass: v5.15.60-48-g789367af88749) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-baylibre    | gcc-10   | defconf=
ig           | 1          =


  Details:     https://kernelci.org/test/plan/id/62f7e21597f2d84875daf063

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s=
905x-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s=
905x-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f7e21597f2d84875daf=
064
        new failure (last pass: v5.15.60-48-g789367af88749) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-broonie     | gcc-10   | defconf=
ig           | 1          =


  Details:     https://kernelci.org/test/plan/id/62f7e21349977d9149daf05a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s9=
05x-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s9=
05x-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f7e21349977d9149daf=
05b
        new failure (last pass: v5.15.60-48-g789367af88749) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-clabbe      | gcc-10   | defconf=
ig           | 1          =


  Details:     https://kernelci.org/test/plan/id/62f7e21705c8af2966daf062

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm64/defconfig/gcc-10/lab-clabbe/baseline-meson-gxl-s90=
5x-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm64/defconfig/gcc-10/lab-clabbe/baseline-meson-gxl-s90=
5x-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f7e21705c8af2966daf=
063
        new failure (last pass: v5.15.60-48-g789367af88749) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
meson-gxm-khadas-vim2        | arm64 | lab-baylibre    | gcc-10   | defconf=
ig           | 1          =


  Details:     https://kernelci.org/test/plan/id/62f7e1fb43179beecedaf07f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm-k=
hadas-vim2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm-k=
hadas-vim2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f7e1fb43179beecedaf=
080
        new failure (last pass: v5.15.60-48-g789367af88749) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
meson-sm1-khadas-vim3l       | arm64 | lab-baylibre    | gcc-10   | defconf=
ig           | 1          =


  Details:     https://kernelci.org/test/plan/id/62f7e21849977d9149daf060

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-sm1-k=
hadas-vim3l.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-sm1-k=
hadas-vim3l.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f7e21849977d9149daf=
061
        new failure (last pass: v5.15.60-48-g789367af88749) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
meson-sm1-sei610             | arm64 | lab-baylibre    | gcc-10   | defconf=
ig           | 1          =


  Details:     https://kernelci.org/test/plan/id/62f7e20743179beecedaf085

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-sm1-s=
ei610.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-sm1-s=
ei610.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f7e20743179beecedaf=
086
        new failure (last pass: v5.15.60-48-g789367af88749) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
sun4i-a10-olinuxino-lime     | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig     | 1          =


  Details:     https://kernelci.org/test/plan/id/62f7df3eead95b05a9daf09f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun4i-a=
10-olinuxino-lime.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun4i-a=
10-olinuxino-lime.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f7df3eead95b05a9daf=
0a0
        new failure (last pass: v5.15.60-48-g789367af88749) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
sun5i-a13-olinuxino-micro    | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig     | 1          =


  Details:     https://kernelci.org/test/plan/id/62f7dc1d2fec09735adaf067

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun5i-a=
13-olinuxino-micro.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun5i-a=
13-olinuxino-micro.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f7dc1d2fec09735adaf=
068
        new failure (last pass: v5.15.60-48-g789367af88749) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
sun7i-a20-cubieboard2        | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig     | 1          =


  Details:     https://kernelci.org/test/plan/id/62f7dbe587621f3cc9daf067

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7i-a=
20-cubieboard2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7i-a=
20-cubieboard2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f7dbe587621f3cc9daf=
068
        new failure (last pass: v5.15.60-48-g789367af88749) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
sun7i-a20-cubieboard2        | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig     | 1          =


  Details:     https://kernelci.org/test/plan/id/62f7dbead53e06e763daf072

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun7i-a20=
-cubieboard2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun7i-a20=
-cubieboard2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f7dbead53e06e763daf=
073
        new failure (last pass: v5.15.60-48-g789367af88749) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
sun8i-a33-olinuxino          | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig     | 1          =


  Details:     https://kernelci.org/test/plan/id/62f7dbff33d619a700daf05c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a33=
-olinuxino.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a33=
-olinuxino.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f7dbff33d619a700daf=
05d
        new failure (last pass: v5.15.60-48-g789367af88749) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
sun8i-h2-plus-orangepi-r1    | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig     | 1          =


  Details:     https://kernelci.org/test/plan/id/62f7dcab5d4bff8742daf063

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h=
2-plus-orangepi-r1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h=
2-plus-orangepi-r1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f7dcab5d4bff8742daf=
064
        new failure (last pass: v5.15.60-48-g789367af88749) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
sun8i-h2-plus-orangepi-zero  | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig     | 1          =


  Details:     https://kernelci.org/test/plan/id/62f7de130b68d78487daf057

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h=
2-plus-orangepi-zero.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h=
2-plus-orangepi-zero.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f7de130b68d78487daf=
058
        new failure (last pass: v5.15.60-48-g789367af88749) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
sun8i-h3-orangepi-pc         | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig     | 1          =


  Details:     https://kernelci.org/test/plan/id/62f7dd3f9399c4bee7daf056

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-=
orangepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
110-g5a4012ec04fef/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-=
orangepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f7dd3f9399c4bee7daf=
057
        new failure (last pass: v5.15.60-48-g789367af88749) =

 =20
