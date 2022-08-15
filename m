Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA43D594E1E
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239271AbiHPBhA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 21:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240441AbiHPBge (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 21:36:34 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A7B11E7122
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 14:29:04 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id s206so7565404pgs.3
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 14:29:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=oNAcQM4+tpao6jR37w5KtzPWW9xaP8P7l3LN5NgfhnY=;
        b=qFZUeU+0n9HQbOGHZH48/gla13kLQAq68PrcFf/uhwJ0oCbPECh5NOxzutrxMLoOv8
         5w1fLNLYK1wi14V+OB7ZvvMjAs01+JRASozOnq4TJAxyMMIO4Z0F/5Kr481xmnrSHb3+
         VzoVEbAcIiHFYb949+4Zqj9Mzcrn+Cvxnlz3IMQjquZZ0ieeC6jm1AeqCvXyFWeFjelR
         OcXWV0ASstxjlW4pAAVJCqSHcAA48lRWh9vwwnQFSGQ4IaIaSjgAQEJ4CBk1sqY49PKy
         7YXd1hTn+IJ46LmyAPXMiFqe918KjOvdxBpnp1kDhFC4rGzu4JS2R1gIPoFOh1ordjbh
         BiJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=oNAcQM4+tpao6jR37w5KtzPWW9xaP8P7l3LN5NgfhnY=;
        b=t+b7SpQBi28khgmWnLD4D/xQrpENgYLED1h8V9k8/ri609J8eapCmcRJDM82vl5/39
         DkXRphvIgg/jYsj53vAoUi720XBgJeIMHaI2jT1h4ZxwqysoMPEouppt5cNAdE/4ETmC
         T5BTLUgPhjvC8zx79n3MZUDcHxd+619Hy2LEvpK1vb8huPPhupEymOuyfkT8ulUjEFOl
         h45XFtpkvGX/WIqTgvQgK1FNPCRJbJgkABP8mJSGCMo10EhdDkaE4omzuSjN6NNha1hg
         wpccNiUKRPD/kjuLG15qVbxpxeQ/0QDMrt6j7kW+P5yCEEWiZMilqZWqfnA5t2ABL9jW
         u5Xg==
X-Gm-Message-State: ACgBeo1q6iwKLiOQpCvbzo8CZgDOnbjUvZHa5/iNfwkpUclAV3Y1Uf3x
        Amlqv0tkbXTPdhShaq4+ZI115I/cKbqDtYja
X-Google-Smtp-Source: AA6agR6Ilt7pSLRVC1w8Qv54ssovNWbkDV5k1mBRPEsQJF5wCOQaCM2uA7gFFd5086zjx95gHaYGUg==
X-Received: by 2002:a63:5a61:0:b0:41b:b021:f916 with SMTP id k33-20020a635a61000000b0041bb021f916mr14886293pgm.387.1660598943149;
        Mon, 15 Aug 2022 14:29:03 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c13-20020a170903234d00b0016c1a1c1405sm7476667plh.222.2022.08.15.14.29.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 14:29:02 -0700 (PDT)
Message-ID: <62faba9e.170a0220.5ab44.c1ea@mx.google.com>
Date:   Mon, 15 Aug 2022 14:29:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.136-545-g67a6d65f4f9ba
Subject: stable-rc/linux-5.10.y baseline: 71 runs,
 15 regressions (v5.10.136-545-g67a6d65f4f9ba)
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

stable-rc/linux-5.10.y baseline: 71 runs, 15 regressions (v5.10.136-545-g67=
a6d65f4f9ba)

Regressions Summary
-------------------

platform                  | arch | lab             | compiler | defconfig  =
         | regressions
--------------------------+------+-----------------+----------+------------=
---------+------------
at91sam9g20ek             | arm  | lab-broonie     | gcc-10   | at91_dt_def=
config   | 1          =

cubietruck                | arm  | lab-baylibre    | gcc-10   | sunxi_defco=
nfig     | 1          =

imx6dl-riotboard          | arm  | lab-pengutronix | gcc-10   | imx_v6_v7_d=
efconfig | 1          =

imx6qp-sabresd            | arm  | lab-nxp         | gcc-10   | imx_v6_v7_d=
efconfig | 1          =

imx6sx-sdb                | arm  | lab-nxp         | gcc-10   | imx_v6_v7_d=
efconfig | 1          =

imx6ul-14x14-evk          | arm  | lab-nxp         | gcc-10   | imx_v6_v7_d=
efconfig | 1          =

imx6ul-pico-hobbit        | arm  | lab-pengutronix | gcc-10   | imx_v6_v7_d=
efconfig | 1          =

imx7d-sdb                 | arm  | lab-nxp         | gcc-10   | imx_v6_v7_d=
efconfig | 1          =

jetson-tk1                | arm  | lab-baylibre    | gcc-10   | tegra_defco=
nfig     | 1          =

sun4i-a10-olinuxino-lime  | arm  | lab-baylibre    | gcc-10   | sunxi_defco=
nfig     | 1          =

sun5i-a13-olinuxino-micro | arm  | lab-baylibre    | gcc-10   | sunxi_defco=
nfig     | 1          =

sun7i-a20-cubieboard2     | arm  | lab-baylibre    | gcc-10   | sunxi_defco=
nfig     | 1          =

sun7i-a20-cubieboard2     | arm  | lab-clabbe      | gcc-10   | sunxi_defco=
nfig     | 1          =

sun8i-a33-olinuxino       | arm  | lab-clabbe      | gcc-10   | sunxi_defco=
nfig     | 1          =

sun8i-h2-plus-orangepi-r1 | arm  | lab-baylibre    | gcc-10   | sunxi_defco=
nfig     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.136-545-g67a6d65f4f9ba/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.136-545-g67a6d65f4f9ba
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      67a6d65f4f9bada6c3e47761789e5aed325d0b04 =



Test Regressions
---------------- =



platform                  | arch | lab             | compiler | defconfig  =
         | regressions
--------------------------+------+-----------------+----------+------------=
---------+------------
at91sam9g20ek             | arm  | lab-broonie     | gcc-10   | at91_dt_def=
config   | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa88a8af6bfd1456355642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: at91_dt_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-545-g67a6d65f4f9ba/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at9=
1sam9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-545-g67a6d65f4f9ba/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at9=
1sam9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa88a8af6bfd1456355=
643
        failing since 0 day (last pass: v5.10.135-24-gcf6f87a93412e, first =
fail: v5.10.136-517-g9e37063f15dd9) =

 =



platform                  | arch | lab             | compiler | defconfig  =
         | regressions
--------------------------+------+-----------------+----------+------------=
---------+------------
cubietruck                | arm  | lab-baylibre    | gcc-10   | sunxi_defco=
nfig     | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa8e2f4b1fb8561d35569b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-545-g67a6d65f4f9ba/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-545-g67a6d65f4f9ba/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa8e2f4b1fb8561d355=
69c
        failing since 0 day (last pass: v5.10.135-24-gcf6f87a93412e, first =
fail: v5.10.136-517-g9e37063f15dd9) =

 =



platform                  | arch | lab             | compiler | defconfig  =
         | regressions
--------------------------+------+-----------------+----------+------------=
---------+------------
imx6dl-riotboard          | arm  | lab-pengutronix | gcc-10   | imx_v6_v7_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa81730261fc27e6355663

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-545-g67a6d65f4f9ba/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseli=
ne-imx6dl-riotboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-545-g67a6d65f4f9ba/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseli=
ne-imx6dl-riotboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa81730261fc27e6355=
664
        failing since 0 day (last pass: v5.10.133-168-g4f874431e68c8, first=
 fail: v5.10.136-517-g9e37063f15dd9) =

 =



platform                  | arch | lab             | compiler | defconfig  =
         | regressions
--------------------------+------+-----------------+----------+------------=
---------+------------
imx6qp-sabresd            | arm  | lab-nxp         | gcc-10   | imx_v6_v7_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa80e1a3a92cda05355659

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-545-g67a6d65f4f9ba/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6q=
p-sabresd.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-545-g67a6d65f4f9ba/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6q=
p-sabresd.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa80e1a3a92cda05355=
65a
        failing since 0 day (last pass: v5.10.133-168-g4f874431e68c8, first=
 fail: v5.10.136-517-g9e37063f15dd9) =

 =



platform                  | arch | lab             | compiler | defconfig  =
         | regressions
--------------------------+------+-----------------+----------+------------=
---------+------------
imx6sx-sdb                | arm  | lab-nxp         | gcc-10   | imx_v6_v7_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa817fe3b7d6554f35566a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-545-g67a6d65f4f9ba/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6s=
x-sdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-545-g67a6d65f4f9ba/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6s=
x-sdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa817fe3b7d6554f355=
66b
        failing since 0 day (last pass: v5.10.133-168-g4f874431e68c8, first=
 fail: v5.10.136-517-g9e37063f15dd9) =

 =



platform                  | arch | lab             | compiler | defconfig  =
         | regressions
--------------------------+------+-----------------+----------+------------=
---------+------------
imx6ul-14x14-evk          | arm  | lab-nxp         | gcc-10   | imx_v6_v7_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa8191a11328b8d4355642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-545-g67a6d65f4f9ba/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6u=
l-14x14-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-545-g67a6d65f4f9ba/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6u=
l-14x14-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa8191a11328b8d4355=
643
        failing since 0 day (last pass: v5.10.128-85-g29ca824cd19a, first f=
ail: v5.10.136-517-g9e37063f15dd9) =

 =



platform                  | arch | lab             | compiler | defconfig  =
         | regressions
--------------------------+------+-----------------+----------+------------=
---------+------------
imx6ul-pico-hobbit        | arm  | lab-pengutronix | gcc-10   | imx_v6_v7_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa88b53bfa9df66f355677

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-545-g67a6d65f4f9ba/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseli=
ne-imx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-545-g67a6d65f4f9ba/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseli=
ne-imx6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa88b53bfa9df66f355=
678
        failing since 0 day (last pass: v5.10.133-168-g4f874431e68c8, first=
 fail: v5.10.136-517-g9e37063f15dd9) =

 =



platform                  | arch | lab             | compiler | defconfig  =
         | regressions
--------------------------+------+-----------------+----------+------------=
---------+------------
imx7d-sdb                 | arm  | lab-nxp         | gcc-10   | imx_v6_v7_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa821e6f4c30e41835564e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-545-g67a6d65f4f9ba/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d=
-sdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-545-g67a6d65f4f9ba/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d=
-sdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa821e6f4c30e418355=
64f
        failing since 0 day (last pass: v5.10.133-168-g4f874431e68c8, first=
 fail: v5.10.136-517-g9e37063f15dd9) =

 =



platform                  | arch | lab             | compiler | defconfig  =
         | regressions
--------------------------+------+-----------------+----------+------------=
---------+------------
jetson-tk1                | arm  | lab-baylibre    | gcc-10   | tegra_defco=
nfig     | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa9acee1673d184935565d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-545-g67a6d65f4f9ba/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jets=
on-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-545-g67a6d65f4f9ba/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jets=
on-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa9acee1673d1849355=
65e
        failing since 0 day (last pass: v5.10.132-149-g00d1152b11625, first=
 fail: v5.10.136-517-g9e37063f15dd9) =

 =



platform                  | arch | lab             | compiler | defconfig  =
         | regressions
--------------------------+------+-----------------+----------+------------=
---------+------------
sun4i-a10-olinuxino-lime  | arm  | lab-baylibre    | gcc-10   | sunxi_defco=
nfig     | 1          =


  Details:     https://kernelci.org/test/plan/id/62fab728d922a17aff355642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-545-g67a6d65f4f9ba/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun4=
i-a10-olinuxino-lime.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-545-g67a6d65f4f9ba/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun4=
i-a10-olinuxino-lime.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fab728d922a17aff355=
643
        failing since 0 day (last pass: v5.10.135-24-gcf6f87a93412e, first =
fail: v5.10.136-517-g9e37063f15dd9) =

 =



platform                  | arch | lab             | compiler | defconfig  =
         | regressions
--------------------------+------+-----------------+----------+------------=
---------+------------
sun5i-a13-olinuxino-micro | arm  | lab-baylibre    | gcc-10   | sunxi_defco=
nfig     | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa8d2d6a5dfe0eb8355677

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-545-g67a6d65f4f9ba/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun5=
i-a13-olinuxino-micro.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-545-g67a6d65f4f9ba/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun5=
i-a13-olinuxino-micro.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa8d2d6a5dfe0eb8355=
678
        failing since 0 day (last pass: v5.10.135-24-gcf6f87a93412e, first =
fail: v5.10.136-517-g9e37063f15dd9) =

 =



platform                  | arch | lab             | compiler | defconfig  =
         | regressions
--------------------------+------+-----------------+----------+------------=
---------+------------
sun7i-a20-cubieboard2     | arm  | lab-baylibre    | gcc-10   | sunxi_defco=
nfig     | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa8906146ce5d87d35564e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-545-g67a6d65f4f9ba/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7=
i-a20-cubieboard2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-545-g67a6d65f4f9ba/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7=
i-a20-cubieboard2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa8906146ce5d87d355=
64f
        failing since 0 day (last pass: v5.10.135-24-gcf6f87a93412e, first =
fail: v5.10.136-517-g9e37063f15dd9) =

 =



platform                  | arch | lab             | compiler | defconfig  =
         | regressions
--------------------------+------+-----------------+----------+------------=
---------+------------
sun7i-a20-cubieboard2     | arm  | lab-clabbe      | gcc-10   | sunxi_defco=
nfig     | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa8901146ce5d87d35564a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-545-g67a6d65f4f9ba/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun7i-=
a20-cubieboard2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-545-g67a6d65f4f9ba/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun7i-=
a20-cubieboard2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa8901146ce5d87d355=
64b
        failing since 0 day (last pass: v5.10.135-24-gcf6f87a93412e, first =
fail: v5.10.136-517-g9e37063f15dd9) =

 =



platform                  | arch | lab             | compiler | defconfig  =
         | regressions
--------------------------+------+-----------------+----------+------------=
---------+------------
sun8i-a33-olinuxino       | arm  | lab-clabbe      | gcc-10   | sunxi_defco=
nfig     | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa8964a752b60f43355644

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-545-g67a6d65f4f9ba/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-=
a33-olinuxino.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-545-g67a6d65f4f9ba/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-=
a33-olinuxino.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa8965a752b60f43355=
645
        failing since 0 day (last pass: v5.10.135-24-gcf6f87a93412e, first =
fail: v5.10.136-517-g9e37063f15dd9) =

 =



platform                  | arch | lab             | compiler | defconfig  =
         | regressions
--------------------------+------+-----------------+----------+------------=
---------+------------
sun8i-h2-plus-orangepi-r1 | arm  | lab-baylibre    | gcc-10   | sunxi_defco=
nfig     | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa8bdf7227e7758b355677

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-545-g67a6d65f4f9ba/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h2-plus-orangepi-r1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-545-g67a6d65f4f9ba/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h2-plus-orangepi-r1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa8bdf7227e7758b355=
678
        failing since 0 day (last pass: v5.10.131, first fail: v5.10.136-51=
7-g9e37063f15dd9) =

 =20
