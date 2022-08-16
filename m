Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3CA6595357
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 09:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbiHPHFl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 03:05:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbiHPHFM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 03:05:12 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B69A6569
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 19:48:42 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id q16so8118732pgq.6
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 19:48:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=f9mOUZGvey69/hHM4spjjTgFZDbz4fenJz5doHdU84Q=;
        b=tpO9CyxbZBEh813rhhR408GTPVS9nx+eISC7Y5FRFsikaIOJzjAXbTPHYDxWxMvHRy
         3Bd+F010vb0y8kqDnRkZqpNRzEsevW+e3QL+b5zyhIRu7Of/70D8QGB6TNK6e38s3vTp
         QT37jJ6SmSDbLOBxu+zCBj8DznzTMDtiCGsxaDP4D+yXhaHtwrRHQWFcxwJZ9+z6eRHe
         hV/q3TgFU0/yBSau1vH7xZzgXdb+5rvMW7M5FrWDmlz+NiCbROd+mX0RbI/JgoTpeeQe
         xVZdDFfvtOkWxIKN6TfW0vsaNje5LZUyNhNPaKP5pjt2WKO4FEkQ5ng4bUHxjBfdp+yO
         gr5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=f9mOUZGvey69/hHM4spjjTgFZDbz4fenJz5doHdU84Q=;
        b=4Y2d5jOok+enH3yqDKMrm8ydr0N9+x2XFMK24VBiL9+dCq1SW6NzvYL/h5g4qnTn3O
         T2Dk5xskjb72O6g7DS3bSv3GYYXx/IKjmWcVfPh4s7iN2ydKWfJgC+d2NuCJvpE0pe+G
         XTkHDqiBspSkTVH8lIyng1AMNg+Q12PWMCcOd0Cw6Pm3FfWSohpy84/IczstVWsXxK2/
         KDM8lu5XigkpSAkmSEoZkRguR7fNql2E50a/heckCxPYrku6OwwFwcqy1PFvScpKglbR
         +BTkKx6JwttUJAe7g4Md6uI9u6lSOBJw3AfCAXA4DtAIfvfs/QWsiu7SNSrCG83Lzb4X
         MecA==
X-Gm-Message-State: ACgBeo2zyHh7kD7yxZRxFFq9uJ1ZBI+oV6Bn2u2E4INHjdKDrb9OyTLN
        2yQur7pCAPI89jhOyWYQcLtNTOzUjJuHs9of
X-Google-Smtp-Source: AA6agR6OjYL4s9WBgVzpqwl2gHmOUMUb4zF7Nyrzvu0wfR6X2cVC7bi6lBppvVRgdYfcVkyJGkVh2Q==
X-Received: by 2002:a63:1450:0:b0:41c:c499:4fc8 with SMTP id 16-20020a631450000000b0041cc4994fc8mr16231703pgu.556.1660618121611;
        Mon, 15 Aug 2022 19:48:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x189-20020a6286c6000000b0052d7cca96acsm4361439pfd.110.2022.08.15.19.48.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 19:48:41 -0700 (PDT)
Message-ID: <62fb0589.620a0220.73b86.70ce@mx.google.com>
Date:   Mon, 15 Aug 2022 19:48:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.136-545-g71f2154ac93f2
Subject: stable-rc/linux-5.10.y baseline: 81 runs,
 15 regressions (v5.10.136-545-g71f2154ac93f2)
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

stable-rc/linux-5.10.y baseline: 81 runs, 15 regressions (v5.10.136-545-g71=
f2154ac93f2)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.136-545-g71f2154ac93f2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.136-545-g71f2154ac93f2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      71f2154ac93f2d6cf536292c7c72b410e05c8041 =



Test Regressions
---------------- =



platform                  | arch | lab             | compiler | defconfig  =
         | regressions
--------------------------+------+-----------------+----------+------------=
---------+------------
at91sam9g20ek             | arm  | lab-broonie     | gcc-10   | at91_dt_def=
config   | 1          =


  Details:     https://kernelci.org/test/plan/id/62facd0fec43a3025635564d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: at91_dt_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-545-g71f2154ac93f2/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at9=
1sam9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-545-g71f2154ac93f2/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at9=
1sam9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62facd0fec43a30256355=
64e
        failing since 0 day (last pass: v5.10.135-24-gcf6f87a93412e, first =
fail: v5.10.136-517-g9e37063f15dd9) =

 =



platform                  | arch | lab             | compiler | defconfig  =
         | regressions
--------------------------+------+-----------------+----------+------------=
---------+------------
cubietruck                | arm  | lab-baylibre    | gcc-10   | sunxi_defco=
nfig     | 1          =


  Details:     https://kernelci.org/test/plan/id/62fad6f028eac3fc9f355662

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-545-g71f2154ac93f2/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-545-g71f2154ac93f2/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fad6f028eac3fc9f355=
663
        failing since 0 day (last pass: v5.10.135-24-gcf6f87a93412e, first =
fail: v5.10.136-517-g9e37063f15dd9) =

 =



platform                  | arch | lab             | compiler | defconfig  =
         | regressions
--------------------------+------+-----------------+----------+------------=
---------+------------
imx6dl-riotboard          | arm  | lab-pengutronix | gcc-10   | imx_v6_v7_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62face09d2eef0a4f535566a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-545-g71f2154ac93f2/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseli=
ne-imx6dl-riotboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-545-g71f2154ac93f2/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseli=
ne-imx6dl-riotboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62face09d2eef0a4f5355=
66b
        failing since 0 day (last pass: v5.10.133-168-g4f874431e68c8, first=
 fail: v5.10.136-517-g9e37063f15dd9) =

 =



platform                  | arch | lab             | compiler | defconfig  =
         | regressions
--------------------------+------+-----------------+----------+------------=
---------+------------
imx6qp-sabresd            | arm  | lab-nxp         | gcc-10   | imx_v6_v7_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62faccd7921771f809355674

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-545-g71f2154ac93f2/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6q=
p-sabresd.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-545-g71f2154ac93f2/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6q=
p-sabresd.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62faccd7921771f809355=
675
        failing since 0 day (last pass: v5.10.133-168-g4f874431e68c8, first=
 fail: v5.10.136-517-g9e37063f15dd9) =

 =



platform                  | arch | lab             | compiler | defconfig  =
         | regressions
--------------------------+------+-----------------+----------+------------=
---------+------------
imx6sx-sdb                | arm  | lab-nxp         | gcc-10   | imx_v6_v7_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62faccea31d2e20754355685

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-545-g71f2154ac93f2/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6s=
x-sdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-545-g71f2154ac93f2/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6s=
x-sdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62faccea31d2e20754355=
686
        failing since 0 day (last pass: v5.10.133-168-g4f874431e68c8, first=
 fail: v5.10.136-517-g9e37063f15dd9) =

 =



platform                  | arch | lab             | compiler | defconfig  =
         | regressions
--------------------------+------+-----------------+----------+------------=
---------+------------
imx6ul-14x14-evk          | arm  | lab-nxp         | gcc-10   | imx_v6_v7_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62faccd949edd4591f35565e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-545-g71f2154ac93f2/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6u=
l-14x14-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-545-g71f2154ac93f2/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6u=
l-14x14-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62faccd949edd4591f355=
65f
        failing since 0 day (last pass: v5.10.128-85-g29ca824cd19a, first f=
ail: v5.10.136-517-g9e37063f15dd9) =

 =



platform                  | arch | lab             | compiler | defconfig  =
         | regressions
--------------------------+------+-----------------+----------+------------=
---------+------------
imx6ul-pico-hobbit        | arm  | lab-pengutronix | gcc-10   | imx_v6_v7_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62faeab6a8ae8adb10355657

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-545-g71f2154ac93f2/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseli=
ne-imx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-545-g71f2154ac93f2/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseli=
ne-imx6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62faeab6a8ae8adb10355=
658
        failing since 0 day (last pass: v5.10.133-168-g4f874431e68c8, first=
 fail: v5.10.136-517-g9e37063f15dd9) =

 =



platform                  | arch | lab             | compiler | defconfig  =
         | regressions
--------------------------+------+-----------------+----------+------------=
---------+------------
imx7d-sdb                 | arm  | lab-nxp         | gcc-10   | imx_v6_v7_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62facd8b5d1d6959e13556cf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-545-g71f2154ac93f2/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d=
-sdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-545-g71f2154ac93f2/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d=
-sdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62facd8b5d1d6959e1355=
6d0
        failing since 0 day (last pass: v5.10.133-168-g4f874431e68c8, first=
 fail: v5.10.136-517-g9e37063f15dd9) =

 =



platform                  | arch | lab             | compiler | defconfig  =
         | regressions
--------------------------+------+-----------------+----------+------------=
---------+------------
jetson-tk1                | arm  | lab-baylibre    | gcc-10   | tegra_defco=
nfig     | 1          =


  Details:     https://kernelci.org/test/plan/id/62fb0523bdff02d2bc355642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-545-g71f2154ac93f2/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jets=
on-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-545-g71f2154ac93f2/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jets=
on-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fb0523bdff02d2bc355=
643
        failing since 0 day (last pass: v5.10.132-149-g00d1152b11625, first=
 fail: v5.10.136-517-g9e37063f15dd9) =

 =



platform                  | arch | lab             | compiler | defconfig  =
         | regressions
--------------------------+------+-----------------+----------+------------=
---------+------------
sun5i-a13-olinuxino-micro | arm  | lab-baylibre    | gcc-10   | sunxi_defco=
nfig     | 1          =


  Details:     https://kernelci.org/test/plan/id/62facca70e36b5513c3556a6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-545-g71f2154ac93f2/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun5=
i-a13-olinuxino-micro.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-545-g71f2154ac93f2/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun5=
i-a13-olinuxino-micro.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62facca70e36b5513c355=
6a7
        failing since 0 day (last pass: v5.10.135-24-gcf6f87a93412e, first =
fail: v5.10.136-517-g9e37063f15dd9) =

 =



platform                  | arch | lab             | compiler | defconfig  =
         | regressions
--------------------------+------+-----------------+----------+------------=
---------+------------
sun7i-a20-cubieboard2     | arm  | lab-baylibre    | gcc-10   | sunxi_defco=
nfig     | 1          =


  Details:     https://kernelci.org/test/plan/id/62facc6d9675e9085635569b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-545-g71f2154ac93f2/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7=
i-a20-cubieboard2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-545-g71f2154ac93f2/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7=
i-a20-cubieboard2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62facc6d9675e90856355=
69c
        failing since 0 day (last pass: v5.10.135-24-gcf6f87a93412e, first =
fail: v5.10.136-517-g9e37063f15dd9) =

 =



platform                  | arch | lab             | compiler | defconfig  =
         | regressions
--------------------------+------+-----------------+----------+------------=
---------+------------
sun7i-a20-cubieboard2     | arm  | lab-clabbe      | gcc-10   | sunxi_defco=
nfig     | 1          =


  Details:     https://kernelci.org/test/plan/id/62facc4d9675e9085635568f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-545-g71f2154ac93f2/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun7i-=
a20-cubieboard2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-545-g71f2154ac93f2/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun7i-=
a20-cubieboard2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62facc4d9675e90856355=
690
        failing since 0 day (last pass: v5.10.135-24-gcf6f87a93412e, first =
fail: v5.10.136-517-g9e37063f15dd9) =

 =



platform                  | arch | lab             | compiler | defconfig  =
         | regressions
--------------------------+------+-----------------+----------+------------=
---------+------------
sun8i-a33-olinuxino       | arm  | lab-clabbe      | gcc-10   | sunxi_defco=
nfig     | 1          =


  Details:     https://kernelci.org/test/plan/id/62facc61f770fbc90b35565e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-545-g71f2154ac93f2/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-=
a33-olinuxino.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-545-g71f2154ac93f2/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-=
a33-olinuxino.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62facc61f770fbc90b355=
65f
        failing since 0 day (last pass: v5.10.135-24-gcf6f87a93412e, first =
fail: v5.10.136-517-g9e37063f15dd9) =

 =



platform                  | arch | lab             | compiler | defconfig  =
         | regressions
--------------------------+------+-----------------+----------+------------=
---------+------------
sun8i-h2-plus-orangepi-r1 | arm  | lab-baylibre    | gcc-10   | sunxi_defco=
nfig     | 1          =


  Details:     https://kernelci.org/test/plan/id/62fad367eac2135402355676

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-545-g71f2154ac93f2/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h2-plus-orangepi-r1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-545-g71f2154ac93f2/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h2-plus-orangepi-r1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fad367eac2135402355=
677
        failing since 0 day (last pass: v5.10.131, first fail: v5.10.136-51=
7-g9e37063f15dd9) =

 =



platform                  | arch | lab             | compiler | defconfig  =
         | regressions
--------------------------+------+-----------------+----------+------------=
---------+------------
sun8i-h3-orangepi-pc      | arm  | lab-clabbe      | gcc-10   | sunxi_defco=
nfig     | 1          =


  Details:     https://kernelci.org/test/plan/id/62facda1b1699446f335567e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-545-g71f2154ac93f2/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-=
h3-orangepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
36-545-g71f2154ac93f2/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-=
h3-orangepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62facda1b1699446f3355=
67f
        failing since 0 day (last pass: v5.10.135-24-gcf6f87a93412e, first =
fail: v5.10.136-517-g9e37063f15dd9) =

 =20
