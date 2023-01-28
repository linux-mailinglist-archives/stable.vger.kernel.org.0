Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80B9A67F76E
	for <lists+stable@lfdr.de>; Sat, 28 Jan 2023 12:08:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231518AbjA1LIA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 Jan 2023 06:08:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbjA1LH7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 Jan 2023 06:07:59 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74BA21B540
        for <stable@vger.kernel.org>; Sat, 28 Jan 2023 03:07:54 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id cl23-20020a17090af69700b0022c745bfdc3so401209pjb.3
        for <stable@vger.kernel.org>; Sat, 28 Jan 2023 03:07:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=zRqXtgd73PVF57VMT4wX2gDrx5j2iscvVK7tyIBlIe0=;
        b=8HXTAcYRTvxa/ZATTplsP0YN63aS9HpFh5LpvAS5j+jVOecGAjqvv8pYdNEStZfDUi
         iev9+sR5IK3gT+BwTNyvbULhPNJhCbZC9OJSZaSdQqxas9p229G9szN567LZCi4C+JGz
         aTnnrlGeNrBXN1KGq+QicGxAg6xDC7CH/rjyhuCGmYobkGlCW+LdvKo0y7DB2xiBy6tt
         Ap+wOHX07bqLpMlS5l5XpxVRkKh/HhICorEbN7c7RtCMbIs2yAYwqhR9HY7Dfgd6tH43
         cADcscE8zi8iJgylV19snt+zLrI970xCCcXAENj04RdpgOxdaQ7bPT8YFo/iZaLn9C8K
         fMPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zRqXtgd73PVF57VMT4wX2gDrx5j2iscvVK7tyIBlIe0=;
        b=LCM4jqvJUyDmhaYR1maWupuDYeiEtl3YNbuNj+CdPHe71Xtksw0VE4M9LjjI2tcsUn
         ZWqq3NY3OSwnqtdpl8+kOAZNgNxJD7DmI/06DtGMGkuzXJPwvdo/m0xTp9rq/V/tPj3O
         Ix/3FKhWIlZxr29MTXoPCJXDDxtwDXBsmMpVvrCk3woJjYzxwzxqtimrN0BBbjlytVq3
         3LnZbpuVcfU0jIsW3qqm8dxsvfdrv3nKj/aoyJLmaN2/B4lODAk/m8gMrimu9FNY+4+x
         QE/X/KNquY27wc9amsw5mOAcutfQOhNt2GFll9PnPNnqI8lMhpshcbQqGBxGzWzpfE9y
         ZWBQ==
X-Gm-Message-State: AO0yUKVsz3YK+bwj/cUgvmgbEuvN+b1ijI+zXGBN39dcS5w3t6ZFmqrd
        kWrpwtEGy7dfE6s4TopSR3myoICMX6Ez30DcJAJk3g==
X-Google-Smtp-Source: AK7set/tf+xaDOA1flDDIWAFNgCng460dnrn4FnJwWBuoNuY9bjreTEMTmq9Rv2rTg7VU7B2GjkeBQ==
X-Received: by 2002:a05:6a20:699c:b0:bb:b22a:d7ae with SMTP id t28-20020a056a20699c00b000bbb22ad7aemr2569596pzk.2.1674904072083;
        Sat, 28 Jan 2023 03:07:52 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r93-20020a17090a43e600b0022c01ab2899sm4130817pjg.49.2023.01.28.03.07.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Jan 2023 03:07:51 -0800 (PST)
Message-ID: <63d50207.170a0220.3612f.64bf@mx.google.com>
Date:   Sat, 28 Jan 2023 03:07:51 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.230-76-g18d0eaaeda96
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 162 runs,
 86 regressions (v5.4.230-76-g18d0eaaeda96)
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

stable-rc/queue/5.4 baseline: 162 runs, 86 regressions (v5.4.230-76-g18d0ea=
aeda96)

Regressions Summary
-------------------

platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
at91sam9g20ek                | arm   | lab-broonie     | gcc-10   | multi_v=
5_defconfig         | 1          =

beagle-xm                    | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 1          =

beagle-xm                    | arm   | lab-baylibre    | gcc-10   | omap2pl=
us_defconfig        | 2          =

cubietruck                   | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 3          =

cubietruck                   | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =

da850-lcdk                   | arm   | lab-baylibre    | gcc-10   | davinci=
_all_defconfig      | 1          =

da850-lcdk                   | arm   | lab-baylibre    | gcc-10   | multi_v=
5_defconfig         | 1          =

dove-cubox                   | arm   | lab-pengutronix | gcc-10   | mvebu_v=
7_defconfig         | 1          =

fsl-ls1088a-rdb              | arm64 | lab-nxp         | gcc-10   | defconf=
ig                  | 2          =

hifive-unleashed-a00         | riscv | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

imx53-qsrb                   | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig         | 1          =

imx6dl-riotboard             | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig         | 2          =

imx6qp-wandboard-revd1       | arm   | lab-pengutronix | gcc-10   | imx_v6_=
v7_defconfig        | 1          =

imx6qp-wandboard-revd1       | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig         | 1          =

imx7d-sdb                    | arm   | lab-nxp         | gcc-10   | imx_v6_=
v7_defconfig        | 1          =

imx7d-sdb                    | arm   | lab-nxp         | gcc-10   | multi_v=
7_defconfig         | 1          =

imx8mn-ddr4-evk              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

jetson-tk1                   | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 1          =

jetson-tk1                   | arm   | lab-baylibre    | gcc-10   | tegra_d=
efconfig            | 1          =

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

meson-gxbb-p200              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

meson-gxl-s905x-libretech-cc | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

meson-gxl-s905x-libretech-cc | arm64 | lab-broonie     | gcc-10   | defconf=
ig                  | 1          =

meson-gxm-khadas-vim2        | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

meson-gxm-q200               | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

meson-sm1-sei610             | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

meson8b-odroidc1             | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 1          =

odroid-xu3                   | arm   | lab-collabora   | gcc-10   | exynos_=
defconfig           | 1          =

odroid-xu3                   | arm   | lab-collabora   | gcc-10   | multi_v=
7_defconfig         | 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-baylibre    | gcc-10   | defconf=
ig+arm64-chromebook | 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-broonie     | gcc-10   | defconf=
ig+arm64-chromebook | 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-broonie     | gcc-10   | defconf=
ig                  | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-baylibre    | gcc-10   | defconf=
ig+arm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie     | gcc-10   | defconf=
ig+arm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie     | gcc-10   | defconf=
ig                  | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-baylibre    | gcc-10   | defconf=
ig+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-broonie     | gcc-10   | defconf=
ig+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-broonie     | gcc-10   | defconf=
ig                  | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-baylibre    | gcc-10   | defconf=
ig+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie     | gcc-10   | defconf=
ig+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie     | gcc-10   | defconf=
ig                  | 1          =

rk3288-rock2-square          | arm   | lab-collabora   | gcc-10   | multi_v=
7_defconfig         | 1          =

rk3288-veyron-jaq            | arm   | lab-collabora   | gcc-10   | multi_v=
7_defconfig         | 1          =

rk3399-gru-kevin             | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =

sun4i-a10-olinuxino-lime     | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =

sun50i-a64-bananapi-m64      | arm64 | lab-clabbe      | gcc-10   | defconf=
ig                  | 1          =

sun50i-a64-pine64-plus       | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

sun50i-a64-pine64-plus       | arm64 | lab-broonie     | gcc-10   | defconf=
ig                  | 1          =

sun50i-h6-orangepi-3         | arm64 | lab-clabbe      | gcc-10   | defconf=
ig                  | 1          =

sun50i-h6-pine-h64           | arm64 | lab-clabbe      | gcc-10   | defconf=
ig                  | 1          =

sun50i-h6-pine-h64           | arm64 | lab-collabora   | gcc-10   | defconf=
ig                  | 1          =

sun5i-a13-olinuxino-micro    | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =

sun7i-a20-cubieboard2        | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =

sun7i-a20-cubieboard2        | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig            | 1          =

sun7i-a20-olinuxino-lime2    | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =

sun8i-a33-olinuxino          | arm   | lab-clabbe      | gcc-10   | multi_v=
7_defconfig         | 2          =

sun8i-a33-olinuxino          | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig            | 1          =

sun8i-a83t-bananapi-m3       | arm   | lab-clabbe      | gcc-10   | multi_v=
7_defconfig         | 2          =

sun8i-a83t-bananapi-m3       | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig            | 1          =

sun8i-h3-libretech-all-h3-cc | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 2          =

sun8i-h3-libretech-all-h3-cc | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =

sun8i-h3-orangepi-pc         | arm   | lab-clabbe      | gcc-10   | multi_v=
7_defconfig         | 2          =

sun8i-h3-orangepi-pc         | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig            | 1          =

sun8i-r40-bananapi-m2-ultra  | arm   | lab-clabbe      | gcc-10   | multi_v=
7_defconfig         | 1          =

sun8i-r40-bananapi-m2-ultra  | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig            | 1          =

tegra124-nyan-big            | arm   | lab-collabora   | gcc-10   | multi_v=
7_defconfig         | 1          =

tegra124-nyan-big            | arm   | lab-collabora   | gcc-10   | tegra_d=
efconfig            | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.230-76-g18d0eaaeda96/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.230-76-g18d0eaaeda96
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      18d0eaaeda96e9f7fb30f4c77ea2df65a3382452 =



Test Regressions
---------------- =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
at91sam9g20ek                | arm   | lab-broonie     | gcc-10   | multi_v=
5_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4c8c932717d99d5915ebf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam9=
g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam9=
g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d4c8c932717d99d5915=
ec0
        failing since 3 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
beagle-xm                    | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4ca332cb9e52054915ed0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d4ca332cb9e52054915=
ed1
        new failure (last pass: v5.4.230-75-geddb0a82dc83) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
beagle-xm                    | arm   | lab-baylibre    | gcc-10   | omap2pl=
us_defconfig        | 2          =


  Details:     https://kernelci.org/test/plan/id/63d4c8cd32717d99d5915ed8

  Results:     3 PASS, 3 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d4c8cd32717d9=
9d5915edf
        failing since 3 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b)
        26 lines

    2023-01-28T07:03:19.250443  kern  :emerg : Internal error: Oops: 800000=
0d [#1] SMP ARM
    2023-01-28T07:03:19.255896  kern  :emerg : Process udevd (pid: 97, stac=
k limit =3D 0x(ptrval))
    2023-01-28T07:03:19.261545  kern  :emerg : Stack: (0xc985dd48 to 0xc985=
e000)
    2023-01-28T07:03:19.278484  kern  :emerg : dd40:                   c994=
ce80 c06226e4 00000000 c9999680<8>[   23.974212] <LAVA_SIGNAL_TESTCASE TEST=
_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D26>
    2023-01-28T07:03:19.279331   c994cd00 ec29cfd0   =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d4c8cd32717d9=
9d5915ee0
        failing since 3 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b)
        4 lines

    2023-01-28T07:03:19.186471  kern  :alert : 8<--- cut here ---
    2023-01-28T07:03:19.191920  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address ce20e810
    2023-01-28T07:03:19.197318  kern  :alert : pgd =3D (ptrval)
    2023-01-28T07:03:19.203337  kern  :alert : [ce20e810] *pgd=3D8e20041e(b=
ad)
    2023-01-28T07:03:19.209832  <8>[   23.910797] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
cubietruck                   | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 3          =


  Details:     https://kernelci.org/test/plan/id/63d4c957dba59d4513915f17

  Results:     3 PASS, 3 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietr=
uck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietr=
uck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d4c957dba59d4513915f1c
        failing since 0 day (last pass: v5.4.230-72-g354d091498c1, first fa=
il: v5.4.230-75-geddb0a82dc83)

    2023-01-28T07:05:33.642222  erg : 9d80:                   c3e8d100 c098=
917c 00000000 c398178<8>[   37.737448] <LAVA_SIGNAL_ENDRUN 0_dmesg 3231836_=
1.5.2.4.1>
    2023-01-28T07:05:33.642789  0 c3e8d100 46dbbc43
    2023-01-28T07:05:33.653022  kern  :emerg : 9da0: ee037780 ee16c010 0000=
0000 c19e4ec8 fffffdfb c19e4ec4 bf049024 0000000d
    2023-01-28T07:05:33.658548  kern  :emerg : 9dc0: 00020000 c09852f8 0000=
0000 ee16c010 bf049024 ee16c054 bf049024 c3e8d0b8
    2023-01-28T07:05:33.669805  kern  :emerg : 9de0: 00000000 0000017b 0002=
0000 c09857f8 a0000013 00000000 ee16c010 00000000
    2023-01-28T07:05:33.675329  kern  :emerg : 9e00: ee16c054 bf049024 c3e8=
d0b8 c0985ba0 bf049024 ee16c010 c0985ba8 c3da8000
    2023-01-28T07:05:33.686341  kern  :emerg : 9e20: c3e8d0b8 c0985c08 0000=
0000 bf049024 c0985ba8 c09831bc 00000000 ee037758
    2023-01-28T07:05:33.691957  kern  :emerg : 9e40: ee106834 46dbbc43 bf04=
9024 bf049024 c3e8d080 00000000 c194a938 c0984500
    2023-01-28T07:05:33.703021  kern  :emerg : 9e60: bf048494 c1009030 bf04=
9024 00000000 bf04c000 ffffe000 00000000 c0986704
    2023-01-28T07:05:33.708559  kern  :emerg : 9e80: c3da8000 c19928a0 bf04=
c000 c0302e9c 00000000 00004c90 00000000 00000000 =

    ... (50 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d4c957dba59d4=
513915f1e
        failing since 3 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b)
        41 lines

    2023-01-28T07:05:33.577013  kern  :alert : 8<--- cut here ---
    2023-01-28T07:05:33.582446  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address ee5d2000
    2023-01-28T07:05:33.582990  kern  :alert : pgd =3D (ptrval)
    2023-01-28T07:05:33.589065  kern  :alert : [ee5d2000] *pgd=3D6e41141e(b=
ad)
    2023-01-28T07:05:33.608684  kern  :emerg : Internal error: Oops: 800000=
0d [#1] SMP ARM
    2023-01-28T07:05:33.614356  kern  :emerg : Process udevd (pid: 101, sta=
ck limit =3D 0x(ptrval))
    2023-01-28T07:05:33.619812  kern  :emerg : Stack: (0xc3da9d88 to 0xc3da=
a000)
    2023-01-28T07:05:33.630972  kern  :em<8>[   37.724744] <LAVA_SIGNAL_TES=
TCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D41>   =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d4c957dba59d4=
513915f1f
        failing since 3 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b)
        8 lines

    2023-01-28T07:05:33.549494  kern  :alert : 8<--- cut here ---
    2023-01-28T07:05:33.554903  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address ee16c010
    2023-01-28T07:05:33.560620  kern  :alert : pgd =3D (ptrval)
    2023-01-28T07:05:33.571698  kern  :alert<8>[   37.664834] <LAVA_SIGNAL_=
TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D8>
    2023-01-28T07:05:33.572391   : [ee16c010] *pgd=3D6e01141e(bad)   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
cubietruck                   | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4c6c3949e81b51b915eea

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-cubietruck=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-cubietruck=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d4c6c3949e81b51b915=
eeb
        failing since 3 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
da850-lcdk                   | arm   | lab-baylibre    | gcc-10   | davinci=
_all_defconfig      | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4c92f3f03c12b0d915ee4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: davinci_all_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/davinci_all_defconfig/gcc-10/lab-baylibre/baseline-da85=
0-lcdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/davinci_all_defconfig/gcc-10/lab-baylibre/baseline-da85=
0-lcdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d4c92f3f03c12b0d915=
ee5
        failing since 3 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
da850-lcdk                   | arm   | lab-baylibre    | gcc-10   | multi_v=
5_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4c8173adab7e1d1915edb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/multi_v5_defconfig/gcc-10/lab-baylibre/baseline-da850-l=
cdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/multi_v5_defconfig/gcc-10/lab-baylibre/baseline-da850-l=
cdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d4c8173adab7e1d1915=
edc
        failing since 3 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
dove-cubox                   | arm   | lab-pengutronix | gcc-10   | mvebu_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4c7aff8ed246774915ece

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: mvebu_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/mvebu_v7_defconfig/gcc-10/lab-pengutronix/baseline-dove=
-cubox.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/mvebu_v7_defconfig/gcc-10/lab-pengutronix/baseline-dove=
-cubox.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d4c7aff8ed246774915=
ecf
        failing since 3 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
fsl-ls1088a-rdb              | arm64 | lab-nxp         | gcc-10   | defconf=
ig                  | 2          =


  Details:     https://kernelci.org/test/plan/id/63d4cad6c56914831f915ecf

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls1088a-rdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls1088a-rdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d4cad6c569148=
31f915ed7
        failing since 3 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b)
        11 lines

    2023-01-28T07:12:01.397055  kern  :alert : Unable to handle kernel NULL=
 poin[    9.356468] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfai=
l UNITS=3Dlines MEASUREMENT=3D11>   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d4cad6c569148=
31f915ed8
        failing since 3 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b)
        2 lines

    2023-01-28T07:12:01.400653  ter dereference at virtual address 00000000=
00000000
    2023-01-28T07:12:01.400930  kern  :alert : Mem abort info:
    2023-01-28T07:12:01.406160  kern  :alert :   ESR =3D 0x96000006
    2023-01-28T07:12:01.417153  kern  :a[    9.376010] <LAVA_SIGNAL_TESTCAS=
E TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
hifive-unleashed-a00         | riscv | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4cb1d3584ad9293915ec8

  Results:     3 PASS, 2 FAIL, 2 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleash=
ed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleash=
ed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/riscv/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/63d4cb1d3584ad92=
93915ed1
        failing since 101 days (last pass: v5.4.219-270-gde284a6cd1e4, firs=
t fail: v5.4.219-266-g5eb28a6c7901)
        3 lines

    2023-01-28T07:13:12.130653  / # =

    2023-01-28T07:13:12.131507  =

    2023-01-28T07:13:14.192807  / # #
    2023-01-28T07:13:14.193937  #
    2023-01-28T07:13:16.207560  / # export SHELL=3D/bin/sh
    2023-01-28T07:13:16.208006  export SHELL=3D/bin/sh
    2023-01-28T07:13:18.222856  / # . /lava-3231827/environment
    2023-01-28T07:13:18.224279  . /lava-3231827/environment
    2023-01-28T07:13:20.239405  / # /lava-3231827/bin/lava-test-runner /lav=
a-3231827/0
    2023-01-28T07:13:20.241762  /lava-3231827/bin/lava-test-runner /lava-32=
31827/0 =

    ... (9 line(s) more)  =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx53-qsrb                   | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4c91760ba800bd7915f02

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx5=
3-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx5=
3-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d4c91760ba800bd7915=
f03
        failing since 0 day (last pass: v5.4.225-156-g7471077ea69c, first f=
ail: v5.4.230-75-geddb0a82dc83) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6dl-riotboard             | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig         | 2          =


  Details:     https://kernelci.org/test/plan/id/63d4c904cf1182c166915ee1

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6=
dl-riotboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6=
dl-riotboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d4c904cf1182c=
166915ee8
        failing since 3 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b)
        25 lines

    2023-01-28T07:04:27.681814  kern  :a[    7.860467] <LAVA_SIGNAL_TESTCAS=
E TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>
    2023-01-28T07:04:27.681968  lert : pgd =3D (ptrval)
    2023-01-28T07:04:27.682090  kern  :alert : [eeaa7420] *pgd=3D3ea0041e(b=
ad)
    2023-01-28T07:04:27.708508  kern  :emerg : Internal error: Oops: 800000=
0d [#1] SMP ARM   =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d4c904cf1182c=
166915ee9
        failing since 3 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b)
        4 lines

    2023-01-28T07:04:27.634029  [    7.821525] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dcrit RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2023-01-28T07:04:27.664697  kern  :alert : 8<--- cut here ---
    2023-01-28T07:04:27.672513  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address eeaa7420   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6qp-wandboard-revd1       | arm   | lab-pengutronix | gcc-10   | imx_v6_=
v7_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4c865940d641225915eca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
6qp-wandboard-revd1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
6qp-wandboard-revd1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d4c865940d641225915=
ecb
        failing since 3 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6qp-wandboard-revd1       | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4c8deb610b738cc915ec6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6=
qp-wandboard-revd1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6=
qp-wandboard-revd1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d4c8deb610b738cc915=
ec7
        failing since 3 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx7d-sdb                    | arm   | lab-nxp         | gcc-10   | imx_v6_=
v7_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4c89b940d641225915ef6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sdb.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sdb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d4c89b940d641225915=
ef7
        failing since 3 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx7d-sdb                    | arm   | lab-nxp         | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4c931fd34a3e876915ee9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sdb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d4c931fd34a3e876915=
eea
        failing since 3 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx8mn-ddr4-evk              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4cc03a8907ed3e6915ecc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-ddr4-ev=
k.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-ddr4-ev=
k.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d4cc03a8907ed3e6915=
ecd
        failing since 3 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
jetson-tk1                   | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4c907cf1182c166915eec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson-=
tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson-=
tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d4c907cf1182c166915=
eed
        failing since 3 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
jetson-tk1                   | arm   | lab-baylibre    | gcc-10   | tegra_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4c7b30a4d06cf6b915ebd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d4c7b30a4d06cf6b915=
ebe
        failing since 3 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-g12a-sei510            | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4ca7f5bfcc8312e915ed2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-sei=
510.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-sei=
510.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d4ca7f5bfcc8312e915=
ed3
        failing since 3 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-g12a-u200              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4cab2f342f38d3b915ef3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-u20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-u20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d4cab2f342f38d3b915=
ef4
        failing since 3 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-g12a-x96-max           | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4cab7f342f38d3b915ef6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-x96=
-max.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-x96=
-max.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d4cab7f342f38d3b915=
ef7
        failing since 3 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4caa1f342f38d3b915eed

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-a31=
1d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-a31=
1d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d4caa1f342f38d3b915=
eee
        failing since 3 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-collabora   | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4cb840c09dd696b915edd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig/gcc-10/lab-collabora/baseline-meson-g12b-a3=
11d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig/gcc-10/lab-collabora/baseline-meson-g12b-a3=
11d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d4cb840c09dd696b915=
ede
        failing since 3 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-g12b-odroid-n2         | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4ca7e13a1d0c7e3915eb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-odr=
oid-n2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-odr=
oid-n2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d4ca7e13a1d0c7e3915=
eba
        failing since 3 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-gxbb-p200              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4cc4fefdd53a44e915ec3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d4cc4fefdd53a44e915=
ec4
        failing since 3 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4cad0c56914831f915ec9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s905=
x-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s905=
x-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d4cad0c56914831f915=
eca
        failing since 3 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-broonie     | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4cac6c56914831f915ec3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s905x=
-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s905x=
-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d4cac6c56914831f915=
ec4
        failing since 3 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-gxm-khadas-vim2        | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4ca9ff342f38d3b915eea

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm-khad=
as-vim2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm-khad=
as-vim2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d4ca9ff342f38d3b915=
eeb
        failing since 3 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-gxm-q200               | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4cd08b24f7eb93b915ee1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm-q200=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm-q200=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d4cd08b24f7eb93b915=
ee2
        failing since 3 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-sm1-sei610             | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4ca7d5bfcc8312e915ecb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-sm1-sei6=
10.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-sm1-sei6=
10.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d4ca7d5bfcc8312e915=
ecc
        failing since 3 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson8b-odroidc1             | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4c908cf1182c166915eef

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson8b=
-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson8b=
-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d4c908cf1182c166915=
ef0
        failing since 3 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
odroid-xu3                   | arm   | lab-collabora   | gcc-10   | exynos_=
defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4c8c971bb3e3a55915f29

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: exynos_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-odroid-x=
u3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-odroid-x=
u3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d4c8c971bb3e3a55915=
f2a
        failing since 3 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
odroid-xu3                   | arm   | lab-collabora   | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4c942dba59d4513915ebf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-odroid=
-xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-odroid=
-xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d4c942dba59d4513915=
ec0
        failing since 3 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
qemu_arm64-virt-gicv2        | arm64 | lab-baylibre    | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4ca8b5bfcc8312e915ee4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseli=
ne-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseli=
ne-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d4ca8b5bfcc8312e915=
ee5
        failing since 262 days (last pass: v5.4.191-84-g56ce42d78d96, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
qemu_arm64-virt-gicv2        | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4cbd71d350d5c36915ecf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d4cbd71d350d5c36915=
ed0
        failing since 262 days (last pass: v5.4.191-77-g1a3b249e415b, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
qemu_arm64-virt-gicv2        | arm64 | lab-broonie     | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4cb07e93997431d915eeb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d4cb07e93997431d915=
eec
        failing since 262 days (last pass: v5.4.191-84-g56ce42d78d96, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
qemu_arm64-virt-gicv2        | arm64 | lab-broonie     | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4cc4a3871d9d890915ede

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d4cc4a3871d9d890915=
edf
        failing since 262 days (last pass: v5.4.191-77-g1a3b249e415b, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-baylibre    | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4ca8a5bfcc8312e915ede

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseli=
ne-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseli=
ne-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d4ca8a5bfcc8312e915=
edf
        failing since 262 days (last pass: v5.4.191-84-g56ce42d78d96, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4cbd63a32f50f9a915ec2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d4cbd63a32f50f9a915=
ec3
        failing since 262 days (last pass: v5.4.191-77-g1a3b249e415b, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie     | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4cae2e93997431d915ebb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d4cae2e93997431d915=
ebc
        failing since 262 days (last pass: v5.4.191-84-g56ce42d78d96, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie     | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4cc49efdd53a44e915ebe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d4cc49efdd53a44e915=
ebf
        failing since 262 days (last pass: v5.4.191-77-g1a3b249e415b, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-baylibre    | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4ca865bfcc8312e915ed8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseli=
ne-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseli=
ne-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d4ca865bfcc8312e915=
ed9
        failing since 186 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4cbd51d350d5c36915ec9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d4cbd51d350d5c36915=
eca
        failing since 262 days (last pass: v5.4.191-77-g1a3b249e415b, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-broonie     | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4cadff10a05ad9b915eb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d4cadff10a05ad9b915=
eba
        failing since 186 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-broonie     | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4cc483871d9d890915ed9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d4cc483871d9d890915=
eda
        failing since 262 days (last pass: v5.4.191-77-g1a3b249e415b, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4ca372e1cb2168a915ed9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d4ca372e1cb2168a915=
eda
        failing since 186 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-baylibre    | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4ca8813a1d0c7e3915ec4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseli=
ne-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseli=
ne-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d4ca8813a1d0c7e3915=
ec5
        failing since 262 days (last pass: v5.4.191-84-g56ce42d78d96, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4cbd83a32f50f9a915ec8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d4cbd83a32f50f9a915=
ec9
        failing since 262 days (last pass: v5.4.191-77-g1a3b249e415b, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie     | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4cae1f10a05ad9b915ebd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d4cae1f10a05ad9b915=
ebe
        failing since 262 days (last pass: v5.4.191-84-g56ce42d78d96, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie     | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4cc6fefdd53a44e915ecd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d4cc6fefdd53a44e915=
ece
        failing since 262 days (last pass: v5.4.191-77-g1a3b249e415b, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
rk3288-rock2-square          | arm   | lab-collabora   | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4c97dda84fc38ee915ec7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk3288=
-rock2-square.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk3288=
-rock2-square.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d4c97dda84fc38ee915=
ec8
        failing since 3 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
rk3288-veyron-jaq            | arm   | lab-collabora   | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4e5cbf9c3ad8652915ec2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk3288=
-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk3288=
-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d4e5cbf9c3ad8652915=
ec3
        failing since 3 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
rk3399-gru-kevin             | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4c9b1e07b1d4b72915eeb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d4c9b1e07b1d4b72915=
eec
        failing since 3 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun4i-a10-olinuxino-lime     | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4c94338a488f227915ed8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun4i-a10-=
olinuxino-lime.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun4i-a10-=
olinuxino-lime.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d4c94338a488f227915=
ed9
        failing since 1 day (last pass: v5.4.228-658-g579a0289832d, first f=
ail: v5.4.230-80-g3dc8085bd06d) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-a64-bananapi-m64      | arm64 | lab-clabbe      | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4ca9813a1d0c7e3915eeb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d4ca9813a1d0c7e3915=
eec
        failing since 3 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-a64-pine64-plus       | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4cc503871d9d890915ee3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64-pin=
e64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64-pin=
e64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d4cc503871d9d890915=
ee4
        failing since 3 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-a64-pine64-plus       | arm64 | lab-broonie     | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4cafee93997431d915ee8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pine=
64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pine=
64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d4cafee93997431d915=
ee9
        failing since 3 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-h6-orangepi-3         | arm64 | lab-clabbe      | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4cba387e8ba8d99915ecb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-orange=
pi-3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-orange=
pi-3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d4cba387e8ba8d99915=
ecc
        failing since 3 days (last pass: v5.4.228-622-ge3f2d3701743, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-h6-pine-h64           | arm64 | lab-clabbe      | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4ca8a13a1d0c7e3915eca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-pine-h=
64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-pine-h=
64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d4ca8a13a1d0c7e3915=
ecb
        failing since 3 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-h6-pine-h64           | arm64 | lab-collabora   | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4ca95f342f38d3b915eba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig/gcc-10/lab-collabora/baseline-sun50i-h6-pin=
e-h64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm64/defconfig/gcc-10/lab-collabora/baseline-sun50i-h6-pin=
e-h64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d4ca95f342f38d3b915=
ebb
        failing since 3 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun5i-a13-olinuxino-micro    | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4c7269e00f6e0f2915ec1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun5i-a13-=
olinuxino-micro.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun5i-a13-=
olinuxino-micro.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d4c7269e00f6e0f2915=
ec2
        failing since 3 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun7i-a20-cubieboard2        | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4c69bcd72dbf114915ee8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7i-a20-=
cubieboard2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7i-a20-=
cubieboard2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d4c69bcd72dbf114915=
ee9
        failing since 3 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun7i-a20-cubieboard2        | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4c69ccd72dbf114915eeb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun7i-a20-cu=
bieboard2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun7i-a20-cu=
bieboard2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d4c69ccd72dbf114915=
eec
        failing since 3 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun7i-a20-olinuxino-lime2    | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4c82ec39a06939d915ebc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7i-a20-=
olinuxino-lime2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7i-a20-=
olinuxino-lime2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d4c82ec39a06939d915=
ebd
        failing since 3 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-a33-olinuxino          | arm   | lab-clabbe      | gcc-10   | multi_v=
7_defconfig         | 2          =


  Details:     https://kernelci.org/test/plan/id/63d4c91c60ba800bd7915f13

  Results:     3 PASS, 3 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a33=
-olinuxino.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a33=
-olinuxino.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d4c91c60ba800=
bd7915f1b
        failing since 3 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b)
        4 lines

    2023-01-28T07:04:38.446157  kern  :alert : 8<--- cut here ---
    2023-01-28T07:04:38.446574  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address ee9ba810
    2023-01-28T07:04:38.447137  kern  :alert : pgd =3D (ptrval)
    2023-01-28T07:04:38.447518  kern  :alert : [ee9ba810] *pgd=3D6e81141e(b=
ad<8>[   17.919296] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfai=
l UNITS=3Dlines MEASUREMENT=3D4>
    2023-01-28T07:04:38.447836  )   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d4c91c60ba800=
bd7915f1c
        failing since 3 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b)
        24 lines

    2023-01-28T07:04:38.528145  kern  :emerg : Internal error: Oops: 800000=
0d [#1] SMP ARM
    2023-01-28T07:04:38.528839  kern  :emerg : Process udevd (pid: 109, sta=
ck limit =3D 0x(ptrval))
    2023-01-28T07:04:38.529190  kern  :emerg : Stack: (0xedccfd88 to 0xedcd=
0000)
    2023-01-28T07:04:38.529495  kern  :emerg : fd80:                   ee9d=
3700 c098917c 00000000 ee9da000 ee9d3780 36d6de53
    2023-01-28T07:04:38.529813  kern  :emerg : fda0: ee832a80 ee9ba810 0000=
0000 c19e4ec8 fffffdfb c19e4ec4 bf049024 00000009
    2023-01-28T07:04:38.530177  kern  :emerg : fdc0<8>[   18.012573] <LAVA_=
SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMEN=
T=3D24>   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-a33-olinuxino          | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4c6b0949e81b51b915ecf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a33-ol=
inuxino.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a33-ol=
inuxino.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d4c6b0949e81b51b915=
ed0
        failing since 3 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-a83t-bananapi-m3       | arm   | lab-clabbe      | gcc-10   | multi_v=
7_defconfig         | 2          =


  Details:     https://kernelci.org/test/plan/id/63d4c91760ba800bd7915ef7

  Results:     3 PASS, 3 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a83=
t-bananapi-m3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a83=
t-bananapi-m3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d4c91760ba800=
bd7915eff
        failing since 3 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b)
        8 lines

    2023-01-28T07:04:49.754576  kern  :alert : 8<--- cut here ---
    2023-01-28T07:04:49.755022  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address ee2b1c10
    2023-01-28T07:04:49.755633  kern  :alert : pgd =3D (ptrval)
    2023-01-28T07:04:49.755944  kern  :alert : [ee2b1c10] *pgd=3D6e21141e(b=
ad[   45.406741] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail U=
NITS=3Dlines MEASUREMENT=3D8>
    2023-01-28T07:04:49.756289  )
    2023-01-28T07:04:49.756598  kern  :alert : 8<--- cut here ---
    2023-01-28T07:04:49.756884  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address ed37b000
    2023-01-28T07:04:49.757196  kern  :alert : pgd =3D (ptrval)
    2023-01-28T07:04:49.757532  kern  :alert : [ed37b000] *pgd=3D6d21141e(b=
ad)   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d4c91760ba800=
bd7915f00
        failing since 3 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b)
        41 lines

    2023-01-28T07:04:49.800411  kern  :emerg : Internal error: Oops: 800000=
0d [#1] SMP ARM
    2023-01-28T07:04:49.801086  kern  :emerg : Process udevd (pid: 158, sta=
ck limit =3D 0x(ptrval))
    2023-01-28T07:04:49.801421  kern  :emerg : Stack: (0xeb8cfd88 to 0xeb8d=
0000)
    2023-01-28T07:04:49.801722  kern  :emerg : fd80:                   ee40=
a380 c098917c 00000000 ee40f000 [   45.465639] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D41>
    2023-01-28T07:04:49.802057  ee40a400 60f21e4b
    2023-01-28T07:04:49.802409  kern  :emerg : fda0: ee033180 ee2b1c10 0000=
00[   45.481711] <LAVA_SIGNAL_ENDRUN 0_dmesg 387414_1.5.2.4.1>   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-a83t-bananapi-m3       | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4c6846d27b9865c915ed5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a83t-b=
ananapi-m3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a83t-b=
ananapi-m3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d4c6846d27b9865c915=
ed6
        failing since 3 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-h3-libretech-all-h3-cc | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 2          =


  Details:     https://kernelci.org/test/plan/id/63d4c90a60ba800bd7915ec4

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h=
3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h=
3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d4c90a60ba800=
bd7915ecb
        failing since 3 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b)
        24 lines

    2023-01-28T07:04:28.081226  kern  :emerg : Internal error: Oops: 800000=
0d [#1] SMP ARM
    2023-01-28T07:04:28.081743  kern  :emerg : Process udevd (pid: 113, sta=
ck limit =3D 0x(ptrval))
    2023-01-28T07:04:28.081978  kern  :emerg : Stack: (0xedf41d88 to 0xedf4=
2000)
    2023-01-28T07:04:28.082198  kern  :em<8>[    7.960784] <LAVA_SIGNAL_TES=
TCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D24>
    2023-01-28T07:04:28.082413  erg : 1d80:                   ed238200 c098=
917c 00000000 eea7f18<8>[    7.975628] <LAVA_SIGNAL_ENDRUN 0_dmesg 3231849_=
1.5.2.4.1>
    2023-01-28T07:04:28.082626  0 eea92400 de6a52ee   =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d4c90a60ba800=
bd7915ecc
        failing since 3 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b)
        4 lines

    2023-01-28T07:04:28.022220  kern  :alert : 8<--- cut here ---
    2023-01-28T07:04:28.022741  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address eea23010
    2023-01-28T07:04:28.022989  kern  :alert : pgd =3D (ptrval)
    2023-01-28T07:04:28.025837  kern  :alert : [eea23010] *pgd=3D6ea1141e(b=
ad<8>[    7.913100] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfai=
l UNITS=3Dlines MEASUREMENT=3D4>
    2023-01-28T07:04:28.026097  )   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-h3-libretech-all-h3-cc | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4c698cd72dbf114915ee5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h3-l=
ibretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h3-l=
ibretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d4c698cd72dbf114915=
ee6
        failing since 3 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-h3-orangepi-pc         | arm   | lab-clabbe      | gcc-10   | multi_v=
7_defconfig         | 2          =


  Details:     https://kernelci.org/test/plan/id/63d4c96e9db3f7fc43915ebe

  Results:     3 PASS, 3 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-=
orangepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-=
orangepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d4c96e9db3f7f=
c43915ec6
        failing since 3 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b)
        4 lines

    2023-01-28T07:05:52.727720  kern  :alert : 8<--- cut here ---
    2023-01-28T07:05:52.733149  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address ee9e2c10
    2023-01-28T07:05:52.742483  kern  :ale<8>[   15.838425] <LAVA_SIGNAL_TE=
STCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d4c96e9db3f7f=
c43915ec7
        failing since 3 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b)
        24 lines

    2023-01-28T07:05:52.748767  rt : pgd =3D (ptrval)
    2023-01-28T07:05:52.749141  kern  :alert : [ee9e2c10] *pgd=3D6e81141e(b=
ad)
    2023-01-28T07:05:52.766296  kern  :emerg : Internal error: Oops: 800000=
0d [#1] SMP ARM
    2023-01-28T07:05:52.777266  kern  :emerg : Process udevd (pid: 113, sta=
ck limit =3D 0x(ptrval))
    2023-01-28T07:05:52.780997  k<8>[   15.877207] <LAVA_SIGNAL_TESTCASE TE=
ST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D24>   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-h3-orangepi-pc         | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4c6ec9918d294c0915eef

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-ora=
ngepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-ora=
ngepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d4c6ec9918d294c0915=
ef0
        failing since 3 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-r40-bananapi-m2-ultra  | arm   | lab-clabbe      | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4c96d545c822fda915ef3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-r40=
-bananapi-m2-ultra.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-r40=
-bananapi-m2-ultra.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d4c96d545c822fda915=
ef4
        failing since 3 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-r40-bananapi-m2-ultra  | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4c700dca932c339915ec5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-r40-ba=
nanapi-m2-ultra.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-r40-ba=
nanapi-m2-ultra.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d4c700dca932c339915=
ec6
        failing since 3 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
tegra124-nyan-big            | arm   | lab-collabora   | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4c91460ba800bd7915ef4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-tegra1=
24-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-tegra1=
24-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d4c91460ba800bd7915=
ef5
        failing since 3 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
tegra124-nyan-big            | arm   | lab-collabora   | gcc-10   | tegra_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63d4c7c51b1aae9792915fcf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra124-=
nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
6-g18d0eaaeda96/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra124-=
nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d4c7c51b1aae9792915=
fd0
        failing since 3 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =20
