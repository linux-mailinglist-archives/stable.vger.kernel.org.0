Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 804E64217E4
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 21:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234316AbhJDTuy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 15:50:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233919AbhJDTut (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Oct 2021 15:50:49 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52858C061745
        for <stable@vger.kernel.org>; Mon,  4 Oct 2021 12:48:59 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id d13-20020a17090ad3cd00b0019e746f7bd4so278315pjw.0
        for <stable@vger.kernel.org>; Mon, 04 Oct 2021 12:48:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=oPVznGDZoXzmbnvuBXDaI8Ae7lflDq/7qd353r2P774=;
        b=St5Q7JcvD9ppF1DMoxr9Pr1xiRHzAYxj+gOrX4dQYQC7MZrUl778BSWSIZZT5blDP6
         u1k0QRSLnYDGlB48xJ07nRUO4nRbUasVIjurU4b/TuUFz4eafPO64Cg9EwDPRWh/lSM+
         vU0XkbNd4R/XIHHzHb+gZ+gkSPW5wIKfPEtso+7Cw0v5JpeNdY703qOhlDzXycMP6Mot
         l4WmO//jFGCECbMHdCjKEhx3WfI4JhAnPGtQva6eiExyqCWOCRUvlL3+qpHoGONh53Ks
         NOy2l7cNfxoxsvrP/f/6cWr5gY9eMlfGGWBMP4M15qpzlO/rR3A0vEcERp+50S0QTf/n
         yTaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=oPVznGDZoXzmbnvuBXDaI8Ae7lflDq/7qd353r2P774=;
        b=7tvxcjEBv3bWdx/ThV1R9utWKdrkxTOASzSOiPrUrZYhAmoqg4DaXYvuJB2OzYTZKm
         1hnIJRIfTWMeKODzw7IxHLpJi0Fv9gDGgRuyAZwYVWXuwX6/6Tqe0+4x6b6XomYFcazi
         r9/Yxy23T2TnE2MD5D6McqjyRUlfehBTxnb33DNXO9/ChcQErygtw7mF+oyuRNuq9+0q
         usN5JNKACiDg3IzXZ+sSAe+U4qcLMnn7QYxuiTJTw2qPFyzhFh9/rzz1gz2tbEvEIeOY
         7uJ1pp8dnFrILFZAY5dEdPUwPkIp2G3yqvUzY9w72Yzq7AGVvHVgggKKUO4RCSDQ2GWO
         osQA==
X-Gm-Message-State: AOAM533lq7Jw3YhO58NOF9YYBAVUzqAxvwIOzbqxeXuFWNKPoLwz0Yy4
        xkPhZjs1dekaZyBcOdz5cPFPUF4UBtXKE86H
X-Google-Smtp-Source: ABdhPJwQfObRCbpPcuJEC2OA7+cxT6ED7YNDn5iELhsrn19HmJ+FIn1zMQNiCTCYgoRy/C0087QRNg==
X-Received: by 2002:a17:902:bf0a:b0:13d:f4b8:111 with SMTP id bi10-20020a170902bf0a00b0013df4b80111mr1347106plb.35.1633376937381;
        Mon, 04 Oct 2021 12:48:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b10sm14876382pfi.122.2021.10.04.12.48.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 12:48:56 -0700 (PDT)
Message-ID: <615b5aa8.1c69fb81.7e3ff.cb3f@mx.google.com>
Date:   Mon, 04 Oct 2021 12:48:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.208-95-g4a53d0ed459e
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 123 runs,
 116 regressions (v4.19.208-95-g4a53d0ed459e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 123 runs, 116 regressions (v4.19.208-95-g4a5=
3d0ed459e)

Regressions Summary
-------------------

platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C433TA-AJ0005-rammus    | x86_64 | lab-collabora   | gcc-8    | x86_64=
_defcon...6-chromebook | 1          =

asus-C523NA-A20057-coral     | x86_64 | lab-collabora   | gcc-8    | x86_64=
_defcon...6-chromebook | 1          =

bcm2836-rpi-2-b              | arm    | lab-collabora   | gcc-8    | bcm283=
5_defconfig            | 1          =

bcm2836-rpi-2-b              | arm    | lab-collabora   | gcc-8    | multi_=
v7_defconfig           | 1          =

beagle-xm                    | arm    | lab-baylibre    | gcc-8    | multi_=
v7_defconfig           | 1          =

beagle-xm                    | arm    | lab-baylibre    | gcc-8    | omap2p=
lus_defconfig          | 1          =

beaglebone-black             | arm    | lab-cip         | gcc-8    | multi_=
v7_defconfig           | 1          =

beaglebone-black             | arm    | lab-cip         | gcc-8    | omap2p=
lus_defconfig          | 1          =

d2500cc                      | x86_64 | lab-clabbe      | gcc-8    | x86_64=
_defconfig             | 1          =

d2500cc                      | x86_64 | lab-clabbe      | gcc-8    | x86_64=
_defcon...6-chromebook | 1          =

da850-lcdk                   | arm    | lab-baylibre    | gcc-8    | davinc=
i_all_defconfig        | 1          =

hip07-d05                    | arm64  | lab-collabora   | gcc-8    | defcon=
fig                    | 1          =

hp-11A-G6-EE-grunt           | x86_64 | lab-collabora   | gcc-8    | x86_64=
_defcon...6-chromebook | 1          =

hp-x360-12b-n4000-octopus    | x86_64 | lab-collabora   | gcc-8    | x86_64=
_defcon...6-chromebook | 1          =

i945gsex-qs                  | i386   | lab-clabbe      | gcc-8    | i386_d=
efconfig               | 1          =

imx6q-sabrelite              | arm    | lab-collabora   | gcc-8    | multi_=
v7_defconfig           | 1          =

imx6q-var-dt6customboard     | arm    | lab-baylibre    | gcc-8    | imx_v6=
_v7_defconfig          | 1          =

imx6q-var-dt6customboard     | arm    | lab-baylibre    | gcc-8    | multi_=
v7_defconfig           | 1          =

imx6sx-sdb                   | arm    | lab-nxp         | gcc-8    | multi_=
v7_defconfig           | 1          =

jetson-tk1                   | arm    | lab-baylibre    | gcc-8    | multi_=
v7_defconfig           | 1          =

jetson-tk1                   | arm    | lab-baylibre    | gcc-8    | tegra_=
defconfig              | 1          =

meson-gxl-s905x-libretech-cc | arm64  | lab-clabbe      | gcc-8    | defcon=
fig                    | 1          =

meson-gxm-khadas-vim2        | arm64  | lab-baylibre    | gcc-8    | defcon=
fig                    | 1          =

odroid-xu3                   | arm    | lab-collabora   | gcc-8    | multi_=
v7_defconfig           | 1          =

ox820-clouden...lug-series-3 | arm    | lab-baylibre    | gcc-8    | oxnas_=
v6_defconfig           | 1          =

panda                        | arm    | lab-collabora   | gcc-8    | multi_=
v7_defconfig           | 1          =

panda                        | arm    | lab-collabora   | gcc-8    | omap2p=
lus_defconfig          | 1          =

qcom-qdf2400                 | arm64  | lab-linaro-lkft | gcc-8    | defcon=
fig                    | 1          =

qemu_arm-versatilepb         | arm    | lab-baylibre    | gcc-8    | versat=
ile_defconfig          | 1          =

qemu_arm-versatilepb         | arm    | lab-broonie     | gcc-8    | versat=
ile_defconfig          | 1          =

qemu_arm-versatilepb         | arm    | lab-cip         | gcc-8    | versat=
ile_defconfig          | 1          =

qemu_arm-vexpress-a15        | arm    | lab-baylibre    | gcc-8    | vexpre=
ss_defconfig           | 1          =

qemu_arm-vexpress-a15        | arm    | lab-broonie     | gcc-8    | vexpre=
ss_defconfig           | 1          =

qemu_arm-vexpress-a15        | arm    | lab-cip         | gcc-8    | vexpre=
ss_defconfig           | 1          =

qemu_arm-vexpress-a9         | arm    | lab-baylibre    | gcc-8    | vexpre=
ss_defconfig           | 1          =

qemu_arm-vexpress-a9         | arm    | lab-broonie     | gcc-8    | vexpre=
ss_defconfig           | 1          =

qemu_arm-vexpress-a9         | arm    | lab-cip         | gcc-8    | vexpre=
ss_defconfig           | 1          =

qemu_arm-virt-gicv2          | arm    | lab-baylibre    | gcc-8    | multi_=
v7_defconfig           | 1          =

qemu_arm-virt-gicv2          | arm    | lab-broonie     | gcc-8    | multi_=
v7_defconfig           | 1          =

qemu_arm-virt-gicv2          | arm    | lab-cip         | gcc-8    | multi_=
v7_defconfig           | 1          =

qemu_arm-virt-gicv2-uefi     | arm    | lab-baylibre    | gcc-8    | multi_=
v7_defconfig           | 1          =

qemu_arm-virt-gicv2-uefi     | arm    | lab-broonie     | gcc-8    | multi_=
v7_defconfig           | 1          =

qemu_arm-virt-gicv2-uefi     | arm    | lab-cip         | gcc-8    | multi_=
v7_defconfig           | 1          =

qemu_arm-virt-gicv3          | arm    | lab-baylibre    | gcc-8    | multi_=
v7_defconfig           | 1          =

qemu_arm-virt-gicv3          | arm    | lab-broonie     | gcc-8    | multi_=
v7_defconfig           | 1          =

qemu_arm-virt-gicv3          | arm    | lab-cip         | gcc-8    | multi_=
v7_defconfig           | 1          =

qemu_arm-virt-gicv3-uefi     | arm    | lab-baylibre    | gcc-8    | multi_=
v7_defconfig           | 1          =

qemu_arm-virt-gicv3-uefi     | arm    | lab-broonie     | gcc-8    | multi_=
v7_defconfig           | 1          =

qemu_arm-virt-gicv3-uefi     | arm    | lab-cip         | gcc-8    | multi_=
v7_defconfig           | 1          =

qemu_arm64-virt-gicv2        | arm64  | lab-baylibre    | gcc-8    | defcon=
fig                    | 1          =

qemu_arm64-virt-gicv2        | arm64  | lab-broonie     | gcc-8    | defcon=
fig                    | 1          =

qemu_arm64-virt-gicv2        | arm64  | lab-cip         | gcc-8    | defcon=
fig                    | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64  | lab-baylibre    | gcc-8    | defcon=
fig                    | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64  | lab-broonie     | gcc-8    | defcon=
fig                    | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64  | lab-cip         | gcc-8    | defcon=
fig                    | 1          =

qemu_arm64-virt-gicv3        | arm64  | lab-baylibre    | gcc-8    | defcon=
fig                    | 1          =

qemu_arm64-virt-gicv3        | arm64  | lab-broonie     | gcc-8    | defcon=
fig                    | 1          =

qemu_arm64-virt-gicv3        | arm64  | lab-cip         | gcc-8    | defcon=
fig                    | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64  | lab-baylibre    | gcc-8    | defcon=
fig                    | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64  | lab-broonie     | gcc-8    | defcon=
fig                    | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64  | lab-cip         | gcc-8    | defcon=
fig                    | 1          =

qemu_i386                    | i386   | lab-baylibre    | gcc-8    | i386_d=
efconfig               | 1          =

qemu_i386                    | i386   | lab-broonie     | gcc-8    | i386_d=
efconfig               | 1          =

qemu_i386                    | i386   | lab-cip         | gcc-8    | i386_d=
efconfig               | 1          =

qemu_i386-uefi               | i386   | lab-baylibre    | gcc-8    | i386_d=
efconfig               | 1          =

qemu_i386-uefi               | i386   | lab-broonie     | gcc-8    | i386_d=
efconfig               | 1          =

qemu_i386-uefi               | i386   | lab-cip         | gcc-8    | i386_d=
efconfig               | 1          =

qemu_x86_64                  | x86_64 | lab-baylibre    | gcc-8    | x86_64=
_defconfig             | 1          =

qemu_x86_64                  | x86_64 | lab-baylibre    | gcc-8    | x86_64=
_defcon...6-chromebook | 1          =

qemu_x86_64                  | x86_64 | lab-broonie     | gcc-8    | x86_64=
_defconfig             | 1          =

qemu_x86_64                  | x86_64 | lab-broonie     | gcc-8    | x86_64=
_defcon...6-chromebook | 1          =

qemu_x86_64                  | x86_64 | lab-cip         | gcc-8    | x86_64=
_defconfig             | 1          =

qemu_x86_64                  | x86_64 | lab-cip         | gcc-8    | x86_64=
_defcon...6-chromebook | 1          =

qemu_x86_64-uefi             | x86_64 | lab-baylibre    | gcc-8    | x86_64=
_defconfig             | 1          =

qemu_x86_64-uefi             | x86_64 | lab-baylibre    | gcc-8    | x86_64=
_defcon...6-chromebook | 1          =

qemu_x86_64-uefi             | x86_64 | lab-broonie     | gcc-8    | x86_64=
_defconfig             | 1          =

qemu_x86_64-uefi             | x86_64 | lab-broonie     | gcc-8    | x86_64=
_defcon...6-chromebook | 1          =

qemu_x86_64-uefi             | x86_64 | lab-cip         | gcc-8    | x86_64=
_defconfig             | 1          =

qemu_x86_64-uefi             | x86_64 | lab-cip         | gcc-8    | x86_64=
_defcon...6-chromebook | 1          =

rk3288-rock2-square          | arm    | lab-collabora   | gcc-8    | multi_=
v7_defconfig           | 1          =

rk3288-veyron-jaq            | arm    | lab-collabora   | gcc-8    | multi_=
v7_defconfig           | 1          =

rk3328-rock64                | arm64  | lab-baylibre    | gcc-8    | defcon=
fig                    | 1          =

rk3399-gru-kevin             | arm64  | lab-collabora   | gcc-8    | defcon=
fig                    | 1          =

sun50i-a64-bananapi-m64      | arm64  | lab-clabbe      | gcc-8    | defcon=
fig                    | 1          =

sun50i-a64-pine64-plus       | arm64  | lab-baylibre    | gcc-8    | defcon=
fig                    | 1          =

sun50i-h5-lib...ch-all-h3-cc | arm64  | lab-baylibre    | gcc-8    | defcon=
fig                    | 1          =

sun50i-h5-nanopi-neo-plus2   | arm64  | lab-clabbe      | gcc-8    | defcon=
fig                    | 1          =

sun50i-h6-pine-h64           | arm64  | lab-clabbe      | gcc-8    | defcon=
fig                    | 1          =

sun50i-h6-pine-h64           | arm64  | lab-collabora   | gcc-8    | defcon=
fig                    | 1          =

sun5i-a13-olinuxino-micro    | arm    | lab-baylibre    | gcc-8    | multi_=
v7_defconfig           | 1          =

sun5i-a13-olinuxino-micro    | arm    | lab-baylibre    | gcc-8    | sunxi_=
defconfig              | 1          =

sun7i-a20-cubieboard2        | arm    | lab-clabbe      | gcc-8    | multi_=
v7_defconfig           | 1          =

sun7i-a20-cubieboard2        | arm    | lab-clabbe      | gcc-8    | sunxi_=
defconfig              | 1          =

sun7i-a20-olinuxino-lime2    | arm    | lab-baylibre    | gcc-8    | multi_=
v7_defconfig           | 1          =

sun7i-a20-olinuxino-lime2    | arm    | lab-baylibre    | gcc-8    | sunxi_=
defconfig              | 1          =

sun8i-a33-olinuxino          | arm    | lab-clabbe      | gcc-8    | multi_=
v7_defconfig           | 1          =

sun8i-a33-olinuxino          | arm    | lab-clabbe      | gcc-8    | sunxi_=
defconfig              | 1          =

sun8i-a83t-bananapi-m3       | arm    | lab-clabbe      | gcc-8    | multi_=
v7_defconfig           | 1          =

sun8i-a83t-bananapi-m3       | arm    | lab-clabbe      | gcc-8    | sunxi_=
defconfig              | 1          =

sun8i-h2-plus...ch-all-h3-cc | arm    | lab-baylibre    | gcc-8    | multi_=
v7_defconfig           | 1          =

sun8i-h2-plus...ch-all-h3-cc | arm    | lab-baylibre    | gcc-8    | sunxi_=
defconfig              | 1          =

sun8i-h2-plus-orangepi-r1    | arm    | lab-baylibre    | gcc-8    | multi_=
v7_defconfig           | 1          =

sun8i-h2-plus-orangepi-r1    | arm    | lab-baylibre    | gcc-8    | sunxi_=
defconfig              | 1          =

sun8i-h2-plus-orangepi-zero  | arm    | lab-baylibre    | gcc-8    | multi_=
v7_defconfig           | 1          =

sun8i-h2-plus-orangepi-zero  | arm    | lab-baylibre    | gcc-8    | sunxi_=
defconfig              | 1          =

sun8i-h3-bananapi-m2-plus    | arm    | lab-baylibre    | gcc-8    | multi_=
v7_defconfig           | 1          =

sun8i-h3-bananapi-m2-plus    | arm    | lab-baylibre    | gcc-8    | sunxi_=
defconfig              | 1          =

sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre    | gcc-8    | multi_=
v7_defconfig           | 1          =

sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre    | gcc-8    | sunxi_=
defconfig              | 1          =

sun8i-h3-orangepi-pc         | arm    | lab-clabbe      | gcc-8    | multi_=
v7_defconfig           | 1          =

sun8i-h3-orangepi-pc         | arm    | lab-clabbe      | gcc-8    | sunxi_=
defconfig              | 1          =

sun8i-r40-bananapi-m2-ultra  | arm    | lab-clabbe      | gcc-8    | multi_=
v7_defconfig           | 1          =

sun8i-r40-bananapi-m2-ultra  | arm    | lab-clabbe      | gcc-8    | sunxi_=
defconfig              | 1          =

tegra124-nyan-big            | arm    | lab-collabora   | gcc-8    | multi_=
v7_defconfig           | 1          =

tegra124-nyan-big            | arm    | lab-collabora   | gcc-8    | tegra_=
defconfig              | 1          =

zynqmp-zcu102                | arm64  | lab-cip         | gcc-8    | defcon=
fig                    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.208-95-g4a53d0ed459e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.208-95-g4a53d0ed459e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4a53d0ed459ec5d9e0d684d6ddf5095030cb25d3 =



Test Regressions
---------------- =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C433TA-AJ0005-rammus    | x86_64 | lab-collabora   | gcc-8    | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/615b25333bbda0690599a2fc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-collabor=
a/baseline-asus-C433TA-AJ0005-rammus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-collabor=
a/baseline-asus-C433TA-AJ0005-rammus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b25333bbda0690599a=
2fd
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C523NA-A20057-coral     | x86_64 | lab-collabora   | gcc-8    | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/615b26cbdf004d7bd099a2e9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-collabor=
a/baseline-asus-C523NA-A20057-coral.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-collabor=
a/baseline-asus-C523NA-A20057-coral.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b26cbdf004d7bd099a=
2ea
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
bcm2836-rpi-2-b              | arm    | lab-collabora   | gcc-8    | bcm283=
5_defconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2345c6560b734799a2fa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/bcm2835_defconfig/gcc-8/lab-collabora/baseline-bcm283=
6-rpi-2-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/bcm2835_defconfig/gcc-8/lab-collabora/baseline-bcm283=
6-rpi-2-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2345c6560b734799a=
2fb
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
bcm2836-rpi-2-b              | arm    | lab-collabora   | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2774b8d649569399a2da

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-bcm28=
36-rpi-2-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-bcm28=
36-rpi-2-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2774b8d649569399a=
2db
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beagle-xm                    | arm    | lab-baylibre    | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2758572545ad1f99a2f6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2758572545ad1f99a=
2f7
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beagle-xm                    | arm    | lab-baylibre    | gcc-8    | omap2p=
lus_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/615b244a39afb78df099a2ed

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b244a39afb78df099a=
2ee
        new failure (last pass: v4.19.208-55-g875c7e1e11e4) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beaglebone-black             | arm    | lab-cip         | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b28ed6e2453c00699a2dd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-beaglebone-=
black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-beaglebone-=
black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b28ed6e2453c00699a=
2de
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beaglebone-black             | arm    | lab-cip         | gcc-8    | omap2p=
lus_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/615b27852bb677a61299a2fe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/omap2plus_defconfig/gcc-8/lab-cip/baseline-beaglebone=
-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/omap2plus_defconfig/gcc-8/lab-cip/baseline-beaglebone=
-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b27852bb677a61299a=
2ff
        new failure (last pass: v4.19.208-55-g875c7e1e11e4) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
d2500cc                      | x86_64 | lab-clabbe      | gcc-8    | x86_64=
_defconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/615b22674dd023095599a2e1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b22674dd023095599a=
2e2
        new failure (last pass: v4.19.208-55-g875c7e1e11e4) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
d2500cc                      | x86_64 | lab-clabbe      | gcc-8    | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/615b255fe3ce43173799a303

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/b=
aseline-d2500cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/b=
aseline-d2500cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b255fe3ce43173799a=
304
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
da850-lcdk                   | arm    | lab-baylibre    | gcc-8    | davinc=
i_all_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/615b23d2ab720c491599a2e9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: davinci_all_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/davinci_all_defconfig/gcc-8/lab-baylibre/baseline-da8=
50-lcdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/davinci_all_defconfig/gcc-8/lab-baylibre/baseline-da8=
50-lcdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b23d2ab720c491599a=
2ea
        new failure (last pass: v4.19.208-55-g875c7e1e11e4) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hip07-d05                    | arm64  | lab-collabora   | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b27e6cd29e3ac3199a2e9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b27e6cd29e3ac3199a=
2ea
        new failure (last pass: v4.19.208-55-g9e4075ab91c6) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-11A-G6-EE-grunt           | x86_64 | lab-collabora   | gcc-8    | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2549e3ce43173799a2ec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-collabor=
a/baseline-hp-11A-G6-EE-grunt.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-collabor=
a/baseline-hp-11A-G6-EE-grunt.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2549e3ce43173799a=
2ed
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-12b-n4000-octopus    | x86_64 | lab-collabora   | gcc-8    | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/615b25d90b20deb76e99a2f7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-collabor=
a/baseline-hp-x360-12b-n4000-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-collabor=
a/baseline-hp-x360-12b-n4000-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b25d90b20deb76e99a=
2f8
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
i945gsex-qs                  | i386   | lab-clabbe      | gcc-8    | i386_d=
efconfig               | 1          =


  Details:     https://kernelci.org/test/plan/id/615b248383c69a5b7399a2e0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/i386/i386_defconfig/gcc-8/lab-clabbe/baseline-i945gsex-qs=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/i386/i386_defconfig/gcc-8/lab-clabbe/baseline-i945gsex-qs=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b248383c69a5b7399a=
2e1
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx6q-sabrelite              | arm    | lab-collabora   | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b27981f02e1cad099a2f0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-imx6q=
-sabrelite.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-imx6q=
-sabrelite.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b27981f02e1cad099a=
2f1
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx6q-var-dt6customboard     | arm    | lab-baylibre    | gcc-8    | imx_v6=
_v7_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/615b28aab469e23ef999a2ec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/imx_v6_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q=
-var-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/imx_v6_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q=
-var-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b28aab469e23ef999a=
2ed
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx6q-var-dt6customboard     | arm    | lab-baylibre    | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b27570a3d6b83a499a2f8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-=
var-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-=
var-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b27570a3d6b83a499a=
2f9
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx6sx-sdb                   | arm    | lab-nxp         | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2e408e7492058499a320

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx6sx-sdb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx6sx-sdb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2e408e7492058499a=
321
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
jetson-tk1                   | arm    | lab-baylibre    | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b299c1bdb96026799a2e9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-jetson=
-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-jetson=
-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b299c1bdb96026799a=
2ea
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
jetson-tk1                   | arm    | lab-baylibre    | gcc-8    | tegra_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/615b26e0e7aff657d099a30c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/tegra_defconfig/gcc-8/lab-baylibre/baseline-jetson-tk=
1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/tegra_defconfig/gcc-8/lab-baylibre/baseline-jetson-tk=
1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b26e0e7aff657d099a=
30d
        new failure (last pass: v4.19.208-55-g875c7e1e11e4) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
meson-gxl-s905x-libretech-cc | arm64  | lab-clabbe      | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b26b8cc6cb26e3199a2f6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm64/defconfig/gcc-8/lab-clabbe/baseline-meson-gxl-s905x=
-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm64/defconfig/gcc-8/lab-clabbe/baseline-meson-gxl-s905x=
-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b26b8cc6cb26e3199a=
2f7
        new failure (last pass: v4.19.208-55-g9e4075ab91c6) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
meson-gxm-khadas-vim2        | arm64  | lab-baylibre    | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b26f59368eb977c99a2f7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-kha=
das-vim2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-kha=
das-vim2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b26f59368eb977c99a=
2f8
        new failure (last pass: v4.19.208-55-g9e4075ab91c6) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
odroid-xu3                   | arm    | lab-collabora   | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b4fb76dd0d4836199a2ec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-odroi=
d-xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-odroi=
d-xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b4fb76dd0d4836199a=
2ed
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
ox820-clouden...lug-series-3 | arm    | lab-baylibre    | gcc-8    | oxnas_=
v6_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b24dc1b301904b599a2e7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: oxnas_v6_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/oxnas_v6_defconfig/gcc-8/lab-baylibre/baseline-ox820-=
cloudengines-pogoplug-series-3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/oxnas_v6_defconfig/gcc-8/lab-baylibre/baseline-ox820-=
cloudengines-pogoplug-series-3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b24dc1b301904b599a=
2e8
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
panda                        | arm    | lab-collabora   | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2765572545ad1f99a303

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2765572545ad1f99a=
304
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
panda                        | arm    | lab-collabora   | gcc-8    | omap2p=
lus_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/615b24568b21118ffc99a2ee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b24568b21118ffc99a=
2ef
        new failure (last pass: v4.19.208-55-g875c7e1e11e4) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qcom-qdf2400                 | arm64  | lab-linaro-lkft | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b26a059c89cff6699a2f2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm64/defconfig/gcc-8/lab-linaro-lkft/baseline-qcom-qdf24=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm64/defconfig/gcc-8/lab-linaro-lkft/baseline-qcom-qdf24=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b26a059c89cff6699a=
2f3
        new failure (last pass: v4.19.208-55-g9e4075ab91c6) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm-versatilepb         | arm    | lab-baylibre    | gcc-8    | versat=
ile_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/615b25250bfae9e8cd99a2fc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b25250bfae9e8cd99a=
2fd
        failing since 324 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm-versatilepb         | arm    | lab-broonie     | gcc-8    | versat=
ile_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/615b26ac59c89cff6699a2fe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b26ac59c89cff6699a=
2ff
        failing since 324 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm-versatilepb         | arm    | lab-cip         | gcc-8    | versat=
ile_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2591fd3094204899a2e9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2591fd3094204899a=
2ea
        failing since 324 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm-vexpress-a15        | arm    | lab-baylibre    | gcc-8    | vexpre=
ss_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2575043fdfde6399a2ef

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: vexpress_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/vexpress_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-vexpress-a15.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/vexpress_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-vexpress-a15.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2575043fdfde6399a=
2f0
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm-vexpress-a15        | arm    | lab-broonie     | gcc-8    | vexpre=
ss_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b272527d59fb1f699a2fd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: vexpress_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/vexpress_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-vexpress-a15.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/vexpress_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-vexpress-a15.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b272527d59fb1f699a=
2fe
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm-vexpress-a15        | arm    | lab-cip         | gcc-8    | vexpre=
ss_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b265381b1e29bd399a2ec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: vexpress_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/vexpress_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
xpress-a15.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/vexpress_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
xpress-a15.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b265381b1e29bd399a=
2ed
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm-vexpress-a9         | arm    | lab-baylibre    | gcc-8    | vexpre=
ss_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2589fd3094204899a2e0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: vexpress_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/vexpress_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-vexpress-a9.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/vexpress_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-vexpress-a9.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2589fd3094204899a=
2e1
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm-vexpress-a9         | arm    | lab-broonie     | gcc-8    | vexpre=
ss_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b274d0a3d6b83a499a2ea

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: vexpress_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/vexpress_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-vexpress-a9.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/vexpress_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-vexpress-a9.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b274d0a3d6b83a499a=
2eb
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm-vexpress-a9         | arm    | lab-cip         | gcc-8    | vexpre=
ss_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b26488cb507079d99a2e1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: vexpress_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/vexpress_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
xpress-a9.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/vexpress_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
xpress-a9.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b26488cb507079d99a=
2e2
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm-virt-gicv2          | arm    | lab-baylibre    | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b290d832c0ef0d699a2f5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b290d832c0ef0d699a=
2f6
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm-virt-gicv2          | arm    | lab-broonie     | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2bd63de1e8ee8099a2e9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2bd63de1e8ee8099a=
2ea
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm-virt-gicv2          | arm    | lab-cip         | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2a41c7b9a78ccc99a2f6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vi=
rt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vi=
rt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2a41c7b9a78ccc99a=
2f7
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm-virt-gicv2-uefi     | arm    | lab-baylibre    | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2832721e2717fa99a2db

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2832721e2717fa99a=
2dc
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm-virt-gicv2-uefi     | arm    | lab-broonie     | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2b9ac3841add1999a2f4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2b9ac3841add1999a=
2f5
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm-virt-gicv2-uefi     | arm    | lab-cip         | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2a08d628a838bc99a2ff

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vi=
rt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vi=
rt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2a08d628a838bc99a=
300
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm-virt-gicv3          | arm    | lab-baylibre    | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b29722d630bc40a99a2fa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b29722d630bc40a99a=
2fb
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm-virt-gicv3          | arm    | lab-broonie     | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2d166a1347c95c99a2ef

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2d166a1347c95c99a=
2f0
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm-virt-gicv3          | arm    | lab-cip         | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2ba8fda315094699a2da

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vi=
rt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vi=
rt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2ba9fda315094699a=
2db
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm-virt-gicv3-uefi     | arm    | lab-baylibre    | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b285adbed6cf3c099a2e1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b285adbed6cf3c099a=
2e2
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm-virt-gicv3-uefi     | arm    | lab-broonie     | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2bc20a9442531599a304

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2bc20a9442531599a=
305
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm-virt-gicv3-uefi     | arm    | lab-cip         | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2a40c7b9a78ccc99a2f3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vi=
rt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vi=
rt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2a40c7b9a78ccc99a=
2f4
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-baylibre    | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b26c9e7aff657d099a2dd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm64/defconfig/gcc-8/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm64/defconfig/gcc-8/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b26c9e7aff657d099a=
2de
        new failure (last pass: v4.19.208-55-g9e4075ab91c6) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-broonie     | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b28c9c13bc0558d99a2e6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm64/defconfig/gcc-8/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm64/defconfig/gcc-8/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b28c9c13bc0558d99a=
2e7
        new failure (last pass: v4.19.208-55-g9e4075ab91c6) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-cip         | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b281f2a3421ca1e99a2f3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm64/defconfig/gcc-8/lab-cip/baseline-qemu_arm64-virt-gi=
cv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm64/defconfig/gcc-8/lab-cip/baseline-qemu_arm64-virt-gi=
cv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b281f2a3421ca1e99a=
2f4
        new failure (last pass: v4.19.208-55-g9e4075ab91c6) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-baylibre    | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b26dee7aff657d099a306

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm64/defconfig/gcc-8/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm64/defconfig/gcc-8/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b26dee7aff657d099a=
307
        new failure (last pass: v4.19.208-55-g9e4075ab91c6) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-broonie     | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b28f1a5f8d4aed899a2da

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm64/defconfig/gcc-8/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm64/defconfig/gcc-8/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b28f1a5f8d4aed899a=
2db
        new failure (last pass: v4.19.208-55-g9e4075ab91c6) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-cip         | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b27c4169cd7b06f99a2e7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm64/defconfig/gcc-8/lab-cip/baseline-qemu_arm64-virt-gi=
cv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm64/defconfig/gcc-8/lab-cip/baseline-qemu_arm64-virt-gi=
cv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b27c4169cd7b06f99a=
2e8
        new failure (last pass: v4.19.208-55-g9e4075ab91c6) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-baylibre    | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b26a1eb7d68888499a2e9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm64/defconfig/gcc-8/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm64/defconfig/gcc-8/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b26a1eb7d68888499a=
2ea
        new failure (last pass: v4.19.208-55-g9e4075ab91c6) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-broonie     | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b28a1b469e23ef999a2da

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm64/defconfig/gcc-8/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm64/defconfig/gcc-8/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b28a1b469e23ef999a=
2db
        new failure (last pass: v4.19.208-55-g9e4075ab91c6) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-cip         | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b27490a3d6b83a499a2e4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm64/defconfig/gcc-8/lab-cip/baseline-qemu_arm64-virt-gi=
cv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm64/defconfig/gcc-8/lab-cip/baseline-qemu_arm64-virt-gi=
cv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b27490a3d6b83a499a=
2e5
        new failure (last pass: v4.19.208-55-g9e4075ab91c6) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-baylibre    | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b27b9a7ef84fff399a2eb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm64/defconfig/gcc-8/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm64/defconfig/gcc-8/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b27b9a7ef84fff399a=
2ec
        new failure (last pass: v4.19.208-55-g9e4075ab91c6) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-broonie     | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2a1de1a7c5014899a2ec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm64/defconfig/gcc-8/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm64/defconfig/gcc-8/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2a1de1a7c5014899a=
2ed
        new failure (last pass: v4.19.208-55-g9e4075ab91c6) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-cip         | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b289cbfcd23f9dc99a304

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm64/defconfig/gcc-8/lab-cip/baseline-qemu_arm64-virt-gi=
cv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm64/defconfig/gcc-8/lab-cip/baseline-qemu_arm64-virt-gi=
cv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b289cbfcd23f9dc99a=
305
        new failure (last pass: v4.19.208-55-g9e4075ab91c6) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_i386                    | i386   | lab-baylibre    | gcc-8    | i386_d=
efconfig               | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2435db7b68c1dc99a2da

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2435db7b68c1dc99a=
2db
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_i386                    | i386   | lab-broonie     | gcc-8    | i386_d=
efconfig               | 1          =


  Details:     https://kernelci.org/test/plan/id/615b25a8d6020570ff99a2f3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i386.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i386.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b25a8d6020570ff99a=
2f4
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_i386                    | i386   | lab-cip         | gcc-8    | i386_d=
efconfig               | 1          =


  Details:     https://kernelci.org/test/plan/id/615b24b85cf25429e699a2df

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/i386/i386_defconfig/gcc-8/lab-cip/baseline-qemu_i386.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/i386/i386_defconfig/gcc-8/lab-cip/baseline-qemu_i386.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b24b85cf25429e699a=
2e0
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_i386-uefi               | i386   | lab-baylibre    | gcc-8    | i386_d=
efconfig               | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2437db7b68c1dc99a2e0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386=
-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386=
-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2437db7b68c1dc99a=
2e1
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_i386-uefi               | i386   | lab-broonie     | gcc-8    | i386_d=
efconfig               | 1          =


  Details:     https://kernelci.org/test/plan/id/615b25d10b20deb76e99a2f1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i386-=
uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i386-=
uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b25d10b20deb76e99a=
2f2
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_i386-uefi               | i386   | lab-cip         | gcc-8    | i386_d=
efconfig               | 1          =


  Details:     https://kernelci.org/test/plan/id/615b24f41b301904b599a2fd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/i386/i386_defconfig/gcc-8/lab-cip/baseline-qemu_i386-uefi=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/i386/i386_defconfig/gcc-8/lab-cip/baseline-qemu_i386-uefi=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b24f41b301904b599a=
2fe
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_x86_64                  | x86_64 | lab-baylibre    | gcc-8    | x86_64=
_defconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2240eea9e6b74e99a2f5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2240eea9e6b74e99a=
2f6
        new failure (last pass: v4.19.208-55-g875c7e1e11e4) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_x86_64                  | x86_64 | lab-baylibre    | gcc-8    | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/615b25273bbda0690599a2ea

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-baylibre=
/baseline-qemu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-baylibre=
/baseline-qemu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b25273bbda0690599a=
2eb
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_x86_64                  | x86_64 | lab-broonie     | gcc-8    | x86_64=
_defconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/615b24a483c69a5b7399a309

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x=
86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x=
86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b24a483c69a5b7399a=
30a
        new failure (last pass: v4.19.208-55-g875c7e1e11e4) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_x86_64                  | x86_64 | lab-broonie     | gcc-8    | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/615b27281b1dd1eba799a2da

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-broonie/=
baseline-qemu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-broonie/=
baseline-qemu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b27281b1dd1eba799a=
2db
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_x86_64                  | x86_64 | lab-cip         | gcc-8    | x86_64=
_defconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/615b239cbed2db4e1c99a2e3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/x86_64/x86_64_defconfig/gcc-8/lab-cip/baseline-qemu_x86_6=
4.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/x86_64/x86_64_defconfig/gcc-8/lab-cip/baseline-qemu_x86_6=
4.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b239cbed2db4e1c99a=
2e4
        new failure (last pass: v4.19.208-55-g875c7e1e11e4) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_x86_64                  | x86_64 | lab-cip         | gcc-8    | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/615b25cd0b20deb76e99a2ee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-cip/base=
line-qemu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-cip/base=
line-qemu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b25cd0b20deb76e99a=
2ef
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-baylibre    | gcc-8    | x86_64=
_defconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2268230879d18099a2ee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2268230879d18099a=
2ef
        new failure (last pass: v4.19.208-55-g875c7e1e11e4) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-baylibre    | gcc-8    | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/615b24ff1b301904b599a304

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-baylibre=
/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-baylibre=
/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b24ff1b301904b599a=
305
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-broonie     | gcc-8    | x86_64=
_defconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/615b251c0bfae9e8cd99a2e8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x=
86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x=
86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b251c0bfae9e8cd99a=
2e9
        new failure (last pass: v4.19.208-55-g875c7e1e11e4) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-broonie     | gcc-8    | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/615b26c1eb7d68888499a34a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-broonie/=
baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-broonie/=
baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b26c1eb7d68888499a=
34b
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-cip         | gcc-8    | x86_64=
_defconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/615b23edd5ed43d4f899a34d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/x86_64/x86_64_defconfig/gcc-8/lab-cip/baseline-qemu_x86_6=
4-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/x86_64/x86_64_defconfig/gcc-8/lab-cip/baseline-qemu_x86_6=
4-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b23edd5ed43d4f899a=
34e
        new failure (last pass: v4.19.208-55-g875c7e1e11e4) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-cip         | gcc-8    | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/615b257d043fdfde6399a2f5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-cip/base=
line-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-cip/base=
line-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b257d043fdfde6399a=
2f6
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
rk3288-rock2-square          | arm    | lab-collabora   | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b28f3d0f6eefbe199a2e2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-rock2-square.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-rock2-square.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b28f3d0f6eefbe199a=
2e3
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
rk3288-veyron-jaq            | arm    | lab-collabora   | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b44eae68111299f99a2e0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b44eae68111299f99a=
2e1
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
rk3328-rock64                | arm64  | lab-baylibre    | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b26a959c89cff6699a2f8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm64/defconfig/gcc-8/lab-baylibre/baseline-rk3328-rock64=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm64/defconfig/gcc-8/lab-baylibre/baseline-rk3328-rock64=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b26a959c89cff6699a=
2f9
        new failure (last pass: v4.19.208-55-g9e4075ab91c6) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
rk3399-gru-kevin             | arm64  | lab-collabora   | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b26abcc6cb26e3199a2ee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-k=
evin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-k=
evin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b26abcc6cb26e3199a=
2ef
        new failure (last pass: v4.19.208-55-g9e4075ab91c6) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun50i-a64-bananapi-m64      | arm64  | lab-clabbe      | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b26cce7aff657d099a2e8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b26cce7aff657d099a=
2e9
        new failure (last pass: v4.19.208-55-g9e4075ab91c6) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun50i-a64-pine64-plus       | arm64  | lab-baylibre    | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b26c4df004d7bd099a2da

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm64/defconfig/gcc-8/lab-baylibre/baseline-sun50i-a64-pi=
ne64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm64/defconfig/gcc-8/lab-baylibre/baseline-sun50i-a64-pi=
ne64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b26c4df004d7bd099a=
2db
        new failure (last pass: v4.19.208-55-g9e4075ab91c6) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun50i-h5-lib...ch-all-h3-cc | arm64  | lab-baylibre    | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b26f7fc47375e0f99a30b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm64/defconfig/gcc-8/lab-baylibre/baseline-sun50i-h5-lib=
retech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm64/defconfig/gcc-8/lab-baylibre/baseline-sun50i-h5-lib=
retech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b26f7fc47375e0f99a=
30c
        new failure (last pass: v4.19.208-55-g9e4075ab91c6) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun50i-h5-nanopi-neo-plus2   | arm64  | lab-clabbe      | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b26a5eb7d68888499a2ee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-h5-nanop=
i-neo-plus2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-h5-nanop=
i-neo-plus2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b26a5eb7d68888499a=
2ef
        new failure (last pass: v4.19.208-55-g9e4075ab91c6) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun50i-h6-pine-h64           | arm64  | lab-clabbe      | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b26b3df4292931a99a2ee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-h6-pine-=
h64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-h6-pine-=
h64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b26b3df4292931a99a=
2ef
        new failure (last pass: v4.19.208-55-g9e4075ab91c6) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun50i-h6-pine-h64           | arm64  | lab-collabora   | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b270a27d59fb1f699a2de

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm64/defconfig/gcc-8/lab-collabora/baseline-sun50i-h6-pi=
ne-h64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm64/defconfig/gcc-8/lab-collabora/baseline-sun50i-h6-pi=
ne-h64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b270a27d59fb1f699a=
2df
        new failure (last pass: v4.19.208-55-g9e4075ab91c6) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun5i-a13-olinuxino-micro    | arm    | lab-baylibre    | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b27782bb677a61299a2ec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-sun5i-=
a13-olinuxino-micro.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-sun5i-=
a13-olinuxino-micro.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b27782bb677a61299a=
2ed
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun5i-a13-olinuxino-micro    | arm    | lab-baylibre    | gcc-8    | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/615b240815ec1d281b99a2da

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/sunxi_defconfig/gcc-8/lab-baylibre/baseline-sun5i-a13=
-olinuxino-micro.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/sunxi_defconfig/gcc-8/lab-baylibre/baseline-sun5i-a13=
-olinuxino-micro.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b240815ec1d281b99a=
2db
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun7i-a20-cubieboard2        | arm    | lab-clabbe      | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b28202a3421ca1e99a2f6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-clabbe/baseline-sun7i-a2=
0-cubieboard2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-clabbe/baseline-sun7i-a2=
0-cubieboard2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b28202a3421ca1e99a=
2f7
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun7i-a20-cubieboard2        | arm    | lab-clabbe      | gcc-8    | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/615b23fc253a16f20199a2dd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/sunxi_defconfig/gcc-8/lab-clabbe/baseline-sun7i-a20-c=
ubieboard2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/sunxi_defconfig/gcc-8/lab-clabbe/baseline-sun7i-a20-c=
ubieboard2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b23fc253a16f20199a=
2de
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun7i-a20-olinuxino-lime2    | arm    | lab-baylibre    | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b35a399f96bb05b99a2f0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-sun7i-=
a20-olinuxino-lime2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-sun7i-=
a20-olinuxino-lime2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b35a399f96bb05b99a=
2f1
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun7i-a20-olinuxino-lime2    | arm    | lab-baylibre    | gcc-8    | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/615b3246d05b2b919e99a2f0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/sunxi_defconfig/gcc-8/lab-baylibre/baseline-sun7i-a20=
-olinuxino-lime2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/sunxi_defconfig/gcc-8/lab-baylibre/baseline-sun7i-a20=
-olinuxino-lime2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b3246d05b2b919e99a=
2f1
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-a33-olinuxino          | arm    | lab-clabbe      | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b28212a3421ca1e99a2f9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-clabbe/baseline-sun8i-a3=
3-olinuxino.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-clabbe/baseline-sun8i-a3=
3-olinuxino.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b28212a3421ca1e99a=
2fa
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-a33-olinuxino          | arm    | lab-clabbe      | gcc-8    | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/615b241015ec1d281b99a2e3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/sunxi_defconfig/gcc-8/lab-clabbe/baseline-sun8i-a33-o=
linuxino.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/sunxi_defconfig/gcc-8/lab-clabbe/baseline-sun8i-a33-o=
linuxino.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b241015ec1d281b99a=
2e4
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-a83t-bananapi-m3       | arm    | lab-clabbe      | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b27f9169cd7b06f99a2ff

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-clabbe/baseline-sun8i-a8=
3t-bananapi-m3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-clabbe/baseline-sun8i-a8=
3t-bananapi-m3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b27f9169cd7b06f99a=
300
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-a83t-bananapi-m3       | arm    | lab-clabbe      | gcc-8    | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/615b23fe1a36c2fb7499a2f9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/sunxi_defconfig/gcc-8/lab-clabbe/baseline-sun8i-a83t-=
bananapi-m3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/sunxi_defconfig/gcc-8/lab-clabbe/baseline-sun8i-a83t-=
bananapi-m3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b23fe1a36c2fb7499a=
2fa
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h2-plus...ch-all-h3-cc | arm    | lab-baylibre    | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b293a35603b7c9f99a2e9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-sun8i-=
h2-plus-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-sun8i-=
h2-plus-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b293a35603b7c9f99a=
2ea
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h2-plus...ch-all-h3-cc | arm    | lab-baylibre    | gcc-8    | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/615b241115ec1d281b99a2e6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/sunxi_defconfig/gcc-8/lab-baylibre/baseline-sun8i-h2-=
plus-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/sunxi_defconfig/gcc-8/lab-baylibre/baseline-sun8i-h2-=
plus-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b241115ec1d281b99a=
2e7
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h2-plus-orangepi-r1    | arm    | lab-baylibre    | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b277d2bb677a61299a2f5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-sun8i-=
h2-plus-orangepi-r1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-sun8i-=
h2-plus-orangepi-r1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b277d2bb677a61299a=
2f6
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h2-plus-orangepi-r1    | arm    | lab-baylibre    | gcc-8    | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/615b241e15ec1d281b99a2e9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/sunxi_defconfig/gcc-8/lab-baylibre/baseline-sun8i-h2-=
plus-orangepi-r1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/sunxi_defconfig/gcc-8/lab-baylibre/baseline-sun8i-h2-=
plus-orangepi-r1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b241e15ec1d281b99a=
2ea
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h2-plus-orangepi-zero  | arm    | lab-baylibre    | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b277b2bb677a61299a2f2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-sun8i-=
h2-plus-orangepi-zero.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-sun8i-=
h2-plus-orangepi-zero.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b277b2bb677a61299a=
2f3
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h2-plus-orangepi-zero  | arm    | lab-baylibre    | gcc-8    | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/615b240a15ec1d281b99a2dd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/sunxi_defconfig/gcc-8/lab-baylibre/baseline-sun8i-h2-=
plus-orangepi-zero.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/sunxi_defconfig/gcc-8/lab-baylibre/baseline-sun8i-h2-=
plus-orangepi-zero.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b240a15ec1d281b99a=
2de
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h3-bananapi-m2-plus    | arm    | lab-baylibre    | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2755572545ad1f99a2f0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-sun8i-=
h3-bananapi-m2-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-sun8i-=
h3-bananapi-m2-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2755572545ad1f99a=
2f1
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h3-bananapi-m2-plus    | arm    | lab-baylibre    | gcc-8    | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/615b240c15ec1d281b99a2e0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/sunxi_defconfig/gcc-8/lab-baylibre/baseline-sun8i-h3-=
bananapi-m2-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/sunxi_defconfig/gcc-8/lab-baylibre/baseline-sun8i-h3-=
bananapi-m2-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b240c15ec1d281b99a=
2e1
        new failure (last pass: v4.19.208-55-g875c7e1e11e4) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre    | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b276a572545ad1f99a309

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-sun8i-=
h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-sun8i-=
h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b276a572545ad1f99a=
30a
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre    | gcc-8    | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/615b23fd1a36c2fb7499a2f1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/sunxi_defconfig/gcc-8/lab-baylibre/baseline-sun8i-h3-=
libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/sunxi_defconfig/gcc-8/lab-baylibre/baseline-sun8i-h3-=
libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b23fd1a36c2fb7499a=
2f2
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h3-orangepi-pc         | arm    | lab-clabbe      | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b3249d497dbbb2199a2e2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-clabbe/baseline-sun8i-h3=
-orangepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-clabbe/baseline-sun8i-h3=
-orangepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b3249d497dbbb2199a=
2e3
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h3-orangepi-pc         | arm    | lab-clabbe      | gcc-8    | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2550e3ce43173799a2f2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/sunxi_defconfig/gcc-8/lab-clabbe/baseline-sun8i-h3-or=
angepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/sunxi_defconfig/gcc-8/lab-clabbe/baseline-sun8i-h3-or=
angepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2550e3ce43173799a=
2f3
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-r40-bananapi-m2-ultra  | arm    | lab-clabbe      | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b334d7e576f764f99a2e3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-clabbe/baseline-sun8i-r4=
0-bananapi-m2-ultra.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-clabbe/baseline-sun8i-r4=
0-bananapi-m2-ultra.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b334d7e576f764f99a=
2e4
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-r40-bananapi-m2-ultra  | arm    | lab-clabbe      | gcc-8    | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2564e3ce43173799a309

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/sunxi_defconfig/gcc-8/lab-clabbe/baseline-sun8i-r40-b=
ananapi-m2-ultra.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/sunxi_defconfig/gcc-8/lab-clabbe/baseline-sun8i-r40-b=
ananapi-m2-ultra.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2564e3ce43173799a=
30a
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
tegra124-nyan-big            | arm    | lab-collabora   | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b43ec0960e9ccc799a2de

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-tegra=
124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-tegra=
124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b43ec0960e9ccc799a=
2df
        new failure (last pass: v4.19.208-61-g337609dd1e94) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
tegra124-nyan-big            | arm    | lab-collabora   | gcc-8    | tegra_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/615b3e24f3f576043c99a2da

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/tegra_defconfig/gcc-8/lab-collabora/baseline-tegra124=
-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm/tegra_defconfig/gcc-8/lab-collabora/baseline-tegra124=
-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b3e24f3f576043c99a=
2db
        new failure (last pass: v4.19.208-55-g875c7e1e11e4) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
zynqmp-zcu102                | arm64  | lab-cip         | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b26aceb7d68888499a2f6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm64/defconfig/gcc-8/lab-cip/baseline-zynqmp-zcu102.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4a53d0ed459e/arm64/defconfig/gcc-8/lab-cip/baseline-zynqmp-zcu102.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b26aceb7d68888499a=
2f7
        new failure (last pass: v4.19.208-55-g9e4075ab91c6) =

 =20
