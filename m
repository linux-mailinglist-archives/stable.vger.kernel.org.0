Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC1CD67C11C
	for <lists+stable@lfdr.de>; Thu, 26 Jan 2023 00:46:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235942AbjAYXqJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Jan 2023 18:46:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbjAYXqI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Jan 2023 18:46:08 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92917DA
        for <stable@vger.kernel.org>; Wed, 25 Jan 2023 15:46:04 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id 88so22841pjo.3
        for <stable@vger.kernel.org>; Wed, 25 Jan 2023 15:46:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Jerv7xvMvYfZ2ynTZlC/a6yhedGXOL9KOboLcvFWHL0=;
        b=frbjvpgT/3ujrigwnGQTBl7pMDBTXJh2LIkJv0n3vfcCMh5DGtpRL+boaV8OXuFSLD
         IuDvp9Hzp5pTPTsjEk4NEermktqWTuoXhh3MdqSVhxLmVp/zFXItAot+hgsGvQjpqwNt
         iVuJ/GHBntYYyw5qMwpW/vBJn21AX0udibIjthEe0B6mMa32cclwCamIZ5cZJhwQuoqN
         fPmHD7Ogfq1Edd0I/C4PmWbIc6CFufiWomG8Z5AnvIbRTP+KDqaV3C/pIIT+ZdSWWmid
         3tm7sOuUVNmXecRQ1bovYmfQe+2WYPk48x0HO+q2bXblpq/VSNFLn0gmCrsIUy/nPTbW
         AkhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Jerv7xvMvYfZ2ynTZlC/a6yhedGXOL9KOboLcvFWHL0=;
        b=so7NtEZT9R2UGBFINSFeGUzO0U+Z0IXoHrO1WYWDKuPBvdhJ5QOBSTsftHErFJ9KPU
         GMw+N8rNp9SWDyYubeBYJE87BOxAbi4jlvJ7dPgBXMDl5Ol8KwH5Xc8djLWBh7FhrEAY
         3DUq7/8vA1VcSrkydLlpc4/s8UCnEMiuVJsDV0u65W6WYZk+mRtf/AEyUgaDEhWvZyFV
         mlrEbGWcJPH4qOMSM4oBvzM+T7L34sri1KOiNIYwNhvch/9MoECO5s2eHuAKCzf1/sdW
         L2oJWrXQQQK1cDzqsTo1XwYdm5FsuVeZ4Z/92QZywgciP6F8+e2sMobicJ55+1i9Pp7u
         GKPw==
X-Gm-Message-State: AFqh2kqzRKj6NEXPBGxvvBc/F4TfQ03LDO9nJq8BFN5qMP/ZD2xw9ZNJ
        wXDSArt/upBhXNvMK+xFKZqeFdvB0KQMRQBR3Ne0qg==
X-Google-Smtp-Source: AMrXdXtCwr+TKaHxBLRt0Dc1OsVhfA2aJcoLX4/qWR/+p/qziCpDshxhFWIblxQ7Kvi159udxrXrBQ==
X-Received: by 2002:a17:902:f70c:b0:194:a7cc:e5ad with SMTP id h12-20020a170902f70c00b00194a7cce5admr35448230plo.45.1674690362571;
        Wed, 25 Jan 2023 15:46:02 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k5-20020a170902e90500b00177f25f8ab3sm4216604pld.89.2023.01.25.15.46.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 15:46:02 -0800 (PST)
Message-ID: <63d1bf3a.170a0220.3a4e2.7ced@mx.google.com>
Date:   Wed, 25 Jan 2023 15:46:02 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.165-76-g5c2e982fcf18
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 170 runs,
 77 regressions (v5.10.165-76-g5c2e982fcf18)
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

stable-rc/queue/5.10 baseline: 170 runs, 77 regressions (v5.10.165-76-g5c2e=
982fcf18)

Regressions Summary
-------------------

platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
am57xx-beagle-x15            | arm    | lab-linaro-lkft | gcc-10   | multi_=
v7_defconfig           | 1          =

am57xx-beagle-x15            | arm    | lab-linaro-lkft | gcc-10   | omap2p=
lus_defconfig          | 1          =

at91sam9g20ek                | arm    | lab-broonie     | gcc-10   | at91_d=
t_defconfig            | 1          =

at91sam9g20ek                | arm    | lab-broonie     | gcc-10   | multi_=
v5_defconfig           | 1          =

bcm2711-rpi-4-b              | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =

bcm2711-rpi-4-b              | arm64  | lab-linaro-lkft | gcc-10   | defcon=
fig                    | 1          =

beagle-xm                    | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =

beagle-xm                    | arm    | lab-baylibre    | gcc-10   | omap2p=
lus_defconfig          | 1          =

beaglebone-black             | arm    | lab-broonie     | gcc-10   | multi_=
v7_defconfig           | 1          =

beaglebone-black             | arm    | lab-broonie     | gcc-10   | omap2p=
lus_defconfig          | 1          =

cubietruck                   | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 2          =

cubietruck                   | arm    | lab-baylibre    | gcc-10   | sunxi_=
defconfig              | 1          =

da850-lcdk                   | arm    | lab-baylibre    | gcc-10   | davinc=
i_all_defconfig        | 1          =

da850-lcdk                   | arm    | lab-baylibre    | gcc-10   | multi_=
v5_defconfig           | 1          =

dell-latitude...8665U-sarien | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

dove-cubox                   | arm    | lab-pengutronix | gcc-10   | mvebu_=
v7_defconfig           | 1          =

fsl-ls1088a-rdb              | arm64  | lab-nxp         | gcc-10   | defcon=
fig                    | 2          =

imx6dl-riotboard             | arm    | lab-pengutronix | gcc-10   | multi_=
v7_defconfig           | 2          =

imx6qp-wandboard-revd1       | arm    | lab-pengutronix | gcc-10   | imx_v6=
_v7_defconfig          | 1          =

imx6qp-wandboard-revd1       | arm    | lab-pengutronix | gcc-10   | multi_=
v7_defconfig           | 1          =

imx7d-sdb                    | arm    | lab-nxp         | gcc-10   | imx_v6=
_v7_defconfig          | 1          =

imx7d-sdb                    | arm    | lab-nxp         | gcc-10   | multi_=
v7_defconfig           | 1          =

imx8mn-ddr4-evk              | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =

imx8mn-ddr4-evk              | arm64  | lab-nxp         | gcc-10   | defcon=
fig                    | 1          =

imx8mp-evk                   | arm64  | lab-nxp         | gcc-10   | defcon=
fig                    | 1          =

jetson-tk1                   | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =

jetson-tk1                   | arm    | lab-baylibre    | gcc-10   | tegra_=
defconfig              | 1          =

meson-g12a-sei510            | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =

meson-g12a-u200              | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =

meson-g12b-a311d-khadas-vim3 | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =

meson-g12b-a311d-khadas-vim3 | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =

meson-g12b-odroid-n2         | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =

meson-gxbb-p200              | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =

meson-gxl-s905d-p230         | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =

meson-gxm-khadas-vim2        | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =

meson-gxm-q200               | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =

meson-sm1-khadas-vim3l       | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =

meson-sm1-sei610             | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =

mt8173-elm-hana              | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =

odroid-xu3                   | arm    | lab-collabora   | gcc-10   | exynos=
_defconfig             | 1          =

odroid-xu3                   | arm    | lab-collabora   | gcc-10   | multi_=
v7_defconfig           | 1          =

rk3399-gru-kevin             | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =

rk3399-roc-pc                | arm64  | lab-clabbe      | gcc-10   | defcon=
fig                    | 1          =

rk3399-rock-pi-4b            | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 2          =

sun50i-a64-bananapi-m64      | arm64  | lab-clabbe      | gcc-10   | defcon=
fig                    | 1          =

sun50i-a64-pine64-plus       | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =

sun50i-h5-lib...ch-all-h3-cc | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =

sun50i-h5-lib...ch-all-h3-cc | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =

sun50i-h6-orangepi-3         | arm64  | lab-clabbe      | gcc-10   | defcon=
fig                    | 1          =

sun50i-h6-orangepi-one-plus  | arm64  | lab-clabbe      | gcc-10   | defcon=
fig                    | 1          =

sun50i-h6-pine-h64           | arm64  | lab-clabbe      | gcc-10   | defcon=
fig                    | 1          =

sun50i-h6-pine-h64           | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =

sun5i-a13-olinuxino-micro    | arm    | lab-baylibre    | gcc-10   | sunxi_=
defconfig              | 1          =

sun7i-a20-cubieboard2        | arm    | lab-baylibre    | gcc-10   | sunxi_=
defconfig              | 1          =

sun7i-a20-cubieboard2        | arm    | lab-clabbe      | gcc-10   | sunxi_=
defconfig              | 1          =

sun7i-a20-olinuxino-lime2    | arm    | lab-baylibre    | gcc-10   | sunxi_=
defconfig              | 1          =

sun8i-a33-olinuxino          | arm    | lab-clabbe      | gcc-10   | multi_=
v7_defconfig           | 2          =

sun8i-a33-olinuxino          | arm    | lab-clabbe      | gcc-10   | sunxi_=
defconfig              | 1          =

sun8i-a83t-bananapi-m3       | arm    | lab-clabbe      | gcc-10   | multi_=
v7_defconfig           | 2          =

sun8i-a83t-bananapi-m3       | arm    | lab-clabbe      | gcc-10   | sunxi_=
defconfig              | 1          =

sun8i-h2-plus...ch-all-h3-cc | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 2          =

sun8i-h2-plus...ch-all-h3-cc | arm    | lab-baylibre    | gcc-10   | sunxi_=
defconfig              | 1          =

sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 2          =

sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre    | gcc-10   | sunxi_=
defconfig              | 1          =

sun8i-h3-orangepi-pc         | arm    | lab-clabbe      | gcc-10   | multi_=
v7_defconfig           | 2          =

sun8i-h3-orangepi-pc         | arm    | lab-clabbe      | gcc-10   | sunxi_=
defconfig              | 1          =

sun8i-r40-bananapi-m2-ultra  | arm    | lab-clabbe      | gcc-10   | multi_=
v7_defconfig           | 1          =

sun8i-r40-bananapi-m2-ultra  | arm    | lab-clabbe      | gcc-10   | sunxi_=
defconfig              | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.165-76-g5c2e982fcf18/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.165-76-g5c2e982fcf18
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5c2e982fcf18a39b2b75978f481af117a781dac0 =



Test Regressions
---------------- =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
am57xx-beagle-x15            | arm    | lab-linaro-lkft | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63d1898a9b38070c15915eca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/multi_v7_defconfig/gcc-10/lab-linaro-lkft/baseline-am=
57xx-beagle-x15.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/multi_v7_defconfig/gcc-10/lab-linaro-lkft/baseline-am=
57xx-beagle-x15.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d1898a9b38070c15915=
ecb
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
am57xx-beagle-x15            | arm    | lab-linaro-lkft | gcc-10   | omap2p=
lus_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/63d18b2233209028f1915eea

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/omap2plus_defconfig/gcc-10/lab-linaro-lkft/baseline-a=
m57xx-beagle-x15.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/omap2plus_defconfig/gcc-10/lab-linaro-lkft/baseline-a=
m57xx-beagle-x15.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d18b2233209028f1915=
eeb
        failing since 1 day (last pass: v5.10.162-950-g0ce90a11c205, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
at91sam9g20ek                | arm    | lab-broonie     | gcc-10   | at91_d=
t_defconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63d18762166d7964aa915ebb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: at91_dt_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam=
9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam=
9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d18762166d7964aa915=
ebc
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
at91sam9g20ek                | arm    | lab-broonie     | gcc-10   | multi_=
v5_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63d187c69ccafa2b85915f1a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sa=
m9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sa=
m9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d187c69ccafa2b85915=
f1b
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
bcm2711-rpi-4-b              | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d18c9bc6ef888181915ec0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm64/defconfig/gcc-10/lab-collabora/baseline-bcm2711-rpi=
-4-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm64/defconfig/gcc-10/lab-collabora/baseline-bcm2711-rpi=
-4-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d18c9bc6ef888181915=
ec1
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
bcm2711-rpi-4-b              | arm64  | lab-linaro-lkft | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d18f01a944bde2eb915ef6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm64/defconfig/gcc-10/lab-linaro-lkft/baseline-bcm2711-r=
pi-4-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm64/defconfig/gcc-10/lab-linaro-lkft/baseline-bcm2711-r=
pi-4-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d18f01a944bde2eb915=
ef7
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beagle-xm                    | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63d18a861c790a092d915f3b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d18a861c790a092d915=
f3c
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beagle-xm                    | arm    | lab-baylibre    | gcc-10   | omap2p=
lus_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/63d18bf524ac2681d2915eb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d18bf524ac2681d2915=
eba
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beaglebone-black             | arm    | lab-broonie     | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63d18a2eda8a8c325e915ebf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-beagle=
bone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-beagle=
bone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d18a2fda8a8c325e915=
ec0
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beaglebone-black             | arm    | lab-broonie     | gcc-10   | omap2p=
lus_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/63d18c09988a367cce915eb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beagl=
ebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beagl=
ebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d18c09988a367cce915=
eba
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
cubietruck                   | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 2          =


  Details:     https://kernelci.org/test/plan/id/63d18aae6f086c15f8915ed5

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d18aae6f086c1=
5f8915edc
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a)
        73 lines

    2023-01-25T20:01:41.950035  kern  :alert : 8<--- cut here ---
    2023-01-25T20:01:41.955491  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address c2748400
    2023-01-25T20:01:41.956305  kern  :alert : pgd =3D (ptrval)
    2023-01-25T20:01:41.962174  kern  :alert : [c2748400] *pgd=3D4261141e(b=
ad)
    2023-01-25T20:01:41.981763  kern  :emerg : Internal error: Oops: 800000=
0d [#1] SMP ARM
    2023-01-25T20:01:41.987478  kern  :emerg : Process udevd (pid: 110, sta=
ck limit =3D 0x(ptrval))
    2023-01-25T20:01:41.993027  kern  :emerg : Stack: (0xc3e99da8 to 0xc3e9=
a000)
    2023-01-25T20:01:42.002259  kern  :emerg : 9da0:                   c3f4=
9080 c0a35490 00000000 c39c0780 c3f49080 eabe9921
    2023-01-25T20:01:42.013387  kern  :emerg : 9dc0: c2114410 c2114410 ffff=
fdfb 00000000 c1a78968 c1a78960 bf06c024 0000000f
    2023-01-25T20:01:42.018843  kern  :emerg : 9de0: 00020000 c0a31454 0000=
0000 c2114410 bf06c024 c2114454 bf06c024 c3f49038 =

    ... (44 line(s) more)  =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d18aae6f086c1=
5f8915edd
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a)
        8 lines

    2023-01-25T20:01:41.922433  kern  :alert : 8<--- cut here ---
    2023-01-25T20:01:41.927701  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address c2114410
    2023-01-25T20:01:41.933371  kern  :alert : pgd =3D (ptrval)
    2023-01-25T20:01:41.944378  kern  :alert : [c2114410] *pgd=3D4201141e(b=
ad<8>[   38.433339] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfai=
l UNITS=3Dlines MEASUREMENT=3D8>
    2023-01-25T20:01:41.945268  )   =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
cubietruck                   | arm    | lab-baylibre    | gcc-10   | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/63d18840b25482e843915ec2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-cubietru=
ck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-cubietru=
ck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d18840b25482e843915=
ec3
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
da850-lcdk                   | arm    | lab-baylibre    | gcc-10   | davinc=
i_all_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/63d187dc9ccafa2b85915f37

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: davinci_all_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/davinci_all_defconfig/gcc-10/lab-baylibre/baseline-da=
850-lcdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/davinci_all_defconfig/gcc-10/lab-baylibre/baseline-da=
850-lcdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d187dc9ccafa2b85915=
f38
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
da850-lcdk                   | arm    | lab-baylibre    | gcc-10   | multi_=
v5_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63d18764950b811ed1915ec6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/multi_v5_defconfig/gcc-10/lab-baylibre/baseline-da850=
-lcdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/multi_v5_defconfig/gcc-10/lab-baylibre/baseline-da850=
-lcdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d18764950b811ed1915=
ec7
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
dell-latitude...8665U-sarien | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63d188d80fefeb30eb915ec5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-dell-latitude-5400-8665U-sarien.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-dell-latitude-5400-8665U-sarien.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d188d80fefeb30eb915=
ec6
        new failure (last pass: v5.10.165-76-gffe5f229ddc9) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
dove-cubox                   | arm    | lab-pengutronix | gcc-10   | mvebu_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63d18875e95b22e700915ee8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: mvebu_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/mvebu_v7_defconfig/gcc-10/lab-pengutronix/baseline-do=
ve-cubox.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/mvebu_v7_defconfig/gcc-10/lab-pengutronix/baseline-do=
ve-cubox.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d18875e95b22e700915=
ee9
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
fsl-ls1088a-rdb              | arm64  | lab-nxp         | gcc-10   | defcon=
fig                    | 2          =


  Details:     https://kernelci.org/test/plan/id/63d18bfcd2f89c6213915eb9

  Results:     3 PASS, 3 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls1088a-rdb.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls1088a-rdb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d18bfcd2f89c6=
213915ec1
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a)
        11 lines

    2023-01-25T20:07:01.110411  kern  :alert : Unable to handle kernel NULL=
 poin[   14.847024] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfai=
l UNITS=3Dlines MEASUREMENT=3D11>   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d18bfcd2f89c6=
213915ec2
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a)
        2 lines

    2023-01-25T20:07:01.114122  ter dereference at virtual address 00000000=
00000000
    2023-01-25T20:07:01.114403  kern  :alert : Mem abort info:
    2023-01-25T20:07:01.119771  kern  :alert :   ESR =3D 0x96000006
    2023-01-25T20:07:01.130672  kern  :a[   14.867227] <LAVA_SIGNAL_TESTCAS=
E TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx6dl-riotboard             | arm    | lab-pengutronix | gcc-10   | multi_=
v7_defconfig           | 2          =


  Details:     https://kernelci.org/test/plan/id/63d18979b08398b402915ec5

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x6dl-riotboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x6dl-riotboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d18979b08398b=
402915ecc
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a)
        41 lines

    2023-01-25T19:56:18.753262  kern  :emerg : Internal error: Oops: 800000=
0d [#1] SMP ARM
    2023-01-25T19:56:18.771525  kern  :emerg : Process udevd (pid: 106, sta=
ck limit =3D 0x(ptrval))[    9.651328] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=
=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D41>
    2023-01-25T19:56:18.771694     =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d18979b08398b=
402915ecd
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a)
        4 lines

    2023-01-25T19:56:18.711206  kern  :alert : 8<--- cut here ---
    2023-01-25T19:56:18.720212  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address c2291c20
    2023-01-25T19:56:18.727663  kern  :a[    9.609188] <LAVA_SIGNAL_TESTCAS=
E TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>
    2023-01-25T19:56:18.727814  lert : pgd =3D (ptrval)
    2023-01-25T19:56:18.727927  kern  :alert : [c2291c20] *pgd=3D1220041e(b=
ad)   =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx6qp-wandboard-revd1       | arm    | lab-pengutronix | gcc-10   | imx_v6=
_v7_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/63d18a2dea5174816b915ef7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx6qp-wandboard-revd1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx6qp-wandboard-revd1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d18a2dea5174816b915=
ef8
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx6qp-wandboard-revd1       | arm    | lab-pengutronix | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63d18b95cb2926a4e8915ecf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x6qp-wandboard-revd1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x6qp-wandboard-revd1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d18b95cb2926a4e8915=
ed0
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx7d-sdb                    | arm    | lab-nxp         | gcc-10   | imx_v6=
_v7_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/63d189b44e40c0ef89915ecc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sdb=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sdb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d189b44e40c0ef89915=
ecd
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx7d-sdb                    | arm    | lab-nxp         | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63d18a2b51a1fd6cda915ebd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sdb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sdb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d18a2b51a1fd6cda915=
ebe
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx8mn-ddr4-evk              | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d18e1bd1ef2903a8915ebc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-ddr4-=
evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-ddr4-=
evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d18e1bd1ef2903a8915=
ebd
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx8mn-ddr4-evk              | arm64  | lab-nxp         | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d18cb03f1c4333c5915ecd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mn-ddr4-evk.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mn-ddr4-evk.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d18cb03f1c4333c5915=
ece
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx8mp-evk                   | arm64  | lab-nxp         | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d18bd49f2debf72b915f21

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d18bd49f2debf72b915=
f22
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
jetson-tk1                   | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63d18980b08398b402915ed0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetso=
n-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetso=
n-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d18980b08398b402915=
ed1
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
jetson-tk1                   | arm    | lab-baylibre    | gcc-10   | tegra_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/63d18b240f8331f7cb915ed7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-t=
k1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-t=
k1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d18b240f8331f7cb915=
ed8
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
meson-g12a-sei510            | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d18b735010c98341915f4e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-s=
ei510.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-s=
ei510.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d18b735010c98341915=
f4f
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
meson-g12a-u200              | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d18bb0990ef02a31915ed5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-u=
200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-u=
200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d18bb0990ef02a31915=
ed6
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
meson-g12b-a311d-khadas-vim3 | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d18bb2990ef02a31915ed8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-a=
311d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-a=
311d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d18bb2990ef02a31915=
ed9
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
meson-g12b-a311d-khadas-vim3 | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d18cb2a8b84d8a08915efe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm64/defconfig/gcc-10/lab-collabora/baseline-meson-g12b-=
a311d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm64/defconfig/gcc-10/lab-collabora/baseline-meson-g12b-=
a311d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d18cb2a8b84d8a08915=
eff
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
meson-g12b-odroid-n2         | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d18b75367ade77b2915ec8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-o=
droid-n2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-o=
droid-n2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d18b75367ade77b2915=
ec9
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
meson-gxbb-p200              | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d18cc92e581abdcb915eb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p=
200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p=
200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d18cc92e581abdcb915=
eba
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
meson-gxl-s905d-p230         | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d18ca43f1c4333c5915ebb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s9=
05d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s9=
05d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d18ca43f1c4333c5915=
ebc
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
meson-gxm-khadas-vim2        | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d18c93a8b84d8a08915eb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm-kh=
adas-vim2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm-kh=
adas-vim2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d18c93a8b84d8a08915=
eba
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
meson-gxm-q200               | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d18fad692ae96159915ebd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm-q2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm-q2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d18fad692ae96159915=
ebe
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
meson-sm1-khadas-vim3l       | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d18bc59f2debf72b915ed0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-sm1-kh=
adas-vim3l.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-sm1-kh=
adas-vim3l.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d18bc59f2debf72b915=
ed1
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
meson-sm1-sei610             | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d18b74367ade77b2915eb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-sm1-se=
i610.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-sm1-se=
i610.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d18b74367ade77b2915=
eba
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
mt8173-elm-hana              | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63d18972b08398b402915ebc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-mt8173-elm-hana.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-mt8173-elm-hana.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d18972b08398b402915=
ebd
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
odroid-xu3                   | arm    | lab-collabora   | gcc-10   | exynos=
_defconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63d186aba14af36e7e915ed0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: exynos_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-odroid=
-xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-odroid=
-xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d186aba14af36e7e915=
ed1
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
odroid-xu3                   | arm    | lab-collabora   | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63d189cff21a70652c915ebc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-odro=
id-xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-odro=
id-xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d189cff21a70652c915=
ebd
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
rk3399-gru-kevin             | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63d18971b08398b402915eb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d18971b08398b402915=
eba
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
rk3399-roc-pc                | arm64  | lab-clabbe      | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d18ca6c6ef888181915ec4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm64/defconfig/gcc-10/lab-clabbe/baseline-rk3399-roc-pc.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm64/defconfig/gcc-10/lab-clabbe/baseline-rk3399-roc-pc.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d18ca6c6ef888181915=
ec5
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
rk3399-rock-pi-4b            | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 2          =


  Details:     https://kernelci.org/test/plan/id/63d18bbf990ef02a31915fb5

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm64/defconfig/gcc-10/lab-collabora/baseline-rk3399-rock=
-pi-4b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm64/defconfig/gcc-10/lab-collabora/baseline-rk3399-rock=
-pi-4b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d18bbf990ef02=
a31915fbc
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a)
        2 lines =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d18bbf990ef02=
a31915fbd
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a)
        8 lines

    2023-01-25T20:06:00.491758  kern  :alert : [ffff0000007ed410] pgd=3D000=
000007fff8003, p4d=3D000000007fff8003, pud=3D000000007fff7003, pmd=3D000000=
007fff4003, pte=3D00680000007ed707
    2023-01-25T20:06:00.491960  <8>[   15.729479] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D8>
    2023-01-25T20:06:00.492065  kern  :emerg : Internal error: Oops: 860000=
0f [#1] PREEMPT SMP
    2023-01-25T20:06:00.492159  kern  :emerg : Code: 00739e00 ffff0000 ffff=
ffff 00000000 (00739e00) =

    2023-01-25T20:06:00.492252  <8>[   15.751250] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>
    2023-01-25T20:06:00.492340  + set +x   =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun50i-a64-bananapi-m64      | arm64  | lab-clabbe      | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d18b9bfc4fae526b915ede

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ban=
anapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ban=
anapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d18b9bfc4fae526b915=
edf
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun50i-a64-pine64-plus       | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d18bfb2358e02886915ed3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pi=
ne64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pi=
ne64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d18bfb2358e02886915=
ed4
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun50i-h5-lib...ch-all-h3-cc | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d18d3316649d341b915ed4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-h5-li=
bretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-h5-li=
bretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d18d3316649d341b915=
ed5
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun50i-h5-lib...ch-all-h3-cc | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d18bbf990ef02a31915fc0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-h5-lib=
retech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-h5-lib=
retech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d18bbf990ef02a31915=
fc1
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun50i-h6-orangepi-3         | arm64  | lab-clabbe      | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d18ca43f1c4333c5915ebe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-oran=
gepi-3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-oran=
gepi-3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d18ca43f1c4333c5915=
ebf
        failing since 1 day (last pass: v5.10.162-851-g33a0798ae8e3, first =
fail: v5.10.162-1026-g401c1c1d3bf5) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun50i-h6-orangepi-one-plus  | arm64  | lab-clabbe      | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d18c0224ac2681d2915ed4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-oran=
gepi-one-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-oran=
gepi-one-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d18c0224ac2681d2915=
ed5
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun50i-h6-pine-h64           | arm64  | lab-clabbe      | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d18ba057acf92b36915eb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-pine=
-h64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-pine=
-h64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d18ba057acf92b36915=
eba
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun50i-h6-pine-h64           | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d18bacfc4fae526b915eea

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm64/defconfig/gcc-10/lab-collabora/baseline-sun50i-h6-p=
ine-h64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm64/defconfig/gcc-10/lab-collabora/baseline-sun50i-h6-p=
ine-h64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d18bacfc4fae526b915=
eeb
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun5i-a13-olinuxino-micro    | arm    | lab-baylibre    | gcc-10   | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/63d18840e95b22e700915ec3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun5i-a1=
3-olinuxino-micro.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun5i-a1=
3-olinuxino-micro.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d18840e95b22e700915=
ec4
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun7i-a20-cubieboard2        | arm    | lab-baylibre    | gcc-10   | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/63d1882cb25482e843915eb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7i-a2=
0-cubieboard2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7i-a2=
0-cubieboard2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d1882cb25482e843915=
eba
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun7i-a20-cubieboard2        | arm    | lab-clabbe      | gcc-10   | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/63d1882b8511720626915ed0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun7i-a20-=
cubieboard2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun7i-a20-=
cubieboard2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d1882b8511720626915=
ed1
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun7i-a20-olinuxino-lime2    | arm    | lab-baylibre    | gcc-10   | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/63d189427838b039fb915ed6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7i-a2=
0-olinuxino-lime2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7i-a2=
0-olinuxino-lime2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d189427838b039fb915=
ed7
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-a33-olinuxino          | arm    | lab-clabbe      | gcc-10   | multi_=
v7_defconfig           | 2          =


  Details:     https://kernelci.org/test/plan/id/63d189a75ec488031d915f8f

  Results:     3 PASS, 3 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a=
33-olinuxino.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a=
33-olinuxino.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d189a75ec4880=
31d915f97
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a)
        4 lines

    2023-01-25T19:57:09.664865  kern  :alert : 8<--- cut here ---
    2023-01-25T19:57:09.665306  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address c21d6c10
    2023-01-25T19:57:09.665909  kern  :alert : pgd =3D (ptrval)
    2023-01-25T19:57:09.666278  kern  :alert : [c21d6c10] *pgd=3D4201141e(b=
ad)
    2023-01-25T19:57:09.666633  <8>[   18.570151] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d189a75ec4880=
31d915f98
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a)
        39 lines

    2023-01-25T19:57:09.739953  kern  :emerg : Internal error: Oops: 800000=
0d [#1] SMP ARM
    2023-01-25T19:57:09.740427  kern  :emerg : Process udevd (pid: 109, sta=
ck limit =3D 0x(ptrval))
    2023-01-25T19:57:09.741052  kern  :emerg : Stack: (0xc3ccfda8 to 0xc3cd=
0000)
    2023-01-25T19:57:09.741383  kern  :emerg : fda0:                   c3ca=
f100 c0a35490 00000000 c243878<8>[   18.637627] <LAVA_SIGNAL_TESTCASE TEST_=
CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D39>
    2023-01-25T19:57:09.741714  0 c3caf180 6899f8f6
    2023-01-25T19:57:09.742018  kern  :emerg : fdc0: c21d6c10 c21d6c10 ffff=
<8>[   18.651071] <LAVA_SIGNAL_ENDRUN 0_dmesg 386133_1.5.2.4.1>
    2023-01-25T19:57:09.742383  fdfb 00000000 c1a78968 c1a78960 bf07e024 00=
000009   =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-a33-olinuxino          | arm    | lab-clabbe      | gcc-10   | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/63d1883f6f7b8b3f5c915eba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a33-=
olinuxino.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a33-=
olinuxino.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d1883f6f7b8b3f5c915=
ebb
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-a83t-bananapi-m3       | arm    | lab-clabbe      | gcc-10   | multi_=
v7_defconfig           | 2          =


  Details:     https://kernelci.org/test/plan/id/63d189b5668454a28f915ecb

  Results:     3 PASS, 3 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a=
83t-bananapi-m3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a=
83t-bananapi-m3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d189b5668454a=
28f915ed3
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a)
        8 lines

    2023-01-25T19:57:15.899757  kern  :alert : 8<--- cut here ---
    2023-01-25T19:57:15.900204  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address c22d2810
    2023-01-25T19:57:15.900793  kern  :alert : pgd =3D (ptrval)
    2023-01-25T19:57:15.901135  kern  :alert : [c22d2810] *pgd=3D4221141e(b=
ad[   44.472776] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail U=
NITS=3Dlines MEASUREMENT=3D8>
    2023-01-25T19:57:15.901475  )
    2023-01-25T19:57:15.901782  kern  :alert : 8<--- cut here ---
    2023-01-25T19:57:15.902083  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address c3beac00
    2023-01-25T19:57:15.902368  kern  :alert : pgd =3D (ptrval)
    2023-01-25T19:57:15.902706  kern  :alert : [c3beac00] *pgd=3D43a1141e(b=
ad)   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d189b5668454a=
28f915ed4
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a)
        73 lines

    2023-01-25T19:57:15.950751  kern  :emerg : Internal error: Oops: 800000=
0d [#1] SMP ARM
    2023-01-25T19:57:15.951441  kern  :emerg : Process udevd (pid: 156, sta=
ck limit =3D 0x(ptrval))
    2023-01-25T19:57:15.951775  kern  :emerg : Stack: (0xc4ebbda8 to 0xc4eb=
c000)
    2023-01-25T19:57:15.952091  kern  :emerg : bda0:                   c243=
c600 c0a35490 00000000 c2442000 c243c680 75c4dff0
    2023-01-25T19:57:15.952413  kern  :emerg : bdc0: c22d2810 c22d2810 ffff=
fdfb 00000000 c1a78968 c1a78960 bf075024 0000001c
    2023-01-25T19:57:15.952762  kern  :emerg : bde0: 00020000 c0a31454 0000=
0000 c22d2810 bf075024 c22d2854 bf075024 c243c5b8
    2023-01-25T19:57:15.993716  kern  :emerg : be00: c4eba000 0000017b 0002=
0000 c0a31a30 c22d2810 00000000 c22d2854 c0a31d20
    2023-01-25T19:57:15.994386  kern  :emerg : be20: bf075024 c22d2810 c0a3=
1d28 c4eba000 c243c5b8 c0a31d88 00000000 bf075024
    2023-01-25T19:57:15.994720  kern  :emerg : be40: c0a31d28 c0a2f3a8 c4eb=
a000 c2083858 c223d5b4 75c4dff0 bf075024 bf075024
    2023-01-25T19:57:15.995021  kern  :emerg : be60: c243c580 00000000 c19c=
7968 c0a306e0 bf074494 c1008dd8 bf075024 00000000 =

    ... (40 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-a83t-bananapi-m3       | arm    | lab-clabbe      | gcc-10   | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/63d1882518c18bb242915ece

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a83t=
-bananapi-m3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a83t=
-bananapi-m3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d1882518c18bb242915=
ecf
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h2-plus...ch-all-h3-cc | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 2          =


  Details:     https://kernelci.org/test/plan/id/63d189a45ec488031d915f76

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i=
-h2-plus-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i=
-h2-plus-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d189a45ec4880=
31d915f7d
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a)
        39 lines

    2023-01-25T19:56:53.740093  kern  :emerg : Internal error: Oops: 800000=
0d [#1] SMP ARM
    2023-01-25T19:56:53.740564  kern  :emerg : Process udevd (pid: 118, sta=
ck limit =3D 0x(ptrval))
    2023-01-25T19:56:53.740832  k<8>[    8.643596] <LAVA_SIGNAL_TESTCASE TE=
ST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D39>
    2023-01-25T19:56:53.741052  ern  :emerg : Stack: (0xc46a9da8 to 0xc46aa=
000)
    2023-01-25T19:56:53.741259  kern  :emerg : <8>[    8.654834] <LAVA_SIGN=
AL_ENDRUN 0_dmesg 3212325_1.5.2.4.1>
    2023-01-25T19:56:53.741463  9da0:                   c3a8f580 c0a35490 0=
0000000 c75620c0 c43c7c00 cf3fe719   =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d189a45ec4880=
31d915f7e
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a)
        4 lines

    2023-01-25T19:56:53.680842  kern  :alert : 8<--- cut here ---
    2023-01-25T19:56:53.681312  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address c213bc10
    2023-01-25T19:56:53.681543  kern  :alert : pgd =3D (ptrval)
    2023-01-25T19:56:53.684384  kern  :alert : [c213bc10] *pgd=3D4201141e(b=
ad<8>[    8.592282] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfai=
l UNITS=3Dlines MEASUREMENT=3D4>
    2023-01-25T19:56:53.684642  )   =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h2-plus...ch-all-h3-cc | arm    | lab-baylibre    | gcc-10   | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/63d18820e95b22e700915eb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h2=
-plus-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h2=
-plus-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d18820e95b22e700915=
eba
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 2          =


  Details:     https://kernelci.org/test/plan/id/63d189a05ec488031d915f55

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i=
-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i=
-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d189a05ec4880=
31d915f5c
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a)
        39 lines

    2023-01-25T19:56:50.534036  kern  :emerg : Internal error: Oops: 800000=
0d [#1] SMP ARM
    2023-01-25T19:56:50.534511  kern  :emerg : Process udevd (pid: 118, sta=
ck limit =3D 0x(ptrval))
    2023-01-25T19:56:50.534745  kern  :emerg : Stack: (0xc3f0dda8 to 0xc3f0=
e000)
    2023-01-25T19:56:50.534999  kern  :emerg : <8>[    7.567855] <LAVA_SIGN=
AL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D=
39>
    2023-01-25T19:56:50.535234  dda0:                   c3fb6d00 c0a35490 0=
0000000 c3a590c0 c3a5<8>[    7.582756] <LAVA_SIGNAL_ENDRUN 0_dmesg 3212317_=
1.5.2.4.1>
    2023-01-25T19:56:50.535448  f800 a1397f47   =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d189a05ec4880=
31d915f5d
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a)
        4 lines

    2023-01-25T19:56:50.468375  kern  :alert : 8<--- cut here ---
    2023-01-25T19:56:50.468848  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address c227bc10
    2023-01-25T19:56:50.469082  kern  :alert : pgd =3D (ptrval)
    2023-01-25T19:56:50.471966  kern  :alert : [c227bc10] *pgd=3D4221141e(b=
ad<8>[    7.508562] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfai=
l UNITS=3Dlines MEASUREMENT=3D4>
    2023-01-25T19:56:50.472225  )   =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre    | gcc-10   | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/63d1881f5230d33ce4915eca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h3=
-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h3=
-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d1881f5230d33ce4915=
ecb
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h3-orangepi-pc         | arm    | lab-clabbe      | gcc-10   | multi_=
v7_defconfig           | 2          =


  Details:     https://kernelci.org/test/plan/id/63d189f745ffeb6792915ebf

  Results:     3 PASS, 3 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h=
3-orangepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h=
3-orangepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d189f745ffeb6=
792915ec7
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a)
        4 lines

    2023-01-25T19:58:18.033443  kern  :alert : 8<--- cut here ---
    2023-01-25T19:58:18.038838  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address c227b810
    2023-01-25T19:58:18.048067  kern  :ale<8>[   14.289644] <LAVA_SIGNAL_TE=
STCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d189f745ffeb6=
792915ec8
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a)
        39 lines

    2023-01-25T19:58:18.054426  rt : pgd =3D (ptrval)
    2023-01-25T19:58:18.054788  kern  :alert : [c227b810] *pgd=3D4221141e(b=
ad)
    2023-01-25T19:58:18.073455  kern  :emerg : Internal error: Oops: 800000=
0d [#1] SMP ARM
    2023-01-25T19:58:18.084321  kern  :emerg : Process udevd (pid: 116, sta=
ck limit =3D 0x(ptrval))
    2023-01-25T19:58:18.088229  k<8>[   14.329731] <LAVA_SIGNAL_TESTCASE TE=
ST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D39>   =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h3-orangepi-pc         | arm    | lab-clabbe      | gcc-10   | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/63d1887ba343a45d42915ed4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-o=
rangepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-o=
rangepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d1887ba343a45d42915=
ed5
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-r40-bananapi-m2-ultra  | arm    | lab-clabbe      | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63d189f930b6c1fdbe915ec8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-r=
40-bananapi-m2-ultra.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-r=
40-bananapi-m2-ultra.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d189f930b6c1fdbe915=
ec9
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-r40-bananapi-m2-ultra  | arm    | lab-clabbe      | gcc-10   | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/63d1888f104669e703915ed8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-r40-=
bananapi-m2-ultra.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-76-g5c2e982fcf18/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-r40-=
bananapi-m2-ultra.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d1888f104669e703915=
ed9
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =20
