Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1720F594F26
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 05:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbiHPDnF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 23:43:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiHPDmm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 23:42:42 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27954327C63
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 17:15:31 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id f28so7986155pfk.1
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 17:15:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=H4F7jtsxDwsLJsVSlxnpQXdlgTzMrekLPiCBiUf+zwo=;
        b=01sO9MbWJFv6Pgfviv3HxbKBPgncuWu64wX5U67bL4CDVY1pdz3PTTjfeVbSzCM/YS
         AwEgwgvxrsG/MhHyBUXji8ravf4HloAg142tKAFsm0v9U2zSy1eDBHuYVzOUPpwmUs6W
         Fx+yyP8qzRL6d4OLJOtjbaH4kHRtXXTQw+NWdEPLZQVPWwBu9b1niuXVey+9zvxNR+U6
         ta/0BjcZMvMsj0/O129hN+g5Cc/wUNPKT+ASpSDrnIhbAwrhpdVxbHjZmm0bqhqd7ZH5
         mVVWAROKugk+OGM/Sv3npYBOGWHgJR+86Rey6QUcMBqea5sNzyl6STHRlGmH+ybW0fHp
         U5XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=H4F7jtsxDwsLJsVSlxnpQXdlgTzMrekLPiCBiUf+zwo=;
        b=wI5nY0lScQbZivHE7VcfUCOCFlfCqERJhPHu4Z8qHbeXlVHR3d6DKKQ0Rdl2sugkDK
         MkgndUS/TYJattWeB+oxCRTmJIMGlVpqTchlufT5e9mlqA+dX8utyfwY2V3KmEPA17fh
         XJskRIJcYl0aEWQBFe/LgpGgLOr/SoOdYMKonWoxOk4FEc4IuiFmn0U8YqaArsnUwuUo
         18QGsRZO5Fvfuc67QVkwpa1eVjRjuHZR2GLlBv9o7IqSES+eqobecGTnlRVu8rsuAlE0
         hbvkFri4XeWpm4j/Pxvf4yoKhg/zaLLNMKaj5Bnh4VOusayQdOvpu1FhOWMZdcwpeGS6
         HUPg==
X-Gm-Message-State: ACgBeo3mDwVMFIN7Uthclden64CF8rmhTUzfvPA6fPo4NvRmaVFs7Mow
        U2jKGIqQpgmJcWKM3BYH+pRe/gNJ3S6hbvFU
X-Google-Smtp-Source: AA6agR7WygLojl8ReQJWjcD8Bi4MN1yWZmMG+ay8+giySa/m6nJuHEbgN4CuHj251DNVpllWz+cF7Q==
X-Received: by 2002:a63:6d09:0:b0:427:bbb0:e62 with SMTP id i9-20020a636d09000000b00427bbb00e62mr8825964pgc.346.1660608929324;
        Mon, 15 Aug 2022 17:15:29 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n17-20020a170902e55100b0016d773aae60sm7627052plf.19.2022.08.15.17.15.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 17:15:28 -0700 (PDT)
Message-ID: <62fae1a0.170a0220.c49ec.cd32@mx.google.com>
Date:   Mon, 15 Aug 2022 17:15:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.60-779-ge1dae9850fdff
Subject: stable-rc/queue/5.15 baseline: 98 runs,
 27 regressions (v5.15.60-779-ge1dae9850fdff)
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

stable-rc/queue/5.15 baseline: 98 runs, 27 regressions (v5.15.60-779-ge1dae=
9850fdff)

Regressions Summary
-------------------

platform                  | arch | lab             | compiler | defconfig  =
         | regressions
--------------------------+------+-----------------+----------+------------=
---------+------------
at91sam9g20ek             | arm  | lab-broonie     | gcc-10   | at91_dt_def=
config   | 1          =

beagle-xm                 | arm  | lab-baylibre    | gcc-10   | omap2plus_d=
efconfig | 1          =

cubietruck                | arm  | lab-baylibre    | gcc-10   | sunxi_defco=
nfig     | 1          =

imx6dl-riotboard          | arm  | lab-pengutronix | gcc-10   | imx_v6_v7_d=
efconfig | 1          =

imx6dl-riotboard          | arm  | lab-pengutronix | gcc-10   | multi_v7_de=
fconfig  | 1          =

imx6q-sabrelite           | arm  | lab-collabora   | gcc-10   | multi_v7_de=
fconfig  | 1          =

imx6qp-sabresd            | arm  | lab-nxp         | gcc-10   | imx_v6_v7_d=
efconfig | 1          =

imx6qp-wandboard-revd1    | arm  | lab-pengutronix | gcc-10   | imx_v6_v7_d=
efconfig | 1          =

imx6qp-wandboard-revd1    | arm  | lab-pengutronix | gcc-10   | multi_v7_de=
fconfig  | 1          =

imx6sx-sdb                | arm  | lab-nxp         | gcc-10   | imx_v6_v7_d=
efconfig | 1          =

imx6sx-sdb                | arm  | lab-nxp         | gcc-10   | multi_v7_de=
fconfig  | 1          =

imx6ul-14x14-evk          | arm  | lab-nxp         | gcc-10   | imx_v6_v7_d=
efconfig | 1          =

imx6ul-14x14-evk          | arm  | lab-nxp         | gcc-10   | multi_v7_de=
fconfig  | 1          =

imx6ul-pico-hobbit        | arm  | lab-pengutronix | gcc-10   | imx_v6_v7_d=
efconfig | 1          =

imx6ul-pico-hobbit        | arm  | lab-pengutronix | gcc-10   | multi_v7_de=
fconfig  | 1          =

imx7d-sdb                 | arm  | lab-nxp         | gcc-10   | imx_v6_v7_d=
efconfig | 1          =

imx7d-sdb                 | arm  | lab-nxp         | gcc-10   | multi_v7_de=
fconfig  | 1          =

jetson-tk1                | arm  | lab-baylibre    | gcc-10   | multi_v7_de=
fconfig  | 1          =

jetson-tk1                | arm  | lab-baylibre    | gcc-10   | tegra_defco=
nfig     | 1          =

panda                     | arm  | lab-baylibre    | gcc-10   | multi_v7_de=
fconfig  | 1          =

rk3288-rock2-square       | arm  | lab-collabora   | gcc-10   | multi_v7_de=
fconfig  | 1          =

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

sun8i-h3-orangepi-pc      | arm  | lab-clabbe      | gcc-10   | sunxi_defco=
nfig     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.60-779-ge1dae9850fdff/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.60-779-ge1dae9850fdff
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e1dae9850fdff0b45a83b9f3fe8aed4b035f0130 =



Test Regressions
---------------- =



platform                  | arch | lab             | compiler | defconfig  =
         | regressions
--------------------------+------+-----------------+----------+------------=
---------+------------
at91sam9g20ek             | arm  | lab-broonie     | gcc-10   | at91_dt_def=
config   | 1          =


  Details:     https://kernelci.org/test/plan/id/62faa9a54056af235b35566a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: at91_dt_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
779-ge1dae9850fdff/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sa=
m9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
779-ge1dae9850fdff/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sa=
m9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62faa9a54056af235b355=
66b
        failing since 2 days (last pass: v5.15.60-48-g789367af88749, first =
fail: v5.15.60-110-g5a4012ec04fef) =

 =



platform                  | arch | lab             | compiler | defconfig  =
         | regressions
--------------------------+------+-----------------+----------+------------=
---------+------------
beagle-xm                 | arm  | lab-baylibre    | gcc-10   | omap2plus_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62faae6f68e9b9bd99355659

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
779-ge1dae9850fdff/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
779-ge1dae9850fdff/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62faae6f68e9b9bd99355=
65a
        failing since 138 days (last pass: v5.15.31-2-g57d4301e22c2, first =
fail: v5.15.31-3-g4ae45332eb9c) =

 =



platform                  | arch | lab             | compiler | defconfig  =
         | regressions
--------------------------+------+-----------------+----------+------------=
---------+------------
cubietruck                | arm  | lab-baylibre    | gcc-10   | sunxi_defco=
nfig     | 1          =


  Details:     https://kernelci.org/test/plan/id/62fab4d52873241d17355642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
779-ge1dae9850fdff/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-cubietr=
uck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
779-ge1dae9850fdff/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-cubietr=
uck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fab4d52873241d17355=
643
        failing since 2 days (last pass: v5.15.60-48-g789367af88749, first =
fail: v5.15.60-110-g5a4012ec04fef) =

 =



platform                  | arch | lab             | compiler | defconfig  =
         | regressions
--------------------------+------+-----------------+----------+------------=
---------+------------
imx6dl-riotboard          | arm  | lab-pengutronix | gcc-10   | imx_v6_v7_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62faab58ba4a77241935568c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
779-ge1dae9850fdff/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6dl-riotboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
779-ge1dae9850fdff/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6dl-riotboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62faab58ba4a772419355=
68d
        failing since 2 days (last pass: v5.15.60-34-gdab49837d475c, first =
fail: v5.15.60-110-g5a4012ec04fef) =

 =



platform                  | arch | lab             | compiler | defconfig  =
         | regressions
--------------------------+------+-----------------+----------+------------=
---------+------------
imx6dl-riotboard          | arm  | lab-pengutronix | gcc-10   | multi_v7_de=
fconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/62faae295a371bbb7335564d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
779-ge1dae9850fdff/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx6dl-riotboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
779-ge1dae9850fdff/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx6dl-riotboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62faae295a371bbb73355=
64e
        new failure (last pass: v5.15.60-48-g789367af88749) =

 =



platform                  | arch | lab             | compiler | defconfig  =
         | regressions
--------------------------+------+-----------------+----------+------------=
---------+------------
imx6q-sabrelite           | arm  | lab-collabora   | gcc-10   | multi_v7_de=
fconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/62faaadeeccf3486a0355678

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
779-ge1dae9850fdff/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-imx=
6q-sabrelite.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
779-ge1dae9850fdff/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-imx=
6q-sabrelite.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62faaadeeccf3486a0355=
679
        new failure (last pass: v5.15.60-48-g789367af88749) =

 =



platform                  | arch | lab             | compiler | defconfig  =
         | regressions
--------------------------+------+-----------------+----------+------------=
---------+------------
imx6qp-sabresd            | arm  | lab-nxp         | gcc-10   | imx_v6_v7_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62faaa124e29a579f2355651

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
779-ge1dae9850fdff/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6qp-s=
abresd.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
779-ge1dae9850fdff/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6qp-s=
abresd.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62faaa124e29a579f2355=
652
        failing since 2 days (last pass: v5.15.60-34-gdab49837d475c, first =
fail: v5.15.60-110-g5a4012ec04fef) =

 =



platform                  | arch | lab             | compiler | defconfig  =
         | regressions
--------------------------+------+-----------------+----------+------------=
---------+------------
imx6qp-wandboard-revd1    | arm  | lab-pengutronix | gcc-10   | imx_v6_v7_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62faa9c81fc18502c3355669

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
779-ge1dae9850fdff/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6qp-wandboard-revd1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
779-ge1dae9850fdff/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6qp-wandboard-revd1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62faa9c81fc18502c3355=
66a
        failing since 2 days (last pass: v5.15.60-34-gdab49837d475c, first =
fail: v5.15.60-110-g5a4012ec04fef) =

 =



platform                  | arch | lab             | compiler | defconfig  =
         | regressions
--------------------------+------+-----------------+----------+------------=
---------+------------
imx6qp-wandboard-revd1    | arm  | lab-pengutronix | gcc-10   | multi_v7_de=
fconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/62faab1ce7b8e51c1d355671

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
779-ge1dae9850fdff/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx6qp-wandboard-revd1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
779-ge1dae9850fdff/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx6qp-wandboard-revd1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62faab1ce7b8e51c1d355=
672
        new failure (last pass: v5.15.60-48-g789367af88749) =

 =



platform                  | arch | lab             | compiler | defconfig  =
         | regressions
--------------------------+------+-----------------+----------+------------=
---------+------------
imx6sx-sdb                | arm  | lab-nxp         | gcc-10   | imx_v6_v7_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62faa9fe827ac4564c355684

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
779-ge1dae9850fdff/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6sx-s=
db.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
779-ge1dae9850fdff/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6sx-s=
db.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62faa9fe827ac4564c355=
685
        failing since 2 days (last pass: v5.15.60-34-gdab49837d475c, first =
fail: v5.15.60-110-g5a4012ec04fef) =

 =



platform                  | arch | lab             | compiler | defconfig  =
         | regressions
--------------------------+------+-----------------+----------+------------=
---------+------------
imx6sx-sdb                | arm  | lab-nxp         | gcc-10   | multi_v7_de=
fconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/62faab8e65db24337e355642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
779-ge1dae9850fdff/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6sx-sd=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
779-ge1dae9850fdff/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6sx-sd=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62faab8e65db24337e355=
643
        new failure (last pass: v5.15.60-48-g789367af88749) =

 =



platform                  | arch | lab             | compiler | defconfig  =
         | regressions
--------------------------+------+-----------------+----------+------------=
---------+------------
imx6ul-14x14-evk          | arm  | lab-nxp         | gcc-10   | imx_v6_v7_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62faaa14d6aea0cb33355663

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
779-ge1dae9850fdff/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul-1=
4x14-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
779-ge1dae9850fdff/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul-1=
4x14-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62faaa14d6aea0cb33355=
664
        failing since 2 days (last pass: v5.15.60-34-gdab49837d475c, first =
fail: v5.15.60-110-g5a4012ec04fef) =

 =



platform                  | arch | lab             | compiler | defconfig  =
         | regressions
--------------------------+------+-----------------+----------+------------=
---------+------------
imx6ul-14x14-evk          | arm  | lab-nxp         | gcc-10   | multi_v7_de=
fconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/62faaba52481ad214c355646

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
779-ge1dae9850fdff/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul-14=
x14-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
779-ge1dae9850fdff/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul-14=
x14-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62faaba52481ad214c355=
647
        new failure (last pass: v5.15.60-48-g789367af88749) =

 =



platform                  | arch | lab             | compiler | defconfig  =
         | regressions
--------------------------+------+-----------------+----------+------------=
---------+------------
imx6ul-pico-hobbit        | arm  | lab-pengutronix | gcc-10   | imx_v6_v7_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62fabd3d1d8e2d5cf1355654

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
779-ge1dae9850fdff/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
779-ge1dae9850fdff/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fabd3d1d8e2d5cf1355=
655
        failing since 2 days (last pass: v5.15.60-34-gdab49837d475c, first =
fail: v5.15.60-110-g5a4012ec04fef) =

 =



platform                  | arch | lab             | compiler | defconfig  =
         | regressions
--------------------------+------+-----------------+----------+------------=
---------+------------
imx6ul-pico-hobbit        | arm  | lab-pengutronix | gcc-10   | multi_v7_de=
fconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fac1619c278e7de3355643

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
779-ge1dae9850fdff/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
779-ge1dae9850fdff/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fac1619c278e7de3355=
644
        new failure (last pass: v5.15.60-48-g789367af88749) =

 =



platform                  | arch | lab             | compiler | defconfig  =
         | regressions
--------------------------+------+-----------------+----------+------------=
---------+------------
imx7d-sdb                 | arm  | lab-nxp         | gcc-10   | imx_v6_v7_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62faaa18d6aea0cb33355677

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
779-ge1dae9850fdff/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sd=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
779-ge1dae9850fdff/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sd=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62faaa18d6aea0cb33355=
678
        failing since 2 days (last pass: v5.15.60-34-gdab49837d475c, first =
fail: v5.15.60-110-g5a4012ec04fef) =

 =



platform                  | arch | lab             | compiler | defconfig  =
         | regressions
--------------------------+------+-----------------+----------+------------=
---------+------------
imx7d-sdb                 | arm  | lab-nxp         | gcc-10   | multi_v7_de=
fconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/62faabbc119f1266e535564d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
779-ge1dae9850fdff/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sdb=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
779-ge1dae9850fdff/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sdb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62faabbc119f1266e5355=
64e
        new failure (last pass: v5.15.60-48-g789367af88749) =

 =



platform                  | arch | lab             | compiler | defconfig  =
         | regressions
--------------------------+------+-----------------+----------+------------=
---------+------------
jetson-tk1                | arm  | lab-baylibre    | gcc-10   | multi_v7_de=
fconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fad45bc2a6a36375355654

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
779-ge1dae9850fdff/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jets=
on-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
779-ge1dae9850fdff/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jets=
on-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fad45bc2a6a36375355=
655
        new failure (last pass: v5.15.60-48-g789367af88749) =

 =



platform                  | arch | lab             | compiler | defconfig  =
         | regressions
--------------------------+------+-----------------+----------+------------=
---------+------------
jetson-tk1                | arm  | lab-baylibre    | gcc-10   | tegra_defco=
nfig     | 1          =


  Details:     https://kernelci.org/test/plan/id/62fad2ee9f3e8c0c97355642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
779-ge1dae9850fdff/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-=
tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
779-ge1dae9850fdff/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-=
tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fad2ee9f3e8c0c97355=
643
        failing since 2 days (last pass: v5.15.60-48-g789367af88749, first =
fail: v5.15.60-673-g7d1e7d167a411) =

 =



platform                  | arch | lab             | compiler | defconfig  =
         | regressions
--------------------------+------+-----------------+----------+------------=
---------+------------
panda                     | arm  | lab-baylibre    | gcc-10   | multi_v7_de=
fconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fab3b70e8284580035566f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
779-ge1dae9850fdff/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
779-ge1dae9850fdff/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fab3b70e82845800355=
670
        new failure (last pass: v5.15.60-48-g789367af88749) =

 =



platform                  | arch | lab             | compiler | defconfig  =
         | regressions
--------------------------+------+-----------------+----------+------------=
---------+------------
rk3288-rock2-square       | arm  | lab-collabora   | gcc-10   | multi_v7_de=
fconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/62faae60bea75db1ee355647

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
779-ge1dae9850fdff/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk3=
288-rock2-square.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
779-ge1dae9850fdff/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk3=
288-rock2-square.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62faae60bea75db1ee355=
648
        new failure (last pass: v5.15.60-48-g789367af88749) =

 =



platform                  | arch | lab             | compiler | defconfig  =
         | regressions
--------------------------+------+-----------------+----------+------------=
---------+------------
sun5i-a13-olinuxino-micro | arm  | lab-baylibre    | gcc-10   | sunxi_defco=
nfig     | 1          =


  Details:     https://kernelci.org/test/plan/id/62fab9bc5efd8f4433355649

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
779-ge1dae9850fdff/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun5i-a=
13-olinuxino-micro.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
779-ge1dae9850fdff/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun5i-a=
13-olinuxino-micro.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fab9bc5efd8f4433355=
64a
        failing since 2 days (last pass: v5.15.60-48-g789367af88749, first =
fail: v5.15.60-110-g5a4012ec04fef) =

 =



platform                  | arch | lab             | compiler | defconfig  =
         | regressions
--------------------------+------+-----------------+----------+------------=
---------+------------
sun7i-a20-cubieboard2     | arm  | lab-baylibre    | gcc-10   | sunxi_defco=
nfig     | 1          =


  Details:     https://kernelci.org/test/plan/id/62faa8cbda3925c6fb35565a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
779-ge1dae9850fdff/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7i-a=
20-cubieboard2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
779-ge1dae9850fdff/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7i-a=
20-cubieboard2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62faa8cbda3925c6fb355=
65b
        failing since 2 days (last pass: v5.15.60-48-g789367af88749, first =
fail: v5.15.60-110-g5a4012ec04fef) =

 =



platform                  | arch | lab             | compiler | defconfig  =
         | regressions
--------------------------+------+-----------------+----------+------------=
---------+------------
sun7i-a20-cubieboard2     | arm  | lab-clabbe      | gcc-10   | sunxi_defco=
nfig     | 1          =


  Details:     https://kernelci.org/test/plan/id/62faa8bc779f32b90b355645

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
779-ge1dae9850fdff/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun7i-a20=
-cubieboard2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
779-ge1dae9850fdff/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun7i-a20=
-cubieboard2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62faa8bc779f32b90b355=
646
        failing since 2 days (last pass: v5.15.60-48-g789367af88749, first =
fail: v5.15.60-110-g5a4012ec04fef) =

 =



platform                  | arch | lab             | compiler | defconfig  =
         | regressions
--------------------------+------+-----------------+----------+------------=
---------+------------
sun8i-a33-olinuxino       | arm  | lab-clabbe      | gcc-10   | sunxi_defco=
nfig     | 1          =


  Details:     https://kernelci.org/test/plan/id/62faa90cbfc6c74b6035566b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
779-ge1dae9850fdff/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a33=
-olinuxino.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
779-ge1dae9850fdff/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a33=
-olinuxino.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62faa90cbfc6c74b60355=
66c
        failing since 2 days (last pass: v5.15.60-48-g789367af88749, first =
fail: v5.15.60-110-g5a4012ec04fef) =

 =



platform                  | arch | lab             | compiler | defconfig  =
         | regressions
--------------------------+------+-----------------+----------+------------=
---------+------------
sun8i-h2-plus-orangepi-r1 | arm  | lab-baylibre    | gcc-10   | sunxi_defco=
nfig     | 1          =


  Details:     https://kernelci.org/test/plan/id/62fab67d9c09514b4c355679

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
779-ge1dae9850fdff/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h=
2-plus-orangepi-r1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
779-ge1dae9850fdff/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h=
2-plus-orangepi-r1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fab67d9c09514b4c355=
67a
        failing since 2 days (last pass: v5.15.60-48-g789367af88749, first =
fail: v5.15.60-110-g5a4012ec04fef) =

 =



platform                  | arch | lab             | compiler | defconfig  =
         | regressions
--------------------------+------+-----------------+----------+------------=
---------+------------
sun8i-h3-orangepi-pc      | arm  | lab-clabbe      | gcc-10   | sunxi_defco=
nfig     | 1          =


  Details:     https://kernelci.org/test/plan/id/62faaa11d6aea0cb3335565d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
779-ge1dae9850fdff/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-=
orangepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
779-ge1dae9850fdff/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-=
orangepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62faaa11d6aea0cb33355=
65e
        failing since 2 days (last pass: v5.15.60-48-g789367af88749, first =
fail: v5.15.60-110-g5a4012ec04fef) =

 =20
