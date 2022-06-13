Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18842549D03
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 21:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348692AbiFMTKw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 15:10:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351013AbiFMTJW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 15:09:22 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1929727168
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 10:08:15 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id i64so6284634pfc.8
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 10:08:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=NPYRH4oAPs6AFYMf6b96c1XnjeMCkIaHMTve5mNJ34M=;
        b=TvaWAGgGDnqWIFwVlzsmFjpfy3I3jlM47IBQqpC1iSVAl78w3oMugtjM4ISLveUhPd
         p7RVmx/aBe/TQzTASZW8pDbEAQ1NXBIRx7U0sasAFUNOuysVoGHv8GE4gluX4IOg0XmQ
         0smDH1vcITLGG7IHOI8bplwZam6euDy7plLIiy8jQA9xSYgd4KOIfK74FnjMHpfKj0pg
         nG0K4kUFaWkJl+2NlTGe47ZKiY4qS9Iy03+gxl25zN10RJJDJKdI+Ij2ronZZEzYsJia
         8lwBwcNLNOHx5xYjSf6d/QRjE+TcERfoYcR/QzdTYi2tOY0oH28ZuAjz/pFxMehIkekp
         v59w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=NPYRH4oAPs6AFYMf6b96c1XnjeMCkIaHMTve5mNJ34M=;
        b=qdyyrn+cHxzF8NuXtZduOnPNIsQz9UfsVwrSRSi6l2PTipV6jv+vs0zMGrefd9hnt2
         to+xDgBorBEDkCtoRj4xSsQ3N0lVdWJ+JrYnCbkwEhSNeaOCzqoXQYYzr5DJPfyRw/2s
         xQTutqCxw80y98ozdLK9FAi7867rkTY81tKJbp/dF0VqHWFuxP6OC9J3/qWtJjrEqCIp
         7oamb3y6nVAB5hTPuUgqwDSRBfQ1bANTxbS26kD1dVHjUI6GxvAaf3P+I4HvsNs5TjlI
         5bANreVexHIOpg2UvaTcZKCUD5xn6rLQyODOhw0TOg7nm9kxhXcQK1S/RyyEHBrJ6xkT
         mXAw==
X-Gm-Message-State: AOAM531uMP2ykB4gnPXGasfd0t3b3D8OfxpLDCFysqiBfs/opnrxTFOW
        sDesVXNPsWy0NlPrRRxw6TRYdQv2xTrjP/Qr6o8=
X-Google-Smtp-Source: ABdhPJxvCXXPg92K2v6rU9Jn+nkSf8prM/BdS4eoygU0XLZfleAPcFieqqTDaBNh3dv0VWm8XINl6w==
X-Received: by 2002:a63:4718:0:b0:3fe:6905:cdad with SMTP id u24-20020a634718000000b003fe6905cdadmr514343pga.193.1655140094212;
        Mon, 13 Jun 2022 10:08:14 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v16-20020a170902e8d000b00161455d8029sm5406747plg.12.2022.06.13.10.08.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 10:08:13 -0700 (PDT)
Message-ID: <62a76efd.1c69fb81.71191.67f4@mx.google.com>
Date:   Mon, 13 Jun 2022 10:08:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.2-1220-gd5ac9cd9153f6
X-Kernelci-Branch: linux-5.18.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.18.y baseline: 138 runs,
 6 regressions (v5.18.2-1220-gd5ac9cd9153f6)
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

stable-rc/linux-5.18.y baseline: 138 runs, 6 regressions (v5.18.2-1220-gd5a=
c9cd9153f6)

Regressions Summary
-------------------

platform           | arch  | lab           | compiler | defconfig          =
| regressions
-------------------+-------+---------------+----------+--------------------=
+------------
imx8mn-ddr4-evk    | arm64 | lab-nxp       | gcc-10   | defconfig          =
| 1          =

jetson-tk1         | arm   | lab-baylibre  | gcc-10   | multi_v7_defconfig =
| 1          =

jetson-tk1         | arm   | lab-baylibre  | gcc-10   | tegra_defconfig    =
| 1          =

kontron-pitx-imx8m | arm64 | lab-kontron   | gcc-10   | defconfig          =
| 1          =

tegra124-nyan-big  | arm   | lab-collabora | gcc-10   | multi_v7_defconfig =
| 1          =

tegra124-nyan-big  | arm   | lab-collabora | gcc-10   | tegra_defconfig    =
| 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.18.y/ker=
nel/v5.18.2-1220-gd5ac9cd9153f6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.18.y
  Describe: v5.18.2-1220-gd5ac9cd9153f6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d5ac9cd9153f6e737a5b024986649d87cf211066 =



Test Regressions
---------------- =



platform           | arch  | lab           | compiler | defconfig          =
| regressions
-------------------+-------+---------------+----------+--------------------=
+------------
imx8mn-ddr4-evk    | arm64 | lab-nxp       | gcc-10   | defconfig          =
| 1          =


  Details:     https://kernelci.org/test/plan/id/62a73b349d67fc9ebea39be9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.2=
-1220-gd5ac9cd9153f6/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mn-ddr4-ev=
k.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.2=
-1220-gd5ac9cd9153f6/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mn-ddr4-ev=
k.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62a73b349d67fc9ebea39=
bea
        new failure (last pass: v5.18-48-g10e6e3d47333) =

 =



platform           | arch  | lab           | compiler | defconfig          =
| regressions
-------------------+-------+---------------+----------+--------------------=
+------------
jetson-tk1         | arm   | lab-baylibre  | gcc-10   | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/62a74374fd0bf80c92a39bea

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.2=
-1220-gd5ac9cd9153f6/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-je=
tson-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.2=
-1220-gd5ac9cd9153f6/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-je=
tson-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62a74374fd0bf80c92a39=
beb
        new failure (last pass: v5.18.2-880-g09bf95a7c28a7) =

 =



platform           | arch  | lab           | compiler | defconfig          =
| regressions
-------------------+-------+---------------+----------+--------------------=
+------------
jetson-tk1         | arm   | lab-baylibre  | gcc-10   | tegra_defconfig    =
| 1          =


  Details:     https://kernelci.org/test/plan/id/62a7411b6aee9c65b4a39bdf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.2=
-1220-gd5ac9cd9153f6/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetso=
n-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.2=
-1220-gd5ac9cd9153f6/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetso=
n-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62a7411b6aee9c65b4a39=
be0
        new failure (last pass: v5.18.2-880-g09bf95a7c28a7) =

 =



platform           | arch  | lab           | compiler | defconfig          =
| regressions
-------------------+-------+---------------+----------+--------------------=
+------------
kontron-pitx-imx8m | arm64 | lab-kontron   | gcc-10   | defconfig          =
| 1          =


  Details:     https://kernelci.org/test/plan/id/62a7397555b6a62676a39c4c

  Results:     51 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.2=
-1220-gd5ac9cd9153f6/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pi=
tx-imx8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.2=
-1220-gd5ac9cd9153f6/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pi=
tx-imx8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.dwc3-usb1-probed: https://kernelci.org/test/case/id/62a=
7397555b6a62676a39c5f
        new failure (last pass: v5.18.2-880-g09bf95a7c28a7)

    2022-06-13T13:19:38.730117  /lava-127222/1/../bin/lava-test-case
    2022-06-13T13:19:38.730390  <8>[   16.709506] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwc3-usb1-probed RESULT=3Dfail>
    2022-06-13T13:19:38.730538  /lava-127222/1/../bin/lava-test-case
    2022-06-13T13:19:38.730676  <8>[   16.729289] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dimx8mq-usb-phy-driver-present RESULT=3Dpass>
    2022-06-13T13:19:38.730814  /lava-127222/1/../bin/lava-test-case
    2022-06-13T13:19:38.730947  <8>[   16.750381] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dimx8mq-usb-phy0-probed RESULT=3Dpass>
    2022-06-13T13:19:38.735893  /lava-127222/1/../bin/lava-test-case   =

 =



platform           | arch  | lab           | compiler | defconfig          =
| regressions
-------------------+-------+---------------+----------+--------------------=
+------------
tegra124-nyan-big  | arm   | lab-collabora | gcc-10   | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/62a7539a8725b32b28a39bdc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.2=
-1220-gd5ac9cd9153f6/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-t=
egra124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.2=
-1220-gd5ac9cd9153f6/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-t=
egra124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62a7539a8725b32b28a39=
bdd
        new failure (last pass: v5.18.2-880-g09bf95a7c28a7) =

 =



platform           | arch  | lab           | compiler | defconfig          =
| regressions
-------------------+-------+---------------+----------+--------------------=
+------------
tegra124-nyan-big  | arm   | lab-collabora | gcc-10   | tegra_defconfig    =
| 1          =


  Details:     https://kernelci.org/test/plan/id/62a7506934deab6295a39c0c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.2=
-1220-gd5ac9cd9153f6/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegr=
a124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.2=
-1220-gd5ac9cd9153f6/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegr=
a124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62a7506934deab6295a39=
c0d
        new failure (last pass: v5.18.2-880-g09bf95a7c28a7) =

 =20
