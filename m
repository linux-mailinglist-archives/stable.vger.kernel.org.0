Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E74E642182F
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 22:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234851AbhJDUKl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 16:10:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbhJDUKk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Oct 2021 16:10:40 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78024C061745
        for <stable@vger.kernel.org>; Mon,  4 Oct 2021 13:08:51 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id pf6-20020a17090b1d8600b0019fa884ab85so261110pjb.5
        for <stable@vger.kernel.org>; Mon, 04 Oct 2021 13:08:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=uB90b674zBFI7s8VLnedo9QQjd+toAJU+M4RbqnNSKQ=;
        b=NQoJrt4d/B0cEDMTFxqu4pzNEUY7vmbzhy+xW4NRrc8EXEBU+ZneXtVesjRPg9aknh
         IB9Cv3CUpLqczALvlNWd1ys2zlJdfz8bgyhuRIkf39hgvPKnxTaaYfikP3SnqvBhnQsb
         Xi2uR8Jqt/jg2uxwCQEMk0+sVvhrn6yyxE69331S1Z+3JYKDAXvpk7gThM4Dks7FD++f
         9/rJCH2/37CJw5fl/diouu2kaMokh3vYwWSIQVPUsWW+ROgdGL7shIbGIq2tbIRJEWPb
         0sPkW5xEPd+0pEiLn3gqzCSbMFdBIyytWfofshDqYd+HxE1PLwTTivbSYVrRHPKoGnUU
         cfXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=uB90b674zBFI7s8VLnedo9QQjd+toAJU+M4RbqnNSKQ=;
        b=dH6PX2lPwDf4NV5ai9ejIBSXjyJJQA1qSjxB2VeyhSJ2hO3MTv2iHq0A4AzvyRgAbQ
         aJWLUgNY3dVtUWHhc2OlWjBgLOzIch6d0v/2XtfXwFYCYUifuRPC6sMiTepDkHCpZuBi
         EILlKDHEpqZItILpa4Mq4plgz2SW1UsInQAS+l48FfsJbCQfPruwL2Jg/xIy2YOJtOro
         NpgZCZCxTZynKJRgriTqcjP2tJ4jGkuZu360ZmKxB/IplOfu6ZYuEGq9QDtT2Q65AI74
         8cBYL2Q0O0pKqjCbBVQ+arKKuM7da4BGVjnBRjaIOyOOa/QH20a3Y1Bmmhulsdjgt/XD
         WyKw==
X-Gm-Message-State: AOAM533lBwA7KaV1P8iOSPTX5jUop8HGJq21DdOwSdGQFOw1LZzYmciR
        UwGgNDvoUzStIkGGi9r7TDhdWr6x2/D3Eb0w
X-Google-Smtp-Source: ABdhPJw7kbz5sSGNnyrTq150zMXxkkBGH+S7P1IkRlBV7p7Kt2uJwuORkc3jHqd8AvlnO+u2PC85Kw==
X-Received: by 2002:a17:902:a58b:b0:13e:cfb5:c086 with SMTP id az11-20020a170902a58b00b0013ecfb5c086mr1463402plb.8.1633378129589;
        Mon, 04 Oct 2021 13:08:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id qe17sm15327686pjb.39.2021.10.04.13.08.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 13:08:49 -0700 (PDT)
Message-ID: <615b5f51.1c69fb81.6652.c173@mx.google.com>
Date:   Mon, 04 Oct 2021 13:08:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.208-96-gee3e528d83e9
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 125 runs,
 118 regressions (v4.19.208-96-gee3e528d83e9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 125 runs, 118 regressions (v4.19.208-96-ge=
e3e528d83e9)

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
_defcon...6-chromebook | 1          =

d2500cc                      | x86_64 | lab-clabbe      | gcc-8    | x86_64=
_defconfig             | 1          =

da850-lcdk                   | arm    | lab-baylibre    | gcc-8    | davinc=
i_all_defconfig        | 1          =

fsl-ls1043a-rdb              | arm64  | lab-nxp         | gcc-8    | defcon=
fig                    | 1          =

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

odroid-xu3                   | arm    | lab-collabora   | gcc-8    | exynos=
_defconfig             | 1          =

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
_defcon...6-chromebook | 1          =

qemu_x86_64                  | x86_64 | lab-baylibre    | gcc-8    | x86_64=
_defconfig             | 1          =

qemu_x86_64                  | x86_64 | lab-broonie     | gcc-8    | x86_64=
_defcon...6-chromebook | 1          =

qemu_x86_64                  | x86_64 | lab-broonie     | gcc-8    | x86_64=
_defconfig             | 1          =

qemu_x86_64                  | x86_64 | lab-cip         | gcc-8    | x86_64=
_defcon...6-chromebook | 1          =

qemu_x86_64                  | x86_64 | lab-cip         | gcc-8    | x86_64=
_defconfig             | 1          =

qemu_x86_64-uefi             | x86_64 | lab-baylibre    | gcc-8    | x86_64=
_defcon...6-chromebook | 1          =

qemu_x86_64-uefi             | x86_64 | lab-baylibre    | gcc-8    | x86_64=
_defconfig             | 1          =

qemu_x86_64-uefi             | x86_64 | lab-broonie     | gcc-8    | x86_64=
_defcon...6-chromebook | 1          =

qemu_x86_64-uefi             | x86_64 | lab-broonie     | gcc-8    | x86_64=
_defconfig             | 1          =

qemu_x86_64-uefi             | x86_64 | lab-cip         | gcc-8    | x86_64=
_defcon...6-chromebook | 1          =

qemu_x86_64-uefi             | x86_64 | lab-cip         | gcc-8    | x86_64=
_defconfig             | 1          =

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.208-96-gee3e528d83e9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.208-96-gee3e528d83e9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ee3e528d83e91547f386a30677ccb96c28e78218 =



Test Regressions
---------------- =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C433TA-AJ0005-rammus    | x86_64 | lab-collabora   | gcc-8    | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/615b26cee7aff657d099a2f1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-collab=
ora/baseline-asus-C433TA-AJ0005-rammus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-collab=
ora/baseline-asus-C433TA-AJ0005-rammus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b26cee7aff657d099a=
2f2
        new failure (last pass: v4.19.208-62-g0f04201c0ff5) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C523NA-A20057-coral     | x86_64 | lab-collabora   | gcc-8    | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2761572545ad1f99a300

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-collab=
ora/baseline-asus-C523NA-A20057-coral.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-collab=
ora/baseline-asus-C523NA-A20057-coral.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2761572545ad1f99a=
301
        new failure (last pass: v4.19.208-62-g0f04201c0ff5) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
bcm2836-rpi-2-b              | arm    | lab-collabora   | gcc-8    | bcm283=
5_defconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2e91ba6807dbe099a2f2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/bcm2835_defconfig/gcc-8/lab-collabora/baseline-bcm2=
836-rpi-2-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/bcm2835_defconfig/gcc-8/lab-collabora/baseline-bcm2=
836-rpi-2-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2e91ba6807dbe099a=
2f3
        new failure (last pass: v4.19.208-62-g0f04201c0ff5) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
bcm2836-rpi-2-b              | arm    | lab-collabora   | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2abe1efef5b12d99a2dc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-bcm=
2836-rpi-2-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-bcm=
2836-rpi-2-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2abe1efef5b12d99a=
2dd
        new failure (last pass: v4.19.208-62-g0f04201c0ff5) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beagle-xm                    | arm    | lab-baylibre    | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b28ac7067be736399a2e5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b28ac7067be736399a=
2e6
        new failure (last pass: v4.19.208-62-g0f04201c0ff5) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beagle-xm                    | arm    | lab-baylibre    | gcc-8    | omap2p=
lus_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2b068b3b80423f99a2f5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2b068b3b80423f99a=
2f6
        new failure (last pass: v4.19.208-62-g0f04201c0ff5) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beaglebone-black             | arm    | lab-cip         | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2bbd0a9442531599a2f5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-beaglebon=
e-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-beaglebon=
e-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2bbd0a9442531599a=
2f6
        new failure (last pass: v4.19.208-62-g0f04201c0ff5) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beaglebone-black             | arm    | lab-cip         | gcc-8    | omap2p=
lus_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2e8dba6807dbe099a2ec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/omap2plus_defconfig/gcc-8/lab-cip/baseline-beaglebo=
ne-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/omap2plus_defconfig/gcc-8/lab-cip/baseline-beaglebo=
ne-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2e8dba6807dbe099a=
2ed
        new failure (last pass: v4.19.208-62-g0f04201c0ff5) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
d2500cc                      | x86_64 | lab-clabbe      | gcc-8    | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/615b264f244083e60599a2e7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe=
/baseline-d2500cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe=
/baseline-d2500cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b264f244083e60599a=
2e8
        new failure (last pass: v4.19.208-62-g0f04201c0ff5) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
d2500cc                      | x86_64 | lab-clabbe      | gcc-8    | x86_64=
_defconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2894582c5140e499a2e8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500=
cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500=
cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2894582c5140e499a=
2e9
        new failure (last pass: v4.19.208-62-g0f04201c0ff5) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
da850-lcdk                   | arm    | lab-baylibre    | gcc-8    | davinc=
i_all_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/615b27f7425f92f6ba99a30e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: davinci_all_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/davinci_all_defconfig/gcc-8/lab-baylibre/baseline-d=
a850-lcdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/davinci_all_defconfig/gcc-8/lab-baylibre/baseline-d=
a850-lcdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b27f7425f92f6ba99a=
30f
        new failure (last pass: v4.19.208-62-g0f04201c0ff5) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
fsl-ls1043a-rdb              | arm64  | lab-nxp         | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b30189c80fe776b99a2ef

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls1043a-rdb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls1043a-rdb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b30189c80fe776b99a=
2f0
        new failure (last pass: v4.19.207) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hip07-d05                    | arm64  | lab-collabora   | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b307378e6eb1b9c99a2da

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b307378e6eb1b9c99a=
2db
        new failure (last pass: v4.19.208-56-g99d9199153a6) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-11A-G6-EE-grunt           | x86_64 | lab-collabora   | gcc-8    | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/615b282749d566284f99a2f2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-collab=
ora/baseline-hp-11A-G6-EE-grunt.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-collab=
ora/baseline-hp-11A-G6-EE-grunt.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b282749d566284f99a=
2f3
        new failure (last pass: v4.19.208-62-g0f04201c0ff5) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-12b-n4000-octopus    | x86_64 | lab-collabora   | gcc-8    | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/615b27ad7c1c75331899a2f8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-collab=
ora/baseline-hp-x360-12b-n4000-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-collab=
ora/baseline-hp-x360-12b-n4000-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b27ad7c1c75331899a=
2f9
        new failure (last pass: v4.19.208-62-g0f04201c0ff5) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
i945gsex-qs                  | i386   | lab-clabbe      | gcc-8    | i386_d=
efconfig               | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2807425f92f6ba99a314

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/i386/i386_defconfig/gcc-8/lab-clabbe/baseline-i945gsex-=
qs.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/i386/i386_defconfig/gcc-8/lab-clabbe/baseline-i945gsex-=
qs.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2807425f92f6ba99a=
315
        new failure (last pass: v4.19.208-56-g99d9199153a6) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx6q-sabrelite              | arm    | lab-collabora   | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b281b2a3421ca1e99a2e7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-imx=
6q-sabrelite.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-imx=
6q-sabrelite.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b281b2a3421ca1e99a=
2e8
        new failure (last pass: v4.19.208-62-g0f04201c0ff5) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx6q-var-dt6customboard     | arm    | lab-baylibre    | gcc-8    | imx_v6=
_v7_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2b52bdda2aa4b499a2f1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/imx_v6_v7_defconfig/gcc-8/lab-baylibre/baseline-imx=
6q-var-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/imx_v6_v7_defconfig/gcc-8/lab-baylibre/baseline-imx=
6q-var-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2b52bdda2aa4b499a=
2f2
        new failure (last pass: v4.19.208-56-g99d9199153a6) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx6q-var-dt6customboard     | arm    | lab-baylibre    | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b29fed628a838bc99a2f0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6=
q-var-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6=
q-var-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b29fed628a838bc99a=
2f1
        new failure (last pass: v4.19.208-62-g0f04201c0ff5) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx6sx-sdb                   | arm    | lab-nxp         | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b33dc241e2c1fc699a313

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx6sx-sd=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx6sx-sd=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b33dc241e2c1fc699a=
314
        new failure (last pass: v4.19.208-62-g0f04201c0ff5) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
jetson-tk1                   | arm    | lab-baylibre    | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2c59beaa839b4599a2ec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-jets=
on-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-jets=
on-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2c59beaa839b4599a=
2ed
        new failure (last pass: v4.19.208-62-g0f04201c0ff5) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
jetson-tk1                   | arm    | lab-baylibre    | gcc-8    | tegra_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2f15a04ebbca6599a2e2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/tegra_defconfig/gcc-8/lab-baylibre/baseline-jetson-=
tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/tegra_defconfig/gcc-8/lab-baylibre/baseline-jetson-=
tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2f15a04ebbca6599a=
2e3
        new failure (last pass: v4.19.208-62-g0f04201c0ff5) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
meson-gxl-s905x-libretech-cc | arm64  | lab-clabbe      | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2f15f1bc7fcd8699a303

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm64/defconfig/gcc-8/lab-clabbe/baseline-meson-gxl-s90=
5x-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm64/defconfig/gcc-8/lab-clabbe/baseline-meson-gxl-s90=
5x-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2f15f1bc7fcd8699a=
304
        new failure (last pass: v4.19.208-56-g99d9199153a6) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
meson-gxm-khadas-vim2        | arm64  | lab-baylibre    | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b31ab667472cab999a31c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-k=
hadas-vim2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-k=
hadas-vim2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b31ab667472cab999a=
31d
        new failure (last pass: v4.19.208-56-g99d9199153a6) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
odroid-xu3                   | arm    | lab-collabora   | gcc-8    | exynos=
_defconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/615b5b1570b6e1659799a2da

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: exynos_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/exynos_defconfig/gcc-8/lab-collabora/baseline-odroi=
d-xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/exynos_defconfig/gcc-8/lab-collabora/baseline-odroi=
d-xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b5b1570b6e1659799a=
2db
        new failure (last pass: v4.19.208-62-g0f04201c0ff5) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
odroid-xu3                   | arm    | lab-collabora   | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b531ee605ce496d99a300

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-odr=
oid-xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-odr=
oid-xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b531ee605ce496d99a=
301
        new failure (last pass: v4.19.208-62-g0f04201c0ff5) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
ox820-clouden...lug-series-3 | arm    | lab-baylibre    | gcc-8    | oxnas_=
v6_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b270c4ec402eb6099a2df

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: oxnas_v6_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/oxnas_v6_defconfig/gcc-8/lab-baylibre/baseline-ox82=
0-cloudengines-pogoplug-series-3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/oxnas_v6_defconfig/gcc-8/lab-baylibre/baseline-ox82=
0-cloudengines-pogoplug-series-3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b270c4ec402eb6099a=
2e0
        new failure (last pass: v4.19.208-62-g0f04201c0ff5) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
panda                        | arm    | lab-collabora   | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b28f66e2453c00699a2e3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b28f66e2453c00699a=
2e4
        new failure (last pass: v4.19.208-62-g0f04201c0ff5) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
panda                        | arm    | lab-collabora   | gcc-8    | omap2p=
lus_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2b2ad026e2f77299a2dc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2b2ad026e2f77299a=
2dd
        new failure (last pass: v4.19.208-62-g0f04201c0ff5) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qcom-qdf2400                 | arm64  | lab-linaro-lkft | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2f11f1bc7fcd8699a2f7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm64/defconfig/gcc-8/lab-linaro-lkft/baseline-qcom-qdf=
2400.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm64/defconfig/gcc-8/lab-linaro-lkft/baseline-qcom-qdf=
2400.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2f11f1bc7fcd8699a=
2f8
        new failure (last pass: v4.19.208-56-g99d9199153a6) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm-versatilepb         | arm    | lab-baylibre    | gcc-8    | versat=
ile_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2b033498c6c00a99a2ed

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2b033498c6c00a99a=
2ee
        failing since 320 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm-versatilepb         | arm    | lab-broonie     | gcc-8    | versat=
ile_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/615b304bd95ef7655999a2dc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b304bd95ef7655999a=
2dd
        failing since 320 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm-versatilepb         | arm    | lab-cip         | gcc-8    | versat=
ile_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2e68a265e7ede899a2db

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2e68a265e7ede899a=
2dc
        failing since 320 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm-vexpress-a15        | arm    | lab-baylibre    | gcc-8    | vexpre=
ss_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2986821f2db8e799a2df

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: vexpress_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/vexpress_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-vexpress-a15.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/vexpress_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-vexpress-a15.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2986821f2db8e799a=
2e0
        new failure (last pass: v4.19.208-62-g0f04201c0ff5) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm-vexpress-a15        | arm    | lab-broonie     | gcc-8    | vexpre=
ss_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2d525fd7b1fdb599a2e0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: vexpress_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/vexpress_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-vexpress-a15.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/vexpress_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-vexpress-a15.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2d525fd7b1fdb599a=
2e1
        new failure (last pass: v4.19.208-62-g0f04201c0ff5) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm-vexpress-a15        | arm    | lab-cip         | gcc-8    | vexpre=
ss_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2b9843d4ae61c899a2eb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: vexpress_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/vexpress_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
vexpress-a15.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/vexpress_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
vexpress-a15.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2b9843d4ae61c899a=
2ec
        new failure (last pass: v4.19.208-62-g0f04201c0ff5) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm-vexpress-a9         | arm    | lab-baylibre    | gcc-8    | vexpre=
ss_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b29735848cfada899a2ff

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: vexpress_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/vexpress_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-vexpress-a9.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/vexpress_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-vexpress-a9.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b29735848cfada899a=
300
        new failure (last pass: v4.19.208-62-g0f04201c0ff5) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm-vexpress-a9         | arm    | lab-broonie     | gcc-8    | vexpre=
ss_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2d3e17436af46599a301

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: vexpress_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/vexpress_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-vexpress-a9.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/vexpress_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-vexpress-a9.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2d3e17436af46599a=
302
        new failure (last pass: v4.19.208-62-g0f04201c0ff5) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm-vexpress-a9         | arm    | lab-cip         | gcc-8    | vexpre=
ss_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2ba943d4ae61c899a302

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: vexpress_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/vexpress_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
vexpress-a9.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/vexpress_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
vexpress-a9.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2ba943d4ae61c899a=
303
        new failure (last pass: v4.19.208-62-g0f04201c0ff5) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm-virt-gicv2          | arm    | lab-baylibre    | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2ac81efef5b12d99a2e0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2ac81efef5b12d99a=
2e1
        new failure (last pass: v4.19.208-62-g0f04201c0ff5) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm-virt-gicv2          | arm    | lab-broonie     | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2f0bf1bc7fcd8699a2f1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2f0bf1bc7fcd8699a=
2f2
        new failure (last pass: v4.19.208-62-g0f04201c0ff5) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm-virt-gicv2          | arm    | lab-cip         | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2e378e7492058499a31a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2e378e7492058499a=
31b
        new failure (last pass: v4.19.208-62-g0f04201c0ff5) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm-virt-gicv2-uefi     | arm    | lab-baylibre    | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b29aea09088679899a2da

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b29aea09088679899a=
2db
        new failure (last pass: v4.19.208-62-g0f04201c0ff5) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm-virt-gicv2-uefi     | arm    | lab-broonie     | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2da2713219f86799a2da

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2da2713219f86799a=
2db
        new failure (last pass: v4.19.208-62-g0f04201c0ff5) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm-virt-gicv2-uefi     | arm    | lab-cip         | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2c93bc313360d199a2da

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2c93bc313360d199a=
2db
        new failure (last pass: v4.19.208-62-g0f04201c0ff5) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm-virt-gicv3          | arm    | lab-baylibre    | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2ac63000ea712a99a2ee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2ac63000ea712a99a=
2ef
        new failure (last pass: v4.19.208-62-g0f04201c0ff5) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm-virt-gicv3          | arm    | lab-broonie     | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2ee4adb4747fa099a2e6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2ee4adb4747fa099a=
2e7
        new failure (last pass: v4.19.208-62-g0f04201c0ff5) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm-virt-gicv3          | arm    | lab-cip         | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2d1017436af46599a2dc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2d1017436af46599a=
2dd
        new failure (last pass: v4.19.208-62-g0f04201c0ff5) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm-virt-gicv3-uefi     | arm    | lab-baylibre    | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2a62275ca36f6d99a2f1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2a62275ca36f6d99a=
2f2
        new failure (last pass: v4.19.208-62-g0f04201c0ff5) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm-virt-gicv3-uefi     | arm    | lab-broonie     | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2e92b7961ba41199a2da

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2e92b7961ba41199a=
2db
        new failure (last pass: v4.19.208-62-g0f04201c0ff5) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm-virt-gicv3-uefi     | arm    | lab-cip         | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2cec856cc7493999a30a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2cec856cc7493999a=
30b
        new failure (last pass: v4.19.208-62-g0f04201c0ff5) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-baylibre    | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b31a8cf4e24665899a2f9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm64/defconfig/gcc-8/lab-baylibre/baseline-qemu_arm64-=
virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm64/defconfig/gcc-8/lab-baylibre/baseline-qemu_arm64-=
virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b31a8cf4e24665899a=
2fa
        new failure (last pass: v4.19.208-56-g99d9199153a6) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-broonie     | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b38bddae91c4a2399a2dd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm64/defconfig/gcc-8/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm64/defconfig/gcc-8/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b38bddae91c4a2399a=
2de
        new failure (last pass: v4.19.208-56-g99d9199153a6) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-cip         | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b373cf8374cf62199a306

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm64/defconfig/gcc-8/lab-cip/baseline-qemu_arm64-virt-=
gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm64/defconfig/gcc-8/lab-cip/baseline-qemu_arm64-virt-=
gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b373cf8374cf62199a=
307
        new failure (last pass: v4.19.208-56-g99d9199153a6) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-baylibre    | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b31805142dbc07b99a2f0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm64/defconfig/gcc-8/lab-baylibre/baseline-qemu_arm64-=
virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm64/defconfig/gcc-8/lab-baylibre/baseline-qemu_arm64-=
virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b31805142dbc07b99a=
2f1
        new failure (last pass: v4.19.208-56-g99d9199153a6) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-broonie     | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b38a993679ca47299a303

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm64/defconfig/gcc-8/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm64/defconfig/gcc-8/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b38a993679ca47299a=
304
        new failure (last pass: v4.19.208-56-g99d9199153a6) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-cip         | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b374d17fd4523fc99a2f3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm64/defconfig/gcc-8/lab-cip/baseline-qemu_arm64-virt-=
gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm64/defconfig/gcc-8/lab-cip/baseline-qemu_arm64-virt-=
gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b374d17fd4523fc99a=
2f4
        new failure (last pass: v4.19.208-56-g99d9199153a6) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-baylibre    | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b3069882f15ea4e99a2f9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm64/defconfig/gcc-8/lab-baylibre/baseline-qemu_arm64-=
virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm64/defconfig/gcc-8/lab-baylibre/baseline-qemu_arm64-=
virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b3069882f15ea4e99a=
2fa
        new failure (last pass: v4.19.208-56-g99d9199153a6) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-broonie     | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b374117fd4523fc99a2dd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm64/defconfig/gcc-8/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm64/defconfig/gcc-8/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b374117fd4523fc99a=
2de
        new failure (last pass: v4.19.208-56-g99d9199153a6) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-cip         | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b35e8924e3ea60699a2f6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm64/defconfig/gcc-8/lab-cip/baseline-qemu_arm64-virt-=
gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm64/defconfig/gcc-8/lab-cip/baseline-qemu_arm64-virt-=
gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b35e8924e3ea60699a=
2f7
        new failure (last pass: v4.19.208-56-g99d9199153a6) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-baylibre    | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b306b4767bd491799a2ea

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm64/defconfig/gcc-8/lab-baylibre/baseline-qemu_arm64-=
virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm64/defconfig/gcc-8/lab-baylibre/baseline-qemu_arm64-=
virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b306b4767bd491799a=
2eb
        new failure (last pass: v4.19.208-56-g99d9199153a6) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-broonie     | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b37e127115865c099a2e4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm64/defconfig/gcc-8/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm64/defconfig/gcc-8/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b37e127115865c099a=
2e5
        new failure (last pass: v4.19.208-56-g99d9199153a6) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-cip         | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b37333e3be3c7d899a310

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm64/defconfig/gcc-8/lab-cip/baseline-qemu_arm64-virt-=
gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm64/defconfig/gcc-8/lab-cip/baseline-qemu_arm64-virt-=
gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b37333e3be3c7d899a=
311
        new failure (last pass: v4.19.208-56-g99d9199153a6) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_i386                    | i386   | lab-baylibre    | gcc-8    | i386_d=
efconfig               | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2a8ada2c57ee6299a2e2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i3=
86.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i3=
86.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2a8ada2c57ee6299a=
2e3
        new failure (last pass: v4.19.208-56-g99d9199153a6) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_i386                    | i386   | lab-broonie     | gcc-8    | i386_d=
efconfig               | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2f47dae350859399a2da

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i38=
6.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i38=
6.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2f47dae350859399a=
2db
        new failure (last pass: v4.19.208-56-g99d9199153a6) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_i386                    | i386   | lab-cip         | gcc-8    | i386_d=
efconfig               | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2d4e5fd7b1fdb599a2dd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/i386/i386_defconfig/gcc-8/lab-cip/baseline-qemu_i386.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/i386/i386_defconfig/gcc-8/lab-cip/baseline-qemu_i386.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2d4e5fd7b1fdb599a=
2de
        new failure (last pass: v4.19.208-56-g99d9199153a6) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_i386-uefi               | i386   | lab-baylibre    | gcc-8    | i386_d=
efconfig               | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2ab2da2c57ee6299a2fa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i3=
86-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i3=
86-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2ab2da2c57ee6299a=
2fb
        new failure (last pass: v4.19.208-56-g99d9199153a6) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_i386-uefi               | i386   | lab-broonie     | gcc-8    | i386_d=
efconfig               | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2f3366d3aacc1599a2f3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i38=
6-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i38=
6-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2f3366d3aacc1599a=
2f4
        new failure (last pass: v4.19.208-56-g99d9199153a6) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_i386-uefi               | i386   | lab-cip         | gcc-8    | i386_d=
efconfig               | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2d89bd40dd80a699a3e6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/i386/i386_defconfig/gcc-8/lab-cip/baseline-qemu_i386-ue=
fi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/i386/i386_defconfig/gcc-8/lab-cip/baseline-qemu_i386-ue=
fi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2d89bd40dd80a699a=
3e7
        new failure (last pass: v4.19.208-56-g99d9199153a6) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_x86_64                  | x86_64 | lab-baylibre    | gcc-8    | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/615b26cde7aff657d099a2ee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-baylib=
re/baseline-qemu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-baylib=
re/baseline-qemu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b26cde7aff657d099a=
2ef
        new failure (last pass: v4.19.208-62-g0f04201c0ff5) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_x86_64                  | x86_64 | lab-baylibre    | gcc-8    | x86_64=
_defconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2b1738f94d1cc199a2f0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2b1738f94d1cc199a=
2f1
        new failure (last pass: v4.19.208-62-g0f04201c0ff5) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_x86_64                  | x86_64 | lab-broonie     | gcc-8    | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/615b294141f985073b99a2e2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-brooni=
e/baseline-qemu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-brooni=
e/baseline-qemu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b294141f985073b99a=
2e3
        new failure (last pass: v4.19.208-62-g0f04201c0ff5) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_x86_64                  | x86_64 | lab-broonie     | gcc-8    | x86_64=
_defconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2ffb7675c43fc999a307

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu=
_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu=
_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2ffb7675c43fc999a=
308
        new failure (last pass: v4.19.208-62-g0f04201c0ff5) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_x86_64                  | x86_64 | lab-cip         | gcc-8    | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/615b283c969fe9d20e99a2ea

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-cip/ba=
seline-qemu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-cip/ba=
seline-qemu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b283c969fe9d20e99a=
2eb
        new failure (last pass: v4.19.208-62-g0f04201c0ff5) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_x86_64                  | x86_64 | lab-cip         | gcc-8    | x86_64=
_defconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2ec3c18510d05299a2eb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/x86_64/x86_64_defconfig/gcc-8/lab-cip/baseline-qemu_x86=
_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/x86_64/x86_64_defconfig/gcc-8/lab-cip/baseline-qemu_x86=
_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2ec3c18510d05299a=
2ec
        new failure (last pass: v4.19.208-62-g0f04201c0ff5) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-baylibre    | gcc-8    | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/615b26cbe7aff657d099a2e3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-baylib=
re/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-baylib=
re/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b26cbe7aff657d099a=
2e4
        new failure (last pass: v4.19.208-62-g0f04201c0ff5) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-baylibre    | gcc-8    | x86_64=
_defconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2af18b3b80423f99a2da

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2af18b3b80423f99a=
2db
        new failure (last pass: v4.19.208-62-g0f04201c0ff5) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-broonie     | gcc-8    | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/615b292d832c0ef0d699a30b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-brooni=
e/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-brooni=
e/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b292d832c0ef0d699a=
30c
        new failure (last pass: v4.19.208-62-g0f04201c0ff5) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-broonie     | gcc-8    | x86_64=
_defconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2f97198d9cfbb399a2ef

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu=
_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu=
_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2f97198d9cfbb399a=
2f0
        new failure (last pass: v4.19.208-62-g0f04201c0ff5) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-cip         | gcc-8    | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/615b280070de78a16b99a2f2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-cip/ba=
seline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-cip/ba=
seline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b280070de78a16b99a=
2f3
        new failure (last pass: v4.19.208-62-g0f04201c0ff5) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-cip         | gcc-8    | x86_64=
_defconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2dd99321671cc599a2f3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/x86_64/x86_64_defconfig/gcc-8/lab-cip/baseline-qemu_x86=
_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/x86_64/x86_64_defconfig/gcc-8/lab-cip/baseline-qemu_x86=
_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2dd99321671cc599a=
2f4
        new failure (last pass: v4.19.208-62-g0f04201c0ff5) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
rk3288-rock2-square          | arm    | lab-collabora   | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2b2538f94d1cc199a2fc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-rock2-square.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-rock2-square.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2b2538f94d1cc199a=
2fd
        new failure (last pass: v4.19.208-62-g0f04201c0ff5) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
rk3288-veyron-jaq            | arm    | lab-collabora   | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b493409e15ba7d699a347

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b493409e15ba7d699a=
348
        new failure (last pass: v4.19.208-62-g0f04201c0ff5) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
rk3328-rock64                | arm64  | lab-baylibre    | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2f0609a8f9a2d899a2f0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm64/defconfig/gcc-8/lab-baylibre/baseline-rk3328-rock=
64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm64/defconfig/gcc-8/lab-baylibre/baseline-rk3328-rock=
64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2f0609a8f9a2d899a=
2f1
        new failure (last pass: v4.19.208-56-g99d9199153a6) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
rk3399-gru-kevin             | arm64  | lab-collabora   | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2fd87675c43fc999a2e0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru=
-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru=
-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2fd87675c43fc999a=
2e1
        new failure (last pass: v4.19.208-56-g99d9199153a6) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun50i-a64-bananapi-m64      | arm64  | lab-clabbe      | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b3055882f15ea4e99a2e8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b3055882f15ea4e99a=
2e9
        new failure (last pass: v4.19.208-56-g99d9199153a6) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun50i-a64-pine64-plus       | arm64  | lab-baylibre    | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2f2266d3aacc1599a2ed

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm64/defconfig/gcc-8/lab-baylibre/baseline-sun50i-a64-=
pine64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm64/defconfig/gcc-8/lab-baylibre/baseline-sun50i-a64-=
pine64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2f2266d3aacc1599a=
2ee
        new failure (last pass: v4.19.208-56-g99d9199153a6) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun50i-h5-lib...ch-all-h3-cc | arm64  | lab-baylibre    | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2f53dae350859399a2e5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm64/defconfig/gcc-8/lab-baylibre/baseline-sun50i-h5-l=
ibretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm64/defconfig/gcc-8/lab-baylibre/baseline-sun50i-h5-l=
ibretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2f53dae350859399a=
2e6
        new failure (last pass: v4.19.208-56-g99d9199153a6) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun50i-h5-nanopi-neo-plus2   | arm64  | lab-clabbe      | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2f0209a8f9a2d899a2ea

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-h5-nan=
opi-neo-plus2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-h5-nan=
opi-neo-plus2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2f0209a8f9a2d899a=
2eb
        new failure (last pass: v4.19.208-56-g99d9199153a6) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun50i-h6-pine-h64           | arm64  | lab-clabbe      | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2f1009a8f9a2d899a2fe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-h6-pin=
e-h64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-h6-pin=
e-h64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2f1009a8f9a2d899a=
2ff
        new failure (last pass: v4.19.208-56-g99d9199153a6) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun50i-h6-pine-h64           | arm64  | lab-collabora   | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b3102a09ee73de199a2f3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm64/defconfig/gcc-8/lab-collabora/baseline-sun50i-h6-=
pine-h64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm64/defconfig/gcc-8/lab-collabora/baseline-sun50i-h6-=
pine-h64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b3102a09ee73de199a=
2f4
        new failure (last pass: v4.19.208-56-g99d9199153a6) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun5i-a13-olinuxino-micro    | arm    | lab-baylibre    | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b28f4d8a86566fc99a308

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-sun5=
i-a13-olinuxino-micro.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-sun5=
i-a13-olinuxino-micro.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b28f4d8a86566fc99a=
309
        new failure (last pass: v4.19.208-62-g0f04201c0ff5) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun5i-a13-olinuxino-micro    | arm    | lab-baylibre    | gcc-8    | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2a5d275ca36f6d99a2ea

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/sunxi_defconfig/gcc-8/lab-baylibre/baseline-sun5i-a=
13-olinuxino-micro.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/sunxi_defconfig/gcc-8/lab-baylibre/baseline-sun5i-a=
13-olinuxino-micro.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2a5d275ca36f6d99a=
2eb
        new failure (last pass: v4.19.208-56-g99d9199153a6) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun7i-a20-cubieboard2        | arm    | lab-clabbe      | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2988821f2db8e799a2e5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-clabbe/baseline-sun7i-=
a20-cubieboard2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-clabbe/baseline-sun7i-=
a20-cubieboard2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2988821f2db8e799a=
2e6
        new failure (last pass: v4.19.208-62-g0f04201c0ff5) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun7i-a20-cubieboard2        | arm    | lab-clabbe      | gcc-8    | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2adc39e178f04c99a2f7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/sunxi_defconfig/gcc-8/lab-clabbe/baseline-sun7i-a20=
-cubieboard2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/sunxi_defconfig/gcc-8/lab-clabbe/baseline-sun7i-a20=
-cubieboard2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2adc39e178f04c99a=
2f8
        new failure (last pass: v4.19.208-56-g99d9199153a6) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun7i-a20-olinuxino-lime2    | arm    | lab-baylibre    | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b371f3e3be3c7d899a2e6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-sun7=
i-a20-olinuxino-lime2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-sun7=
i-a20-olinuxino-lime2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b371f3e3be3c7d899a=
2e7
        new failure (last pass: v4.19.208-62-g0f04201c0ff5) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun7i-a20-olinuxino-lime2    | arm    | lab-baylibre    | gcc-8    | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/615b3a544a172427d499a305

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/sunxi_defconfig/gcc-8/lab-baylibre/baseline-sun7i-a=
20-olinuxino-lime2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/sunxi_defconfig/gcc-8/lab-baylibre/baseline-sun7i-a=
20-olinuxino-lime2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b3a544a172427d499a=
306
        new failure (last pass: v4.19.208-56-g99d9199153a6) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-a33-olinuxino          | arm    | lab-clabbe      | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b298aeb44c5a9c999a2ee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-clabbe/baseline-sun8i-=
a33-olinuxino.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-clabbe/baseline-sun8i-=
a33-olinuxino.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b298aeb44c5a9c999a=
2ef
        new failure (last pass: v4.19.208-62-g0f04201c0ff5) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-a33-olinuxino          | arm    | lab-clabbe      | gcc-8    | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2af11efef5b12d99a30f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/sunxi_defconfig/gcc-8/lab-clabbe/baseline-sun8i-a33=
-olinuxino.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/sunxi_defconfig/gcc-8/lab-clabbe/baseline-sun8i-a33=
-olinuxino.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2af11efef5b12d99a=
310
        new failure (last pass: v4.19.208-56-g99d9199153a6) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-a83t-bananapi-m3       | arm    | lab-clabbe      | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b294e35603b7c9f99a300

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-clabbe/baseline-sun8i-=
a83t-bananapi-m3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-clabbe/baseline-sun8i-=
a83t-bananapi-m3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b294e35603b7c9f99a=
301
        new failure (last pass: v4.19.208-62-g0f04201c0ff5) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-a83t-bananapi-m3       | arm    | lab-clabbe      | gcc-8    | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2aa24eeed6d9b299a2f7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/sunxi_defconfig/gcc-8/lab-clabbe/baseline-sun8i-a83=
t-bananapi-m3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/sunxi_defconfig/gcc-8/lab-clabbe/baseline-sun8i-a83=
t-bananapi-m3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2aa24eeed6d9b299a=
2f8
        new failure (last pass: v4.19.208-56-g99d9199153a6) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h2-plus...ch-all-h3-cc | arm    | lab-baylibre    | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2aa24eeed6d9b299a2fa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-sun8=
i-h2-plus-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-sun8=
i-h2-plus-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2aa24eeed6d9b299a=
2fb
        new failure (last pass: v4.19.208-62-g0f04201c0ff5) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h2-plus...ch-all-h3-cc | arm    | lab-baylibre    | gcc-8    | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2bf6b7207b67d499a2e0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/sunxi_defconfig/gcc-8/lab-baylibre/baseline-sun8i-h=
2-plus-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/sunxi_defconfig/gcc-8/lab-baylibre/baseline-sun8i-h=
2-plus-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2bf6b7207b67d499a=
2e1
        new failure (last pass: v4.19.208-56-g99d9199153a6) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h2-plus-orangepi-r1    | arm    | lab-baylibre    | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b28f9832c0ef0d699a2dd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-sun8=
i-h2-plus-orangepi-r1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-sun8=
i-h2-plus-orangepi-r1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b28f9832c0ef0d699a=
2de
        new failure (last pass: v4.19.208-62-g0f04201c0ff5) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h2-plus-orangepi-r1    | arm    | lab-baylibre    | gcc-8    | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2a6051dac67f0d99a2da

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/sunxi_defconfig/gcc-8/lab-baylibre/baseline-sun8i-h=
2-plus-orangepi-r1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/sunxi_defconfig/gcc-8/lab-baylibre/baseline-sun8i-h=
2-plus-orangepi-r1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2a6051dac67f0d99a=
2db
        new failure (last pass: v4.19.208-56-g99d9199153a6) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h2-plus-orangepi-zero  | arm    | lab-baylibre    | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b28f7832c0ef0d699a2da

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-sun8=
i-h2-plus-orangepi-zero.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-sun8=
i-h2-plus-orangepi-zero.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b28f7832c0ef0d699a=
2db
        new failure (last pass: v4.19.208-62-g0f04201c0ff5) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h2-plus-orangepi-zero  | arm    | lab-baylibre    | gcc-8    | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2a749e3732f89299a2da

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/sunxi_defconfig/gcc-8/lab-baylibre/baseline-sun8i-h=
2-plus-orangepi-zero.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/sunxi_defconfig/gcc-8/lab-baylibre/baseline-sun8i-h=
2-plus-orangepi-zero.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2a749e3732f89299a=
2db
        new failure (last pass: v4.19.208-56-g99d9199153a6) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h3-bananapi-m2-plus    | arm    | lab-baylibre    | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b28acb469e23ef999a2f1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-sun8=
i-h3-bananapi-m2-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-sun8=
i-h3-bananapi-m2-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b28acb469e23ef999a=
2f2
        new failure (last pass: v4.19.208-62-g0f04201c0ff5) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h3-bananapi-m2-plus    | arm    | lab-baylibre    | gcc-8    | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2a00d628a838bc99a2f3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/sunxi_defconfig/gcc-8/lab-baylibre/baseline-sun8i-h=
3-bananapi-m2-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/sunxi_defconfig/gcc-8/lab-baylibre/baseline-sun8i-h=
3-bananapi-m2-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2a00d628a838bc99a=
2f4
        new failure (last pass: v4.19.208-56-g99d9199153a6) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre    | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b28be7067be736399a302

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b28be7067be736399a=
303
        new failure (last pass: v4.19.208-62-g0f04201c0ff5) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre    | gcc-8    | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2a13d628a838bc99a308

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/sunxi_defconfig/gcc-8/lab-baylibre/baseline-sun8i-h=
3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/sunxi_defconfig/gcc-8/lab-baylibre/baseline-sun8i-h=
3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2a13d628a838bc99a=
309
        new failure (last pass: v4.19.208-56-g99d9199153a6) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h3-orangepi-pc         | arm    | lab-clabbe      | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b339d252a683c7999a2e2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-clabbe/baseline-sun8i-=
h3-orangepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-clabbe/baseline-sun8i-=
h3-orangepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b339d252a683c7999a=
2e3
        new failure (last pass: v4.19.208-62-g0f04201c0ff5) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h3-orangepi-pc         | arm    | lab-clabbe      | gcc-8    | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/615b3555a6c003d3f899a2f7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/sunxi_defconfig/gcc-8/lab-clabbe/baseline-sun8i-h3-=
orangepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/sunxi_defconfig/gcc-8/lab-clabbe/baseline-sun8i-h3-=
orangepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b3555a6c003d3f899a=
2f8
        new failure (last pass: v4.19.208-56-g99d9199153a6) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-r40-bananapi-m2-ultra  | arm    | lab-clabbe      | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b35e15ff7e96d4999a307

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-clabbe/baseline-sun8i-=
r40-bananapi-m2-ultra.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-clabbe/baseline-sun8i-=
r40-bananapi-m2-ultra.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b35e15ff7e96d4999a=
308
        new failure (last pass: v4.19.208-62-g0f04201c0ff5) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-r40-bananapi-m2-ultra  | arm    | lab-clabbe      | gcc-8    | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/615b3735f8374cf62199a2ef

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/sunxi_defconfig/gcc-8/lab-clabbe/baseline-sun8i-r40=
-bananapi-m2-ultra.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/sunxi_defconfig/gcc-8/lab-clabbe/baseline-sun8i-r40=
-bananapi-m2-ultra.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b3735f8374cf62199a=
2f0
        new failure (last pass: v4.19.208-56-g99d9199153a6) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
tegra124-nyan-big            | arm    | lab-collabora   | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b4872c8248bcd7c99a2da

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-teg=
ra124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-teg=
ra124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b4872c8248bcd7c99a=
2db
        new failure (last pass: v4.19.208-62-g0f04201c0ff5) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
tegra124-nyan-big            | arm    | lab-collabora   | gcc-8    | tegra_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/615b4af13f9f08915299a2fb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/tegra_defconfig/gcc-8/lab-collabora/baseline-tegra1=
24-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm/tegra_defconfig/gcc-8/lab-collabora/baseline-tegra1=
24-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b4af13f9f08915299a=
2fc
        new failure (last pass: v4.19.208-62-g0f04201c0ff5) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
zynqmp-zcu102                | arm64  | lab-cip         | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2f1c66d3aacc1599a2e7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm64/defconfig/gcc-8/lab-cip/baseline-zynqmp-zcu102.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-96-gee3e528d83e9/arm64/defconfig/gcc-8/lab-cip/baseline-zynqmp-zcu102.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2f1c66d3aacc1599a=
2e8
        new failure (last pass: v4.19.208-56-g99d9199153a6) =

 =20
