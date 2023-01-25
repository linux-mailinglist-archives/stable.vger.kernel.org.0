Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9406267BC85
	for <lists+stable@lfdr.de>; Wed, 25 Jan 2023 21:26:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235543AbjAYU0k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Jan 2023 15:26:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236250AbjAYU0j (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Jan 2023 15:26:39 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1A8459269
        for <stable@vger.kernel.org>; Wed, 25 Jan 2023 12:26:33 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id 200so14236787pfx.7
        for <stable@vger.kernel.org>; Wed, 25 Jan 2023 12:26:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=JxOXEGFbS7r1528zDEuXOigJ/c22h1JVGsiKIO+olgQ=;
        b=bbjK27MXEhxFzC1f0E9bghZ1lDDnnndEg3NWGBbq9iXFiJ1VAPeKMoqPj3l7rtGZBC
         SfyJ/8XVRb9Y/PCaEkFatIo9kJ3TIvr6gLMFGciU5tjlufrghm7eMBhfofajex6Zzv+5
         /nqZMh0K7jS8sOK9Ck83WVmFksm4FCoWTzfajxe1Gzw1AL6rMeZdp7TCcS/jYhr41sL8
         CpA0KFGJj9Dnw42s3nwUOo8LHXRSijtdtUXjDdEx9Es5pPgc6yUp2axU/uOXXUv0L2il
         YdrMtqWS9E81CQkzNODx0aXLE76w2XwXaJJLiGV4P35Xj9RB4LRkxK6qapeJC7SyvclQ
         m/qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JxOXEGFbS7r1528zDEuXOigJ/c22h1JVGsiKIO+olgQ=;
        b=0w1YEhpCv9+8bgqpXczCboJISkKS4dr5119LSZC2MUOIChDuXBDvZvQdWZpuimGuMT
         EqizblOJApYB4YZo717NA2f9xWLEESES+tHcSrET/JWt2gM6J089yvQgvyKSIJWwJ3PD
         mkbMrd6JC3xwQyjUh3y/veezKFWLOs2FBrSFwFtW3LlDR3hLSIhhMVz+iDDIGQKDJRXB
         q0OlqYXHMoxNwT2WsPXxQ70+cx89HNXVTZpaTffjd1JzCrazmmxdBbY/bRcBKTbFznH0
         Ay0Q37NNn+f0vdC5odkwlGKbRz8322vzKCsjAe42U1UVCux2cESQLH/pGYb0/WVaqiGL
         ACoQ==
X-Gm-Message-State: AFqh2ko1wQ1pfHEjfGFkxSfiVo6eN82STwKdmlgw1c7pGXeegUCqlQpt
        rwZN/WBO+IHLcfhKpWnYGXC1jBQFKpuMLi46IGYw1w==
X-Google-Smtp-Source: AMrXdXtZCW/dk4+fpoCocFSnNh9rxaQvxNG6QUMdYScS235kpDTNdJE7C/SsXIbQn5G5hsfBrsTO1Q==
X-Received: by 2002:a05:6a00:44c5:b0:580:8c2c:d0ad with SMTP id cv5-20020a056a0044c500b005808c2cd0admr31054197pfb.13.1674678391480;
        Wed, 25 Jan 2023 12:26:31 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k5-20020aa788c5000000b0056b9df2a15esm4065055pff.62.2023.01.25.12.26.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 12:26:31 -0800 (PST)
Message-ID: <63d19077.a70a0220.6ec4f.776c@mx.google.com>
Date:   Wed, 25 Jan 2023 12:26:31 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.230-72-g283de2edfdbd
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 141 runs,
 81 regressions (v5.4.230-72-g283de2edfdbd)
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

stable-rc/queue/5.4 baseline: 141 runs, 81 regressions (v5.4.230-72-g283de2=
edfdbd)

Regressions Summary
-------------------

platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
at91sam9g20ek                | arm   | lab-broonie     | gcc-10   | at91_dt=
_defconfig          | 1          =

at91sam9g20ek                | arm   | lab-broonie     | gcc-10   | multi_v=
5_defconfig         | 1          =

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

hifive-unleashed-a00         | riscv | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

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

imx8mn-ddr4-evk              | arm64 | lab-nxp         | gcc-10   | defconf=
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

meson-gxl-s905d-p230         | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

meson-gxl-s905x-libretech-cc | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

meson-gxl-s905x-libretech-cc | arm64 | lab-broonie     | gcc-10   | defconf=
ig                  | 1          =

meson-gxl-s905x-libretech-cc | arm64 | lab-clabbe      | gcc-10   | defconf=
ig                  | 1          =

meson-gxm-khadas-vim2        | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

meson-gxm-q200               | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

meson-sm1-khadas-vim3l       | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

meson-sm1-sei610             | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

odroid-xu3                   | arm   | lab-collabora   | gcc-10   | exynos_=
defconfig           | 1          =

odroid-xu3                   | arm   | lab-collabora   | gcc-10   | multi_v=
7_defconfig         | 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-baylibre    | gcc-10   | defconf=
ig+arm64-chromebook | 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-baylibre    | gcc-10   | defconf=
ig+arm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-collabora   | gcc-10   | defconf=
ig                  | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-baylibre    | gcc-10   | defconf=
ig+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-baylibre    | gcc-10   | defconf=
ig+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-collabora   | gcc-10   | defconf=
ig                  | 1          =

rk3399-gru-kevin             | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =

sun50i-a64-bananapi-m64      | arm64 | lab-clabbe      | gcc-10   | defconf=
ig                  | 1          =

sun50i-a64-pine64-plus       | arm64 | lab-broonie     | gcc-10   | defconf=
ig                  | 1          =

sun50i-h6-orangepi-3         | arm64 | lab-clabbe      | gcc-10   | defconf=
ig                  | 1          =

sun50i-h6-orangepi-one-plus  | arm64 | lab-clabbe      | gcc-10   | defconf=
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

sun8i-h2-plus...ch-all-h3-cc | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 2          =

sun8i-h2-plus...ch-all-h3-cc | arm   | lab-baylibre    | gcc-10   | sunxi_d=
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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.230-72-g283de2edfdbd/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.230-72-g283de2edfdbd
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      283de2edfdbd24b17f011fb90e57d9ae2d3a4dc7 =



Test Regressions
---------------- =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
at91sam9g20ek                | arm   | lab-broonie     | gcc-10   | at91_dt=
_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/63d1577606c334b2ce915f39

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: at91_dt_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam9g=
20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam9g=
20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d1577606c334b2ce915=
f3a
        failing since 1 day (last pass: v5.4.228-674-g4e406b22c6e0, first f=
ail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
at91sam9g20ek                | arm   | lab-broonie     | gcc-10   | multi_v=
5_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d1587a0389d0bfa0915eca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam9=
g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam9=
g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d1587a0389d0bfa0915=
ecb
        failing since 1 day (last pass: v5.4.228-674-g4e406b22c6e0, first f=
ail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
beagle-xm                    | arm   | lab-baylibre    | gcc-10   | omap2pl=
us_defconfig        | 2          =


  Details:     https://kernelci.org/test/plan/id/63d158026541564240915ed7

  Results:     3 PASS, 3 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d158026541564=
240915ede
        failing since 1 day (last pass: v5.4.228-674-g4e406b22c6e0, first f=
ail: v5.4.228-746-g2ac15b81a26b)
        26 lines

    2023-01-25T16:25:22.190413  kern  :emerg : Internal error: Oops: 800000=
0d [#1] SMP ARM
    2023-01-25T16:25:22.196330  kern  :emerg : Process udevd (pid: 92, stac=
k limit =3D 0x(ptrval))
    2023-01-25T16:25:22.201722  kern  :emerg : Stack: (0xcb7d3d48 to 0xcb7d=
4000)
    2023-01-25T16:25:22.218575  kern  :emerg : 3d40:                   c995=
5e80 c06226e4 00000000 cb7e4680<8>[   24.000732] <LAVA_SIGNAL_TESTCASE TEST=
_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D26>
    2023-01-25T16:25:22.219382   c9955d00 89cbfcb2   =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d158026541564=
240915edf
        failing since 1 day (last pass: v5.4.228-674-g4e406b22c6e0, first f=
ail: v5.4.228-746-g2ac15b81a26b)
        4 lines

    2023-01-25T16:25:22.126869  kern  :alert : 8<--- cut here ---
    2023-01-25T16:25:22.131175  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address ce20e810
    2023-01-25T16:25:22.136807  kern  :alert : pgd =3D (ptrval)
    2023-01-25T16:25:22.142968  kern  :alert : [ce20e810] *pgd=3D8e20041e(b=
ad)
    2023-01-25T16:25:22.149184  <8>[   23.936157] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
cubietruck                   | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 3          =


  Details:     https://kernelci.org/test/plan/id/63d15bb41cb6934d30915eea

  Results:     3 PASS, 3 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietr=
uck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietr=
uck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d15bb41cb6934d30915eef
        failing since 0 day (last pass: v5.4.228-747-gaa765823625c, first f=
ail: v5.4.228-747-g1b0c8bf29445)

    2023-01-25T16:40:58.388705  erg : 3d80:                   ed5a8600 c098=
917c 00000000 ed16fd8<8>[   37.334623] <LAVA_SIGNAL_ENDRUN 0_dmesg 3211079_=
1.5.2.4.1>
    2023-01-25T16:40:58.389430  0 ed5a8600 a9162cfc
    2023-01-25T16:40:58.399739  kern  :emerg : 3da0: ee037780 ee16c010 0000=
0000 c19e4ec8 fffffdfb c19e4ec4 bf050024 0000000d
    2023-01-25T16:40:58.405381  kern  :emerg : 3dc0: 00020000 c09852f8 0000=
0000 ee16c010 bf050024 ee16c054 bf050024 ed5a85b8
    2023-01-25T16:40:58.416434  kern  :emerg : 3de0: 00000000 0000017b 0002=
0000 c09857f8 a0000013 00000000 ee16c010 00000000
    2023-01-25T16:40:58.421911  kern  :emerg : 3e00: ee16c054 bf050024 ed5a=
85b8 c0985ba0 bf050024 ee16c010 c0985ba8 ed652000
    2023-01-25T16:40:58.432909  kern  :emerg : 3e20: ed5a85b8 c0985c08 0000=
0000 bf050024 c0985ba8 c09831bc 00000000 ee037758
    2023-01-25T16:40:58.438395  kern  :emerg : 3e40: ee106834 a9162cfc bf05=
0024 bf050024 ed5a8580 00000000 c194a938 c0984500
    2023-01-25T16:40:58.449634  kern  :emerg : 3e60: bf04f494 c1009030 bf05=
0024 00000000 bf01b000 ffffe000 00000000 c0986704
    2023-01-25T16:40:58.455305  kern  :emerg : 3e80: ed652000 c19928a0 bf01=
b000 c0302e9c 00000000 00004c90 00000000 00000000 =

    ... (50 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d15bb41cb6934=
d30915ef1
        failing since 1 day (last pass: v5.4.228-674-g4e406b22c6e0, first f=
ail: v5.4.228-746-g2ac15b81a26b)
        41 lines

    2023-01-25T16:40:58.328320  kern  :alert : 8<--- cut here ---
    2023-01-25T16:40:58.333860  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address ee5ce000
    2023-01-25T16:40:58.334580  kern  :alert : pgd =3D (ptrval)
    2023-01-25T16:40:58.340696  kern  :alert : [ee5ce000] *pgd=3D6e41141e(b=
ad)
    2023-01-25T16:40:58.355502  kern  :emerg : Internal error: Oops: 800000=
0d [#1] SMP ARM
    2023-01-25T16:40:58.361157  kern  :emerg : Process udevd (pid: 106, sta=
ck limit =3D 0x(ptrval))
    2023-01-25T16:40:58.366672  kern  :emerg : Stack: (0xed653d88 to 0xed65=
4000)
    2023-01-25T16:40:58.377440  kern  :em<8>[   37.321174] <LAVA_SIGNAL_TES=
TCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D41>   =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d15bb41cb6934=
d30915ef2
        failing since 1 day (last pass: v5.4.228-674-g4e406b22c6e0, first f=
ail: v5.4.228-746-g2ac15b81a26b)
        8 lines

    2023-01-25T16:40:58.300719  kern  :alert : 8<--- cut here ---
    2023-01-25T16:40:58.306234  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address ee16c010
    2023-01-25T16:40:58.311696  kern  :alert : pgd =3D (ptrval)
    2023-01-25T16:40:58.322866  kern  :alert<8>[   37.265828] <LAVA_SIGNAL_=
TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D8>
    2023-01-25T16:40:58.323567   : [ee16c010] *pgd=3D6e01141e(bad)   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
cubietruck                   | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63d15864e153e8e65b915ebf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-cubietruck=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-cubietruck=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d15864e153e8e65b915=
ec0
        failing since 1 day (last pass: v5.4.228-674-g4e406b22c6e0, first f=
ail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
da850-lcdk                   | arm   | lab-baylibre    | gcc-10   | davinci=
_all_defconfig      | 1          =


  Details:     https://kernelci.org/test/plan/id/63d15a058cf1c99436915ec1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: davinci_all_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm/davinci_all_defconfig/gcc-10/lab-baylibre/baseline-da85=
0-lcdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm/davinci_all_defconfig/gcc-10/lab-baylibre/baseline-da85=
0-lcdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d15a058cf1c99436915=
ec2
        failing since 1 day (last pass: v5.4.228-674-g4e406b22c6e0, first f=
ail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
da850-lcdk                   | arm   | lab-baylibre    | gcc-10   | multi_v=
5_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d1587e49b129ceec915ebd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm/multi_v5_defconfig/gcc-10/lab-baylibre/baseline-da850-l=
cdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm/multi_v5_defconfig/gcc-10/lab-baylibre/baseline-da850-l=
cdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d1587e49b129ceec915=
ebe
        failing since 1 day (last pass: v5.4.228-674-g4e406b22c6e0, first f=
ail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
dove-cubox                   | arm   | lab-pengutronix | gcc-10   | mvebu_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d15890519839656d915eba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: mvebu_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm/mvebu_v7_defconfig/gcc-10/lab-pengutronix/baseline-dove=
-cubox.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm/mvebu_v7_defconfig/gcc-10/lab-pengutronix/baseline-dove=
-cubox.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d15890519839656d915=
ebb
        failing since 1 day (last pass: v5.4.228-674-g4e406b22c6e0, first f=
ail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
hifive-unleashed-a00         | riscv | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d15729a839ffd6ca915ee8

  Results:     3 PASS, 2 FAIL, 2 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleash=
ed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleash=
ed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/riscv/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/63d15729a839ffd6=
ca915ef1
        failing since 98 days (last pass: v5.4.219-270-gde284a6cd1e4, first=
 fail: v5.4.219-266-g5eb28a6c7901)
        3 lines

    2023-01-25T16:21:41.336359  / # =

    2023-01-25T16:21:41.337195  =

    2023-01-25T16:21:43.404914  / # #
    2023-01-25T16:21:43.405726  #
    2023-01-25T16:21:45.416702  / # export SHELL=3D/bin/sh
    2023-01-25T16:21:45.417128  export SHELL=3D/bin/sh
    2023-01-25T16:21:47.432472  / # . /lava-3210967/environment
    2023-01-25T16:21:47.433165  . /lava-3210967/environment
    2023-01-25T16:21:49.448079  / # /lava-3210967/bin/lava-test-runner /lav=
a-3210967/0
    2023-01-25T16:21:49.450307  /lava-3210967/bin/lava-test-runner /lava-32=
10967/0 =

    ... (9 line(s) more)  =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6dl-riotboard             | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig         | 2          =


  Details:     https://kernelci.org/test/plan/id/63d15a70b8999f4335915ed2

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6=
dl-riotboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6=
dl-riotboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d15a70b8999f4=
335915ed9
        failing since 1 day (last pass: v5.4.228-674-g4e406b22c6e0, first f=
ail: v5.4.228-746-g2ac15b81a26b)
        25 lines

    2023-01-25T16:35:54.197034  kern  :emerg : Internal error: Oops: 800000=
0d [#1] SMP ARM
    2023-01-25T16:35:54.215340  kern  :emerg : Process udevd (pid: 104, sta=
ck limit =3D 0x(ptrval))[    7.871113] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=
=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D25>
    2023-01-25T16:35:54.215581     =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d15a70b8999f4=
335915eda
        failing since 1 day (last pass: v5.4.228-674-g4e406b22c6e0, first f=
ail: v5.4.228-746-g2ac15b81a26b)
        4 lines

    2023-01-25T16:35:54.156617  kern  :alert : 8<--- cut here ---
    2023-01-25T16:35:54.165590  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address eea69420
    2023-01-25T16:35:54.173212  kern  :a[    7.830518] <LAVA_SIGNAL_TESTCAS=
E TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>
    2023-01-25T16:35:54.173494  lert : pgd =3D (ptrval)
    2023-01-25T16:35:54.173628  kern  :alert : [eea69420] *pgd=3D3ea0041e(b=
ad)   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6qp-wandboard-revd1       | arm   | lab-pengutronix | gcc-10   | imx_v6_=
v7_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/63d158f4b777780ab9915eb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
6qp-wandboard-revd1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
6qp-wandboard-revd1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d158f4b777780ab9915=
eba
        failing since 1 day (last pass: v5.4.228-674-g4e406b22c6e0, first f=
ail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6qp-wandboard-revd1       | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d15a72746805bcef915ecf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6=
qp-wandboard-revd1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6=
qp-wandboard-revd1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d15a72746805bcef915=
ed0
        failing since 1 day (last pass: v5.4.228-674-g4e406b22c6e0, first f=
ail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx7d-sdb                    | arm   | lab-nxp         | gcc-10   | imx_v6_=
v7_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/63d159400960d8976d915ec5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sdb.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sdb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d159400960d8976d915=
ec6
        failing since 1 day (last pass: v5.4.228-674-g4e406b22c6e0, first f=
ail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx7d-sdb                    | arm   | lab-nxp         | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d15aa9d3d18feaab915eb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sdb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d15aa9d3d18feaab915=
eba
        failing since 1 day (last pass: v5.4.228-674-g4e406b22c6e0, first f=
ail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx8mn-ddr4-evk              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d15abedb585ce88e915ef2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-ddr4-ev=
k.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-ddr4-ev=
k.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d15abedb585ce88e915=
ef3
        failing since 0 day (last pass: v5.4.228-674-g4e406b22c6e0, first f=
ail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx8mn-ddr4-evk              | arm64 | lab-nxp         | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d15aeeb339481d72915ec4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mn-ddr4-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mn-ddr4-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d15aeeb339481d72915=
ec5
        failing since 0 day (last pass: v5.4.228-674-g4e406b22c6e0, first f=
ail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
jetson-tk1                   | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d15a8df6f7ae5c36915ed9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson-=
tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson-=
tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d15a8df6f7ae5c36915=
eda
        failing since 1 day (last pass: v5.4.228-674-g4e406b22c6e0, first f=
ail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
jetson-tk1                   | arm   | lab-baylibre    | gcc-10   | tegra_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63d1583ee9be9a7c09915eca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d1583ee9be9a7c09915=
ecb
        failing since 1 day (last pass: v5.4.228-674-g4e406b22c6e0, first f=
ail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-g12a-sei510            | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d15a5eb8999f4335915ebe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-sei=
510.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-sei=
510.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d15a5eb8999f4335915=
ebf
        failing since 1 day (last pass: v5.4.228-674-g4e406b22c6e0, first f=
ail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-g12a-u200              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d15ab67949b3f32c915ec5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-u20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-u20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d15ab67949b3f32c915=
ec6
        failing since 1 day (last pass: v5.4.228-674-g4e406b22c6e0, first f=
ail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-g12a-x96-max           | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d15ab0ad388bd648915ece

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-x96=
-max.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-x96=
-max.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d15ab0ad388bd648915=
ecf
        failing since 1 day (last pass: v5.4.228-674-g4e406b22c6e0, first f=
ail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d15a8001e04a5b21915f04

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-a31=
1d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-a31=
1d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d15a8001e04a5b21915=
f05
        failing since 1 day (last pass: v5.4.228-674-g4e406b22c6e0, first f=
ail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-collabora   | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d15b84156a01abe8915ed2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig/gcc-10/lab-collabora/baseline-meson-g12b-a3=
11d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig/gcc-10/lab-collabora/baseline-meson-g12b-a3=
11d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d15b84156a01abe8915=
ed3
        failing since 1 day (last pass: v5.4.228-674-g4e406b22c6e0, first f=
ail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-g12b-odroid-n2         | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d15a71746805bcef915ecc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-odr=
oid-n2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-odr=
oid-n2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d15a71746805bcef915=
ecd
        failing since 1 day (last pass: v5.4.228-674-g4e406b22c6e0, first f=
ail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-gxbb-p200              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d15bb0a889c2dcab915eb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d15bb0a889c2dcab915=
eba
        failing since 1 day (last pass: v5.4.228-674-g4e406b22c6e0, first f=
ail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-gxl-s905d-p230         | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d15a8801e04a5b21915f10

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s905=
d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s905=
d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d15a8801e04a5b21915=
f11
        failing since 1 day (last pass: v5.4.228-674-g4e406b22c6e0, first f=
ail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d15a8401e04a5b21915f07

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s905=
x-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s905=
x-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d15a8401e04a5b21915=
f08
        failing since 1 day (last pass: v5.4.228-674-g4e406b22c6e0, first f=
ail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-broonie     | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d15b54c23d58df75915ebe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s905x=
-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s905x=
-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d15b54c23d58df75915=
ebf
        failing since 1 day (last pass: v5.4.228-674-g4e406b22c6e0, first f=
ail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-clabbe      | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d15a9aa427576450915eb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig/gcc-10/lab-clabbe/baseline-meson-gxl-s905x-=
libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig/gcc-10/lab-clabbe/baseline-meson-gxl-s905x-=
libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d15a9aa427576450915=
eba
        failing since 1 day (last pass: v5.4.228-674-g4e406b22c6e0, first f=
ail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-gxm-khadas-vim2        | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d15a7401e04a5b21915ebd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm-khad=
as-vim2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm-khad=
as-vim2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d15a7401e04a5b21915=
ebe
        failing since 1 day (last pass: v5.4.228-674-g4e406b22c6e0, first f=
ail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-gxm-q200               | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d15b60aa746528e8915ec3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm-q200=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm-q200=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d15b60aa746528e8915=
ec4
        failing since 0 day (last pass: v5.4.228-674-g4e406b22c6e0, first f=
ail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-sm1-khadas-vim3l       | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d15ac4a55c7aa6c3915ec8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-sm1-khad=
as-vim3l.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-sm1-khad=
as-vim3l.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d15ac4a55c7aa6c3915=
ec9
        failing since 1 day (last pass: v5.4.228-674-g4e406b22c6e0, first f=
ail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-sm1-sei610             | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d15a5d94f352cff6915ee3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-sm1-sei6=
10.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-sm1-sei6=
10.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d15a5d94f352cff6915=
ee4
        failing since 1 day (last pass: v5.4.228-674-g4e406b22c6e0, first f=
ail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
odroid-xu3                   | arm   | lab-collabora   | gcc-10   | exynos_=
defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63d157f96541564240915ebb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: exynos_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-odroid-x=
u3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-odroid-x=
u3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d157f96541564240915=
ebc
        failing since 1 day (last pass: v5.4.228-674-g4e406b22c6e0, first f=
ail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
odroid-xu3                   | arm   | lab-collabora   | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d15ab6d3d18feaab915ece

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-odroid=
-xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-odroid=
-xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d15ab6d3d18feaab915=
ecf
        failing since 1 day (last pass: v5.4.228-674-g4e406b22c6e0, first f=
ail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
qemu_arm64-virt-gicv2        | arm64 | lab-baylibre    | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63d159d6727d89bb0c915ec3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseli=
ne-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseli=
ne-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d159d6727d89bb0c915=
ec4
        failing since 183 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
qemu_arm64-virt-gicv2        | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d15b9e8d336072bf915eb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d15b9e8d336072bf915=
eba
        failing since 260 days (last pass: v5.4.191-77-g1a3b249e415b, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
qemu_arm64-virt-gicv2        | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63d1599f954dfed955915ef4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d1599f954dfed955915=
ef5
        failing since 183 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-baylibre    | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63d159d29b66b5640d915edc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseli=
ne-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseli=
ne-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d159d29b66b5640d915=
edd
        failing since 183 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d15bef41c04e2d02915eba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d15bef41c04e2d02915=
ebb
        failing since 183 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63d1599c69bc8d4710915ee6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d1599c69bc8d4710915=
ee7
        failing since 183 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-collabora   | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d15b7d156a01abe8915ec7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vi=
rt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vi=
rt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d15b7d156a01abe8915=
ec8
        failing since 183 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-baylibre    | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63d159d5727d89bb0c915ec0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseli=
ne-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseli=
ne-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d159d5727d89bb0c915=
ec1
        failing since 183 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d15ba066b6266f1e915eed

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d15ba066b6266f1e915=
eee
        failing since 260 days (last pass: v5.4.191-77-g1a3b249e415b, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63d1599e954dfed955915ef1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d1599e954dfed955915=
ef2
        failing since 183 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-baylibre    | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63d159d4727d89bb0c915ebd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseli=
ne-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseli=
ne-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d159d4727d89bb0c915=
ebe
        failing since 183 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d15bcabd1c9c3d03915ec9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d15bcabd1c9c3d03915=
eca
        failing since 183 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63d1599d954dfed955915eee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d1599d954dfed955915=
eef
        failing since 183 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-collabora   | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d15b68aa746528e8915ec9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vi=
rt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vi=
rt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d15b68aa746528e8915=
eca
        failing since 183 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
rk3399-gru-kevin             | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63d159c19b66b5640d915eb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d159c19b66b5640d915=
eba
        failing since 1 day (last pass: v5.4.228-674-g4e406b22c6e0, first f=
ail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-a64-bananapi-m64      | arm64 | lab-clabbe      | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d15a8601e04a5b21915f0d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d15a8601e04a5b21915=
f0e
        failing since 1 day (last pass: v5.4.228-674-g4e406b22c6e0, first f=
ail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-a64-pine64-plus       | arm64 | lab-broonie     | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d15b99364ded538d915ee6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pine=
64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pine=
64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d15b99364ded538d915=
ee7
        failing since 1 day (last pass: v5.4.228-674-g4e406b22c6e0, first f=
ail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-h6-orangepi-3         | arm64 | lab-clabbe      | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d15b8f364ded538d915ed8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-orange=
pi-3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-orange=
pi-3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d15b8f364ded538d915=
ed9
        failing since 1 day (last pass: v5.4.228-622-ge3f2d3701743, first f=
ail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-h6-orangepi-one-plus  | arm64 | lab-clabbe      | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d15af3b3a09d0ddc915ed5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-orange=
pi-one-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-orange=
pi-one-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d15af3b3a09d0ddc915=
ed6
        failing since 1 day (last pass: v5.4.228-674-g4e406b22c6e0, first f=
ail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-h6-pine-h64           | arm64 | lab-clabbe      | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d15a77900c564066915eda

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-pine-h=
64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-pine-h=
64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d15a77900c564066915=
edb
        failing since 1 day (last pass: v5.4.228-674-g4e406b22c6e0, first f=
ail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-h6-pine-h64           | arm64 | lab-collabora   | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d15a8df6f7ae5c36915edc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig/gcc-10/lab-collabora/baseline-sun50i-h6-pin=
e-h64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm64/defconfig/gcc-10/lab-collabora/baseline-sun50i-h6-pin=
e-h64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d15a8df6f7ae5c36915=
edd
        failing since 1 day (last pass: v5.4.228-674-g4e406b22c6e0, first f=
ail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun5i-a13-olinuxino-micro    | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63d15803592bcc506d915eec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun5i-a13-=
olinuxino-micro.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun5i-a13-=
olinuxino-micro.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d15803592bcc506d915=
eed
        failing since 1 day (last pass: v5.4.228-674-g4e406b22c6e0, first f=
ail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun7i-a20-cubieboard2        | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63d157d6f26cede474915ecd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7i-a20-=
cubieboard2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7i-a20-=
cubieboard2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d157d6f26cede474915=
ece
        failing since 1 day (last pass: v5.4.228-674-g4e406b22c6e0, first f=
ail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun7i-a20-cubieboard2        | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63d157def26cede474915ed5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun7i-a20-cu=
bieboard2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun7i-a20-cu=
bieboard2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d157def26cede474915=
ed6
        failing since 1 day (last pass: v5.4.228-674-g4e406b22c6e0, first f=
ail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun7i-a20-olinuxino-lime2    | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63d15b4bd002b784c3915f18

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7i-a20-=
olinuxino-lime2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7i-a20-=
olinuxino-lime2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d15b4bd002b784c3915=
f19
        failing since 0 day (last pass: v5.4.228-674-g4e406b22c6e0, first f=
ail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-a33-olinuxino          | arm   | lab-clabbe      | gcc-10   | multi_v=
7_defconfig         | 2          =


  Details:     https://kernelci.org/test/plan/id/63d15c66d108397221915eca

  Results:     3 PASS, 3 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a33=
-olinuxino.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a33=
-olinuxino.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d15c66d108397=
221915ed2
        failing since 1 day (last pass: v5.4.228-674-g4e406b22c6e0, first f=
ail: v5.4.228-746-g2ac15b81a26b)
        4 lines

    2023-01-25T16:44:02.025846  kern  :alert : 8<--- cut here ---
    2023-01-25T16:44:02.026289  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address ee9ba810
    2023-01-25T16:44:02.026885  kern  :alert : pgd =3D (ptrval)
    2023-01-25T16:44:02.027241  kern  :alert : [ee9ba810] *pgd=3D6e81141e(b=
ad)
    2023-01-25T16:44:02.027595  <8>[   18.146512] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d15c66d108397=
221915ed3
        failing since 1 day (last pass: v5.4.228-674-g4e406b22c6e0, first f=
ail: v5.4.228-746-g2ac15b81a26b)
        24 lines

    2023-01-25T16:44:02.087934  kern  :emerg : Internal error: Oops: 800000=
0d [#1] SMP ARM
    2023-01-25T16:44:02.088623  kern  :emerg : Process udevd (pid: 106, sta=
ck limit =3D 0x(ptrval))
    2023-01-25T16:44:02.088961  kern  :emerg : Stack: (0xedcadd88 to 0xedca=
e000)
    2023-01-25T16:44:02.089279  kern  :emerg : dd80:                   eea8=
9c00 c098917c 00000000 eea770c0 eea89c80 972be81c
    2023-01-25T16:44:02.089603  kern  :emerg : dda0: ee832a80 ee9ba810 0000=
0000 c<8>[   18.208698] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=
=3Dfail UNITS=3Dlines MEASUREMENT=3D24>
    2023-01-25T16:44:02.089968  19e4ec8 fffffdfb c19e4ec4 bf0f8024 0000000e=
   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-a33-olinuxino          | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63d157f2592bcc506d915ec3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a33-ol=
inuxino.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a33-ol=
inuxino.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d157f2592bcc506d915=
ec4
        failing since 1 day (last pass: v5.4.228-674-g4e406b22c6e0, first f=
ail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-a83t-bananapi-m3       | arm   | lab-clabbe      | gcc-10   | multi_v=
7_defconfig         | 2          =


  Details:     https://kernelci.org/test/plan/id/63d15aa7ad388bd648915eb9

  Results:     3 PASS, 3 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a83=
t-bananapi-m3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a83=
t-bananapi-m3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d15aa7ad388bd=
648915ec1
        failing since 1 day (last pass: v5.4.228-674-g4e406b22c6e0, first f=
ail: v5.4.228-746-g2ac15b81a26b)
        8 lines

    2023-01-25T16:36:46.717647  kern  :alert : 8<--- cut here ---
    2023-01-25T16:36:46.718003  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address ee2b1c10
    2023-01-25T16:36:46.718234  kern  :alert : pgd =3D (ptrval)
    2023-01-25T16:36:46.718433  kern  :alert : [ee2b1c10] *pgd=3D6e21141e(b=
ad)
    2023-01-25T16:36:46.718628  kern  :alert : 8<--- cut here --[   44.7121=
41] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines =
MEASUREMENT=3D8>
    2023-01-25T16:36:46.718822  -
    2023-01-25T16:36:46.719019  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address ed37b000
    2023-01-25T16:36:46.719225  kern  :alert : pgd =3D (ptrval)   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d15aa7ad388bd=
648915ec2
        failing since 1 day (last pass: v5.4.228-674-g4e406b22c6e0, first f=
ail: v5.4.228-746-g2ac15b81a26b)
        41 lines

    2023-01-25T16:36:46.725051  kern  :alert : [ed37b000] *pgd=3D6d21141e(b=
ad)
    2023-01-25T16:36:46.762351  kern  :emerg : Internal error: Oops: 800000=
0d [#1] SMP ARM
    2023-01-25T16:36:46.762699  kern  :emerg : Process udevd (pid: 156, sta=
ck limit =3D 0x(ptrval))
    2023-01-25T16:36:46.762909  kern  :emerg : Stack: (0xeb861d88 to 0xeb86=
2000)
    2023-01-25T16:36:46.763119  kern  :emer[   44.770453] <LAVA_SIGNAL_TEST=
CASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D41>
    2023-01-25T16:36:46.764243  g : 1d80:                   ecac6080 c09891=
7c 00000000 ed3a1b40 [   44.782828] <LAVA_SIGNAL_ENDRUN 0_dmesg 385986_1.5.=
2.4.1>
    2023-01-25T16:36:46.764472  ecac6100 ea40333d   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-a83t-bananapi-m3       | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63d157c3cc94df9021915ebc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a83t-b=
ananapi-m3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a83t-b=
ananapi-m3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d157c3cc94df9021915=
ebd
        failing since 1 day (last pass: v5.4.228-674-g4e406b22c6e0, first f=
ail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-h2-plus...ch-all-h3-cc | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 2          =


  Details:     https://kernelci.org/test/plan/id/63d15a9fa427576450915ecc

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h=
2-plus-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h=
2-plus-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d15a9fa427576=
450915ed3
        failing since 1 day (last pass: v5.4.228-674-g4e406b22c6e0, first f=
ail: v5.4.228-746-g2ac15b81a26b)
        24 lines

    2023-01-25T16:36:32.984086  kern  :emerg : Internal error: Oops: 800000=
0d [#1] SMP ARM
    2023-01-25T16:36:32.984564  kern  :emerg : Process udevd (pid: 114, sta=
ck limit =3D 0x(ptrval))
    2023-01-25T16:36:32.984794  kern  :emerg : Stack: (0xc413dd88 to 0xc413=
e000)
    2023-01-25T16:36:32.985007  kern  :emerg : <8>[    7.034699] <LAVA_SIGN=
AL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D=
24>
    2023-01-25T16:36:32.985214  dd80:                   c4372300 c098917c 0=
0000000 c3bc8300 c3bc<8>[    7.049941] <LAVA_SIGNAL_ENDRUN 0_dmesg 3211094_=
1.5.2.4.1>
    2023-01-25T16:36:32.985456  9b00 d1ec76f2   =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d15a9fa427576=
450915ed4
        failing since 1 day (last pass: v5.4.228-674-g4e406b22c6e0, first f=
ail: v5.4.228-746-g2ac15b81a26b)
        4 lines

    2023-01-25T16:36:32.930339  kern  :alert : 8<--- cut here ---
    2023-01-25T16:36:32.930815  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address db19b010
    2023-01-25T16:36:32.931048  kern  :alert : pgd =3D (ptrval)
    2023-01-25T16:36:32.933948  kern  :alert : [db19b010] *pgd=3D5b01141e(b=
ad<8>[    6.986989] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfai=
l UNITS=3Dlines MEASUREMENT=3D4>
    2023-01-25T16:36:32.934208  )   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-h2-plus...ch-all-h3-cc | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63d157e8f26cede474915edd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h2-p=
lus-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h2-p=
lus-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d157e8f26cede474915=
ede
        failing since 1 day (last pass: v5.4.228-674-g4e406b22c6e0, first f=
ail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-h3-libretech-all-h3-cc | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 2          =


  Details:     https://kernelci.org/test/plan/id/63d15aa284d0338947915ee6

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h=
3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h=
3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d15aa284d0338=
947915eed
        failing since 1 day (last pass: v5.4.228-674-g4e406b22c6e0, first f=
ail: v5.4.228-746-g2ac15b81a26b)
        24 lines

    2023-01-25T16:36:24.506035  kern  :emerg : Internal error: Oops: 800000=
0d [#1] SMP ARM
    2023-01-25T16:36:24.506506  kern  :emerg : Process udevd (pid: 119, sta=
ck limit =3D 0x(ptrval))
    2023-01-25T16:36:24.506740  kern  :emerg : Stack: (0xc400dd88 to 0xc400=
e000)
    2023-01-25T16:36:24.506995  kern  :emerg : <8>[    6.916791] <LAVA_SIGN=
AL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D=
24>
    2023-01-25T16:36:24.507239  dd80:                   ede8e180 c098917c 0=
0000000 eeabb6c0 eeab<8>[    6.931957] <LAVA_SIGNAL_ENDRUN 0_dmesg 3211096_=
1.5.2.4.1>
    2023-01-25T16:36:24.507454  9b00 690088a2   =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d15aa284d0338=
947915eee
        failing since 1 day (last pass: v5.4.228-674-g4e406b22c6e0, first f=
ail: v5.4.228-746-g2ac15b81a26b)
        4 lines

    2023-01-25T16:36:24.439805  kern  :alert : 8<--- cut here ---
    2023-01-25T16:36:24.440278  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address eea23010
    2023-01-25T16:36:24.440513  kern  :alert : pgd =3D (ptrval)
    2023-01-25T16:36:24.443361  kern  :alert : [eea23010] *pgd=3D6ea1141e(b=
ad<8>[    6.856787] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfai=
l UNITS=3Dlines MEASUREMENT=3D4>
    2023-01-25T16:36:24.443619  )   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-h3-libretech-all-h3-cc | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63d157cdf26cede474915ebb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h3-l=
ibretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h3-l=
ibretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d157cdf26cede474915=
ebc
        failing since 1 day (last pass: v5.4.228-674-g4e406b22c6e0, first f=
ail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-h3-orangepi-pc         | arm   | lab-clabbe      | gcc-10   | multi_v=
7_defconfig         | 2          =


  Details:     https://kernelci.org/test/plan/id/63d15c7bb34c48e452915ec6

  Results:     3 PASS, 3 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-=
orangepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-=
orangepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d15c7bb34c48e=
452915ece
        failing since 1 day (last pass: v5.4.228-674-g4e406b22c6e0, first f=
ail: v5.4.228-746-g2ac15b81a26b)
        4 lines

    2023-01-25T16:44:11.120657  kern  :alert : 8<--- cut here ---
    2023-01-25T16:44:11.126123  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address ee9e2c10
    2023-01-25T16:44:11.135394  kern  :ale<8>[   14.547898] <LAVA_SIGNAL_TE=
STCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d15c7bb34c48e=
452915ecf
        failing since 1 day (last pass: v5.4.228-674-g4e406b22c6e0, first f=
ail: v5.4.228-746-g2ac15b81a26b)
        24 lines

    2023-01-25T16:44:11.141570  rt : pgd =3D (ptrval)
    2023-01-25T16:44:11.141919  kern  :alert : [ee9e2c10] *pgd=3D6e81141e(b=
ad)
    2023-01-25T16:44:11.158807  kern  :emerg : Internal error: Oops: 800000=
0d [#1] SMP ARM
    2023-01-25T16:44:11.169649  kern  :emerg : Process udevd (pid: 118, sta=
ck limit =3D 0x(ptrval))
    2023-01-25T16:44:11.173517  k<8>[   14.586272] <LAVA_SIGNAL_TESTCASE TE=
ST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D24>   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-h3-orangepi-pc         | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63d1582e8a5f3dea25915ee1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-ora=
ngepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-ora=
ngepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d1582e8a5f3dea25915=
ee2
        failing since 1 day (last pass: v5.4.228-674-g4e406b22c6e0, first f=
ail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-r40-bananapi-m2-ultra  | arm   | lab-clabbe      | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d15d1b0912eefa3e915ee0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-r40=
-bananapi-m2-ultra.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-r40=
-bananapi-m2-ultra.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d15d1b0912eefa3e915=
ee1
        failing since 1 day (last pass: v5.4.228-674-g4e406b22c6e0, first f=
ail: v5.4.228-746-g2ac15b81a26b) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-r40-bananapi-m2-ultra  | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63d158420e05d5ad20915ed5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-r40-ba=
nanapi-m2-ultra.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.230-7=
2-g283de2edfdbd/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-r40-ba=
nanapi-m2-ultra.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d158420e05d5ad20915=
ed6
        failing since 1 day (last pass: v5.4.228-674-g4e406b22c6e0, first f=
ail: v5.4.228-746-g2ac15b81a26b) =

 =20
