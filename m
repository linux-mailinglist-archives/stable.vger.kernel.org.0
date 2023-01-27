Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C87667E261
	for <lists+stable@lfdr.de>; Fri, 27 Jan 2023 11:57:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbjA0K5i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 05:57:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbjA0K5h (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 05:57:37 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E12C9ED8
        for <stable@vger.kernel.org>; Fri, 27 Jan 2023 02:57:32 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id c6so4584124pls.4
        for <stable@vger.kernel.org>; Fri, 27 Jan 2023 02:57:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=zgesswViKGQReONCXRj7AalE5RTLemhTzcDFkRTlDcc=;
        b=jTr3EEu1QpenRFl74ldR1/XdmVGlhLiWhSXBohL1v+Ll7rv30W1TzlCqCDfCE4pXgA
         I+uPtcgi7Qgc+XEBvWqlDitjq8tA3gzWlv6JUK/fGGHbOYlJnGTbIMmSsxWiAMRft+we
         RjLsNeRfzMLfm10Sa5JboCKaUgJLiDHe4NrEiU+3nq/XpV3I57XCOGj5bLEq1f2GEQUb
         xGhTdXQPc2n/mURrrFwZieot3xKYwqhlZio3IfG9DGHOacLtekxlud8Ph+X84KXH8cdx
         h2FNddk9K0tKGvUmfHoLfgUYWba/ZGjJn686Fx90f2qhIyPcW7CZDHfii4VWE/NVlSRM
         Coyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zgesswViKGQReONCXRj7AalE5RTLemhTzcDFkRTlDcc=;
        b=T/HORDXy9EYJ+dmGeSaqhmrLcvNLWJ0EDLsjDVxc0hoOKUfiXtI9vDZKQNWAETuMa3
         zIUUHPt7hoj8WF7jy6SQ0T0sGqCksQmhzXkaI6hwjKzP6oxtXtvRtl4odC4iXe0v2m39
         vvrd7yvkvnxVvO28jAf24mb2l6xkcd9w1yNZswodnJTJu15qgxKHpk6QURtWcQfHha8c
         94jOtwAUFA9jLGUelUmOmybayckyx12KJ5eTbnq1vOBvW2VJiQJtBfbMEqHzstQyDRVk
         pWE5ZuvhyT/dWSS8XQKmAVkAIdn1v18xV11l0QQUJ6MPkpx+N0VHDlHSJDpf3Qgk94l/
         38lQ==
X-Gm-Message-State: AO0yUKWQXUGlj5N34qV/4AEWcZ3JmtvBkHDr99pxG4QeHseOkC+/JblU
        0ehhUfyrx73kvQt49ZsvhN9qUdrgKA7Saa5OdI4=
X-Google-Smtp-Source: AK7set8mfszY3jCTtSNtqxy6EMppshVS7sQEfOvdgJ6+KKzZcjDghv3AV9Y87+Bc4AAd956hA5bMEw==
X-Received: by 2002:a17:902:f2cc:b0:196:196b:39d9 with SMTP id h12-20020a170902f2cc00b00196196b39d9mr4139202plc.3.1674817050340;
        Fri, 27 Jan 2023 02:57:30 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c17-20020a170902b69100b00196025a34b9sm2562854pls.159.2023.01.27.02.57.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 02:57:29 -0800 (PST)
Message-ID: <63d3ae19.170a0220.5d6a1.479f@mx.google.com>
Date:   Fri, 27 Jan 2023 02:57:29 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.165-98-g3fea7cf7c8e0
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 156 runs,
 72 regressions (v5.10.165-98-g3fea7cf7c8e0)
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

stable-rc/queue/5.10 baseline: 156 runs, 72 regressions (v5.10.165-98-g3fea=
7cf7c8e0)

Regressions Summary
-------------------

platform                     | arch  | lab             | compiler | defconf=
ig             | regressions
-----------------------------+-------+-----------------+----------+--------=
---------------+------------
am57xx-beagle-x15            | arm   | lab-linaro-lkft | gcc-10   | multi_v=
7_defconfig    | 1          =

am57xx-beagle-x15            | arm   | lab-linaro-lkft | gcc-10   | omap2pl=
us_defconfig   | 1          =

at91sam9g20ek                | arm   | lab-broonie     | gcc-10   | at91_dt=
_defconfig     | 1          =

bcm2711-rpi-4-b              | arm64 | lab-linaro-lkft | gcc-10   | defconf=
ig             | 1          =

beagle-xm                    | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig    | 1          =

beagle-xm                    | arm   | lab-baylibre    | gcc-10   | omap2pl=
us_defconfig   | 1          =

beaglebone-black             | arm   | lab-broonie     | gcc-10   | multi_v=
7_defconfig    | 1          =

beaglebone-black             | arm   | lab-broonie     | gcc-10   | omap2pl=
us_defconfig   | 1          =

cubietruck                   | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig    | 3          =

cubietruck                   | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig       | 1          =

da850-lcdk                   | arm   | lab-baylibre    | gcc-10   | davinci=
_all_defconfig | 1          =

dove-cubox                   | arm   | lab-pengutronix | gcc-10   | mvebu_v=
7_defconfig    | 1          =

fsl-ls1088a-rdb              | arm64 | lab-nxp         | gcc-10   | defconf=
ig             | 2          =

imx6dl-riotboard             | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig    | 2          =

imx6qp-wandboard-revd1       | arm   | lab-pengutronix | gcc-10   | imx_v6_=
v7_defconfig   | 1          =

imx6qp-wandboard-revd1       | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig    | 1          =

imx7d-sdb                    | arm   | lab-nxp         | gcc-10   | imx_v6_=
v7_defconfig   | 1          =

imx7d-sdb                    | arm   | lab-nxp         | gcc-10   | multi_v=
7_defconfig    | 1          =

imx8mn-ddr4-evk              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig             | 1          =

imx8mp-evk                   | arm64 | lab-nxp         | gcc-10   | defconf=
ig             | 1          =

jetson-tk1                   | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig    | 1          =

jetson-tk1                   | arm   | lab-baylibre    | gcc-10   | tegra_d=
efconfig       | 1          =

meson-g12a-sei510            | arm64 | lab-baylibre    | gcc-10   | defconf=
ig             | 1          =

meson-g12a-u200              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig             | 1          =

meson-g12a-x96-max           | arm64 | lab-baylibre    | gcc-10   | defconf=
ig             | 1          =

meson-g12b-a311d-khadas-vim3 | arm64 | lab-baylibre    | gcc-10   | defconf=
ig             | 1          =

meson-g12b-a311d-khadas-vim3 | arm64 | lab-collabora   | gcc-10   | defconf=
ig             | 1          =

meson-g12b-odroid-n2         | arm64 | lab-baylibre    | gcc-10   | defconf=
ig             | 1          =

meson-gxbb-p200              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig             | 1          =

meson-gxm-khadas-vim2        | arm64 | lab-baylibre    | gcc-10   | defconf=
ig             | 1          =

meson-gxm-q200               | arm64 | lab-baylibre    | gcc-10   | defconf=
ig             | 1          =

meson-sm1-sei610             | arm64 | lab-baylibre    | gcc-10   | defconf=
ig             | 1          =

meson8b-odroidc1             | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig    | 1          =

odroid-xu3                   | arm   | lab-collabora   | gcc-10   | exynos_=
defconfig      | 1          =

odroid-xu3                   | arm   | lab-collabora   | gcc-10   | multi_v=
7_defconfig    | 1          =

rk3288-rock2-square          | arm   | lab-collabora   | gcc-10   | multi_v=
7_defconfig    | 1          =

rk3399-roc-pc                | arm64 | lab-clabbe      | gcc-10   | defconf=
ig             | 1          =

rk3399-rock-pi-4b            | arm64 | lab-collabora   | gcc-10   | defconf=
ig             | 2          =

sun4i-a10-olinuxino-lime     | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig       | 1          =

sun50i-a64-bananapi-m64      | arm64 | lab-clabbe      | gcc-10   | defconf=
ig             | 1          =

sun50i-a64-pine64-plus       | arm64 | lab-baylibre    | gcc-10   | defconf=
ig             | 1          =

sun50i-a64-pine64-plus       | arm64 | lab-broonie     | gcc-10   | defconf=
ig             | 1          =

sun50i-h5-lib...ch-all-h3-cc | arm64 | lab-baylibre    | gcc-10   | defconf=
ig             | 1          =

sun50i-h5-lib...ch-all-h3-cc | arm64 | lab-broonie     | gcc-10   | defconf=
ig             | 1          =

sun50i-h6-orangepi-3         | arm64 | lab-clabbe      | gcc-10   | defconf=
ig             | 1          =

sun50i-h6-pine-h64           | arm64 | lab-clabbe      | gcc-10   | defconf=
ig             | 1          =

sun50i-h6-pine-h64           | arm64 | lab-collabora   | gcc-10   | defconf=
ig             | 1          =

sun5i-a13-olinuxino-micro    | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig       | 1          =

sun7i-a20-cubieboard2        | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig       | 1          =

sun7i-a20-cubieboard2        | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig       | 1          =

sun7i-a20-olinuxino-lime2    | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig       | 1          =

sun8i-a33-olinuxino          | arm   | lab-clabbe      | gcc-10   | multi_v=
7_defconfig    | 2          =

sun8i-a33-olinuxino          | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig       | 1          =

sun8i-a83t-bananapi-m3       | arm   | lab-clabbe      | gcc-10   | multi_v=
7_defconfig    | 2          =

sun8i-a83t-bananapi-m3       | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig       | 1          =

sun8i-h3-libretech-all-h3-cc | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig    | 2          =

sun8i-h3-libretech-all-h3-cc | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig       | 1          =

sun8i-h3-orangepi-pc         | arm   | lab-clabbe      | gcc-10   | multi_v=
7_defconfig    | 2          =

sun8i-h3-orangepi-pc         | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig       | 1          =

sun8i-r40-bananapi-m2-ultra  | arm   | lab-clabbe      | gcc-10   | multi_v=
7_defconfig    | 1          =

sun8i-r40-bananapi-m2-ultra  | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig       | 1          =

tegra124-nyan-big            | arm   | lab-collabora   | gcc-10   | multi_v=
7_defconfig    | 1          =

tegra124-nyan-big            | arm   | lab-collabora   | gcc-10   | tegra_d=
efconfig       | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.165-98-g3fea7cf7c8e0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.165-98-g3fea7cf7c8e0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3fea7cf7c8e0b1e48b8fe280c7bebd3b2478f501 =



Test Regressions
---------------- =



platform                     | arch  | lab             | compiler | defconf=
ig             | regressions
-----------------------------+-------+-----------------+----------+--------=
---------------+------------
am57xx-beagle-x15            | arm   | lab-linaro-lkft | gcc-10   | multi_v=
7_defconfig    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d379c11bc174ce8f915ec7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/multi_v7_defconfig/gcc-10/lab-linaro-lkft/baseline-am=
57xx-beagle-x15.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/multi_v7_defconfig/gcc-10/lab-linaro-lkft/baseline-am=
57xx-beagle-x15.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d379c11bc174ce8f915=
ec8
        failing since 2 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig             | regressions
-----------------------------+-------+-----------------+----------+--------=
---------------+------------
am57xx-beagle-x15            | arm   | lab-linaro-lkft | gcc-10   | omap2pl=
us_defconfig   | 1          =


  Details:     https://kernelci.org/test/plan/id/63d378281739ba2b44915ebc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/omap2plus_defconfig/gcc-10/lab-linaro-lkft/baseline-a=
m57xx-beagle-x15.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/omap2plus_defconfig/gcc-10/lab-linaro-lkft/baseline-a=
m57xx-beagle-x15.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d378281739ba2b44915=
ebd
        failing since 2 days (last pass: v5.10.162-950-g0ce90a11c205, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig             | regressions
-----------------------------+-------+-----------------+----------+--------=
---------------+------------
at91sam9g20ek                | arm   | lab-broonie     | gcc-10   | at91_dt=
_defconfig     | 1          =


  Details:     https://kernelci.org/test/plan/id/63d375e7040338552c915ee3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: at91_dt_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam=
9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam=
9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d375e7040338552c915=
ee4
        failing since 2 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig             | regressions
-----------------------------+-------+-----------------+----------+--------=
---------------+------------
bcm2711-rpi-4-b              | arm64 | lab-linaro-lkft | gcc-10   | defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63d3792df0cfd1ee98915ec8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm64/defconfig/gcc-10/lab-linaro-lkft/baseline-bcm2711-r=
pi-4-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm64/defconfig/gcc-10/lab-linaro-lkft/baseline-bcm2711-r=
pi-4-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d3792df0cfd1ee98915=
ec9
        failing since 2 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig             | regressions
-----------------------------+-------+-----------------+----------+--------=
---------------+------------
beagle-xm                    | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d37aa70989ea8ddf915eb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d37aa70989ea8ddf915=
eba
        failing since 2 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig             | regressions
-----------------------------+-------+-----------------+----------+--------=
---------------+------------
beagle-xm                    | arm   | lab-baylibre    | gcc-10   | omap2pl=
us_defconfig   | 1          =


  Details:     https://kernelci.org/test/plan/id/63d37917c321751809915ee7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d37917c321751809915=
ee8
        failing since 2 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig             | regressions
-----------------------------+-------+-----------------+----------+--------=
---------------+------------
beaglebone-black             | arm   | lab-broonie     | gcc-10   | multi_v=
7_defconfig    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d379d41bc174ce8f915f26

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-beagle=
bone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-beagle=
bone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d379d41bc174ce8f915=
f27
        failing since 2 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig             | regressions
-----------------------------+-------+-----------------+----------+--------=
---------------+------------
beaglebone-black             | arm   | lab-broonie     | gcc-10   | omap2pl=
us_defconfig   | 1          =


  Details:     https://kernelci.org/test/plan/id/63d3786c08ed850400915f36

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beagl=
ebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beagl=
ebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d3786c08ed850400915=
f37
        failing since 2 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig             | regressions
-----------------------------+-------+-----------------+----------+--------=
---------------+------------
cubietruck                   | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig    | 3          =


  Details:     https://kernelci.org/test/plan/id/63d379f7c1bbd43167915ee9

  Results:     3 PASS, 3 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d379f7c1bbd43167915eee
        failing since 0 day (last pass: v5.10.165-76-g5c2e982fcf18, first f=
ail: v5.10.165-77-g4600242c13ed)

    2023-01-27T07:14:39.674981  kern  :emerg : 3f40: c200a418 c1803<8>[   3=
9.106058] <LAVA_SIGNAL_ENDRUN 0_dmesg 3225073_1.5.2.4.1>
    2023-01-27T07:14:39.680711  d00 00000088 c20e2000 c200a400 c03626bc fff=
fe000 c1a1e506
    2023-01-27T07:14:39.686086  kern  :emerg : 3f60: c20a1000 c2096300 c209=
6180 00000000 c20e2000 c0362658 c20a1000 c20d1e9c
    2023-01-27T07:14:39.697323  kern  :emerg : 3f80: c2096324 c036812c 0000=
0001 c2096180 c0367fe0 00000000 00000000 00000000
    2023-01-27T07:14:39.702753  kern  :emerg : 3fa0: 00000000 00000000 0000=
0000 c03001a8 00000000 00000000 00000000 00000000
    2023-01-27T07:14:39.713856  kern  :emerg : 3fc0: 00000000 00000000 0000=
0000 00000000 00000000 00000000 00000000 00000000
    2023-01-27T07:14:39.719598  kern  :emerg : 3fe0: 00000000 00000000 0000=
0000 00000000 00000013 00000000 00000000 00000000
    2023-01-27T07:14:39.730626  kern  :emerg : [<c08626f0>] (devm_clk_relea=
se) from [<c0a35e90>] (devres_release+0x24/0x4c)
    2023-01-27T07:14:39.736059  kern  :emerg : [<c0a35e90>] (devres_release=
) from [<c0862920>] (devm_clk_put+0x1c/0x40)
    2023-01-27T07:14:39.747322  kern  :emerg : [<c0862920>] (devm_clk_put) =
from [<bf1630b0>] (bcm_get_resources+0x174/0x21c [hci_uart]) =

    ... (36 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d379f7c1bbd43=
167915ef0
        failing since 2 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a)
        73 lines

    2023-01-27T07:14:39.257850  kern  :alert : 8<--- cut here ---
    2023-01-27T07:14:39.263472  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address c2728400
    2023-01-27T07:14:39.263646  kern  :alert : pgd =3D (ptrval)
    2023-01-27T07:14:39.270045  kern  :alert : [c2728400] *pgd=3D4261141e(b=
ad)
    2023-01-27T07:14:39.286937  kern  :emerg : Internal error: Oops: 800000=
0d [#1] SMP ARM
    2023-01-27T07:14:39.292290  kern  :emerg : Process udevd (pid: 101, sta=
ck limit =3D 0x(ptrval))
    2023-01-27T07:14:39.297853  kern  :emerg : Stack: (0xc3e3bda8 to 0xc3e3=
c000)
    2023-01-27T07:14:39.309046  kern  :emerg : bda0:                   c3d7=
9880 c0a35570 00000000 c39bc780 c3d79880 f086e5e7
    2023-01-27T07:14:39.314469  kern  :emerg : bdc0: c2114410 c2114410 ffff=
fdfb 00000000 c1a78968 c1a78960 bf05e024 0000000f
    2023-01-27T07:14:39.325499  kern  :emerg : bde0: 00020000 c0a31534 0000=
0000 c2114410 bf05e024 c2114454 bf05e024 c3d79838 =

    ... (44 line(s) more)  =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d379f7c1bbd43=
167915ef1
        failing since 2 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a)
        8 lines

    2023-01-27T07:14:39.230339  kern  :alert : 8<--- cut here ---
    2023-01-27T07:14:39.235833  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address c2114410
    2023-01-27T07:14:39.241108  kern  :alert : pgd =3D (ptrval)
    2023-01-27T07:14:39.252276  kern  :alert<8>[   38.680252] <LAVA_SIGNAL_=
TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D8>
    2023-01-27T07:14:39.252469   : [c2114410] *pgd=3D4201141e(bad)   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig             | regressions
-----------------------------+-------+-----------------+----------+--------=
---------------+------------
cubietruck                   | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig       | 1          =


  Details:     https://kernelci.org/test/plan/id/63d3777219318dfb89915ee8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-cubietru=
ck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-cubietru=
ck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d3777219318dfb89915=
ee9
        failing since 2 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig             | regressions
-----------------------------+-------+-----------------+----------+--------=
---------------+------------
da850-lcdk                   | arm   | lab-baylibre    | gcc-10   | davinci=
_all_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/63d375cd040338552c915eb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: davinci_all_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/davinci_all_defconfig/gcc-10/lab-baylibre/baseline-da=
850-lcdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/davinci_all_defconfig/gcc-10/lab-baylibre/baseline-da=
850-lcdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d375cd040338552c915=
eba
        failing since 2 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig             | regressions
-----------------------------+-------+-----------------+----------+--------=
---------------+------------
dove-cubox                   | arm   | lab-pengutronix | gcc-10   | mvebu_v=
7_defconfig    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d376b7d4c3931c1e915ed5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: mvebu_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/mvebu_v7_defconfig/gcc-10/lab-pengutronix/baseline-do=
ve-cubox.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/mvebu_v7_defconfig/gcc-10/lab-pengutronix/baseline-do=
ve-cubox.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d376b7d4c3931c1e915=
ed6
        failing since 2 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig             | regressions
-----------------------------+-------+-----------------+----------+--------=
---------------+------------
fsl-ls1088a-rdb              | arm64 | lab-nxp         | gcc-10   | defconf=
ig             | 2          =


  Details:     https://kernelci.org/test/plan/id/63d37892a75f157e05915eff

  Results:     3 PASS, 3 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls1088a-rdb.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls1088a-rdb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d37892a75f157=
e05915f07
        failing since 2 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a)
        11 lines

    2023-01-27T07:08:49.066375  kern  :alert : Unable to handle kernel NULL=
 poin[    9.749505] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfai=
l UNITS=3Dlines MEASUREMENT=3D11>   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d37892a75f157=
e05915f08
        failing since 2 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a)
        2 lines

    2023-01-27T07:08:49.070120  ter dereference at virtual address 00000000=
00000000
    2023-01-27T07:08:49.070422  kern  :alert : Mem abort info:
    2023-01-27T07:08:49.075743  kern  :alert :   ESR =3D 0x96000006
    2023-01-27T07:08:49.086616  kern  :a[    9.769632] <LAVA_SIGNAL_TESTCAS=
E TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig             | regressions
-----------------------------+-------+-----------------+----------+--------=
---------------+------------
imx6dl-riotboard             | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig    | 2          =


  Details:     https://kernelci.org/test/plan/id/63d379afb32172493a915eca

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x6dl-riotboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x6dl-riotboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d379afb321724=
93a915ed1
        failing since 2 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a)
        41 lines

    2023-01-27T07:13:31.636442  kern  :emerg : Internal error: Oops: 800000=
0d [#1] SMP ARM   =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d379afb321724=
93a915ed2
        failing since 2 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a)
        4 lines

    2023-01-27T07:13:31.594444  kern  :alert : 8<--- cut here ---
    2023-01-27T07:13:31.606356  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address c2291c20
    2023-01-27T07:13:31.611129  kern  :a[    9.585522] <LAVA_SIGNAL_TESTCAS=
E TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>
    2023-01-27T07:13:31.611361  lert : pgd =3D (ptrval)
    2023-01-27T07:13:31.611468  kern  :alert : [c2291c20] *pgd=3D1220041e(b=
ad)   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig             | regressions
-----------------------------+-------+-----------------+----------+--------=
---------------+------------
imx6qp-wandboard-revd1       | arm   | lab-pengutronix | gcc-10   | imx_v6_=
v7_defconfig   | 1          =


  Details:     https://kernelci.org/test/plan/id/63d3790fc8d40547d8915ec6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx6qp-wandboard-revd1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx6qp-wandboard-revd1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d3790fc8d40547d8915=
ec7
        failing since 2 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig             | regressions
-----------------------------+-------+-----------------+----------+--------=
---------------+------------
imx6qp-wandboard-revd1       | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d37ab30989ea8ddf915ebc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x6qp-wandboard-revd1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x6qp-wandboard-revd1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d37ab30989ea8ddf915=
ebd
        failing since 2 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig             | regressions
-----------------------------+-------+-----------------+----------+--------=
---------------+------------
imx7d-sdb                    | arm   | lab-nxp         | gcc-10   | imx_v6_=
v7_defconfig   | 1          =


  Details:     https://kernelci.org/test/plan/id/63d3781b56c83eff9e915edb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sdb=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sdb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d3781b56c83eff9e915=
edc
        failing since 2 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig             | regressions
-----------------------------+-------+-----------------+----------+--------=
---------------+------------
imx7d-sdb                    | arm   | lab-nxp         | gcc-10   | multi_v=
7_defconfig    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d379d11bc174ce8f915f23

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sdb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sdb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d379d11bc174ce8f915=
f24
        failing since 2 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig             | regressions
-----------------------------+-------+-----------------+----------+--------=
---------------+------------
imx8mn-ddr4-evk              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63d37a052a6875c4f0915ecf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-ddr4-=
evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-ddr4-=
evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d37a052a6875c4f0915=
ed0
        failing since 2 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig             | regressions
-----------------------------+-------+-----------------+----------+--------=
---------------+------------
imx8mp-evk                   | arm64 | lab-nxp         | gcc-10   | defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63d3787e08ed850400915f57

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d3787e08ed850400915=
f58
        failing since 2 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig             | regressions
-----------------------------+-------+-----------------+----------+--------=
---------------+------------
jetson-tk1                   | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d379a311fffe6c31915f16

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetso=
n-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetso=
n-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d379a311fffe6c31915=
f17
        failing since 2 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig             | regressions
-----------------------------+-------+-----------------+----------+--------=
---------------+------------
jetson-tk1                   | arm   | lab-baylibre    | gcc-10   | tegra_d=
efconfig       | 1          =


  Details:     https://kernelci.org/test/plan/id/63d3773505dd49f17f915ec1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-t=
k1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-t=
k1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d3773505dd49f17f915=
ec2
        failing since 2 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig             | regressions
-----------------------------+-------+-----------------+----------+--------=
---------------+------------
meson-g12a-sei510            | arm64 | lab-baylibre    | gcc-10   | defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63d378311739ba2b44915ed4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-s=
ei510.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-s=
ei510.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d378311739ba2b44915=
ed5
        failing since 2 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig             | regressions
-----------------------------+-------+-----------------+----------+--------=
---------------+------------
meson-g12a-u200              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63d3785125f08110c4915eca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-u=
200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-u=
200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d3785125f08110c4915=
ecb
        failing since 2 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig             | regressions
-----------------------------+-------+-----------------+----------+--------=
---------------+------------
meson-g12a-x96-max           | arm64 | lab-baylibre    | gcc-10   | defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63d3784f25f08110c4915ebc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-x=
96-max.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-x=
96-max.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d3784f25f08110c4915=
ebd
        failing since 2 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig             | regressions
-----------------------------+-------+-----------------+----------+--------=
---------------+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-baylibre    | gcc-10   | defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63d379a3b32172493a915ebc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-a=
311d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-a=
311d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d379a3b32172493a915=
ebd
        failing since 2 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig             | regressions
-----------------------------+-------+-----------------+----------+--------=
---------------+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-collabora   | gcc-10   | defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63d3793df0cfd1ee98915ed9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm64/defconfig/gcc-10/lab-collabora/baseline-meson-g12b-=
a311d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm64/defconfig/gcc-10/lab-collabora/baseline-meson-g12b-=
a311d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d3793df0cfd1ee98915=
eda
        failing since 2 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig             | regressions
-----------------------------+-------+-----------------+----------+--------=
---------------+------------
meson-g12b-odroid-n2         | arm64 | lab-baylibre    | gcc-10   | defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63d3786308ed850400915f30

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-o=
droid-n2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-o=
droid-n2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d3786308ed850400915=
f31
        failing since 2 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig             | regressions
-----------------------------+-------+-----------------+----------+--------=
---------------+------------
meson-gxbb-p200              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63d383bd5f7e9e3a81915ecd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p=
200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p=
200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d383bd5f7e9e3a81915=
ece
        failing since 2 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig             | regressions
-----------------------------+-------+-----------------+----------+--------=
---------------+------------
meson-gxm-khadas-vim2        | arm64 | lab-baylibre    | gcc-10   | defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63d37950ca91177001915ecd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm-kh=
adas-vim2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm-kh=
adas-vim2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d37950ca91177001915=
ece
        failing since 2 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig             | regressions
-----------------------------+-------+-----------------+----------+--------=
---------------+------------
meson-gxm-q200               | arm64 | lab-baylibre    | gcc-10   | defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63d381360bd4288a65915ec0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm-q2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm-q2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d381360bd4288a65915=
ec1
        failing since 2 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig             | regressions
-----------------------------+-------+-----------------+----------+--------=
---------------+------------
meson-sm1-sei610             | arm64 | lab-baylibre    | gcc-10   | defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63d378321aba950992915eba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-sm1-se=
i610.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-sm1-se=
i610.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d378321aba950992915=
ebb
        failing since 2 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig             | regressions
-----------------------------+-------+-----------------+----------+--------=
---------------+------------
meson8b-odroidc1             | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d379a5dde3fd2504915ebd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson=
8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson=
8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d379a5dde3fd2504915=
ebe
        failing since 2 days (last pass: v5.10.162-950-g0ce90a11c205, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig             | regressions
-----------------------------+-------+-----------------+----------+--------=
---------------+------------
odroid-xu3                   | arm   | lab-collabora   | gcc-10   | exynos_=
defconfig      | 1          =


  Details:     https://kernelci.org/test/plan/id/63d375ad0be9d72565915edb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: exynos_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-odroid=
-xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-odroid=
-xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d375ad0be9d72565915=
edc
        failing since 2 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig             | regressions
-----------------------------+-------+-----------------+----------+--------=
---------------+------------
odroid-xu3                   | arm   | lab-collabora   | gcc-10   | multi_v=
7_defconfig    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d379e550d7f52611915ed6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-odro=
id-xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-odro=
id-xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d379e550d7f52611915=
ed7
        failing since 2 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig             | regressions
-----------------------------+-------+-----------------+----------+--------=
---------------+------------
rk3288-rock2-square          | arm   | lab-collabora   | gcc-10   | multi_v=
7_defconfig    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d380023bcfb14f9c915eb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk32=
88-rock2-square.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk32=
88-rock2-square.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d380023bcfb14f9c915=
eba
        failing since 2 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig             | regressions
-----------------------------+-------+-----------------+----------+--------=
---------------+------------
rk3399-roc-pc                | arm64 | lab-clabbe      | gcc-10   | defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63d3795c8ea84e43fb915eb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm64/defconfig/gcc-10/lab-clabbe/baseline-rk3399-roc-pc.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm64/defconfig/gcc-10/lab-clabbe/baseline-rk3399-roc-pc.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d3795c8ea84e43fb915=
eba
        failing since 2 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig             | regressions
-----------------------------+-------+-----------------+----------+--------=
---------------+------------
rk3399-rock-pi-4b            | arm64 | lab-collabora   | gcc-10   | defconf=
ig             | 2          =


  Details:     https://kernelci.org/test/plan/id/63d3786208ed850400915f25

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm64/defconfig/gcc-10/lab-collabora/baseline-rk3399-rock=
-pi-4b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm64/defconfig/gcc-10/lab-collabora/baseline-rk3399-rock=
-pi-4b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d3786208ed850=
400915f2c
        failing since 2 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a)
        2 lines

    2023-01-27T07:07:56.163159  kern  :emerg : Internal error: Oops: 860000=
0f [#1] PREEMPT SMP
    2023-01-27T07:07:56.163243  kern  :emerg : Code: 00739e00 ffff0000 ffff=
ffff 00000000 (00739e00) =

    2023-01-27T07:07:56.163318  <8>[   15.670553] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>
    2023-01-27T07:07:56.163386  + set +x
    2023-01-27T07:07:56.163453  <8>[   15.672666] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 8898698_1.5.2.4.1>   =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d3786208ed850=
400915f2d
        failing since 2 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a)
        8 lines

    2023-01-27T07:07:56.134198  kern  :alert : [ffff0000007ed410] pgd=3D000=
000007fff8003, p4d=3D000000007fff8003, pud=3D000000007fff7003, pmd=3D000000=
007fff4003, pte=3D00680000007ed707
    2023-01-27T07:07:56.134288  <8>[   15.645084] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D8>   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig             | regressions
-----------------------------+-------+-----------------+----------+--------=
---------------+------------
sun4i-a10-olinuxino-lime     | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig       | 1          =


  Details:     https://kernelci.org/test/plan/id/63d377f086cf9b911e915ef2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun4i-a1=
0-olinuxino-lime.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun4i-a1=
0-olinuxino-lime.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d377f086cf9b911e915=
ef3
        failing since 0 day (last pass: v5.10.157-95-g602512855c6c, first f=
ail: v5.10.165-77-g4600242c13ed) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig             | regressions
-----------------------------+-------+-----------------+----------+--------=
---------------+------------
sun50i-a64-bananapi-m64      | arm64 | lab-clabbe      | gcc-10   | defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63d3785225f08110c4915ecd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ban=
anapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ban=
anapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d3785225f08110c4915=
ece
        failing since 2 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig             | regressions
-----------------------------+-------+-----------------+----------+--------=
---------------+------------
sun50i-a64-pine64-plus       | arm64 | lab-baylibre    | gcc-10   | defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63d37ae8bb5630a19f915ece

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64-p=
ine64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64-p=
ine64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d37ae8bb5630a19f915=
ecf
        failing since 2 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig             | regressions
-----------------------------+-------+-----------------+----------+--------=
---------------+------------
sun50i-a64-pine64-plus       | arm64 | lab-broonie     | gcc-10   | defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63d378e572008aad44915ebe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pi=
ne64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pi=
ne64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d378e672008aad44915=
ebf
        failing since 2 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig             | regressions
-----------------------------+-------+-----------------+----------+--------=
---------------+------------
sun50i-h5-lib...ch-all-h3-cc | arm64 | lab-baylibre    | gcc-10   | defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63d3788d467daf3f01915f23

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-h5-li=
bretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-h5-li=
bretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d3788d467daf3f01915=
f24
        failing since 2 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig             | regressions
-----------------------------+-------+-----------------+----------+--------=
---------------+------------
sun50i-h5-lib...ch-all-h3-cc | arm64 | lab-broonie     | gcc-10   | defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63d378be18db2d1ed9915ecc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-h5-lib=
retech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-h5-lib=
retech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d378be18db2d1ed9915=
ecd
        failing since 2 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig             | regressions
-----------------------------+-------+-----------------+----------+--------=
---------------+------------
sun50i-h6-orangepi-3         | arm64 | lab-clabbe      | gcc-10   | defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63d3795e74c6522b38915ec2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-oran=
gepi-3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-oran=
gepi-3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d3795e74c6522b38915=
ec3
        failing since 2 days (last pass: v5.10.162-851-g33a0798ae8e3, first=
 fail: v5.10.162-1026-g401c1c1d3bf5) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig             | regressions
-----------------------------+-------+-----------------+----------+--------=
---------------+------------
sun50i-h6-pine-h64           | arm64 | lab-clabbe      | gcc-10   | defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63d37844d03ada7fab915ee3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-pine=
-h64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-pine=
-h64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d37844d03ada7fab915=
ee4
        failing since 2 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig             | regressions
-----------------------------+-------+-----------------+----------+--------=
---------------+------------
sun50i-h6-pine-h64           | arm64 | lab-collabora   | gcc-10   | defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63d3786a08ed850400915f33

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm64/defconfig/gcc-10/lab-collabora/baseline-sun50i-h6-p=
ine-h64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm64/defconfig/gcc-10/lab-collabora/baseline-sun50i-h6-p=
ine-h64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d3786a08ed850400915=
f34
        failing since 2 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig             | regressions
-----------------------------+-------+-----------------+----------+--------=
---------------+------------
sun5i-a13-olinuxino-micro    | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig       | 1          =


  Details:     https://kernelci.org/test/plan/id/63d377a05540e0f991915ed8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun5i-a1=
3-olinuxino-micro.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun5i-a1=
3-olinuxino-micro.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d377a05540e0f991915=
ed9
        failing since 2 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig             | regressions
-----------------------------+-------+-----------------+----------+--------=
---------------+------------
sun7i-a20-cubieboard2        | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig       | 1          =


  Details:     https://kernelci.org/test/plan/id/63d3775e6b050b35fa915ee8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7i-a2=
0-cubieboard2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7i-a2=
0-cubieboard2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d3775e6b050b35fa915=
ee9
        failing since 2 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig             | regressions
-----------------------------+-------+-----------------+----------+--------=
---------------+------------
sun7i-a20-cubieboard2        | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig       | 1          =


  Details:     https://kernelci.org/test/plan/id/63d377626b050b35fa915ef8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun7i-a20-=
cubieboard2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun7i-a20-=
cubieboard2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d377626b050b35fa915=
ef9
        failing since 2 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig             | regressions
-----------------------------+-------+-----------------+----------+--------=
---------------+------------
sun7i-a20-olinuxino-lime2    | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig       | 1          =


  Details:     https://kernelci.org/test/plan/id/63d37901dcf7212db4915f9f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7i-a2=
0-olinuxino-lime2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7i-a2=
0-olinuxino-lime2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d37901dcf7212db4915=
fa0
        failing since 2 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig             | regressions
-----------------------------+-------+-----------------+----------+--------=
---------------+------------
sun8i-a33-olinuxino          | arm   | lab-clabbe      | gcc-10   | multi_v=
7_defconfig    | 2          =


  Details:     https://kernelci.org/test/plan/id/63d379d01bc174ce8f915f18

  Results:     3 PASS, 3 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a=
33-olinuxino.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a=
33-olinuxino.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d379d01bc174c=
e8f915f20
        failing since 2 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a)
        4 lines

    2023-01-27T07:13:53.344928  <8>[   18.592195] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcrit RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2023-01-27T07:13:53.399165  kern  :alert : 8<--- cut here ---
    2023-01-27T07:13:53.399722  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address c21d6c10
    2023-01-27T07:13:53.400278  kern  :alert : pgd =3D (ptrval)
    2023-01-27T07:13:53.400706  kern  :alert : [c21d6c10] *pgd=3D4201141e(b=
ad)
    2023-01-27T07:13:53.401406  <8>[   18.651393] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d379d01bc174c=
e8f915f21
        failing since 2 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a)
        39 lines

    2023-01-27T07:13:53.473910  kern  :emerg : Internal error: Oops: 800000=
0d [#1] SMP ARM
    2023-01-27T07:13:53.474878  kern  :emerg : Process udevd (pid: 112, sta=
ck limit =3D 0x(ptrval))
    2023-01-27T07:13:53.475266  kern  :emerg : Stack: (0xc3cf5da8 to 0xc3cf=
6000)
    2023-01-27T07:13:53.475602  kern  :emerg : 5da0:                   c27b=
3500 c0a35570 00000000 c257a78<8>[   18.719580] <LAVA_SIGNAL_TESTCASE TEST_=
CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D39>
    2023-01-27T07:13:53.476060  0 c27b3580 fbe21ee7
    2023-01-27T07:13:53.476387  kern  :emerg : 5dc0: c21d6c10 c21d6c10 ffff=
fdfb 00000000 c1a78968 c1a78960 bf02c024 0000000a
    2023-01-27T07:13:53.476746  kern  :emerg <8>[   18.739363] <LAVA_SIGNAL=
_ENDRUN 0_dmesg 386900_1.5.2.4.1>   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig             | regressions
-----------------------------+-------+-----------------+----------+--------=
---------------+------------
sun8i-a33-olinuxino          | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig       | 1          =


  Details:     https://kernelci.org/test/plan/id/63d3777619318dfb89915efd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a33-=
olinuxino.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a33-=
olinuxino.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d3777619318dfb89915=
efe
        failing since 2 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig             | regressions
-----------------------------+-------+-----------------+----------+--------=
---------------+------------
sun8i-a83t-bananapi-m3       | arm   | lab-clabbe      | gcc-10   | multi_v=
7_defconfig    | 2          =


  Details:     https://kernelci.org/test/plan/id/63d379c91bc174ce8f915ef4

  Results:     3 PASS, 3 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a=
83t-bananapi-m3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a=
83t-bananapi-m3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d379c91bc174c=
e8f915efc
        failing since 2 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a)
        8 lines

    2023-01-27T07:14:00.384843  kern  :alert : 8<--- cut here ---
    2023-01-27T07:14:00.432795  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address c22d2810
    2023-01-27T07:14:00.433292  kern  :alert : pgd =3D (ptrval)
    2023-01-27T07:14:00.433876  kern  :alert : [c22d2810] *pgd=3D4221141e(b=
ad)
    2023-01-27T07:14:00.434215  kern  :alert : 8<--- cut here --[   47.1026=
76] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines =
MEASUREMENT=3D8>
    2023-01-27T07:14:00.434529  -
    2023-01-27T07:14:00.434832  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address c3be2c00
    2023-01-27T07:14:00.435135  kern  :alert : pgd =3D (ptrval)
    2023-01-27T07:14:00.435474  kern  :alert : [c3be2c00] *pgd=3D43a1141e(b=
ad)   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d379c91bc174c=
e8f915efd
        failing since 2 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a)
        73 lines

    2023-01-27T07:14:00.491935  kern  :emerg : Internal error: Oops: 800000=
0d [#1] SMP ARM
    2023-01-27T07:14:00.492478  kern  :emerg : Process udevd (pid: 160, sta=
ck limit =3D 0x(ptrval))
    2023-01-27T07:14:00.493095  kern  :emerg : Stack: (0xc4f0bda8 to 0xc4f0=
c000)
    2023-01-27T07:14:00.493438  kern  :emerg : bda0:                   c244=
5600 c0a35570 00000000 c24440c0 c2445680 7006321f
    2023-01-27T07:14:00.493749  kern  :emerg : bdc0: c22d2810 c22d2810 ffff=
fdfb 00000000 c1a78968 c1a78960 bf075024 0000001c
    2023-01-27T07:14:00.494105  kern  :emerg : bde0: 00020000 c0a31534 0000=
0000 c22d2810 bf075024 c22d2854 bf075024 c24455b8
    2023-01-27T07:14:00.534918  kern  :emerg : be00: c4f0a000 0000017b 0002=
0000 c0a31b10 c22d2810 00000000 c22d2854 c0a31e00
    2023-01-27T07:14:00.535702  kern  :emerg : be20: bf075024 c22d2810 c0a3=
1e08 c4f0a000 c24455b8 c0a31e68 00000000 bf075024
    2023-01-27T07:14:00.536055  kern  :emerg : be40: c0a31e08 c0a2f488 c4f0=
a000 c2083858 c223d5b4 7006321f bf075024 bf075024
    2023-01-27T07:14:00.536367  kern  :emerg : be60: c2445580 00000000 c19c=
7a28 c0a307c0 bf074494 ffffffff bf075024 00000000 =

    ... (41 line(s) more)  =

 =



platform                     | arch  | lab             | compiler | defconf=
ig             | regressions
-----------------------------+-------+-----------------+----------+--------=
---------------+------------
sun8i-a83t-bananapi-m3       | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig       | 1          =


  Details:     https://kernelci.org/test/plan/id/63d3774a05dd49f17f915f06

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a83t=
-bananapi-m3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a83t=
-bananapi-m3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d3774a05dd49f17f915=
f07
        failing since 2 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig             | regressions
-----------------------------+-------+-----------------+----------+--------=
---------------+------------
sun8i-h3-libretech-all-h3-cc | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig    | 2          =


  Details:     https://kernelci.org/test/plan/id/63d379bd1bc174ce8f915eb9

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i=
-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i=
-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d379bd1bc174c=
e8f915ec0
        failing since 2 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a)
        39 lines

    2023-01-27T07:13:36.126575  kern  :emerg : Internal error: Oops: 800000=
0d [#1] SMP ARM
    2023-01-27T07:13:36.127266  kern  :emerg : Process udevd (pid: 126, sta=
ck limit =3D 0x(ptrval))
    2023-01-27T07:13:36.127510  kern  :emerg : Stack: (0xc48dbda8 to 0xc48d=
c000)
    2023-01-27T07:13:36.127733  kern  :emerg : <8>[    7.655195] <LAVA_SIGN=
AL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D=
39>
    2023-01-27T07:13:36.127949  bda0:                   c3f84980 c0a35570 0=
0000000 c21f8480 c21f<8>[    7.670075] <LAVA_SIGNAL_ENDRUN 0_dmesg 3225070_=
1.5.2.4.1>
    2023-01-27T07:13:36.128162  5f00 2cf98287   =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d379bd1bc174c=
e8f915ec1
        failing since 2 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a)
        4 lines

    2023-01-27T07:13:36.063421  kern  :alert : 8<--- cut here ---
    2023-01-27T07:13:36.063891  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address c227bc10
    2023-01-27T07:13:36.064121  kern  :alert : pgd =3D (ptrval)
    2023-01-27T07:13:36.067010  kern  :alert<8>[    7.599119] <LAVA_SIGNAL_=
TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>
    2023-01-27T07:13:36.067287   : [c227bc10] *pgd=3D4221141e(bad)   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig             | regressions
-----------------------------+-------+-----------------+----------+--------=
---------------+------------
sun8i-h3-libretech-all-h3-cc | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig       | 1          =


  Details:     https://kernelci.org/test/plan/id/63d3774705dd49f17f915f03

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h3=
-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h3=
-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d3774705dd49f17f915=
f04
        failing since 2 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig             | regressions
-----------------------------+-------+-----------------+----------+--------=
---------------+------------
sun8i-h3-orangepi-pc         | arm   | lab-clabbe      | gcc-10   | multi_v=
7_defconfig    | 2          =


  Details:     https://kernelci.org/test/plan/id/63d37a339809e0cf9a915ec7

  Results:     3 PASS, 3 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h=
3-orangepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h=
3-orangepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d37a339809e0c=
f9a915ecf
        failing since 2 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a)
        4 lines

    2023-01-27T07:15:34.658950  kern  :alert : 8<--- cut here ---
    2023-01-27T07:15:34.664370  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address c227b810
    2023-01-27T07:15:34.673690  kern  :ale<8>[   14.049550] <LAVA_SIGNAL_TE=
STCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d37a339809e0c=
f9a915ed0
        failing since 2 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a)
        39 lines

    2023-01-27T07:15:34.679909  rt : pgd =3D (ptrval)
    2023-01-27T07:15:34.680299  kern  :alert : [c227b810] *pgd=3D4221141e(b=
ad)
    2023-01-27T07:15:34.699122  kern  :emerg : Internal error: Oops: 800000=
0d [#1] SMP ARM
    2023-01-27T07:15:34.709945  kern  :emerg : Process udevd (pid: 115, sta=
ck limit =3D 0x(ptrval))
    2023-01-27T07:15:34.713831  k<8>[   14.089988] <LAVA_SIGNAL_TESTCASE TE=
ST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D39>   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig             | regressions
-----------------------------+-------+-----------------+----------+--------=
---------------+------------
sun8i-h3-orangepi-pc         | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig       | 1          =


  Details:     https://kernelci.org/test/plan/id/63d377c66baf31c042915ede

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-o=
rangepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-o=
rangepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d377c66baf31c042915=
edf
        failing since 2 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig             | regressions
-----------------------------+-------+-----------------+----------+--------=
---------------+------------
sun8i-r40-bananapi-m2-ultra  | arm   | lab-clabbe      | gcc-10   | multi_v=
7_defconfig    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d37a349809e0cf9a915ed2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-r=
40-bananapi-m2-ultra.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-r=
40-bananapi-m2-ultra.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d37a349809e0cf9a915=
ed3
        failing since 2 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig             | regressions
-----------------------------+-------+-----------------+----------+--------=
---------------+------------
sun8i-r40-bananapi-m2-ultra  | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig       | 1          =


  Details:     https://kernelci.org/test/plan/id/63d3781756c83eff9e915ed5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-r40-=
bananapi-m2-ultra.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-r40-=
bananapi-m2-ultra.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d3781756c83eff9e915=
ed6
        failing since 2 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig             | regressions
-----------------------------+-------+-----------------+----------+--------=
---------------+------------
tegra124-nyan-big            | arm   | lab-collabora   | gcc-10   | multi_v=
7_defconfig    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d37c8e7bb3783838915ec7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-tegr=
a124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-tegr=
a124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d37c8e7bb3783838915=
ec8
        failing since 2 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig             | regressions
-----------------------------+-------+-----------------+----------+--------=
---------------+------------
tegra124-nyan-big            | arm   | lab-collabora   | gcc-10   | tegra_d=
efconfig       | 1          =


  Details:     https://kernelci.org/test/plan/id/63d37a0ec01a6565a2915f18

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra12=
4-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-98-g3fea7cf7c8e0/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra12=
4-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d37a0ec01a6565a2915=
f19
        failing since 2 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =20
