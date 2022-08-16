Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A76DD5952C1
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 08:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbiHPGmh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 02:42:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbiHPGmW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 02:42:22 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB9FBE3C1D
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 18:30:27 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id o5-20020a17090a3d4500b001ef76490983so8280993pjf.2
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 18:30:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=QvLYwRQ5XIXY53ql8R0Njv4LJChHrPTyvf/pZ3+Jeoo=;
        b=fzJndL3Ue0MuluhiU9Di94XsBn3wzq1UyQLCersEFH89auCDwd1XZXCMKPa/6kuU4h
         eegu+6TIY1q8/zPXXbnBVkJ2jpsfpWbBSffagSNycvI5XhaS+pdrSYBTe7cXCa89w6oo
         3ogAQ1J1DTLJdDAOhkYtda7Taf9bxgQLqlEy9C8KCyeqk9aXsEQrHAM34BsS1Cy+Uu80
         ZcVOg8/CtkQESKZ/acbuqRb6kD2eq6eIDMPs+Mn+lYlmsEIpgEGsaIcDmK34wk6eGqR0
         QFCD3mBIuRqY7lMJW4J/1yFPaC4OB66OLzo9WcKNob4Y+3N0DMP6BSV/i4XSA3+GBDH4
         naQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=QvLYwRQ5XIXY53ql8R0Njv4LJChHrPTyvf/pZ3+Jeoo=;
        b=iwSlU+3k0PVBrVPkuaX93KVhIINL3HHUdGxptfcy4uEpn9ekyYXe6JO4q+nFSvXN7m
         MrraWJCO8Bhjh+P+jxnSISs9qTI36JM4lwqxVPKk31xRJ6mYSKzIDB0goirYHDjfSpOg
         Ci38ritTSLwFi4HzQpXQrx71YHQjHk5nAwNNsbZ1+RljQCwwiDTJ2xuntVu6n246ZiCs
         TULofM6XXZgocMingy/g3N6QY1qeWUmTw3rTBPgqVZmrhIPsS/bAZA+1r1b2c9B6BY3a
         wWFxLCId9QGTRHK9he0JIkydrhrRHA9bgqivs9c6Nxiugeut2eEvlEIK0VMHSwx4pST4
         lvqQ==
X-Gm-Message-State: ACgBeo2UwJc7/v386Fh7VQYL+hKbWjs3KnC4ubAIk0w1fL2aTs3nuRB6
        WE+66H8Scrln2qC8Efyprm2rhHsSzBSiWive
X-Google-Smtp-Source: AA6agR5wPmGJ/Ow6W2vIs4vG9KJO2jBHPuaZYap5r7TViRGXT087wtVoxgjX25z3/W2K3MhYcWwCsw==
X-Received: by 2002:a17:902:e744:b0:16e:f6c2:3731 with SMTP id p4-20020a170902e74400b0016ef6c23731mr20163950plf.104.1660613426507;
        Mon, 15 Aug 2022 18:30:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d10-20020a170902ceca00b00170abc421a6sm7696060plg.42.2022.08.15.18.30.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 18:30:26 -0700 (PDT)
Message-ID: <62faf332.170a0220.3a341.d1cb@mx.google.com>
Date:   Mon, 15 Aug 2022 18:30:26 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.60-780-ge0aee0aca52e6
Subject: stable-rc/linux-5.15.y baseline: 151 runs,
 47 regressions (v5.15.60-780-ge0aee0aca52e6)
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

stable-rc/linux-5.15.y baseline: 151 runs, 47 regressions (v5.15.60-780-ge0=
aee0aca52e6)

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

bcm2711-rpi-4-b              | arm64 | lab-linaro-lkft | gcc-10   | defconf=
ig                  | 1          =

beagle-xm                    | arm   | lab-baylibre    | gcc-10   | omap2pl=
us_defconfig        | 1          =

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

imx6ul-pico-hobbit           | arm   | lab-pengutronix | gcc-10   | multi_v=
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

panda                        | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 1          =

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.60-780-ge0aee0aca52e6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.60-780-ge0aee0aca52e6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e0aee0aca52e6cb568c2c2a250c23af3035767d6 =



Test Regressions
---------------- =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
at91sam9g20ek                | arm   | lab-broonie     | gcc-10   | at91_dt=
_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/62fabc7c5387f0bc11355652

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: at91_dt_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91=
sam9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91=
sam9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fabc7c5387f0bc11355=
653
        new failure (last pass: v5.15.59-31-g9c5eacc2ad1f6) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
bcm2711-rpi-4-b              | arm64 | lab-collabora   | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fac4d03f33040f7b355658

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm64/defconfig/gcc-10/lab-collabora/baseline-bcm2711-=
rpi-4-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm64/defconfig/gcc-10/lab-collabora/baseline-bcm2711-=
rpi-4-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fac4d03f33040f7b355=
659
        failing since 14 days (last pass: v5.15.57-203-g77a604df16d5, first=
 fail: v5.15.57-273-gf7c660e98f9b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
bcm2711-rpi-4-b              | arm64 | lab-linaro-lkft | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62faefba61491845a9355642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm64/defconfig/gcc-10/lab-linaro-lkft/baseline-bcm271=
1-rpi-4-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm64/defconfig/gcc-10/lab-linaro-lkft/baseline-bcm271=
1-rpi-4-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62faefba61491845a9355=
643
        failing since 14 days (last pass: v5.15.57-203-g77a604df16d5, first=
 fail: v5.15.57-273-gf7c660e98f9b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
beagle-xm                    | arm   | lab-baylibre    | gcc-10   | omap2pl=
us_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/62fabf057cc00add87355646

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-b=
eagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-b=
eagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fabf057cc00add87355=
647
        failing since 95 days (last pass: v5.15.37-259-gab77581473a3, first=
 fail: v5.15.39) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
cubietruck                   | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/62facbfe34ed29009735568b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62facbfe34ed290097355=
68c
        new failure (last pass: v5.15.59-31-g9c5eacc2ad1f6) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
fsl-ls1028a-rdb              | arm64 | lab-nxp         | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fac2c2bb17d19d6c355668

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls1028a-rd=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls1028a-rd=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fac2c2bb17d19d6c355=
669
        new failure (last pass: v5.15.57-273-gf7c660e98f9b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6dl-riotboard             | arm   | lab-pengutronix | gcc-10   | imx_v6_=
v7_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/62fac62528ff7e05ef355679

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baselin=
e-imx6dl-riotboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baselin=
e-imx6dl-riotboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fac62528ff7e05ef355=
67a
        failing since 0 day (last pass: v5.15.59-31-g9c5eacc2ad1f6, first f=
ail: v5.15.60-758-g5ab97c8bc34ec) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6dl-riotboard             | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62fac8f5e0c1295b1835566e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline=
-imx6dl-riotboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline=
-imx6dl-riotboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fac8f5e0c1295b18355=
66f
        new failure (last pass: v5.15.59) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6q-sabrelite              | arm   | lab-collabora   | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62fac14953dcb8d08e355642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-i=
mx6q-sabrelite.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-i=
mx6q-sabrelite.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fac14953dcb8d08e355=
643
        new failure (last pass: v5.15.59) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6qp-sabresd               | arm   | lab-nxp         | gcc-10   | imx_v6_=
v7_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/62fac02fadf5933ae735565a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6qp=
-sabresd.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6qp=
-sabresd.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fac02fadf5933ae7355=
65b
        failing since 0 day (last pass: v5.15.59-31-g9c5eacc2ad1f6, first f=
ail: v5.15.60-758-g5ab97c8bc34ec) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6qp-wandboard-revd1       | arm   | lab-pengutronix | gcc-10   | imx_v6_=
v7_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/62fabfe53a32e571ab35566b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baselin=
e-imx6qp-wandboard-revd1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baselin=
e-imx6qp-wandboard-revd1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fabfe53a32e571ab355=
66c
        failing since 0 day (last pass: v5.15.59-31-g9c5eacc2ad1f6, first f=
ail: v5.15.60-758-g5ab97c8bc34ec) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6qp-wandboard-revd1       | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62fac1394c007fecd635564d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline=
-imx6qp-wandboard-revd1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline=
-imx6qp-wandboard-revd1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fac1394c007fecd6355=
64e
        new failure (last pass: v5.15.59) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6sx-sdb                   | arm   | lab-nxp         | gcc-10   | imx_v6_=
v7_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/62fac03525e8ecf79435564f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6sx=
-sdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6sx=
-sdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fac03525e8ecf794355=
650
        failing since 0 day (last pass: v5.15.59-31-g9c5eacc2ad1f6, first f=
ail: v5.15.60-758-g5ab97c8bc34ec) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6sx-sdb                   | arm   | lab-nxp         | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62fac1f987daa0f962355694

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6sx-=
sdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6sx-=
sdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fac1f987daa0f962355=
695
        new failure (last pass: v5.15.59) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6ul-14x14-evk             | arm   | lab-nxp         | gcc-10   | imx_v6_=
v7_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/62fac01a0670ca5fa5355645

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul=
-14x14-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul=
-14x14-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fac01a0670ca5fa5355=
646
        failing since 0 day (last pass: v5.15.59-31-g9c5eacc2ad1f6, first f=
ail: v5.15.60-758-g5ab97c8bc34ec) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6ul-14x14-evk             | arm   | lab-nxp         | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62fac1d412a707103b355646

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul-=
14x14-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul-=
14x14-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fac1d412a707103b355=
647
        new failure (last pass: v5.15.52-99-gbcb9695d82c0) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6ul-pico-hobbit           | arm   | lab-pengutronix | gcc-10   | imx_v6_=
v7_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/62fad9fd9b149751b9355666

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baselin=
e-imx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baselin=
e-imx6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fad9fd9b149751b9355=
667
        failing since 0 day (last pass: v5.15.59-31-g9c5eacc2ad1f6, first f=
ail: v5.15.60-758-g5ab97c8bc34ec) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6ul-pico-hobbit           | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62fadcba0b818b9330355676

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline=
-imx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline=
-imx6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fadcba0b818b9330355=
677
        new failure (last pass: v5.15.59) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx7d-sdb                    | arm   | lab-nxp         | gcc-10   | imx_v6_=
v7_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/62fac0327f068f90b1355646

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-=
sdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-=
sdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fac0327f068f90b1355=
647
        new failure (last pass: v5.15.59-31-g9c5eacc2ad1f6) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx7d-sdb                    | arm   | lab-nxp         | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62fac1d243fd63be3c355667

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-s=
db.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-s=
db.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fac1d243fd63be3c355=
668
        new failure (last pass: v5.15.59) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx8mn-ddr4-evk              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fac2e8012326049a355650

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-dd=
r4-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-dd=
r4-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fac2e8012326049a355=
651
        new failure (last pass: v5.15.57-273-gf7c660e98f9b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx8mn-ddr4-evk              | arm64 | lab-nxp         | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fac2d6dd4fdda53535565b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mn-ddr4-ev=
k.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mn-ddr4-ev=
k.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fac2d6dd4fdda535355=
65c
        new failure (last pass: v5.15.57-273-gf7c660e98f9b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
jetson-tk1                   | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62faee8d3c3a187965355658

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-je=
tson-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-je=
tson-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62faee8d3c3a187965355=
659
        new failure (last pass: v5.15.59) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
jetson-tk1                   | arm   | lab-baylibre    | gcc-10   | tegra_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/62faed3b8cf3bc4e6635570d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetso=
n-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetso=
n-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62faed3b8cf3bc4e66355=
70e
        new failure (last pass: v5.15.59-31-g9c5eacc2ad1f6) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
kontron-bl-imx8mm            | arm64 | lab-kontron     | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fac29deea4d2ce3a355649

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-bl=
-imx8mm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-bl=
-imx8mm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fac29deea4d2ce3a355=
64a
        new failure (last pass: v5.15.57-273-gf7c660e98f9b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
kontron-pitx-imx8m           | arm64 | lab-kontron     | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fac2b16b8919a0ee355659

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pi=
tx-imx8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pi=
tx-imx8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fac2b16b8919a0ee355=
65a
        new failure (last pass: v5.15.57-273-gf7c660e98f9b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-g12a-sei510            | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fac294eea4d2ce3a355642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12=
a-sei510.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12=
a-sei510.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fac294eea4d2ce3a355=
643
        new failure (last pass: v5.15.57) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-g12a-u200              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fac2adeb1fd8f662355654

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12=
a-u200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12=
a-u200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fac2adeb1fd8f662355=
655
        new failure (last pass: v5.15.53-227-g71721f5974f2) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-g12a-x96-max           | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fac29311fae07f0c355662

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12=
a-x96-max.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12=
a-x96-max.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fac29311fae07f0c355=
663
        new failure (last pass: v5.15.57) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fac297f3adad264635565b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12=
b-a311d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12=
b-a311d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fac297f3adad2646355=
65c
        new failure (last pass: v5.15.53-227-g71721f5974f2) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-collabora   | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62facbff34ed29009735568e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm64/defconfig/gcc-10/lab-collabora/baseline-meson-g1=
2b-a311d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm64/defconfig/gcc-10/lab-collabora/baseline-meson-g1=
2b-a311d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62facbff34ed290097355=
68f
        new failure (last pass: v5.15.53-227-g71721f5974f2) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-g12b-odroid-n2         | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fac43c47e9a85ce0355645

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12=
b-odroid-n2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12=
b-odroid-n2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fac43c47e9a85ce0355=
646
        new failure (last pass: v5.15.57) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-gxl-s905x-khadas-vim   | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fac2a9eea4d2ce3a355653

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl=
-s905x-khadas-vim.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl=
-s905x-khadas-vim.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fac2a9eea4d2ce3a355=
654
        new failure (last pass: v5.15.52-99-gbcb9695d82c0) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fae0742604843767355674

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl=
-s905x-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl=
-s905x-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fae0742604843767355=
675
        new failure (last pass: v5.15.57-273-gf7c660e98f9b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-broonie     | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fac2c6fe97e55fc135566b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-=
s905x-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-=
s905x-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fac2c6fe97e55fc1355=
66c
        new failure (last pass: v5.15.57-273-gf7c660e98f9b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-gxm-khadas-vim2        | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fac295e1ea288904355671

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm=
-khadas-vim2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm=
-khadas-vim2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fac295e1ea288904355=
672
        new failure (last pass: v5.15.52) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-sm1-khadas-vim3l       | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fac2abbb17d19d6c35564d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-sm1=
-khadas-vim3l.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-sm1=
-khadas-vim3l.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fac2abbb17d19d6c355=
64e
        new failure (last pass: v5.15.55-168-g91c6070d5ced) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-sm1-sei610             | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fac2afbb17d19d6c355654

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-sm1=
-sei610.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-sm1=
-sei610.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fac2afbb17d19d6c355=
655
        new failure (last pass: v5.15.57) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
panda                        | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62fac03a5e16c1247735564f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fac03a5e16c12477355=
650
        new failure (last pass: v5.15.59) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
rk3288-rock2-square          | arm   | lab-collabora   | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62fad40e04f9f5eac935566f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-r=
k3288-rock2-square.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-r=
k3288-rock2-square.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fad40e04f9f5eac9355=
670
        new failure (last pass: v5.15.59) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
rk3399-gru-kevin             | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fac649741e75a47a355645

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62fac64a741e75a47a355667
        failing since 161 days (last pass: v5.15.26, first fail: v5.15.26-2=
58-g7b9aacd770fa)

    2022-08-15T22:17:21.441424  /lava-7043238/1/../bin/lava-test-case   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun5i-a13-olinuxino-micro    | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/62fac4c44513ac5a463556b0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun5i=
-a13-olinuxino-micro.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun5i=
-a13-olinuxino-micro.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fac4c44513ac5a46355=
6b1
        new failure (last pass: v5.15.59-31-g9c5eacc2ad1f6) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun7i-a20-cubieboard2        | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/62fabd0c514004eb1135567a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7i=
-a20-cubieboard2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7i=
-a20-cubieboard2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fabd0c514004eb11355=
67b
        new failure (last pass: v5.15.59-31-g9c5eacc2ad1f6) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun7i-a20-cubieboard2        | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/62fabd0fb47ba1e6de355649

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun7i-a=
20-cubieboard2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun7i-a=
20-cubieboard2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fabd0fb47ba1e6de355=
64a
        new failure (last pass: v5.15.59-31-g9c5eacc2ad1f6) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-a33-olinuxino          | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/62fabd231d8e2d5cf1355643

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a=
33-olinuxino.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a=
33-olinuxino.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fabd231d8e2d5cf1355=
644
        new failure (last pass: v5.15.59-31-g9c5eacc2ad1f6) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-h2-plus-orangepi-r1    | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/62fac1443f03af65ba355644

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i=
-h2-plus-orangepi-r1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i=
-h2-plus-orangepi-r1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fac1443f03af65ba355=
645
        new failure (last pass: v5.15.59) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-h3-orangepi-pc         | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/62fabeef6bc19fbc93355642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h=
3-orangepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
0-780-ge0aee0aca52e6/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h=
3-orangepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fabeef6bc19fbc93355=
643
        new failure (last pass: v5.15.59-31-g9c5eacc2ad1f6) =

 =20
