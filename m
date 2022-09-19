Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47BC75BC288
	for <lists+stable@lfdr.de>; Mon, 19 Sep 2022 07:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbiISFdS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Sep 2022 01:33:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbiISFdR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Sep 2022 01:33:17 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A41DC17AB2
        for <stable@vger.kernel.org>; Sun, 18 Sep 2022 22:33:14 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id q35-20020a17090a752600b002038d8a68fbso1844200pjk.0
        for <stable@vger.kernel.org>; Sun, 18 Sep 2022 22:33:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=FU4B2MM8FYkA3ZBZdhYuGVy1WBkb2RZB0thd32vk9js=;
        b=DBuG5aCrn4LiCNQZGwWCHa0dRgNxgzd9FSBKTlc3OdzB41BZptdTrJRB1a+fJrGurZ
         68M52kiyuv708AaBFXyzA/SSuy9MmTAD90QnoyBqPR78R4TwqPlFLNz3dPcUE5skEjE1
         5dbEg9EpYyJiV+yeSGeBLMRcVmlyxnt6nopAlHoQQ1dvnTZnaylaS/H5uS8mWKvsJ40T
         qWJVIcQ2zgtRxobmRzKmRySegAohQcUpZ4s8sj8ZHkadxBbrUTtXpZWF3zLmVSb89NaL
         r6T/uk2aUlwMWdqkDVnzwttRU3MXCVW/6OGhvtsSPMcDUKhsLZE6UxdptxOX5yW/6knc
         5Y5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=FU4B2MM8FYkA3ZBZdhYuGVy1WBkb2RZB0thd32vk9js=;
        b=hCXzxkEHORtwSH5SI2rtSxbFQou6fb2KmCThw8oy++/Guw+HSSyuHkYmdoPgbzjHRL
         onvUf6eAWJTlmgUN+7BS8K8RqpI2WU10Ad0UYBLN/4OH438GKSsesIkl3smbynsJXrrp
         KTAX/00x3tIIwLh8uFxVb9sydESc/R5W0o8aeB1Aa0Rhqcx/IbApQaqThoxMF/IcqSbQ
         8QgZvbtd99x7ISY+SOJfa11cmSn6RjWVQSEjM5pHPzcm1YOtpJTJhbQAm8oplpyuc6GK
         VyLevxQWqQ9LQYvUfdc5cXxVKXub+FGJpeI1Y4sQUZi2iZf8g2UvhuOrRDIO6zlp1Kzz
         BsRw==
X-Gm-Message-State: ACrzQf3te0Cf+h/DVwDbun9JjsETGymXmkGhRpfqaWSj4SQDjrN91biJ
        xh/3Ib53CNmPBDr3sjPW7cuWcXZOBFqQphvZpR4=
X-Google-Smtp-Source: AMsMyM7NwX/I3ZFuKE+11ZT/xvrn+1NoYbKmX0JGkOd+GIXR+NFKsZiL1n8kg2Hqx9MKsJ8WdY5QIQ==
X-Received: by 2002:a17:90b:164a:b0:202:5f0f:290e with SMTP id il10-20020a17090b164a00b002025f0f290emr29090899pjb.27.1663565593412;
        Sun, 18 Sep 2022 22:33:13 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c206-20020a621cd7000000b00536431c6ae0sm19112740pfc.101.2022.09.18.22.33.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Sep 2022 22:33:13 -0700 (PDT)
Message-ID: <6327ff19.620a0220.ffc38.15ef@mx.google.com>
Date:   Sun, 18 Sep 2022 22:33:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.68-50-gad0a589ec3ba
Subject: stable-rc/queue/5.15 baseline: 184 runs,
 45 regressions (v5.15.68-50-gad0a589ec3ba)
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

stable-rc/queue/5.15 baseline: 184 runs, 45 regressions (v5.15.68-50-gad0a5=
89ec3ba)

Regressions Summary
-------------------

platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
at91sam9g20ek                | arm   | lab-broonie     | gcc-10   | at91_dt=
_defconfig   | 1          =

bcm2711-rpi-4-b              | arm64 | lab-linaro-lkft | gcc-10   | defconf=
ig           | 1          =

fsl-ls1028a-rdb              | arm64 | lab-nxp         | gcc-10   | defconf=
ig           | 1          =

imx53-qsrb                   | arm   | lab-pengutronix | gcc-10   | imx_v6_=
v7_defconfig | 1          =

imx53-qsrb                   | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig  | 1          =

imx6dl-riotboard             | arm   | lab-pengutronix | gcc-10   | imx_v6_=
v7_defconfig | 1          =

imx6dl-riotboard             | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig  | 1          =

imx6q-sabrelite              | arm   | lab-collabora   | gcc-10   | multi_v=
7_defconfig  | 1          =

imx6qp-sabresd               | arm   | lab-nxp         | gcc-10   | imx_v6_=
v7_defconfig | 1          =

imx6qp-wandboard-revd1       | arm   | lab-pengutronix | gcc-10   | imx_v6_=
v7_defconfig | 1          =

imx6qp-wandboard-revd1       | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig  | 1          =

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

imx7d-sdb                    | arm   | lab-nxp         | gcc-10   | multi_v=
7_defconfig  | 1          =

imx7ulp-evk                  | arm   | lab-nxp         | gcc-10   | imx_v6_=
v7_defconfig | 1          =

imx7ulp-evk                  | arm   | lab-nxp         | gcc-10   | multi_v=
7_defconfig  | 1          =

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

meson-gxl-s905x-libretech-cc | arm64 | lab-broonie     | gcc-10   | defconf=
ig           | 1          =

meson-gxl-s905x-libretech-cc | arm64 | lab-clabbe      | gcc-10   | defconf=
ig           | 1          =

meson-gxm-khadas-vim2        | arm64 | lab-baylibre    | gcc-10   | defconf=
ig           | 1          =

meson-sm1-sei610             | arm64 | lab-baylibre    | gcc-10   | defconf=
ig           | 1          =

odroid-xu3                   | arm   | lab-collabora   | gcc-10   | exynos_=
defconfig    | 1          =

odroid-xu3                   | arm   | lab-collabora   | gcc-10   | multi_v=
7_defconfig  | 1          =

rk3288-rock2-square          | arm   | lab-collabora   | gcc-10   | multi_v=
7_defconfig  | 1          =

sun5i-a13-olinuxino-micro    | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig     | 1          =

sun7i-a20-cubieboard2        | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig     | 1          =

sun7i-a20-olinuxino-lime2    | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig     | 1          =

sun8i-a33-olinuxino          | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig     | 1          =

sun8i-a83t-bananapi-m3       | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig     | 1          =

sun8i-h2-plus-orangepi-zero  | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig     | 1          =

sun8i-h3-orangepi-pc         | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.68-50-gad0a589ec3ba/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.68-50-gad0a589ec3ba
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ad0a589ec3ba94a600614bb4fb122803dd900db1 =



Test Regressions
---------------- =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
at91sam9g20ek                | arm   | lab-broonie     | gcc-10   | at91_dt=
_defconfig   | 1          =


  Details:     https://kernelci.org/test/plan/id/6327cbe487380d3ae3355680

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: at91_dt_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam9=
g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam9=
g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6327cbe487380d3ae3355=
681
        new failure (last pass: v5.15.68-34-g3fdf7e4dee84) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
bcm2711-rpi-4-b              | arm64 | lab-linaro-lkft | gcc-10   | defconf=
ig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6327cce22bf837d6b6355642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm64/defconfig/gcc-10/lab-linaro-lkft/baseline-bcm2711-rp=
i-4-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm64/defconfig/gcc-10/lab-linaro-lkft/baseline-bcm2711-rp=
i-4-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6327cce22bf837d6b6355=
643
        new failure (last pass: v5.15.68-34-g3fdf7e4dee84) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
fsl-ls1028a-rdb              | arm64 | lab-nxp         | gcc-10   | defconf=
ig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6327cd294c8b177955355698

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls1028a-rdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls1028a-rdb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6327cd294c8b177955355=
699
        new failure (last pass: v5.15.68-34-g3fdf7e4dee84) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
imx53-qsrb                   | arm   | lab-pengutronix | gcc-10   | imx_v6_=
v7_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6327cc85afaf29fa5f355660

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6327cc85afaf29fa5f355=
661
        new failure (last pass: v5.15.68-34-g3fdf7e4dee84) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
imx53-qsrb                   | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/6327cfe1c4472f8dfa355692

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6327cfe1c4472f8dfa355=
693
        new failure (last pass: v5.15.68-34-g3fdf7e4dee84) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
imx6dl-riotboard             | arm   | lab-pengutronix | gcc-10   | imx_v6_=
v7_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6327cc99892131d020355648

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x6dl-riotboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x6dl-riotboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6327cc99892131d020355=
649
        new failure (last pass: v5.15.68-34-g3fdf7e4dee84) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
imx6dl-riotboard             | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/6327d009763ba51e0835566b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
6dl-riotboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
6dl-riotboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6327d009763ba51e08355=
66c
        new failure (last pass: v5.15.68-34-g3fdf7e4dee84) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
imx6q-sabrelite              | arm   | lab-collabora   | gcc-10   | multi_v=
7_defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/6327cbdff9b3765d3f355681

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-imx6q=
-sabrelite.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-imx6q=
-sabrelite.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6327cbdff9b3765d3f355=
682
        new failure (last pass: v5.15.68-34-g3fdf7e4dee84) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
imx6qp-sabresd               | arm   | lab-nxp         | gcc-10   | imx_v6_=
v7_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6327cb1e7c64d195df355695

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6qp-sab=
resd.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6qp-sab=
resd.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6327cb1e7c64d195df355=
696
        new failure (last pass: v5.15.68-34-g3fdf7e4dee84) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
imx6qp-wandboard-revd1       | arm   | lab-pengutronix | gcc-10   | imx_v6_=
v7_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6327caf50afd7334e9355666

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x6qp-wandboard-revd1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x6qp-wandboard-revd1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6327caf50afd7334e9355=
667
        new failure (last pass: v5.15.68-34-g3fdf7e4dee84) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
imx6qp-wandboard-revd1       | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/6327cc4996a5aeecbf355657

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
6qp-wandboard-revd1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
6qp-wandboard-revd1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6327cc4996a5aeecbf355=
658
        new failure (last pass: v5.15.68-34-g3fdf7e4dee84) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
imx6sx-sdb                   | arm   | lab-nxp         | gcc-10   | imx_v6_=
v7_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6327cb49fa29df99c7355648

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6sx-sdb=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6sx-sdb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6327cb49fa29df99c7355=
649
        new failure (last pass: v5.15.68-34-g3fdf7e4dee84) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
imx6sx-sdb                   | arm   | lab-nxp         | gcc-10   | multi_v=
7_defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/6327cd3ac199268109355661

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6sx-sdb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6sx-sdb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6327cd3ac199268109355=
662
        new failure (last pass: v5.15.68-34-g3fdf7e4dee84) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
imx6ul-14x14-evk             | arm   | lab-nxp         | gcc-10   | imx_v6_=
v7_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6327cb5ffa29df99c73556aa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul-14x=
14-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul-14x=
14-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6327cb5ffa29df99c7355=
6ab
        new failure (last pass: v5.15.68-34-g3fdf7e4dee84) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
imx6ul-14x14-evk             | arm   | lab-nxp         | gcc-10   | multi_v=
7_defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/6327cd9e44daa8a13c355642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul-14x1=
4-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul-14x1=
4-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6327cd9e44daa8a13c355=
643
        new failure (last pass: v5.15.68-34-g3fdf7e4dee84) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
imx6ul-pico-hobbit           | arm   | lab-pengutronix | gcc-10   | imx_v6_=
v7_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6327cc5d54c9309f17355647

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6327cc5d54c9309f17355=
648
        new failure (last pass: v5.15.68-34-g3fdf7e4dee84) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
imx6ul-pico-hobbit           | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/6327cfcdc4472f8dfa35565a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6327cfcdc4472f8dfa355=
65b
        new failure (last pass: v5.15.68-34-g3fdf7e4dee84) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
imx7d-sdb                    | arm   | lab-nxp         | gcc-10   | imx_v6_=
v7_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6327cb471359989ace35565b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sdb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sdb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6327cb471359989ace355=
65c
        new failure (last pass: v5.15.68-34-g3fdf7e4dee84) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
imx7d-sdb                    | arm   | lab-nxp         | gcc-10   | multi_v=
7_defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/6327cbfc32c2d4e9d935564b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sdb.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sdb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6327cbfc32c2d4e9d9355=
64c
        new failure (last pass: v5.15.68-27-g08cb13c1cfaa) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
imx7ulp-evk                  | arm   | lab-nxp         | gcc-10   | imx_v6_=
v7_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6327cb5dfa29df99c73556a7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6327cb5dfa29df99c7355=
6a8
        new failure (last pass: v5.15.68-34-g3fdf7e4dee84) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
imx7ulp-evk                  | arm   | lab-nxp         | gcc-10   | multi_v=
7_defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/6327cd274c8b177955355681

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6327cd274c8b177955355=
682
        new failure (last pass: v5.15.68-34-g3fdf7e4dee84) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
imx8mn-ddr4-evk              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6327cd20c9bf6084cb355656

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-ddr4-e=
vk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-ddr4-e=
vk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6327cd20c9bf6084cb355=
657
        new failure (last pass: v5.15.68-34-g3fdf7e4dee84) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
imx8mn-ddr4-evk              | arm64 | lab-nxp         | gcc-10   | defconf=
ig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6327cd144c8b177955355642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mn-ddr4-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mn-ddr4-evk.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6327cd144c8b177955355=
643
        new failure (last pass: v5.15.68-34-g3fdf7e4dee84) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
kontron-bl-imx8mm            | arm64 | lab-kontron     | gcc-10   | defconf=
ig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6327ccb7d13b75c08d355649

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-bl-imx=
8mm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-bl-imx=
8mm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6327ccb7d13b75c08d355=
64a
        new failure (last pass: v5.15.68-34-g3fdf7e4dee84) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
kontron-pitx-imx8m           | arm64 | lab-kontron     | gcc-10   | defconf=
ig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6327ccb85f8a2a84dc355648

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-i=
mx8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-i=
mx8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6327ccb85f8a2a84dc355=
649
        new failure (last pass: v5.15.68-34-g3fdf7e4dee84) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
meson-g12a-sei510            | arm64 | lab-baylibre    | gcc-10   | defconf=
ig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6327cc8b36238a8394355675

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-se=
i510.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-se=
i510.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6327cc8b36238a8394355=
676
        new failure (last pass: v5.15.68-34-g3fdf7e4dee84) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
meson-g12a-x96-max           | arm64 | lab-baylibre    | gcc-10   | defconf=
ig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6327cc8a36238a8394355672

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-x9=
6-max.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-x9=
6-max.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6327cc8a36238a8394355=
673
        new failure (last pass: v5.15.68-34-g3fdf7e4dee84) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-baylibre    | gcc-10   | defconf=
ig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6327d8ea884a690c12355661

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-a3=
11d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-a3=
11d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6327d8ea884a690c12355=
662
        new failure (last pass: v5.15.68-34-g3fdf7e4dee84) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-collabora   | gcc-10   | defconf=
ig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6327d5622c3c6e730d35567a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm64/defconfig/gcc-10/lab-collabora/baseline-meson-g12b-a=
311d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm64/defconfig/gcc-10/lab-collabora/baseline-meson-g12b-a=
311d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6327d5622c3c6e730d355=
67b
        new failure (last pass: v5.15.68-34-g3fdf7e4dee84) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
meson-g12b-odroid-n2         | arm64 | lab-baylibre    | gcc-10   | defconf=
ig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6327d087fc501d812b355645

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-od=
roid-n2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-od=
roid-n2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6327d087fc501d812b355=
646
        new failure (last pass: v5.15.68-34-g3fdf7e4dee84) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
meson-gxl-s905x-khadas-vim   | arm64 | lab-baylibre    | gcc-10   | defconf=
ig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6327cca5ef68d0cbf6355660

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s90=
5x-khadas-vim.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s90=
5x-khadas-vim.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6327cca5ef68d0cbf6355=
661
        new failure (last pass: v5.15.68-34-g3fdf7e4dee84) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-broonie     | gcc-10   | defconf=
ig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6327cc99be72a533d3355647

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s905=
x-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s905=
x-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6327cc9abe72a533d3355=
648
        new failure (last pass: v5.15.68-34-g3fdf7e4dee84) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-clabbe      | gcc-10   | defconf=
ig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6327ce77d80ea20df3355659

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm64/defconfig/gcc-10/lab-clabbe/baseline-meson-gxl-s905x=
-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm64/defconfig/gcc-10/lab-clabbe/baseline-meson-gxl-s905x=
-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6327ce77d80ea20df3355=
65a
        new failure (last pass: v5.15.68-34-g3fdf7e4dee84) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
meson-gxm-khadas-vim2        | arm64 | lab-baylibre    | gcc-10   | defconf=
ig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6327cca6ef68d0cbf6355663

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm-kha=
das-vim2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm-kha=
das-vim2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6327cca6ef68d0cbf6355=
664
        new failure (last pass: v5.15.68-34-g3fdf7e4dee84) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
meson-sm1-sei610             | arm64 | lab-baylibre    | gcc-10   | defconf=
ig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6327cc9e892131d020355668

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-sm1-sei=
610.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-sm1-sei=
610.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6327cc9e892131d020355=
669
        new failure (last pass: v5.15.68-34-g3fdf7e4dee84) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
odroid-xu3                   | arm   | lab-collabora   | gcc-10   | exynos_=
defconfig    | 1          =


  Details:     https://kernelci.org/test/plan/id/6327ebbdb6835d7c35355642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: exynos_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-odroid-=
xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-odroid-=
xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6327ebbdb6835d7c35355=
643
        new failure (last pass: v5.15.68-34-g3fdf7e4dee84) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
odroid-xu3                   | arm   | lab-collabora   | gcc-10   | multi_v=
7_defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/6327e609a447bc6f0e355642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-odroi=
d-xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-odroi=
d-xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6327e609a447bc6f0e355=
643
        new failure (last pass: v5.15.68-34-g3fdf7e4dee84) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
rk3288-rock2-square          | arm   | lab-collabora   | gcc-10   | multi_v=
7_defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/6327cf20d6bfb8595d355675

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk328=
8-rock2-square.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk328=
8-rock2-square.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6327cf20d6bfb8595d355=
676
        new failure (last pass: v5.15.68-34-g3fdf7e4dee84) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
sun5i-a13-olinuxino-micro    | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig     | 1          =


  Details:     https://kernelci.org/test/plan/id/6327c97d59825c535835568f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun5i-a13=
-olinuxino-micro.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun5i-a13=
-olinuxino-micro.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6327c97d59825c5358355=
690
        new failure (last pass: v5.15.68-34-g3fdf7e4dee84) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
sun7i-a20-cubieboard2        | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig     | 1          =


  Details:     https://kernelci.org/test/plan/id/6327ca7a63a819dd583556ba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun7i-a20-c=
ubieboard2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun7i-a20-c=
ubieboard2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6327ca7a63a819dd58355=
6bb
        new failure (last pass: v5.15.68-34-g3fdf7e4dee84) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
sun7i-a20-olinuxino-lime2    | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig     | 1          =


  Details:     https://kernelci.org/test/plan/id/6327f895ff8c1a1cd4355643

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7i-a20=
-olinuxino-lime2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7i-a20=
-olinuxino-lime2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6327f895ff8c1a1cd4355=
644
        new failure (last pass: v5.15.68-34-g3fdf7e4dee84) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
sun8i-a33-olinuxino          | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig     | 1          =


  Details:     https://kernelci.org/test/plan/id/6327cbbbd1222b5f88355663

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a33-o=
linuxino.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a33-o=
linuxino.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6327cbbbd1222b5f88355=
664
        new failure (last pass: v5.15.68-34-g3fdf7e4dee84) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
sun8i-a83t-bananapi-m3       | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig     | 1          =


  Details:     https://kernelci.org/test/plan/id/6327ca05d61a0b4118355642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a83t-=
bananapi-m3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a83t-=
bananapi-m3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6327ca05d61a0b4118355=
643
        new failure (last pass: v5.15.68-34-g3fdf7e4dee84) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
sun8i-h2-plus-orangepi-zero  | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig     | 1          =


  Details:     https://kernelci.org/test/plan/id/6327cb7a7a540d1dae355642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h2-=
plus-orangepi-zero.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h2-=
plus-orangepi-zero.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6327cb7a7a540d1dae355=
643
        new failure (last pass: v5.15.68-34-g3fdf7e4dee84) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig           | regressions
-----------------------------+-------+-----------------+----------+--------=
-------------+------------
sun8i-h3-orangepi-pc         | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig     | 1          =


  Details:     https://kernelci.org/test/plan/id/6327d39f2a3e673abd355642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-or=
angepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.68-=
50-gad0a589ec3ba/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-or=
angepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6327d39f2a3e673abd355=
643
        new failure (last pass: v5.15.68-34-g3fdf7e4dee84) =

 =20
