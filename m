Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B665F59316E
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 17:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232905AbiHOPOR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 11:14:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243030AbiHOPNv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 11:13:51 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ABC624F1E
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 08:13:18 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id s206so6741286pgs.3
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 08:13:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=MOP0Y0YS/8AVAD19d1oTge4ipx5rwjx8EsCbJz+AScs=;
        b=GvN7vShHAXtWvxmeMmoOZV2b2kcuARLaK3ySxFASTgTJOH4gqUy7D2AKMcw5C5hux6
         izpPoAMJzhmFxjo/LMpRoSNFHcK7+FTK+P/KGj9ReHn1dKbEGOFxygnMvlxAWGT8KNmz
         icHr5okC9qTC5Rah4cAiCnVxOrFcGT6bObho3nB4bm4JWnuYtQ6oPnkuKtpGSGVeKINL
         NwgjKT7ef6KWos5tWaxTkAo8ildIthOMspVKtMokAn7p26FANiZZeXQQGItzycCN4anl
         2Apj5BtvnnDrRlpaGIRV6kxs57kxf1jc9L2Tu1p0i0ESzY6s5W0Kpko7MbgTdbyWiGFx
         671A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=MOP0Y0YS/8AVAD19d1oTge4ipx5rwjx8EsCbJz+AScs=;
        b=Dqbf1f+4AmzD7+tye09YO053scaHsNOOaAlR+IJXvrwkLBjfZELjTk8fiHMriq2a6X
         KsN68194rnwyHHaBvSqDKkpkqo0gpIesgbtQuQXvOQpAXT5DWoAZeGkvl3omr70TLdme
         LwEFO2oGXG316RoJAxQW4a1Qw/ypL7wcKjfhd+mB8VnxBdhw/qAiP6TLZT2LR4qRystI
         LJ2w8m7S6XVVHdFoNf4EOnpTWflhYNjOmLvXy7gp3b7LNS9KEhd/w+8ad9+T3SRcmRsS
         zvwABcwyYrDPZY1am5NWv5WoAoeFeK8yozHSzY516pYCfGoKLLpc+APYZPaURF9zQa+f
         oDkQ==
X-Gm-Message-State: ACgBeo2z911K+ayCTgje2/TG1csf1sXGk7QsDVaNr0Y9nzSEf02y4h1r
        nV5zbs4BQ1cK+fww0+H09JnwgxKpD6mhM4ta
X-Google-Smtp-Source: AA6agR50iHvPjFvnRTn0XoEBQNGSmH/mv2gflE+/Pt8BDvKO5gtUaT8aOt9RQ2X9D+qxRuMVAsge7A==
X-Received: by 2002:a63:1265:0:b0:41d:a571:2805 with SMTP id 37-20020a631265000000b0041da5712805mr14163833pgs.230.1660576396347;
        Mon, 15 Aug 2022 08:13:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r22-20020a635156000000b0040c40b022fbsm5865241pgl.94.2022.08.15.08.13.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 08:13:15 -0700 (PDT)
Message-ID: <62fa628b.630a0220.f7b00.92fe@mx.google.com>
Date:   Mon, 15 Aug 2022 08:13:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.255-191-gab9c8d4442969
Subject: stable-rc/linux-4.19.y baseline: 149 runs,
 42 regressions (v4.19.255-191-gab9c8d4442969)
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

stable-rc/linux-4.19.y baseline: 149 runs, 42 regressions (v4.19.255-191-ga=
b9c8d4442969)

Regressions Summary
-------------------

platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
at91sam9g20ek               | arm   | lab-broonie     | gcc-10   | at91_dt_=
defconfig          | 1          =

cubietruck                  | arm   | lab-baylibre    | gcc-10   | sunxi_de=
fconfig            | 1          =

imx6dl-riotboard            | arm   | lab-pengutronix | gcc-10   | imx_v6_v=
7_defconfig        | 1          =

imx6dl-riotboard            | arm   | lab-pengutronix | gcc-10   | multi_v7=
_defconfig         | 1          =

imx6q-sabrelite             | arm   | lab-collabora   | gcc-10   | multi_v7=
_defconfig         | 1          =

imx6qp-sabresd              | arm   | lab-nxp         | gcc-10   | imx_v6_v=
7_defconfig        | 1          =

imx6sx-sdb                  | arm   | lab-nxp         | gcc-10   | imx_v6_v=
7_defconfig        | 1          =

imx6sx-sdb                  | arm   | lab-nxp         | gcc-10   | multi_v7=
_defconfig         | 1          =

imx6ul-14x14-evk            | arm   | lab-nxp         | gcc-10   | imx_v6_v=
7_defconfig        | 1          =

imx6ul-14x14-evk            | arm   | lab-nxp         | gcc-10   | multi_v7=
_defconfig         | 1          =

imx6ul-pico-hobbit          | arm   | lab-pengutronix | gcc-10   | imx_v6_v=
7_defconfig        | 1          =

imx6ul-pico-hobbit          | arm   | lab-pengutronix | gcc-10   | multi_v7=
_defconfig         | 1          =

imx7d-sdb                   | arm   | lab-nxp         | gcc-10   | imx_v6_v=
7_defconfig        | 1          =

jetson-tk1                  | arm   | lab-baylibre    | gcc-10   | multi_v7=
_defconfig         | 1          =

jetson-tk1                  | arm   | lab-baylibre    | gcc-10   | tegra_de=
fconfig            | 1          =

odroid-xu3                  | arm   | lab-collabora   | gcc-10   | exynos_d=
efconfig           | 1          =

odroid-xu3                  | arm   | lab-collabora   | gcc-10   | multi_v7=
_defconfig         | 1          =

qemu_arm64-virt-gicv2       | arm64 | lab-broonie     | gcc-10   | defconfi=
g                  | 1          =

qemu_arm64-virt-gicv2       | arm64 | lab-broonie     | gcc-10   | defconfi=
g+arm64-chromebook | 1          =

qemu_arm64-virt-gicv2       | arm64 | lab-collabora   | gcc-10   | defconfi=
g                  | 1          =

qemu_arm64-virt-gicv2-uefi  | arm64 | lab-broonie     | gcc-10   | defconfi=
g                  | 1          =

qemu_arm64-virt-gicv2-uefi  | arm64 | lab-broonie     | gcc-10   | defconfi=
g+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3       | arm64 | lab-broonie     | gcc-10   | defconfi=
g                  | 1          =

qemu_arm64-virt-gicv3       | arm64 | lab-broonie     | gcc-10   | defconfi=
g+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3       | arm64 | lab-collabora   | gcc-10   | defconfi=
g                  | 1          =

qemu_arm64-virt-gicv3       | arm64 | lab-collabora   | gcc-10   | defconfi=
g+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi  | arm64 | lab-broonie     | gcc-10   | defconfi=
g                  | 1          =

qemu_arm64-virt-gicv3-uefi  | arm64 | lab-broonie     | gcc-10   | defconfi=
g+arm64-chromebook | 1          =

rk3288-rock2-square         | arm   | lab-collabora   | gcc-10   | multi_v7=
_defconfig         | 1          =

rk3399-gru-kevin            | arm64 | lab-collabora   | gcc-10   | defconfi=
g+arm64-chromebook | 1          =

sun4i-a10-olinuxino-lime    | arm   | lab-baylibre    | gcc-10   | sunxi_de=
fconfig            | 1          =

sun50i-a64-bananapi-m64     | arm64 | lab-clabbe      | gcc-10   | defconfi=
g                  | 1          =

sun5i-a13-olinuxino-micro   | arm   | lab-baylibre    | gcc-10   | sunxi_de=
fconfig            | 1          =

sun7i-a20-cubieboard2       | arm   | lab-baylibre    | gcc-10   | sunxi_de=
fconfig            | 1          =

sun7i-a20-cubieboard2       | arm   | lab-clabbe      | gcc-10   | sunxi_de=
fconfig            | 1          =

sun7i-a20-olinuxino-lime2   | arm   | lab-baylibre    | gcc-10   | sunxi_de=
fconfig            | 1          =

sun8i-a33-olinuxino         | arm   | lab-clabbe      | gcc-10   | sunxi_de=
fconfig            | 1          =

sun8i-h2-plus-orangepi-r1   | arm   | lab-baylibre    | gcc-10   | sunxi_de=
fconfig            | 1          =

sun8i-h2-plus-orangepi-zero | arm   | lab-baylibre    | gcc-10   | sunxi_de=
fconfig            | 1          =

sun8i-h3-orangepi-pc        | arm   | lab-clabbe      | gcc-10   | sunxi_de=
fconfig            | 1          =

zynqmp-zcu102               | arm64 | lab-cip         | gcc-10   | defconfi=
g                  | 1          =

zynqmp-zcu102               | arm64 | lab-cip         | gcc-10   | defconfi=
g+arm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.255-191-gab9c8d4442969/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.255-191-gab9c8d4442969
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ab9c8d444296931571bf9154ac64138346b1496d =



Test Regressions
---------------- =



platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
at91sam9g20ek               | arm   | lab-broonie     | gcc-10   | at91_dt_=
defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa2f9d33879150a8daf085

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: at91_dt_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at9=
1sam9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at9=
1sam9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa2f9d33879150a8daf=
086
        new failure (last pass: v4.19.254) =

 =



platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
cubietruck                  | arm   | lab-baylibre    | gcc-10   | sunxi_de=
fconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa35c8ea3a5c8bccdaf074

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa35c8ea3a5c8bccdaf=
075
        new failure (last pass: v4.19.254-33-g02c6011ece11) =

 =



platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
imx6dl-riotboard            | arm   | lab-pengutronix | gcc-10   | imx_v6_v=
7_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa3403797eec87fcdaf067

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseli=
ne-imx6dl-riotboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseli=
ne-imx6dl-riotboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa3403797eec87fcdaf=
068
        new failure (last pass: v4.19.254-33-g02c6011ece11) =

 =



platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
imx6dl-riotboard            | arm   | lab-pengutronix | gcc-10   | multi_v7=
_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa36e7fcb6de5d1edaf05c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baselin=
e-imx6dl-riotboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baselin=
e-imx6dl-riotboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa36e7fcb6de5d1edaf=
05d
        new failure (last pass: v4.19.254-33-g02c6011ece11) =

 =



platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
imx6q-sabrelite             | arm   | lab-collabora   | gcc-10   | multi_v7=
_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa2face1db134eb1daf057

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-=
imx6q-sabrelite.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-=
imx6q-sabrelite.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa2face1db134eb1daf=
058
        new failure (last pass: v4.19.254-33-g02c6011ece11) =

 =



platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
imx6qp-sabresd              | arm   | lab-nxp         | gcc-10   | imx_v6_v=
7_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa2f3b1c248b92fadaf062

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6q=
p-sabresd.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6q=
p-sabresd.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa2f3b1c248b92fadaf=
063
        new failure (last pass: v4.19.254-33-g02c6011ece11) =

 =



platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
imx6sx-sdb                  | arm   | lab-nxp         | gcc-10   | imx_v6_v=
7_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa2f4d1446c192ccdaf082

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6s=
x-sdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6s=
x-sdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa2f4d1446c192ccdaf=
083
        new failure (last pass: v4.19.254-33-g02c6011ece11) =

 =



platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
imx6sx-sdb                  | arm   | lab-nxp         | gcc-10   | multi_v7=
_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa30dc7e9aff5f12daf056

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6sx=
-sdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6sx=
-sdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa30dc7e9aff5f12daf=
057
        new failure (last pass: v4.19.254-33-g02c6011ece11) =

 =



platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
imx6ul-14x14-evk            | arm   | lab-nxp         | gcc-10   | imx_v6_v=
7_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa2f4b1446c192ccdaf07c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6u=
l-14x14-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6u=
l-14x14-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa2f4b1446c192ccdaf=
07d
        new failure (last pass: v4.19.254-33-g02c6011ece11) =

 =



platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
imx6ul-14x14-evk            | arm   | lab-nxp         | gcc-10   | multi_v7=
_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa30da9ac443c5f5daf07e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul=
-14x14-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul=
-14x14-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa30da9ac443c5f5daf=
07f
        new failure (last pass: v4.19.254-33-g02c6011ece11) =

 =



platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
imx6ul-pico-hobbit          | arm   | lab-pengutronix | gcc-10   | imx_v6_v=
7_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa3af70cdb71c6e8daf05e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseli=
ne-imx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseli=
ne-imx6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa3af70cdb71c6e8daf=
05f
        new failure (last pass: v4.19.254-33-g02c6011ece11) =

 =



platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
imx6ul-pico-hobbit          | arm   | lab-pengutronix | gcc-10   | multi_v7=
_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa3db36e500056a9daf088

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baselin=
e-imx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baselin=
e-imx6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa3db36e500056a9daf=
089
        new failure (last pass: v4.19.254-33-g02c6011ece11) =

 =



platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
imx7d-sdb                   | arm   | lab-nxp         | gcc-10   | imx_v6_v=
7_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa2f4fa83c72b654daf065

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d=
-sdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d=
-sdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa2f4fa83c72b654daf=
066
        new failure (last pass: v4.19.254-33-g02c6011ece11) =

 =



platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
jetson-tk1                  | arm   | lab-baylibre    | gcc-10   | multi_v7=
_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa416abf5162aa6edaf069

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-j=
etson-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-j=
etson-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa416abf5162aa6edaf=
06a
        new failure (last pass: v4.19.254-33-g02c6011ece11) =

 =



platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
jetson-tk1                  | arm   | lab-baylibre    | gcc-10   | tegra_de=
fconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa3eaecde8ae5c71daf056

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jets=
on-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jets=
on-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa3eaecde8ae5c71daf=
057
        new failure (last pass: v4.19.252-49-g8b84863f2dd59) =

 =



platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
odroid-xu3                  | arm   | lab-collabora   | gcc-10   | exynos_d=
efconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa446a939f4ac54edaf080

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: exynos_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-od=
roid-xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-od=
roid-xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa446a939f4ac54edaf=
081
        new failure (last pass: v4.19.254-33-g02c6011ece11) =

 =



platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
odroid-xu3                  | arm   | lab-collabora   | gcc-10   | multi_v7=
_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa488f6b94185fdfdaf07c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-=
odroid-xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-=
odroid-xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa488f6b94185fdfdaf=
07d
        new failure (last pass: v4.19.254-33-g02c6011ece11) =

 =



platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
qemu_arm64-virt-gicv2       | arm64 | lab-broonie     | gcc-10   | defconfi=
g                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa33e9797eec87fcdaf056

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm6=
4-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm6=
4-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa33e9797eec87fcdaf=
057
        new failure (last pass: v4.19.230-41-g73351b9c55d9) =

 =



platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
qemu_arm64-virt-gicv2       | arm64 | lab-broonie     | gcc-10   | defconfi=
g+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa356582262b3959daf071

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/b=
aseline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/b=
aseline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa356582262b3959daf=
072
        failing since 97 days (last pass: v4.19.241-59-g7070c1b6eeed, first=
 fail: v4.19.241-79-ge28b1117a7ab) =

 =



platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
qemu_arm64-virt-gicv2       | arm64 | lab-collabora   | gcc-10   | defconfi=
g                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa2faded25e63b03daf057

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_ar=
m64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_ar=
m64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa2faded25e63b03daf=
058
        new failure (last pass: v4.19.230-41-g73351b9c55d9) =

 =



platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
qemu_arm64-virt-gicv2-uefi  | arm64 | lab-broonie     | gcc-10   | defconfi=
g                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa34257d21433e9ddaf067

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm6=
4-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm6=
4-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa34257d21433e9ddaf=
068
        failing since 96 days (last pass: v4.19.241-59-g7070c1b6eeed, first=
 fail: v4.19.241-89-g71a9ee8b0cfd) =

 =



platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
qemu_arm64-virt-gicv2-uefi  | arm64 | lab-broonie     | gcc-10   | defconfi=
g+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa35a181ca380785daf07b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/b=
aseline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/b=
aseline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa35a181ca380785daf=
07c
        failing since 97 days (last pass: v4.19.241-59-g7070c1b6eeed, first=
 fail: v4.19.241-79-ge28b1117a7ab) =

 =



platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
qemu_arm64-virt-gicv3       | arm64 | lab-broonie     | gcc-10   | defconfi=
g                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa33ea0b4d9a500bdaf074

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm6=
4-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm6=
4-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa33ea0b4d9a500bdaf=
075
        failing since 11 days (last pass: v4.19.230-41-g73351b9c55d9, first=
 fail: v4.19.254) =

 =



platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
qemu_arm64-virt-gicv3       | arm64 | lab-broonie     | gcc-10   | defconfi=
g+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa35a35298305425daf066

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/b=
aseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/b=
aseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa35a35298305425daf=
067
        new failure (last pass: v4.19.230-41-g73351b9c55d9) =

 =



platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
qemu_arm64-virt-gicv3       | arm64 | lab-collabora   | gcc-10   | defconfi=
g                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa2faea2aa6fec9fdaf059

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_ar=
m64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_ar=
m64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa2faea2aa6fec9fdaf=
05a
        failing since 11 days (last pass: v4.19.230-41-g73351b9c55d9, first=
 fail: v4.19.254) =

 =



platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
qemu_arm64-virt-gicv3       | arm64 | lab-collabora   | gcc-10   | defconfi=
g+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa31014f76735635daf06e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora=
/baseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora=
/baseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa31014f76735635daf=
06f
        new failure (last pass: v4.19.230-41-g73351b9c55d9) =

 =



platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
qemu_arm64-virt-gicv3-uefi  | arm64 | lab-broonie     | gcc-10   | defconfi=
g                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa33fd0b4d9a500bdaf081

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm6=
4-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm6=
4-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa33fd0b4d9a500bdaf=
082
        failing since 96 days (last pass: v4.19.241-59-g7070c1b6eeed, first=
 fail: v4.19.241-89-g71a9ee8b0cfd) =

 =



platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
qemu_arm64-virt-gicv3-uefi  | arm64 | lab-broonie     | gcc-10   | defconfi=
g+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa358d412fada5eddaf07a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/b=
aseline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/b=
aseline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa358d412fada5eddaf=
07b
        failing since 97 days (last pass: v4.19.241-59-g7070c1b6eeed, first=
 fail: v4.19.241-79-ge28b1117a7ab) =

 =



platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
rk3288-rock2-square         | arm   | lab-collabora   | gcc-10   | multi_v7=
_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa33450e69789a8adaf066

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-=
rk3288-rock2-square.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-=
rk3288-rock2-square.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa33450e69789a8adaf=
067
        new failure (last pass: v4.19.254-33-g02c6011ece11) =

 =



platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
rk3399-gru-kevin            | arm64 | lab-collabora   | gcc-10   | defconfi=
g+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa300ee41c2b5e1bdaf078

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora=
/baseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora=
/baseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62fa300ee41c2b5e1bdaf09a
        failing since 161 days (last pass: v4.19.232, first fail: v4.19.232=
-45-g5da8d73687e7)

    2022-08-15T11:37:27.348461  /lava-7037767/1/../bin/lava-test-case<8>[  =
 35.760626] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-i2s0-probed RESUL=
T=3Dpass>
    2022-08-15T11:37:27.348533  =

    2022-08-15T11:37:28.359572  /lava-7037767/1/../bin/lava-test-case   =

 =



platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
sun4i-a10-olinuxino-lime    | arm   | lab-baylibre    | gcc-10   | sunxi_de=
fconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa4a92a7647692b3daf086

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun4=
i-a10-olinuxino-lime.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun4=
i-a10-olinuxino-lime.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa4a92a7647692b3daf=
087
        new failure (last pass: v4.19.254-33-g02c6011ece11) =

 =



platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
sun50i-a64-bananapi-m64     | arm64 | lab-clabbe      | gcc-10   | defconfi=
g                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa2ffa790b794707daf07b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64=
-bananapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64=
-bananapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa2ffa790b794707daf=
07c
        new failure (last pass: v4.19.254-33-g02c6011ece11) =

 =



platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
sun5i-a13-olinuxino-micro   | arm   | lab-baylibre    | gcc-10   | sunxi_de=
fconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa35268add52fbbedaf05b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun5=
i-a13-olinuxino-micro.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun5=
i-a13-olinuxino-micro.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa35268add52fbbedaf=
05c
        new failure (last pass: v4.19.254-33-g02c6011ece11) =

 =



platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
sun7i-a20-cubieboard2       | arm   | lab-baylibre    | gcc-10   | sunxi_de=
fconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa2e41eb94f4cd3ddaf05b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7=
i-a20-cubieboard2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7=
i-a20-cubieboard2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa2e41eb94f4cd3ddaf=
05c
        new failure (last pass: v4.19.254-33-g02c6011ece11) =

 =



platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
sun7i-a20-cubieboard2       | arm   | lab-clabbe      | gcc-10   | sunxi_de=
fconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa2e56292ddbf81ddaf05a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun7i-=
a20-cubieboard2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun7i-=
a20-cubieboard2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa2e56292ddbf81ddaf=
05b
        new failure (last pass: v4.19.254-33-g02c6011ece11) =

 =



platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
sun7i-a20-olinuxino-lime2   | arm   | lab-baylibre    | gcc-10   | sunxi_de=
fconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa585b3949e1d008355718

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7=
i-a20-olinuxino-lime2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7=
i-a20-olinuxino-lime2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa585b3949e1d008355=
719
        new failure (last pass: v4.19.254-33-g02c6011ece11) =

 =



platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
sun8i-a33-olinuxino         | arm   | lab-clabbe      | gcc-10   | sunxi_de=
fconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa2e4133451993b8daf067

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-=
a33-olinuxino.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-=
a33-olinuxino.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa2e4233451993b8daf=
068
        new failure (last pass: v4.19.254-33-g02c6011ece11) =

 =



platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
sun8i-h2-plus-orangepi-r1   | arm   | lab-baylibre    | gcc-10   | sunxi_de=
fconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa3415797eec87fcdaf07f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h2-plus-orangepi-r1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h2-plus-orangepi-r1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa3415797eec87fcdaf=
080
        new failure (last pass: v4.19.254) =

 =



platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
sun8i-h2-plus-orangepi-zero | arm   | lab-baylibre    | gcc-10   | sunxi_de=
fconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa620d9ec4a6c2c3355690

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h2-plus-orangepi-zero.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h2-plus-orangepi-zero.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa620d9ec4a6c2c3355=
691
        new failure (last pass: v4.19.254-33-g02c6011ece11) =

 =



platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
sun8i-h3-orangepi-pc        | arm   | lab-clabbe      | gcc-10   | sunxi_de=
fconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa303672ff014699daf083

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-=
h3-orangepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-=
h3-orangepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa303672ff014699daf=
084
        new failure (last pass: v4.19.254-33-g02c6011ece11) =

 =



platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
zynqmp-zcu102               | arm64 | lab-cip         | gcc-10   | defconfi=
g                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa2faea2aa6fec9fdaf05c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm64/defconfig/gcc-10/lab-cip/baseline-zynqmp-zcu102=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm64/defconfig/gcc-10/lab-cip/baseline-zynqmp-zcu102=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa2faea2aa6fec9fdaf=
05d
        new failure (last pass: v4.19.254-33-g02c6011ece11) =

 =



platform                    | arch  | lab             | compiler | defconfi=
g                  | regressions
----------------------------+-------+-----------------+----------+---------=
-------------------+------------
zynqmp-zcu102               | arm64 | lab-cip         | gcc-10   | defconfi=
g+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fa315221d029a9cedaf09a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm64/defconfig+arm64-chromebook/gcc-10/lab-cip/basel=
ine-zynqmp-zcu102.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
55-191-gab9c8d4442969/arm64/defconfig+arm64-chromebook/gcc-10/lab-cip/basel=
ine-zynqmp-zcu102.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fa315221d029a9cedaf=
09b
        new failure (last pass: v4.19.254-33-g02c6011ece11) =

 =20
