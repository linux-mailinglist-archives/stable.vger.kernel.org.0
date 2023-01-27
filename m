Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 376BF67E0DA
	for <lists+stable@lfdr.de>; Fri, 27 Jan 2023 10:56:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231542AbjA0J4P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 04:56:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232615AbjA0J4N (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 04:56:13 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A8CF24CA2
        for <stable@vger.kernel.org>; Fri, 27 Jan 2023 01:56:09 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id 203so1619819pfx.6
        for <stable@vger.kernel.org>; Fri, 27 Jan 2023 01:56:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=zF5LJUMeGuMr5kabJ/b72Xj6nCY0Hnh9IeUhk09Q/og=;
        b=T9zxz7cNnxfgW6SQIH3bhATPuzTsOpLc3MXDFguqh+YISludTOPPsJ/YPHUW2jjFnZ
         HzeZ5IRrYEMMDOCggh5kNuR84DDqX9O3GlCbdn6ZldYg3nagIWDReNgnbDgf1o4/AXKM
         eV0QzIc/sqhZIcQaIXkq/P7qEDPMIyK8U3hKCeSaoHUlCU1LJjpsGdIORlamheR2N2GB
         JlNotEr5yhDuhV6vFgBdi2k4vf0SG1nYkBM2wHVUWygL87oPp1zV/mvVYp16y5nkZQ5W
         YMOT70Mg1yw3CuCkVpDjmq0Oil5fMbWL2EDIprOd6mRRN01cl8zKryWiBeTbGBVgwTwk
         2I9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zF5LJUMeGuMr5kabJ/b72Xj6nCY0Hnh9IeUhk09Q/og=;
        b=AgItOBONmxMTCkwp8L7BSubq6LkDhXPXeo6IDtQWOEya2SEzHOq+vRoBPu8TrgSJXH
         P5qm+iOXGbIslxyw+mPu6BMKmIWTq8WV8WdFwMCiuwSMifPwx3GuJ3Tl2EQAlnngNQuq
         kTiybRoaR1L/jH60lE1UUXxujlnTAr0VSfcDuJn3hVGsTQIi1sdzeAuvxH8fFXgp5qVs
         +UUH7IaNwSTE+6owTefTujF83TSVfZF7rgMjr5nI2UutqnNcoYkzMCOS2F+YRulDfeG+
         8a1eDDMNgn77vbZE7kMr0CH9Ra+/+WKMokbvntQGuwNXyEFWxHqldIiS5JFeL6OjpyZ4
         se1w==
X-Gm-Message-State: AFqh2krke+KVVHTRmC92/gRLZU+hzMqv72Jd2uroysIlt2wZa9E7y1Ks
        GecqHaxyU+uGflgWIu1o8EcGIJltIT36hQ4f1Og=
X-Google-Smtp-Source: AMrXdXup5r8ds2eEHFsPAoL10ztyf1lGdKElqL7Q8/kji4FV8YrXX3aDM7fWpWDRbflq/QWberfTlA==
X-Received: by 2002:aa7:88d5:0:b0:58d:a683:bb2d with SMTP id k21-20020aa788d5000000b0058da683bb2dmr50066719pff.30.1674813367599;
        Fri, 27 Jan 2023 01:56:07 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m2-20020a056a00164200b00587304cbd3fsm2226665pfc.181.2023.01.27.01.56.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 01:56:07 -0800 (PST)
Message-ID: <63d39fb7.050a0220.7648d.355f@mx.google.com>
Date:   Fri, 27 Jan 2023 01:56:07 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.230-80-g3dc8085bd06d
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 162 runs,
 85 regressions (v5.4.230-80-g3dc8085bd06d)
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

stable-rc/queue/5.4 baseline: 162 runs, 85 regressions (v5.4.230-80-g3dc808=
5bd06d)

Regressions Summary
-------------------

platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
at91sam9g20ek                | arm    | lab-broonie     | gcc-10   | at91_d=
t_defconfig            | 1          =

at91sam9g20ek                | arm    | lab-broonie     | gcc-10   | multi_=
v5_defconfig           | 1          =

beagle-xm                    | arm    | lab-baylibre    | gcc-10   | omap2p=
lus_defconfig          | 2          =

cubietruck                   | arm    | lab-baylibre    | gcc-10   | sunxi_=
defconfig              | 1          =

da850-lcdk                   | arm    | lab-baylibre    | gcc-10   | davinc=
i_all_defconfig        | 1          =

da850-lcdk                   | arm    | lab-baylibre    | gcc-10   | multi_=
v5_defconfig           | 1          =

fsl-ls1088a-rdb              | arm64  | lab-nxp         | gcc-10   | defcon=
fig                    | 2          =

hifive-unleashed-a00         | riscv  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =

hp-11A-G6-EE-grunt           | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

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

jetson-tk1                   | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =

jetson-tk1                   | arm    | lab-baylibre    | gcc-10   | tegra_=
defconfig              | 1          =

meson-g12a-sei510            | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =

meson-g12a-u200              | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =

meson-g12a-x96-max           | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =

meson-g12b-a311d-khadas-vim3 | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =

meson-g12b-a311d-khadas-vim3 | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =

meson-g12b-odroid-n2         | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =

meson-gxbb-p200              | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =

meson-gxl-s905x-libretech-cc | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =

meson-gxl-s905x-libretech-cc | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =

meson-gxm-khadas-vim2        | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =

meson-gxm-q200               | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =

meson-sm1-sei610             | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =

meson8b-odroidc1             | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =

odroid-xu3                   | arm    | lab-collabora   | gcc-10   | exynos=
_defconfig             | 1          =

odroid-xu3                   | arm    | lab-collabora   | gcc-10   | multi_=
v7_defconfig           | 1          =

qemu_arm64-virt-gicv2        | arm64  | lab-baylibre    | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv2        | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =

qemu_arm64-virt-gicv2        | arm64  | lab-broonie     | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv2        | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =

qemu_arm64-virt-gicv2        | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64  | lab-baylibre    | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64  | lab-broonie     | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =

qemu_arm64-virt-gicv3        | arm64  | lab-baylibre    | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv3        | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =

qemu_arm64-virt-gicv3        | arm64  | lab-broonie     | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv3        | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =

qemu_arm64-virt-gicv3        | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv3        | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64  | lab-baylibre    | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64  | lab-broonie     | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =

rk3288-rock2-square          | arm    | lab-collabora   | gcc-10   | multi_=
v7_defconfig           | 1          =

rk3399-gru-kevin             | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =

sun4i-a10-olinuxino-lime     | arm    | lab-baylibre    | gcc-10   | sunxi_=
defconfig              | 1          =

sun50i-a64-bananapi-m64      | arm64  | lab-clabbe      | gcc-10   | defcon=
fig                    | 1          =

sun50i-a64-pine64-plus       | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =

sun50i-a64-pine64-plus       | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =

sun50i-h6-orangepi-3         | arm64  | lab-clabbe      | gcc-10   | defcon=
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

tegra124-nyan-big            | arm    | lab-collabora   | gcc-10   | multi_=
v7_defconfig           | 1          =

tegra124-nyan-big            | arm    | lab-collabora   | gcc-10   | tegra_=
defconfig              | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.230-80-g3dc8085bd06d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.230-80-g3dc8085bd06d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3dc8085bd06d546477ea8652e96feb74aac2fd94 =



Test Regressions
---------------- =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
at91sam9g20ek                | arm    | lab-broonie     | gcc-10   | at91_d=
t_defconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63d36c86364e5f566b915f52

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: at91_dt_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam9g=
20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam9g=
20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d36c86364e5f566b915=
f53
        failing since 2 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
at91sam9g20ek                | arm    | lab-broonie     | gcc-10   | multi_=
v5_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63d36c22d46cb22b96915ebc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam9=
g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam9=
g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d36c22d46cb22b96915=
ebd
        failing since 2 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beagle-xm                    | arm    | lab-baylibre    | gcc-10   | omap2p=
lus_defconfig          | 2          =


  Details:     https://kernelci.org/test/plan/id/63d36f1830813c3aef915f1c

  Results:     3 PASS, 3 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d36f1830813c3=
aef915f23
        failing since 2 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b)
        26 lines

    2023-01-27T06:28:17.235362  kern  :emerg : Internal error: Oops: 800000=
0d [#1] SMP ARM
    2023-01-27T06:28:17.240878  kern  :emerg : Process udevd (pid: 101, sta=
ck limit =3D 0x(ptrval))
    2023-01-27T06:28:17.246545  kern  :emerg : Stack: (0xc98b3d48 to 0xc98b=
4000)
    2023-01-27T06:28:17.261408  kern  :emerg : 3d40:                   c995=
ae80 c06226e4 00000000 cb7f268<8>[   24.003723] <LAVA_SIGNAL_TESTCASE TEST_=
CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D26>   =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d36f1830813c3=
aef915f24
        failing since 2 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b)
        4 lines

    2023-01-27T06:28:17.171907  kern  :alert : 8<--- cut here ---
    2023-01-27T06:28:17.177546  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address ce20e810
    2023-01-27T06:28:17.182924  kern  :alert : pgd =3D (ptrval)
    2023-01-27T06:28:17.188637  kern  :alert : [ce20e810] *pgd=3D8e20041e(b=
ad)
    2023-01-27T06:28:17.195039  <8>[   23.940216] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>   =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
cubietruck                   | arm    | lab-baylibre    | gcc-10   | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/63d36de9f156fb153a915ec4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-cubietruck=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-cubietruck=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d36de9f156fb153a915=
ec5
        failing since 2 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
da850-lcdk                   | arm    | lab-baylibre    | gcc-10   | davinc=
i_all_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/63d36c5c60ffeed01e915ee4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: davinci_all_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm/davinci_all_defconfig/gcc-10/lab-baylibre/baseline-da85=
0-lcdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm/davinci_all_defconfig/gcc-10/lab-baylibre/baseline-da85=
0-lcdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d36c5c60ffeed01e915=
ee5
        failing since 2 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
da850-lcdk                   | arm    | lab-baylibre    | gcc-10   | multi_=
v5_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63d36c0c3c4013b620915ec7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm/multi_v5_defconfig/gcc-10/lab-baylibre/baseline-da850-l=
cdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm/multi_v5_defconfig/gcc-10/lab-baylibre/baseline-da850-l=
cdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d36c0c3c4013b620915=
ec8
        failing since 2 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
fsl-ls1088a-rdb              | arm64  | lab-nxp         | gcc-10   | defcon=
fig                    | 2          =


  Details:     https://kernelci.org/test/plan/id/63d36f2f6d4f2203db915ede

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls1088a-rdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls1088a-rdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d36f2f6d4f220=
3db915ee6
        failing since 2 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b)
        11 lines

    2023-01-27T06:28:27.248662  kern  :alert : Unable to handle kernel NULL=
 poin[   10.057207] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfai=
l UNITS=3Dlines MEASUREMENT=3D11>   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d36f2f6d4f220=
3db915ee7
        failing since 2 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b)
        2 lines

    2023-01-27T06:28:27.252413  ter dereference at virtual address 00000000=
00000000
    2023-01-27T06:28:27.252720  kern  :alert : Mem abort info:
    2023-01-27T06:28:27.257925  kern  :alert :   ESR =3D 0x96000006
    2023-01-27T06:28:27.268912  kern  :a[   10.076760] <LAVA_SIGNAL_TESTCAS=
E TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hifive-unleashed-a00         | riscv  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d36bc25be872104d915ec1

  Results:     3 PASS, 2 FAIL, 2 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleash=
ed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleash=
ed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/riscv/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/63d36bc35be87210=
4d915eca
        failing since 99 days (last pass: v5.4.219-270-gde284a6cd1e4, first=
 fail: v5.4.219-266-g5eb28a6c7901)
        3 lines

    2023-01-27T06:14:05.794835  / # =

    2023-01-27T06:14:05.795690  =

    2023-01-27T06:14:07.861026  / # #
    2023-01-27T06:14:07.861897  #
    2023-01-27T06:14:09.872206  / # export SHELL=3D/bin/sh
    2023-01-27T06:14:09.872557  export SHELL=3D/bin/sh
    2023-01-27T06:14:11.888718  / # . /lava-3224743/environment
    2023-01-27T06:14:11.889136  . /lava-3224743/environment
    2023-01-27T06:14:13.904747  / # /lava-3224743/bin/lava-test-runner /lav=
a-3224743/0
    2023-01-27T06:14:13.905885  /lava-3224743/bin/lava-test-runner /lava-32=
24743/0 =

    ... (9 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-11A-G6-EE-grunt           | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63d36cf19b7e36cc9c915ebd

  Results:     17 PASS, 1 FAIL, 1 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-11A-G6-EE-grunt.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-11A-G6-EE-grunt.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/x86/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d36cf19b7e36c=
c9c915ed0
        new failure (last pass: v5.4.230-72-gfed0bc9a3f6d)
        1 lines

    2023-01-27T06:19:23.653381  kern  :emerg : do_IRQ: 1.55 No irq handler =
for vector
    2023-01-27T06:19:23.660150  <8>[   10.394619] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>   =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx6dl-riotboard             | arm    | lab-pengutronix | gcc-10   | multi_=
v7_defconfig           | 2          =


  Details:     https://kernelci.org/test/plan/id/63d36d81502e4b97d8915eb9

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6=
dl-riotboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6=
dl-riotboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d36d81502e4b9=
7d8915ec0
        failing since 2 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b)
        25 lines

    2023-01-27T06:21:45.758609  kern  :emerg : Internal error: Oops: 800000=
0d [#1] SMP ARM
    2023-01-27T06:21:45.776693  kern  :emerg : Process udevd (pid: 102, sta=
ck limit =3D 0x(ptrval))[    7.884144] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=
=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D25>
    2023-01-27T06:21:45.777012     =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d36d81502e4b9=
7d8915ec1
        failing since 2 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b)
        4 lines

    2023-01-27T06:21:45.718233  kern  :alert : 8<--- cut here ---
    2023-01-27T06:21:45.727161  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address eea69420
    2023-01-27T06:21:45.734803  kern  :a[    7.843610] <LAVA_SIGNAL_TESTCAS=
E TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>
    2023-01-27T06:21:45.735004  lert : pgd =3D (ptrval)
    2023-01-27T06:21:45.735129  kern  :alert : [eea69420] *pgd=3D3ea0041e(b=
ad)   =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx6qp-wandboard-revd1       | arm    | lab-pengutronix | gcc-10   | imx_v6=
_v7_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/63d36c90da0484bc63915eb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
6qp-wandboard-revd1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
6qp-wandboard-revd1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d36c90da0484bc63915=
eba
        failing since 2 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx6qp-wandboard-revd1       | arm    | lab-pengutronix | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63d36d8205c484687e915eba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6=
qp-wandboard-revd1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6=
qp-wandboard-revd1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d36d8205c484687e915=
ebb
        failing since 2 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx7d-sdb                    | arm    | lab-nxp         | gcc-10   | imx_v6=
_v7_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/63d36ce5a38d510245915ed8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sdb.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sdb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d36ce5a38d510245915=
ed9
        failing since 2 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx7d-sdb                    | arm    | lab-nxp         | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63d36dc2441481ab6b915f0b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sdb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d36dc2441481ab6b915=
f0c
        failing since 2 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx8mn-ddr4-evk              | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d36f78074e0769dc915f18

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-ddr4-ev=
k.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-ddr4-ev=
k.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d36f78074e0769dc915=
f19
        failing since 2 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
jetson-tk1                   | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63d36d9a502e4b97d8915eec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson-=
tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson-=
tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d36d9a502e4b97d8915=
eed
        failing since 2 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
jetson-tk1                   | arm    | lab-baylibre    | gcc-10   | tegra_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/63d36c61aa670a5d40915ef6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d36c61aa670a5d40915=
ef7
        failing since 2 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
meson-g12a-sei510            | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d36ea80657912281915f06

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-sei=
510.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-sei=
510.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d36ea80657912281915=
f07
        failing since 2 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
meson-g12a-u200              | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d36ec875ba11e366915f1b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-u20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-u20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d36ec875ba11e366915=
f1c
        failing since 2 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
meson-g12a-x96-max           | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d36ec575ba11e366915f15

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-x96=
-max.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-x96=
-max.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d36ec575ba11e366915=
f16
        failing since 2 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
meson-g12b-a311d-khadas-vim3 | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d36f1130813c3aef915f19

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-a31=
1d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-a31=
1d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d36f1130813c3aef915=
f1a
        failing since 2 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
meson-g12b-a311d-khadas-vim3 | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d36fb45356b2ad97915ed6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig/gcc-10/lab-collabora/baseline-meson-g12b-a3=
11d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig/gcc-10/lab-collabora/baseline-meson-g12b-a3=
11d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d36fb45356b2ad97915=
ed7
        failing since 2 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
meson-g12b-odroid-n2         | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d36ec775ba11e366915f18

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-odr=
oid-n2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-odr=
oid-n2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d36ec775ba11e366915=
f19
        failing since 2 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
meson-gxbb-p200              | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d380b1090a9a86ca915ee1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d380b1090a9a86ca915=
ee2
        failing since 2 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
meson-gxl-s905x-libretech-cc | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d36f5015de0a21f3915ebb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s905=
x-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s905=
x-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d36f5015de0a21f3915=
ebc
        failing since 2 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
meson-gxl-s905x-libretech-cc | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d37107daf85e2b17915ed5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s905x=
-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s905x=
-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d37107daf85e2b17915=
ed6
        failing since 2 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
meson-gxm-khadas-vim2        | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d36ead0657912281915f0e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm-khad=
as-vim2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm-khad=
as-vim2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d36ead0657912281915=
f0f
        failing since 2 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
meson-gxm-q200               | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d37d8a94fc224174915edb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm-q200=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm-q200=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d37d8a94fc224174915=
edc
        failing since 2 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
meson-sm1-sei610             | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d36ea75b202f20f9915ef0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-sm1-sei6=
10.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-sm1-sei6=
10.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d36ea75b202f20f9915=
ef1
        failing since 2 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
meson8b-odroidc1             | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63d36dab05c484687e915f51

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson8b=
-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson8b=
-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d36dab05c484687e915=
f52
        failing since 2 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
odroid-xu3                   | arm    | lab-collabora   | gcc-10   | exynos=
_defconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63d36cb0da0484bc63915ed3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: exynos_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-odroid-x=
u3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-odroid-x=
u3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d36cb0da0484bc63915=
ed4
        failing since 2 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
odroid-xu3                   | arm    | lab-collabora   | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63d36df03e60f8e724915ebf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-odroid=
-xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-odroid=
-xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d36df03e60f8e724915=
ec0
        failing since 2 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-baylibre    | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63d36dc047c1ce118b915ee7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseli=
ne-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseli=
ne-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d36dc047c1ce118b915=
ee8
        failing since 261 days (last pass: v5.4.191-84-g56ce42d78d96, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d36feda67c070cc6915f1a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d36feda67c070cc6915=
f1b
        failing since 261 days (last pass: v5.4.191-77-g1a3b249e415b, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-broonie     | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63d36dad539b696b4e915ecc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d36dad539b696b4e915=
ecd
        failing since 261 days (last pass: v5.4.191-84-g56ce42d78d96, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d370b98dca1b90c5915ecc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d370b98dca1b90c5915=
ecd
        failing since 261 days (last pass: v5.4.191-77-g1a3b249e415b, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d370e6fa397d78ee915ecf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vi=
rt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vi=
rt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d370e6fa397d78ee915=
ed0
        failing since 261 days (last pass: v5.4.191-77-g1a3b249e415b, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-baylibre    | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63d36dc2846a942bdf915ee1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseli=
ne-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseli=
ne-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d36dc2846a942bdf915=
ee2
        failing since 261 days (last pass: v5.4.191-84-g56ce42d78d96, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d36ff2a67c070cc6915f20

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d36ff2a67c070cc6915=
f21
        failing since 261 days (last pass: v5.4.191-77-g1a3b249e415b, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-broonie     | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63d36dae846a942bdf915ebc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d36dae846a942bdf915=
ebd
        failing since 261 days (last pass: v5.4.191-84-g56ce42d78d96, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d37131c7bc3fdeef915ec0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d37131c7bc3fdeef915=
ec1
        failing since 261 days (last pass: v5.4.191-77-g1a3b249e415b, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d3718ad101e794f5915ebf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vi=
rt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vi=
rt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d3718ad101e794f5915=
ec0
        failing since 261 days (last pass: v5.4.191-77-g1a3b249e415b, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-baylibre    | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63d36dbe846a942bdf915ecc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseli=
ne-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseli=
ne-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d36dbe846a942bdf915=
ecd
        failing since 185 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d36fefa67c070cc6915f1d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d36fefa67c070cc6915=
f1e
        failing since 261 days (last pass: v5.4.191-77-g1a3b249e415b, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-broonie     | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63d36d98502e4b97d8915ee6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d36d98502e4b97d8915=
ee7
        failing since 185 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d370e18dca1b90c5915ef1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d370e18dca1b90c5915=
ef2
        failing since 261 days (last pass: v5.4.191-77-g1a3b249e415b, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63d36d8905c484687e915ec3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d36d8905c484687e915=
ec4
        failing since 185 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d371a0f81fc7764e915eb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vi=
rt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vi=
rt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d371a0f81fc7764e915=
eba
        failing since 261 days (last pass: v5.4.191-77-g1a3b249e415b, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-baylibre    | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63d36dbfc86580fbbb915ed9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseli=
ne-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseli=
ne-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d36dbfc86580fbbb915=
eda
        failing since 261 days (last pass: v5.4.191-84-g56ce42d78d96, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d36ff4a67c070cc6915f23

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d36ff4a67c070cc6915=
f24
        failing since 261 days (last pass: v5.4.191-77-g1a3b249e415b, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-broonie     | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63d36d9a502e4b97d8915ee9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d36d9a502e4b97d8915=
eea
        failing since 261 days (last pass: v5.4.191-84-g56ce42d78d96, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d3714501d6d56746915ee2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d3714501d6d56746915=
ee3
        failing since 261 days (last pass: v5.4.191-77-g1a3b249e415b, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d371d65227668023915eb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vi=
rt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vi=
rt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d371d65227668023915=
eba
        failing since 261 days (last pass: v5.4.191-77-g1a3b249e415b, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
rk3288-rock2-square          | arm    | lab-collabora   | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63d37efb3dba3d6ef6915eb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk3288=
-rock2-square.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk3288=
-rock2-square.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d37efb3dba3d6ef6915=
eba
        failing since 2 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
rk3399-gru-kevin             | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63d36d4d426b9ff747915ede

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d36d4d426b9ff747915=
edf
        failing since 2 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun4i-a10-olinuxino-lime     | arm    | lab-baylibre    | gcc-10   | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/63d36f2ebc049574b9915ecf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun4i-a10-=
olinuxino-lime.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun4i-a10-=
olinuxino-lime.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d36f2ebc049574b9915=
ed0
        new failure (last pass: v5.4.228-658-g579a0289832d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun50i-a64-bananapi-m64      | arm64  | lab-clabbe      | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d36ec975ba11e366915f1e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d36ec975ba11e366915=
f1f
        failing since 2 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun50i-a64-pine64-plus       | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d37818d2b57e0667915ed4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64-pin=
e64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64-pin=
e64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d37818d2b57e0667915=
ed5
        failing since 2 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun50i-a64-pine64-plus       | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d36ee430813c3aef915ed5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pine=
64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pine=
64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d36ee430813c3aef915=
ed6
        failing since 2 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun50i-h6-orangepi-3         | arm64  | lab-clabbe      | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d36fd329d9fa0eb1915ecc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-orange=
pi-3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-orange=
pi-3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d36fd329d9fa0eb1915=
ecd
        failing since 2 days (last pass: v5.4.228-622-ge3f2d3701743, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun50i-h6-pine-h64           | arm64  | lab-clabbe      | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d36ebbcfcd9984ad915ec6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-pine-h=
64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-pine-h=
64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d36ebbcfcd9984ad915=
ec7
        failing since 2 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun50i-h6-pine-h64           | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d36ecce839675ab7915f02

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig/gcc-10/lab-collabora/baseline-sun50i-h6-pin=
e-h64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm64/defconfig/gcc-10/lab-collabora/baseline-sun50i-h6-pin=
e-h64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d36ecce839675ab7915=
f03
        failing since 2 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun5i-a13-olinuxino-micro    | arm    | lab-baylibre    | gcc-10   | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/63d36d8a05c484687e915ec6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun5i-a13-=
olinuxino-micro.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun5i-a13-=
olinuxino-micro.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d36d8a05c484687e915=
ec7
        failing since 2 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun7i-a20-cubieboard2        | arm    | lab-baylibre    | gcc-10   | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/63d36cd1a38d510245915ec4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7i-a20-=
cubieboard2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7i-a20-=
cubieboard2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d36cd1a38d510245915=
ec5
        failing since 2 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun7i-a20-cubieboard2        | arm    | lab-clabbe      | gcc-10   | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/63d36cd5847a2d5c1e915ec0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun7i-a20-cu=
bieboard2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun7i-a20-cu=
bieboard2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d36cd5847a2d5c1e915=
ec1
        failing since 2 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun7i-a20-olinuxino-lime2    | arm    | lab-baylibre    | gcc-10   | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/63d370a58dca1b90c5915ec6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7i-a20-=
olinuxino-lime2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7i-a20-=
olinuxino-lime2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d370a58dca1b90c5915=
ec7
        failing since 2 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-a33-olinuxino          | arm    | lab-clabbe      | gcc-10   | multi_=
v7_defconfig           | 2          =


  Details:     https://kernelci.org/test/plan/id/63d36e17f156fb153a915ed5

  Results:     3 PASS, 3 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a33=
-olinuxino.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a33=
-olinuxino.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d36e17f156fb1=
53a915edd
        failing since 2 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b)
        4 lines

    2023-01-27T06:24:03.723216  kern  :alert : 8<--- cut here ---
    2023-01-27T06:24:03.723917  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address ee9ba810
    2023-01-27T06:24:03.724253  kern  :alert : pgd =3D (ptrval)
    2023-01-27T06:24:03.724569  kern  :alert : [ee9ba810] *pgd=3D6e81141e(b=
ad)
    2023-01-27T06:24:03.724920  <8>[   17.905553] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d36e17f156fb1=
53a915ede
        failing since 2 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b)
        24 lines

    2023-01-27T06:24:03.798279  kern  :emerg : Internal error: Oops: 800000=
0d [#1] SMP ARM
    2023-01-27T06:24:03.798719  kern  :emerg : Process udevd (pid: 109, sta=
ck limit =3D 0x(ptrval))
    2023-01-27T06:24:03.799345  kern  :emerg : Stack: (0xedcc5d88 to 0xedcc=
6000)
    2023-01-27T06:24:03.799656  kern  :emerg : 5d80:                   ee9d=
3900 c098917c 00000000 ee9d9000 ee9d<8>[   17.975833] <LAVA_SIGNAL_TESTCASE=
 TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D24>
    2023-01-27T06:24:03.799978  3980 66550c2a
    2023-01-27T06:24:03.800297  kern  :emerg : 5da0: ee832a80 ee9ba810 0000=
0000 c<8>[   17.987070] <LAVA_SIGNAL_ENDRUN 0_dmesg 386878_1.5.2.4.1>
    2023-01-27T06:24:03.800640  19e4ec8 fffffdfb c19e4ec4 bf093024 00000009=
   =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-a33-olinuxino          | arm    | lab-clabbe      | gcc-10   | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/63d36ce9847a2d5c1e915ed3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a33-ol=
inuxino.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a33-ol=
inuxino.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d36ce9847a2d5c1e915=
ed4
        failing since 2 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-a83t-bananapi-m3       | arm    | lab-clabbe      | gcc-10   | multi_=
v7_defconfig           | 2          =


  Details:     https://kernelci.org/test/plan/id/63d36dc0c86580fbbb915ede

  Results:     3 PASS, 3 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a83=
t-bananapi-m3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a83=
t-bananapi-m3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d36dc0c86580f=
bbb915ee6
        failing since 2 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b)
        8 lines

    2023-01-27T06:22:35.264636  kern  :alert : 8<--- cut here ---
    2023-01-27T06:22:35.265134  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address ee2b1c10
    2023-01-27T06:22:35.265760  kern  :alert : pgd =3D (ptrval)
    2023-01-27T06:22:35.266101  kern  :alert : [ee2b1c10] *pgd=3D6e21141e(b=
ad)
    2023-01-27T06:22:35.266426  kern  :alert : 8<--- cut here [   45.219213=
] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines ME=
ASUREMENT=3D8>
    2023-01-27T06:22:35.266726  ---
    2023-01-27T06:22:35.267019  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address ed3af000
    2023-01-27T06:22:35.267326  kern  :alert : pgd =3D (ptrval)
    2023-01-27T06:22:35.267665  kern  :alert : [ed3af000] *pgd=3D6d21141e(b=
ad)   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d36dc0c86580f=
bbb915ee7
        failing since 2 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b)
        41 lines

    2023-01-27T06:22:35.317232  kern  :emerg : Internal error: Oops: 800000=
0d [#1] SMP ARM
    2023-01-27T06:22:35.317953  kern  :emerg : Process udevd (pid: 159, sta=
ck limit =3D 0x(ptrval))
    2023-01-27T06:22:35.318308  kern  :emerg : Stack: (0xeb895d88 to 0xeb89=
6000)
    2023-01-27T06:22:35.318614  kern  :em[   45.282564] <LAVA_SIGNAL_TESTCA=
SE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D41>
    2023-01-27T06:22:35.318938  erg : 5d80:                   ed7e4600 c098=
917c 00000000 ed3de84[   45.293468] <LAVA_SIGNAL_ENDRUN 0_dmesg 386877_1.5.=
2.4.1>
    2023-01-27T06:22:35.319257  0 ed7e4680 52425e85   =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-a83t-bananapi-m3       | arm    | lab-clabbe      | gcc-10   | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/63d36cbc50624f73e7915ebc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a83t-b=
ananapi-m3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a83t-b=
ananapi-m3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d36cbc50624f73e7915=
ebd
        failing since 2 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 2          =


  Details:     https://kernelci.org/test/plan/id/63d36dadc86580fbbb915eb9

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h=
3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h=
3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d36dadc86580f=
bbb915ec0
        failing since 2 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b)
        24 lines

    2023-01-27T06:22:27.061053  kern  :emerg : Internal error: Oops: 800000=
0d [#1] SMP ARM
    2023-01-27T06:22:27.061639  kern  :emerg : Process udevd (pid: 121, sta=
ck limit =3D 0x(ptrval))
    2023-01-27T06:22:27.061885  kern  :emerg : Stack: (0xedffdd88 to 0xedff=
e000)
    2023-01-27T06:22:27.062145  kern  :emerg : <8>[    7.990521] <LAVA_SIGN=
AL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D=
24>
    2023-01-27T06:22:27.062408  dd80:                   edf62680 c098917c 0=
0000000 eda3b480 ed06<8>[    8.005665] <LAVA_SIGNAL_ENDRUN 0_dmesg 3224806_=
1.5.2.4.1>
    2023-01-27T06:22:27.062661  2000 c80cfd8e   =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d36dadc86580f=
bbb915ec1
        failing since 2 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b)
        4 lines

    2023-01-27T06:22:26.998739  kern  :alert : 8<--- cut here ---
    2023-01-27T06:22:26.999217  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address eea23010
    2023-01-27T06:22:26.999459  kern  :alert : pgd =3D (ptrval)
    2023-01-27T06:22:26.999720  kern  :alert : [eea23010] *pgd=3D6ea1141e(b=
ad)
    2023-01-27T06:22:27.002363  <8>[    7.939609] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>   =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre    | gcc-10   | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/63d36cba50624f73e7915eb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h3-l=
ibretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h3-l=
ibretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d36cba50624f73e7915=
eba
        failing since 2 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h3-orangepi-pc         | arm    | lab-clabbe      | gcc-10   | multi_=
v7_defconfig           | 2          =


  Details:     https://kernelci.org/test/plan/id/63d36db3846a942bdf915ec1

  Results:     3 PASS, 3 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-=
orangepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-=
orangepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d36db3846a942=
bdf915ec9
        failing since 2 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b)
        4 lines

    2023-01-27T06:22:26.449981  kern  :alert : 8<--- cut here ---
    2023-01-27T06:22:26.455450  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address ee9e2c10
    2023-01-27T06:22:26.464553  kern  :ale<8>[   14.930267] <LAVA_SIGNAL_TE=
STCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d36db3846a942=
bdf915eca
        failing since 2 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b)
        24 lines

    2023-01-27T06:22:26.471002  rt : pgd =3D (ptrval)
    2023-01-27T06:22:26.471365  kern  :alert : [ee9e2c10] *pgd=3D6e81141e(b=
ad)
    2023-01-27T06:22:26.488474  kern  :emerg : Internal error: Oops: 800000=
0d [#1] SMP ARM
    2023-01-27T06:22:26.499311  kern  :emerg : Process udevd (pid: 122, sta=
ck limit =3D 0x(ptrval))
    2023-01-27T06:22:26.503194  k<8>[   14.968931] <LAVA_SIGNAL_TESTCASE TE=
ST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D24>   =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h3-orangepi-pc         | arm    | lab-clabbe      | gcc-10   | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/63d36d25426b9ff747915eba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-ora=
ngepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-ora=
ngepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d36d25426b9ff747915=
ebb
        failing since 2 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-r40-bananapi-m2-ultra  | arm    | lab-clabbe      | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63d36e15bf8a77c0a2915ebd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-r40=
-bananapi-m2-ultra.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-r40=
-bananapi-m2-ultra.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d36e15bf8a77c0a2915=
ebe
        failing since 2 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-r40-bananapi-m2-ultra  | arm    | lab-clabbe      | gcc-10   | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/63d36d399027ec1061915eb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-r40-ba=
nanapi-m2-ultra.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-r40-ba=
nanapi-m2-ultra.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d36d399027ec1061915=
eba
        failing since 2 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
tegra124-nyan-big            | arm    | lab-collabora   | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63d37729a1cefe50da915ed7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-tegra1=
24-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-tegra1=
24-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d37729a1cefe50da915=
ed8
        failing since 2 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
tegra124-nyan-big            | arm    | lab-collabora   | gcc-10   | tegra_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/63d376c5dd7727fa6f915ec8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra124-=
nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-8=
0-g3dc8085bd06d/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra124-=
nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d376c5dd7727fa6f915=
ec9
        failing since 2 days (last pass: v5.4.228-674-g4e406b22c6e0, first =
fail: v5.4.228-746-g2ac15b81a26b) =

 =20
