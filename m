Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B595C591D91
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 04:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbiHNCPY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Aug 2022 22:15:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiHNCPX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Aug 2022 22:15:23 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FBBADF5C
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 19:15:20 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id 15-20020a17090a098f00b001f305b453feso11624261pjo.1
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 19:15:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=XM0beNmaSi8sBT7HwCcBOPIia0koD5nlfLoTLsByIXg=;
        b=gQ4C1SCrHNgaXtFwCQP1dcLXE3VMs4WxjN6G1uTWXoNdOtUTXzXwJ+yYm6uz7jfXHi
         rXQnuLtJTjyph8Jb6oKxbHhQheQetQIg5g5RIb7NoGmCEBDrnApZ+zEoEyzEAPOOPamR
         NEGlsz8YXNIIjQug54D54v+UkgSxWN8ZHUQIj/z+sxQUyKdfWXeHKBbiKpmn71xuk7Gu
         lfMzcD64Q918cFezyDDsQ5nx16oyKX40Hm1eoEjztWwRtmHpe4gAHmVmYWAJdzBPdNyA
         tXaA43aaLAGMgTSjAKt4DgDio+oFYfgylGyBzB1oRN3rMhdIvy/Qu87re1v6lL+MbmVl
         tG5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=XM0beNmaSi8sBT7HwCcBOPIia0koD5nlfLoTLsByIXg=;
        b=PS1WPc2OrpxS3j/MV1OUllcnwEFNrxH5k/7OAnk3GgywCHTltnD+9ZKKX8Ib1g6XTS
         ewXwhyyggKJRMHZuxuMsMT//88wzweYTP5St2a7cX83AtxGfUha7oEqanj24YmChAstv
         5ncLu1MF7dk3oyNjiiuzzGLDFyyRfQOhjqCRACQ92oa2hvs/xEVsWXpwNNfnuZoriCNp
         hlWsROVHhjKbZqN4rJiINz7ITrNFh3EIvu8Jk2bikN/9CCVsLXLeY8WI4EGhoUyC9ffB
         U+YCJc6TbpgYuqww8eP6y5vQHAvw0QxH32VJ6qibvH9HN7brAl3ftHdv3kjGUS+g4T/s
         xgwQ==
X-Gm-Message-State: ACgBeo0s8FLNrOD7rvFY3N6F4uJiNnS2xMj49pHAr9wl2i3QTeMTqjdG
        +zdQZj+PiyhzsBwvsw9gS4kQJ2jVOBQWX9aO
X-Google-Smtp-Source: AA6agR5+/iD9J1xpqKKyJiUC7gHdi1lfpNEqJMoL1w4FB/OnVh7RIrgnYYNa98gS2e+AugEKOs/eQg==
X-Received: by 2002:a17:90a:e7cc:b0:1f7:26c9:ee9f with SMTP id kb12-20020a17090ae7cc00b001f726c9ee9fmr11842201pjb.75.1660443319887;
        Sat, 13 Aug 2022 19:15:19 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x7-20020a170902ec8700b0016d9a17c8e0sm4410069plg.68.2022.08.13.19.15.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Aug 2022 19:15:19 -0700 (PDT)
Message-ID: <62f85ab7.170a0220.be50e.7b37@mx.google.com>
Date:   Sat, 13 Aug 2022 19:15:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.60-673-g7d1e7d167a411
Subject: stable-rc/queue/5.15 baseline: 79 runs,
 20 regressions (v5.15.60-673-g7d1e7d167a411)
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

stable-rc/queue/5.15 baseline: 79 runs, 20 regressions (v5.15.60-673-g7d1e7=
d167a411)

Regressions Summary
-------------------

platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
at91sam9g20ek               | arm  | lab-broonie     | gcc-10   | at91_dt_d=
efconfig   | 1          =

cubietruck                  | arm  | lab-baylibre    | gcc-10   | sunxi_def=
config     | 1          =

imx6dl-riotboard            | arm  | lab-pengutronix | gcc-10   | imx_v6_v7=
_defconfig | 1          =

imx6qp-sabresd              | arm  | lab-nxp         | gcc-10   | imx_v6_v7=
_defconfig | 1          =

imx6qp-wandboard-revd1      | arm  | lab-pengutronix | gcc-10   | imx_v6_v7=
_defconfig | 1          =

imx6sx-sdb                  | arm  | lab-nxp         | gcc-10   | imx_v6_v7=
_defconfig | 1          =

imx6ul-14x14-evk            | arm  | lab-nxp         | gcc-10   | imx_v6_v7=
_defconfig | 1          =

imx6ul-pico-hobbit          | arm  | lab-pengutronix | gcc-10   | imx_v6_v7=
_defconfig | 1          =

imx7d-sdb                   | arm  | lab-nxp         | gcc-10   | imx_v6_v7=
_defconfig | 1          =

imx7ulp-evk                 | arm  | lab-nxp         | gcc-10   | imx_v6_v7=
_defconfig | 1          =

jetson-tk1                  | arm  | lab-baylibre    | gcc-10   | tegra_def=
config     | 1          =

odroid-xu3                  | arm  | lab-collabora   | gcc-10   | exynos_de=
fconfig    | 1          =

sun4i-a10-olinuxino-lime    | arm  | lab-baylibre    | gcc-10   | sunxi_def=
config     | 1          =

sun5i-a13-olinuxino-micro   | arm  | lab-baylibre    | gcc-10   | sunxi_def=
config     | 1          =

sun7i-a20-cubieboard2       | arm  | lab-baylibre    | gcc-10   | sunxi_def=
config     | 1          =

sun7i-a20-cubieboard2       | arm  | lab-clabbe      | gcc-10   | sunxi_def=
config     | 1          =

sun8i-a33-olinuxino         | arm  | lab-clabbe      | gcc-10   | sunxi_def=
config     | 1          =

sun8i-h2-plus-orangepi-r1   | arm  | lab-baylibre    | gcc-10   | sunxi_def=
config     | 1          =

sun8i-h2-plus-orangepi-zero | arm  | lab-baylibre    | gcc-10   | sunxi_def=
config     | 1          =

sun8i-h3-orangepi-pc        | arm  | lab-clabbe      | gcc-10   | sunxi_def=
config     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.60-673-g7d1e7d167a411/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.60-673-g7d1e7d167a411
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7d1e7d167a4112313851b25e76da040a6ce6fdf3 =



Test Regressions
---------------- =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
at91sam9g20ek               | arm  | lab-broonie     | gcc-10   | at91_dt_d=
efconfig   | 1          =


  Details:     https://kernelci.org/test/plan/id/62f829193958621711daf086

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: at91_dt_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
673-g7d1e7d167a411/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sa=
m9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
673-g7d1e7d167a411/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sa=
m9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f829193958621711daf=
087
        failing since 0 day (last pass: v5.15.60-48-g789367af88749, first f=
ail: v5.15.60-110-g5a4012ec04fef) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
cubietruck                  | arm  | lab-baylibre    | gcc-10   | sunxi_def=
config     | 1          =


  Details:     https://kernelci.org/test/plan/id/62f8279455c50ad99cdaf099

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
673-g7d1e7d167a411/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-cubietr=
uck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
673-g7d1e7d167a411/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-cubietr=
uck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f8279455c50ad99cdaf=
09a
        failing since 0 day (last pass: v5.15.60-48-g789367af88749, first f=
ail: v5.15.60-110-g5a4012ec04fef) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
imx6dl-riotboard            | arm  | lab-pengutronix | gcc-10   | imx_v6_v7=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62f829c9e243634388daf05e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
673-g7d1e7d167a411/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6dl-riotboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
673-g7d1e7d167a411/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6dl-riotboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f829c9e243634388daf=
05f
        failing since 0 day (last pass: v5.15.60-34-gdab49837d475c, first f=
ail: v5.15.60-110-g5a4012ec04fef) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
imx6qp-sabresd              | arm  | lab-nxp         | gcc-10   | imx_v6_v7=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62f828cf7ae5ecd9f3daf069

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
673-g7d1e7d167a411/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6qp-s=
abresd.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
673-g7d1e7d167a411/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6qp-s=
abresd.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f828cf7ae5ecd9f3daf=
06a
        failing since 0 day (last pass: v5.15.60-34-gdab49837d475c, first f=
ail: v5.15.60-110-g5a4012ec04fef) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
imx6qp-wandboard-revd1      | arm  | lab-pengutronix | gcc-10   | imx_v6_v7=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62f828619d0b9eaf3fdaf058

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
673-g7d1e7d167a411/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6qp-wandboard-revd1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
673-g7d1e7d167a411/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6qp-wandboard-revd1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f828619d0b9eaf3fdaf=
059
        failing since 0 day (last pass: v5.15.60-34-gdab49837d475c, first f=
ail: v5.15.60-110-g5a4012ec04fef) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
imx6sx-sdb                  | arm  | lab-nxp         | gcc-10   | imx_v6_v7=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62f828a86fe0c6bc7bdaf073

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
673-g7d1e7d167a411/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6sx-s=
db.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
673-g7d1e7d167a411/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6sx-s=
db.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f828a86fe0c6bc7bdaf=
074
        failing since 0 day (last pass: v5.15.60-34-gdab49837d475c, first f=
ail: v5.15.60-110-g5a4012ec04fef) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
imx6ul-14x14-evk            | arm  | lab-nxp         | gcc-10   | imx_v6_v7=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62f828bd7ae5ecd9f3daf056

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
673-g7d1e7d167a411/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul-1=
4x14-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
673-g7d1e7d167a411/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul-1=
4x14-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f828bd7ae5ecd9f3daf=
057
        failing since 0 day (last pass: v5.15.60-34-gdab49837d475c, first f=
ail: v5.15.60-110-g5a4012ec04fef) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
imx6ul-pico-hobbit          | arm  | lab-pengutronix | gcc-10   | imx_v6_v7=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62f829dde243634388daf064

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
673-g7d1e7d167a411/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
673-g7d1e7d167a411/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f829dde243634388daf=
065
        failing since 0 day (last pass: v5.15.60-34-gdab49837d475c, first f=
ail: v5.15.60-110-g5a4012ec04fef) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
imx7d-sdb                   | arm  | lab-nxp         | gcc-10   | imx_v6_v7=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62f828d3283f7f2b77daf056

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
673-g7d1e7d167a411/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sd=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
673-g7d1e7d167a411/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sd=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f828d3283f7f2b77daf=
057
        failing since 0 day (last pass: v5.15.60-34-gdab49837d475c, first f=
ail: v5.15.60-110-g5a4012ec04fef) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
imx7ulp-evk                 | arm  | lab-nxp         | gcc-10   | imx_v6_v7=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62f828d196ac8bfe17daf076

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
673-g7d1e7d167a411/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-=
evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
673-g7d1e7d167a411/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-=
evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f828d196ac8bfe17daf=
077
        failing since 0 day (last pass: v5.15.60-34-gdab49837d475c, first f=
ail: v5.15.60-110-g5a4012ec04fef) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
jetson-tk1                  | arm  | lab-baylibre    | gcc-10   | tegra_def=
config     | 1          =


  Details:     https://kernelci.org/test/plan/id/62f829c2e243634388daf058

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
673-g7d1e7d167a411/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-=
tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
673-g7d1e7d167a411/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-=
tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f829c2e243634388daf=
059
        new failure (last pass: v5.15.60-48-g789367af88749) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
odroid-xu3                  | arm  | lab-collabora   | gcc-10   | exynos_de=
fconfig    | 1          =


  Details:     https://kernelci.org/test/plan/id/62f82b4545747d05dbdaf068

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: exynos_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
673-g7d1e7d167a411/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-odroi=
d-xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
673-g7d1e7d167a411/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-odroi=
d-xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f82b4545747d05dbdaf=
069
        new failure (last pass: v5.15.60-48-g789367af88749) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
sun4i-a10-olinuxino-lime    | arm  | lab-baylibre    | gcc-10   | sunxi_def=
config     | 1          =


  Details:     https://kernelci.org/test/plan/id/62f82a3b6c981e8326daf058

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
673-g7d1e7d167a411/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun4i-a=
10-olinuxino-lime.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
673-g7d1e7d167a411/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun4i-a=
10-olinuxino-lime.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f82a3b6c981e8326daf=
059
        failing since 0 day (last pass: v5.15.60-48-g789367af88749, first f=
ail: v5.15.60-110-g5a4012ec04fef) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
sun5i-a13-olinuxino-micro   | arm  | lab-baylibre    | gcc-10   | sunxi_def=
config     | 1          =


  Details:     https://kernelci.org/test/plan/id/62f827dee9371dd1dadaf082

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
673-g7d1e7d167a411/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun5i-a=
13-olinuxino-micro.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
673-g7d1e7d167a411/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun5i-a=
13-olinuxino-micro.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f827dee9371dd1dadaf=
083
        failing since 0 day (last pass: v5.15.60-48-g789367af88749, first f=
ail: v5.15.60-110-g5a4012ec04fef) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
sun7i-a20-cubieboard2       | arm  | lab-baylibre    | gcc-10   | sunxi_def=
config     | 1          =


  Details:     https://kernelci.org/test/plan/id/62f8279255c50ad99cdaf093

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
673-g7d1e7d167a411/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7i-a=
20-cubieboard2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
673-g7d1e7d167a411/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7i-a=
20-cubieboard2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f8279255c50ad99cdaf=
094
        failing since 0 day (last pass: v5.15.60-48-g789367af88749, first f=
ail: v5.15.60-110-g5a4012ec04fef) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
sun7i-a20-cubieboard2       | arm  | lab-clabbe      | gcc-10   | sunxi_def=
config     | 1          =


  Details:     https://kernelci.org/test/plan/id/62f827a882d1d7b5a6daf05d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
673-g7d1e7d167a411/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun7i-a20=
-cubieboard2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
673-g7d1e7d167a411/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun7i-a20=
-cubieboard2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f827a882d1d7b5a6daf=
05e
        failing since 0 day (last pass: v5.15.60-48-g789367af88749, first f=
ail: v5.15.60-110-g5a4012ec04fef) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
sun8i-a33-olinuxino         | arm  | lab-clabbe      | gcc-10   | sunxi_def=
config     | 1          =


  Details:     https://kernelci.org/test/plan/id/62f827931461b889a6daf087

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
673-g7d1e7d167a411/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a33=
-olinuxino.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
673-g7d1e7d167a411/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a33=
-olinuxino.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f827931461b889a6daf=
088
        failing since 0 day (last pass: v5.15.60-48-g789367af88749, first f=
ail: v5.15.60-110-g5a4012ec04fef) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
sun8i-h2-plus-orangepi-r1   | arm  | lab-baylibre    | gcc-10   | sunxi_def=
config     | 1          =


  Details:     https://kernelci.org/test/plan/id/62f827a582d1d7b5a6daf057

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
673-g7d1e7d167a411/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h=
2-plus-orangepi-r1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
673-g7d1e7d167a411/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h=
2-plus-orangepi-r1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f827a582d1d7b5a6daf=
058
        failing since 0 day (last pass: v5.15.60-48-g789367af88749, first f=
ail: v5.15.60-110-g5a4012ec04fef) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
sun8i-h2-plus-orangepi-zero | arm  | lab-baylibre    | gcc-10   | sunxi_def=
config     | 1          =


  Details:     https://kernelci.org/test/plan/id/62f827a464300708c2daf056

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
673-g7d1e7d167a411/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h=
2-plus-orangepi-zero.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
673-g7d1e7d167a411/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h=
2-plus-orangepi-zero.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f827a464300708c2daf=
057
        failing since 0 day (last pass: v5.15.60-48-g789367af88749, first f=
ail: v5.15.60-110-g5a4012ec04fef) =

 =



platform                    | arch | lab             | compiler | defconfig=
           | regressions
----------------------------+------+-----------------+----------+----------=
-----------+------------
sun8i-h3-orangepi-pc        | arm  | lab-clabbe      | gcc-10   | sunxi_def=
config     | 1          =


  Details:     https://kernelci.org/test/plan/id/62f828e8a246d153f9daf0aa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
673-g7d1e7d167a411/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-=
orangepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
673-g7d1e7d167a411/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-=
orangepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f828e8a246d153f9daf=
0ab
        failing since 0 day (last pass: v5.15.60-48-g789367af88749, first f=
ail: v5.15.60-110-g5a4012ec04fef) =

 =20
