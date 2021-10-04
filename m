Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45188421656
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 20:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234355AbhJDS0Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 14:26:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238247AbhJDS0X (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Oct 2021 14:26:23 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7763C061746
        for <stable@vger.kernel.org>; Mon,  4 Oct 2021 11:24:33 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id 133so17402892pgb.1
        for <stable@vger.kernel.org>; Mon, 04 Oct 2021 11:24:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=a49+d8jlNaHlEASbf1tiyskMOHvW0inD0X/Qho2LO+s=;
        b=BIFoCpoTi5HH6tCDRtlkOYkukYKLCOvoLLJ2MTkcMMxkveIuhkjFdvRgYOcQ7FFPwv
         /Ei9HEjwiMAtHyi1jaLKAikPjUB2TtXWze+asllCv3WKznKXjAMGhkJ68VxboUUH9I+8
         feDAh1KKKI6R0Lg+xsDCnkd45ziC1K8yPOExGIqzZRn9b/v3EOG0noNZlXa3R1uHnp0p
         /sMI2rlebauJsaCHgo78oHm8K0d4mm7/lZwYnMeKApaICNyfphclHPJdBsTKTfSbeWvO
         koj7sXkwU4QRpQ017QYcP0tGufPg7sJaix3N/V87GYmkuxtJBswAjRVxML9oo29vebIg
         uQoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=a49+d8jlNaHlEASbf1tiyskMOHvW0inD0X/Qho2LO+s=;
        b=uPtJ20pA5U6VZ690POtAsAhXgXBq2D3G9F4UFqXCaw3XDr7JgZQoOMezbofXnijb0h
         XRZ8OcYTLroUBDInz8TwUugVH6tK0DCRnKmaLADO7Fg9mXeZpnECMJSWoFdCL2bC8uYZ
         TpuDWA8oljzpTWEUD+4aQbd933tjrEPY5vycTihcZknfDl4zefgxAKghdtrvlTJs4yY9
         2HloilN4ePYEwiO8nns2UVCioeenC42/xqOYr4Qn1twKw3sD9l4XsyXojX5E02UxNc2k
         RAVxcvqIbZ95EXLYsDr6nWEdoMdZtb+XqZDwAIahBuxleelKYnwu6qMm/xR8+AjpB4mD
         rVVQ==
X-Gm-Message-State: AOAM531ooo7bBQ9bBsjtKAgdBxlvjqDO3Ax1lHDP4ec/K85g04Y0F/pj
        isoDEouachQMn3AhLHR2UmxH2qAYS+WEAz0B
X-Google-Smtp-Source: ABdhPJxWCKYYykn4DYZqg+5rZ2OhnOl6dY+QEXq5X5L/pNB0D+jR0s8Zgb/jKORnbLtx8BuWQHvzYQ==
X-Received: by 2002:a63:5f0d:: with SMTP id t13mr12171419pgb.22.1633371871840;
        Mon, 04 Oct 2021 11:24:31 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p9sm4389266pfh.162.2021.10.04.11.24.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 11:24:31 -0700 (PDT)
Message-ID: <615b46df.1c69fb81.ecc32.be14@mx.google.com>
Date:   Mon, 04 Oct 2021 11:24:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.248-76-g7f6d4fdae68d
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 126 runs,
 116 regressions (v4.14.248-76-g7f6d4fdae68d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 126 runs, 116 regressions (v4.14.248-76-g7=
f6d4fdae68d)

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

beaglebone-black             | arm    | lab-cip         | gcc-8    | omap2p=
lus_defconfig          | 1          =

d2500cc                      | x86_64 | lab-clabbe      | gcc-8    | x86_64=
_defcon...6-chromebook | 1          =

d2500cc                      | x86_64 | lab-clabbe      | gcc-8    | x86_64=
_defconfig             | 1          =

da850-lcdk                   | arm    | lab-baylibre    | gcc-8    | davinc=
i_all_defconfig        | 1          =

fsl-ls1012a-rdb              | arm64  | lab-nxp         | gcc-8    | defcon=
fig                    | 1          =

fsl-ls1043a-rdb              | arm64  | lab-nxp         | gcc-8    | defcon=
fig                    | 1          =

fsl-ls1088a-rdb              | arm64  | lab-nxp         | gcc-8    | defcon=
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

imx6q-sabresd                | arm    | lab-nxp         | gcc-8    | multi_=
v7_defconfig           | 1          =

imx6qp-sabresd               | arm    | lab-nxp         | gcc-8    | imx_v6=
_v7_defconfig          | 1          =

imx6qp-sabresd               | arm    | lab-nxp         | gcc-8    | multi_=
v7_defconfig           | 1          =

imx6sx-sdb                   | arm    | lab-nxp         | gcc-8    | imx_v6=
_v7_defconfig          | 1          =

imx6sx-sdb                   | arm    | lab-nxp         | gcc-8    | multi_=
v7_defconfig           | 1          =

imx6ul-14x14-evk             | arm    | lab-nxp         | gcc-8    | imx_v6=
_v7_defconfig          | 1          =

imx6ul-14x14-evk             | arm    | lab-nxp         | gcc-8    | multi_=
v7_defconfig           | 1          =

imx6ull-14x14-evk            | arm    | lab-nxp         | gcc-8    | imx_v6=
_v7_defconfig          | 1          =

imx7d-sdb                    | arm    | lab-nxp         | gcc-8    | imx_v6=
_v7_defconfig          | 1          =

imx7d-sdb                    | arm    | lab-nxp         | gcc-8    | multi_=
v7_defconfig           | 1          =

jetson-tk1                   | arm    | lab-baylibre    | gcc-8    | multi_=
v7_defconfig           | 1          =

jetson-tk1                   | arm    | lab-baylibre    | gcc-8    | tegra_=
defconfig              | 1          =

meson-gxl-s905x-libretech-cc | arm64  | lab-clabbe      | gcc-8    | defcon=
fig                    | 1          =

odroid-xu3                   | arm    | lab-collabora   | gcc-8    | exynos=
_defconfig             | 1          =

odroid-xu3                   | arm    | lab-collabora   | gcc-8    | multi_=
v7_defconfig           | 1          =

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

qemu_arm-versatilepb         | arm    | lab-collabora   | gcc-8    | versat=
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

qemu_x86_64                  | x86_64 | lab-collabora   | gcc-8    | x86_64=
_defcon...6-chromebook | 1          =

qemu_x86_64                  | x86_64 | lab-collabora   | gcc-8    | x86_64=
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

qemu_x86_64-uefi             | x86_64 | lab-collabora   | gcc-8    | x86_64=
_defcon...6-chromebook | 1          =

qemu_x86_64-uefi             | x86_64 | lab-collabora   | gcc-8    | x86_64=
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

sun8i-h2-plus-orangepi-zero  | arm    | lab-baylibre    | gcc-8    | multi_=
v7_defconfig           | 1          =

sun8i-h2-plus-orangepi-zero  | arm    | lab-baylibre    | gcc-8    | sunxi_=
defconfig              | 1          =

sun8i-h3-bananapi-m2-plus    | arm    | lab-baylibre    | gcc-8    | multi_=
v7_defconfig           | 1          =

sun8i-h3-bananapi-m2-plus    | arm    | lab-baylibre    | gcc-8    | sunxi_=
defconfig              | 1          =

sun8i-h3-orangepi-pc         | arm    | lab-clabbe      | gcc-8    | multi_=
v7_defconfig           | 1          =

sun8i-h3-orangepi-pc         | arm    | lab-clabbe      | gcc-8    | sunxi_=
defconfig              | 1          =

tegra124-nyan-big            | arm    | lab-collabora   | gcc-8    | multi_=
v7_defconfig           | 1          =

tegra124-nyan-big            | arm    | lab-collabora   | gcc-8    | tegra_=
defconfig              | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.248-76-g7f6d4fdae68d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.248-76-g7f6d4fdae68d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7f6d4fdae68d03504a8db861c9b0b7d141fc8e1b =



Test Regressions
---------------- =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C433TA-AJ0005-rammus    | x86_64 | lab-collabora   | gcc-8    | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/615b125943da6d402f99a2fb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-collab=
ora/baseline-asus-C433TA-AJ0005-rammus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-collab=
ora/baseline-asus-C433TA-AJ0005-rammus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b125943da6d402f99a=
2fc
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C523NA-A20057-coral     | x86_64 | lab-collabora   | gcc-8    | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/615b130b46ff97f92f99a307

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-collab=
ora/baseline-asus-C523NA-A20057-coral.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-collab=
ora/baseline-asus-C523NA-A20057-coral.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b130b46ff97f92f99a=
308
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
bcm2836-rpi-2-b              | arm    | lab-collabora   | gcc-8    | bcm283=
5_defconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/615b14daf6861d7c2699a2f8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/bcm2835_defconfig/gcc-8/lab-collabora/baseline-bcm2=
836-rpi-2-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/bcm2835_defconfig/gcc-8/lab-collabora/baseline-bcm2=
836-rpi-2-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b14daf6861d7c2699a=
2f9
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
bcm2836-rpi-2-b              | arm    | lab-collabora   | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b173834eeb2679b99a2dd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-bcm=
2836-rpi-2-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-bcm=
2836-rpi-2-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b173834eeb2679b99a=
2de
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beagle-xm                    | arm    | lab-baylibre    | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b15abb6b5056a9199a2dd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b15abb6b5056a9199a=
2de
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beagle-xm                    | arm    | lab-baylibre    | gcc-8    | omap2p=
lus_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/615b14578e5865b0fd99a304

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b14578e5865b0fd99a=
305
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beaglebone-black             | arm    | lab-cip         | gcc-8    | omap2p=
lus_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/615b146074834f3d4a99a2f4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/omap2plus_defconfig/gcc-8/lab-cip/baseline-beaglebo=
ne-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/omap2plus_defconfig/gcc-8/lab-cip/baseline-beaglebo=
ne-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b146074834f3d4a99a=
2f5
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
d2500cc                      | x86_64 | lab-clabbe      | gcc-8    | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/615b124da58daf4f2499a2eb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe=
/baseline-d2500cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe=
/baseline-d2500cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b124da58daf4f2499a=
2ec
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
d2500cc                      | x86_64 | lab-clabbe      | gcc-8    | x86_64=
_defconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/615b12c525a749c31399a355

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500=
cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500=
cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b12c525a749c31399a=
356
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
da850-lcdk                   | arm    | lab-baylibre    | gcc-8    | davinc=
i_all_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/615b14d105e46df74199a2dd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: davinci_all_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/davinci_all_defconfig/gcc-8/lab-baylibre/baseline-d=
a850-lcdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/davinci_all_defconfig/gcc-8/lab-baylibre/baseline-d=
a850-lcdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b14d105e46df74199a=
2de
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
fsl-ls1012a-rdb              | arm64  | lab-nxp         | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b16f2454ac71c6b99a2f1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls1012a-rdb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls1012a-rdb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b16f2454ac71c6b99a=
2f2
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
fsl-ls1043a-rdb              | arm64  | lab-nxp         | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b16f4454ac71c6b99a2f4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls1043a-rdb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls1043a-rdb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b16f4454ac71c6b99a=
2f5
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
fsl-ls1088a-rdb              | arm64  | lab-nxp         | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b1706454ac71c6b99a2fc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls1088a-rdb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls1088a-rdb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b1706454ac71c6b99a=
2fd
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hip07-d05                    | arm64  | lab-collabora   | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b18437f5da6426699a2f5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b18437f5da6426699a=
2f6
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-11A-G6-EE-grunt           | x86_64 | lab-collabora   | gcc-8    | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/615b1231ea3189fa6999a2f8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-collab=
ora/baseline-hp-11A-G6-EE-grunt.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-collab=
ora/baseline-hp-11A-G6-EE-grunt.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b1231ea3189fa6999a=
2f9
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-12b-n4000-octopus    | x86_64 | lab-collabora   | gcc-8    | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/615b1234ea3189fa6999a301

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-collab=
ora/baseline-hp-x360-12b-n4000-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-collab=
ora/baseline-hp-x360-12b-n4000-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b1234ea3189fa6999a=
302
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
i945gsex-qs                  | i386   | lab-clabbe      | gcc-8    | i386_d=
efconfig               | 1          =


  Details:     https://kernelci.org/test/plan/id/615b138d4474ba1af399a3ee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/i386/i386_defconfig/gcc-8/lab-clabbe/baseline-i945gsex-=
qs.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/i386/i386_defconfig/gcc-8/lab-clabbe/baseline-i945gsex-=
qs.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b138d4474ba1af399a=
3ef
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx6q-sabrelite              | arm    | lab-collabora   | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b19246a306d955c99a2e0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-imx=
6q-sabrelite.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-imx=
6q-sabrelite.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b19246a306d955c99a=
2e1
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx6q-sabresd                | arm    | lab-nxp         | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b1513a290d2248299a2e8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx6q-sab=
resd.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx6q-sab=
resd.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b1513a290d2248299a=
2e9
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx6qp-sabresd               | arm    | lab-nxp         | gcc-8    | imx_v6=
_v7_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/615b1502d46a2c22eb99a2e3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/imx_v6_v7_defconfig/gcc-8/lab-nxp/baseline-imx6qp-s=
abresd.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/imx_v6_v7_defconfig/gcc-8/lab-nxp/baseline-imx6qp-s=
abresd.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b1502d46a2c22eb99a=
2e4
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx6qp-sabresd               | arm    | lab-nxp         | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b16684529def07d99a2e0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx6qp-sa=
bresd.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx6qp-sa=
bresd.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b16684529def07d99a=
2e1
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx6sx-sdb                   | arm    | lab-nxp         | gcc-8    | imx_v6=
_v7_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/615b1509d46a2c22eb99a2f0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/imx_v6_v7_defconfig/gcc-8/lab-nxp/baseline-imx6sx-s=
db.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/imx_v6_v7_defconfig/gcc-8/lab-nxp/baseline-imx6sx-s=
db.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b1509d46a2c22eb99a=
2f1
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx6sx-sdb                   | arm    | lab-nxp         | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b167c294b84250e99a2df

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx6sx-sd=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx6sx-sd=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b167c294b84250e99a=
2e0
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx6ul-14x14-evk             | arm    | lab-nxp         | gcc-8    | imx_v6=
_v7_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/615b14edfb18aead9899a2e6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/imx_v6_v7_defconfig/gcc-8/lab-nxp/baseline-imx6ul-1=
4x14-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/imx_v6_v7_defconfig/gcc-8/lab-nxp/baseline-imx6ul-1=
4x14-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b14edfb18aead9899a=
2e7
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx6ul-14x14-evk             | arm    | lab-nxp         | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b164596e7d5d60699a2e2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx6ul-14=
x14-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx6ul-14=
x14-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b164596e7d5d60699a=
2e3
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx6ull-14x14-evk            | arm    | lab-nxp         | gcc-8    | imx_v6=
_v7_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/615b1505d46a2c22eb99a2ea

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/imx_v6_v7_defconfig/gcc-8/lab-nxp/baseline-imx6ull-=
14x14-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/imx_v6_v7_defconfig/gcc-8/lab-nxp/baseline-imx6ull-=
14x14-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b1505d46a2c22eb99a=
2eb
        new failure (last pass: v4.14.246-124-g4ee8e281f1b2) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx7d-sdb                    | arm    | lab-nxp         | gcc-8    | imx_v6=
_v7_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/615b14f3266847e4f499a2e8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/imx_v6_v7_defconfig/gcc-8/lab-nxp/baseline-imx7d-sd=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/imx_v6_v7_defconfig/gcc-8/lab-nxp/baseline-imx7d-sd=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b14f3266847e4f499a=
2e9
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx7d-sdb                    | arm    | lab-nxp         | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b150be98714817199a2e8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx7d-sdb=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx7d-sdb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b150be98714817199a=
2e9
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
jetson-tk1                   | arm    | lab-baylibre    | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b14cff6861d7c2699a2e8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-jets=
on-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-jets=
on-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b14cff6861d7c2699a=
2e9
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
jetson-tk1                   | arm    | lab-baylibre    | gcc-8    | tegra_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/615b178c4afaf6ee8d99a2e9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/tegra_defconfig/gcc-8/lab-baylibre/baseline-jetson-=
tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/tegra_defconfig/gcc-8/lab-baylibre/baseline-jetson-=
tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b178c4afaf6ee8d99a=
2ea
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
meson-gxl-s905x-libretech-cc | arm64  | lab-clabbe      | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b16da454ac71c6b99a2e5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm64/defconfig/gcc-8/lab-clabbe/baseline-meson-gxl-s90=
5x-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm64/defconfig/gcc-8/lab-clabbe/baseline-meson-gxl-s90=
5x-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b16da454ac71c6b99a=
2e6
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
odroid-xu3                   | arm    | lab-collabora   | gcc-8    | exynos=
_defconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/615b3053882f15ea4e99a2e3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: exynos_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/exynos_defconfig/gcc-8/lab-collabora/baseline-odroi=
d-xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/exynos_defconfig/gcc-8/lab-collabora/baseline-odroi=
d-xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b3053882f15ea4e99a=
2e4
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
odroid-xu3                   | arm    | lab-collabora   | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b364dad926a401a99a2e7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-odr=
oid-xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-odr=
oid-xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b364dad926a401a99a=
2e8
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
panda                        | arm    | lab-collabora   | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b15d0396966809099a2e0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b15d0396966809099a=
2e1
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
panda                        | arm    | lab-collabora   | gcc-8    | omap2p=
lus_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/615b144f74834f3d4a99a2e2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b144f74834f3d4a99a=
2e3
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qcom-qdf2400                 | arm64  | lab-linaro-lkft | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b16c4454ac71c6b99a2df

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm64/defconfig/gcc-8/lab-linaro-lkft/baseline-qcom-qdf=
2400.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm64/defconfig/gcc-8/lab-linaro-lkft/baseline-qcom-qdf=
2400.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b16c4454ac71c6b99a=
2e0
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm-versatilepb         | arm    | lab-baylibre    | gcc-8    | versat=
ile_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/615b14908a8e7f58e899a336

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b14908a8e7f58e899a=
337
        failing since 324 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm-versatilepb         | arm    | lab-broonie     | gcc-8    | versat=
ile_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/615b15f0c81d5d92df99a3d6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b15f0c81d5d92df99a=
3d7
        failing since 324 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm-versatilepb         | arm    | lab-cip         | gcc-8    | versat=
ile_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/615b148c8a8e7f58e899a333

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b148c8a8e7f58e899a=
334
        failing since 324 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm-versatilepb         | arm    | lab-collabora   | gcc-8    | versat=
ile_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2228c154e2e50f99a30d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2228c154e2e50f99a=
30e
        failing since 324 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm-vexpress-a15        | arm    | lab-baylibre    | gcc-8    | vexpre=
ss_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b1649ed254c39aa99a2e5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: vexpress_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/vexpress_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-vexpress-a15.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/vexpress_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-vexpress-a15.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b1649ed254c39aa99a=
2e6
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm-vexpress-a15        | arm    | lab-broonie     | gcc-8    | vexpre=
ss_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b18715b656b45d699a2ec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: vexpress_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/vexpress_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-vexpress-a15.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/vexpress_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-vexpress-a15.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b18715b656b45d699a=
2ed
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm-vexpress-a15        | arm    | lab-cip         | gcc-8    | vexpre=
ss_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b167d363e9d21a499a2e5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: vexpress_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/vexpress_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
vexpress-a15.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/vexpress_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
vexpress-a15.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b167d363e9d21a499a=
2e6
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm-vexpress-a9         | arm    | lab-baylibre    | gcc-8    | vexpre=
ss_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b164bf6e7b5075899a2df

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: vexpress_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/vexpress_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-vexpress-a9.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/vexpress_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-vexpress-a9.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b164bf6e7b5075899a=
2e0
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm-vexpress-a9         | arm    | lab-broonie     | gcc-8    | vexpre=
ss_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b189a5b656b45d699a2f1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: vexpress_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/vexpress_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-vexpress-a9.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/vexpress_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-vexpress-a9.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b189a5b656b45d699a=
2f2
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm-vexpress-a9         | arm    | lab-cip         | gcc-8    | vexpre=
ss_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b17534afaf6ee8d99a2da

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: vexpress_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/vexpress_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
vexpress-a9.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/vexpress_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
vexpress-a9.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b17534afaf6ee8d99a=
2db
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm-virt-gicv2          | arm    | lab-baylibre    | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b1509e98714817199a2e5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b1509e98714817199a=
2e6
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm-virt-gicv2          | arm    | lab-broonie     | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b171daec782deb799a2da

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b171daec782deb799a=
2db
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm-virt-gicv2          | arm    | lab-cip         | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b15c2b6b5056a9199a2e0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b15c2b6b5056a9199a=
2e1
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm-virt-gicv2-uefi     | arm    | lab-baylibre    | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b14e2fb18aead9899a2da

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b14e2fb18aead9899a=
2db
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm-virt-gicv2-uefi     | arm    | lab-broonie     | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b16e1454ac71c6b99a2e8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b16e1454ac71c6b99a=
2e9
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm-virt-gicv2-uefi     | arm    | lab-cip         | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b1500d46a2c22eb99a2df

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b1500d46a2c22eb99a=
2e0
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm-virt-gicv3          | arm    | lab-baylibre    | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b15f9e03ff4c04999a2e9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b15f9e03ff4c04999a=
2ea
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm-virt-gicv3          | arm    | lab-broonie     | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b185d7f5da6426699a2fe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b185d7f5da6426699a=
2ff
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm-virt-gicv3          | arm    | lab-cip         | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b1668363e9d21a499a2e2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b1668363e9d21a499a=
2e3
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm-virt-gicv3-uefi     | arm    | lab-baylibre    | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b14f4fb18aead9899a2f2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b14f4fb18aead9899a=
2f3
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm-virt-gicv3-uefi     | arm    | lab-broonie     | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b16f5454ac71c6b99a2f7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b16f5454ac71c6b99a=
2f8
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm-virt-gicv3-uefi     | arm    | lab-cip         | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b1515a290d2248299a2eb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b1515a290d2248299a=
2ec
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-baylibre    | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b17614afaf6ee8d99a2e0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm64/defconfig/gcc-8/lab-baylibre/baseline-qemu_arm64-=
virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm64/defconfig/gcc-8/lab-baylibre/baseline-qemu_arm64-=
virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b17614afaf6ee8d99a=
2e1
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-broonie     | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b1a17572c922a6399a2fa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm64/defconfig/gcc-8/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm64/defconfig/gcc-8/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b1a17572c922a6399a=
2fb
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-cip         | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b189c5b656b45d699a2f5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm64/defconfig/gcc-8/lab-cip/baseline-qemu_arm64-virt-=
gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm64/defconfig/gcc-8/lab-cip/baseline-qemu_arm64-virt-=
gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b189c5b656b45d699a=
2f6
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-baylibre    | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b16d5294b84250e99a333

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm64/defconfig/gcc-8/lab-baylibre/baseline-qemu_arm64-=
virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm64/defconfig/gcc-8/lab-baylibre/baseline-qemu_arm64-=
virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b16d5294b84250e99a=
334
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-broonie     | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b18fd33ef19b30199a2ee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm64/defconfig/gcc-8/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm64/defconfig/gcc-8/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b18fd33ef19b30199a=
2ef
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-cip         | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b174834eeb2679b99a2e2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm64/defconfig/gcc-8/lab-cip/baseline-qemu_arm64-virt-=
gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm64/defconfig/gcc-8/lab-cip/baseline-qemu_arm64-virt-=
gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b174834eeb2679b99a=
2e3
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-baylibre    | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b16d64529def07d99a2ec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm64/defconfig/gcc-8/lab-baylibre/baseline-qemu_arm64-=
virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm64/defconfig/gcc-8/lab-baylibre/baseline-qemu_arm64-=
virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b16d64529def07d99a=
2ed
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-broonie     | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b19d903a96ee37e99a2fc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm64/defconfig/gcc-8/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm64/defconfig/gcc-8/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b19da03a96ee37e99a=
2fd
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-cip         | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b17d0e06c9b567099a2e5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm64/defconfig/gcc-8/lab-cip/baseline-qemu_arm64-virt-=
gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm64/defconfig/gcc-8/lab-cip/baseline-qemu_arm64-virt-=
gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b17d0e06c9b567099a=
2e6
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-baylibre    | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b17b1ee106bb7d599a2e4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm64/defconfig/gcc-8/lab-baylibre/baseline-qemu_arm64-=
virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm64/defconfig/gcc-8/lab-baylibre/baseline-qemu_arm64-=
virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b17b1ee106bb7d599a=
2e5
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-broonie     | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b1a7a87f5e3ee2f99a307

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm64/defconfig/gcc-8/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm64/defconfig/gcc-8/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b1a7a87f5e3ee2f99a=
308
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-cip         | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b191eb0c27c769d99a2dd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm64/defconfig/gcc-8/lab-cip/baseline-qemu_arm64-virt-=
gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm64/defconfig/gcc-8/lab-cip/baseline-qemu_arm64-virt-=
gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b191eb0c27c769d99a=
2de
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_i386                    | i386   | lab-baylibre    | gcc-8    | i386_d=
efconfig               | 1          =


  Details:     https://kernelci.org/test/plan/id/615b1367cdb983558399a2f6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i3=
86.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i3=
86.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b1367cdb983558399a=
2f7
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_i386                    | i386   | lab-broonie     | gcc-8    | i386_d=
efconfig               | 1          =


  Details:     https://kernelci.org/test/plan/id/615b1529a290d2248299a2f2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i38=
6.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i38=
6.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b1529a290d2248299a=
2f3
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_i386                    | i386   | lab-cip         | gcc-8    | i386_d=
efconfig               | 1          =


  Details:     https://kernelci.org/test/plan/id/615b13707d5a38eb2e99a2e5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/i386/i386_defconfig/gcc-8/lab-cip/baseline-qemu_i386.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/i386/i386_defconfig/gcc-8/lab-cip/baseline-qemu_i386.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b13707d5a38eb2e99a=
2e6
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_i386-uefi               | i386   | lab-baylibre    | gcc-8    | i386_d=
efconfig               | 1          =


  Details:     https://kernelci.org/test/plan/id/615b1369cdb983558399a2fd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i3=
86-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i3=
86-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b1369cdb983558399a=
2fe
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_i386-uefi               | i386   | lab-broonie     | gcc-8    | i386_d=
efconfig               | 1          =


  Details:     https://kernelci.org/test/plan/id/615b1551a290d2248299a33e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i38=
6-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i38=
6-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b1551a290d2248299a=
33f
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_i386-uefi               | i386   | lab-cip         | gcc-8    | i386_d=
efconfig               | 1          =


  Details:     https://kernelci.org/test/plan/id/615b13854474ba1af399a3df

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/i386/i386_defconfig/gcc-8/lab-cip/baseline-qemu_i386-ue=
fi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/i386/i386_defconfig/gcc-8/lab-cip/baseline-qemu_i386-ue=
fi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b13854474ba1af399a=
3e0
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_x86_64                  | x86_64 | lab-baylibre    | gcc-8    | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/615b121236a521a19399a2fd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-baylib=
re/baseline-qemu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-baylib=
re/baseline-qemu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b121236a521a19399a=
2fe
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_x86_64                  | x86_64 | lab-baylibre    | gcc-8    | x86_64=
_defconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/615b1274a5a5f766b899a30f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b1274a5a5f766b899a=
310
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_x86_64                  | x86_64 | lab-broonie     | gcc-8    | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/615b13e8a6b9b0bf0199a2da

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-brooni=
e/baseline-qemu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-brooni=
e/baseline-qemu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b13e8a6b9b0bf0199a=
2db
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_x86_64                  | x86_64 | lab-broonie     | gcc-8    | x86_64=
_defconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/615b141100d429fc7499a2ed

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu=
_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu=
_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b141100d429fc7499a=
2ee
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_x86_64                  | x86_64 | lab-cip         | gcc-8    | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/615b125843da6d402f99a2f8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-cip/ba=
seline-qemu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-cip/ba=
seline-qemu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b125843da6d402f99a=
2f9
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_x86_64                  | x86_64 | lab-cip         | gcc-8    | x86_64=
_defconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/615b1284a5a5f766b899a332

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/x86_64/x86_64_defconfig/gcc-8/lab-cip/baseline-qemu_x86=
_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/x86_64/x86_64_defconfig/gcc-8/lab-cip/baseline-qemu_x86=
_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b1284a5a5f766b899a=
333
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_x86_64                  | x86_64 | lab-collabora   | gcc-8    | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/615b1ef87e41b3d67399a2da

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-collab=
ora/baseline-qemu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-collab=
ora/baseline-qemu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b1ef87e41b3d67399a=
2db
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_x86_64                  | x86_64 | lab-collabora   | gcc-8    | x86_64=
_defconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/615b1f458cc85aba2399a340

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/x86_64/x86_64_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/x86_64/x86_64_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b1f458cc85aba2399a=
341
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-baylibre    | gcc-8    | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/615b1210ea3189fa6999a2de

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-baylib=
re/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-baylib=
re/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b1210ea3189fa6999a=
2df
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-baylibre    | gcc-8    | x86_64=
_defconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/615b1276a5a5f766b899a315

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b1276a5a5f766b899a=
316
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-broonie     | gcc-8    | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/615b13d5d56284df9c99a2fc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-brooni=
e/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-brooni=
e/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b13d5d56284df9c99a=
2fd
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-broonie     | gcc-8    | x86_64=
_defconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/615b14398e5865b0fd99a2f0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu=
_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu=
_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b14398e5865b0fd99a=
2f1
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-cip         | gcc-8    | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/615b1252a58daf4f2499a2f7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-cip/ba=
seline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-cip/ba=
seline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b1252a58daf4f2499a=
2f8
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-cip         | gcc-8    | x86_64=
_defconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/615b12949f8f42a81899a308

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/x86_64/x86_64_defconfig/gcc-8/lab-cip/baseline-qemu_x86=
_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/x86_64/x86_64_defconfig/gcc-8/lab-cip/baseline-qemu_x86=
_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b12949f8f42a81899a=
309
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-collabora   | gcc-8    | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/615b1cca97f1de19a599a2ef

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-collab=
ora/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-collab=
ora/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b1cca97f1de19a599a=
2f0
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-collabora   | gcc-8    | x86_64=
_defconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/615b1fb4643d91781599a312

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/x86_64/x86_64_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/x86_64/x86_64_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b1fb4643d91781599a=
313
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
rk3288-rock2-square          | arm    | lab-collabora   | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b1cd44a962fd6ce99a309

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-rock2-square.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-rock2-square.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b1cd44a962fd6ce99a=
30a
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
rk3288-veyron-jaq            | arm    | lab-collabora   | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b33487e576f764f99a2dd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b33487e576f764f99a=
2de
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
rk3328-rock64                | arm64  | lab-baylibre    | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b16caf6e7b5075899a2e8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm64/defconfig/gcc-8/lab-baylibre/baseline-rk3328-rock=
64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm64/defconfig/gcc-8/lab-baylibre/baseline-rk3328-rock=
64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b16caf6e7b5075899a=
2e9
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
rk3399-gru-kevin             | arm64  | lab-collabora   | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b1a837901e36ae799a2e2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru=
-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru=
-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b1a837901e36ae799a=
2e3
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun50i-a64-bananapi-m64      | arm64  | lab-clabbe      | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b17a2ee106bb7d599a2dd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b17a2ee106bb7d599a=
2de
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun50i-a64-pine64-plus       | arm64  | lab-baylibre    | gcc-8    | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/615b16e5454ac71c6b99a2eb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm64/defconfig/gcc-8/lab-baylibre/baseline-sun50i-a64-=
pine64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm64/defconfig/gcc-8/lab-baylibre/baseline-sun50i-a64-=
pine64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b16e5454ac71c6b99a=
2ec
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun5i-a13-olinuxino-micro    | arm    | lab-baylibre    | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b14f1fb18aead9899a2ec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-sun5=
i-a13-olinuxino-micro.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-sun5=
i-a13-olinuxino-micro.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b14f1fb18aead9899a=
2ed
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun5i-a13-olinuxino-micro    | arm    | lab-baylibre    | gcc-8    | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/615b125c43da6d402f99a30b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/sunxi_defconfig/gcc-8/lab-baylibre/baseline-sun5i-a=
13-olinuxino-micro.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/sunxi_defconfig/gcc-8/lab-baylibre/baseline-sun5i-a=
13-olinuxino-micro.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b125c43da6d402f99a=
30c
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun7i-a20-cubieboard2        | arm    | lab-clabbe      | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b14d2f6861d7c2699a2ee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/multi_v7_defconfig/gcc-8/lab-clabbe/baseline-sun7i-=
a20-cubieboard2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/multi_v7_defconfig/gcc-8/lab-clabbe/baseline-sun7i-=
a20-cubieboard2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b14d2f6861d7c2699a=
2ef
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun7i-a20-cubieboard2        | arm    | lab-clabbe      | gcc-8    | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/615b1252a58daf4f2499a2f4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/sunxi_defconfig/gcc-8/lab-clabbe/baseline-sun7i-a20=
-cubieboard2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/sunxi_defconfig/gcc-8/lab-clabbe/baseline-sun7i-a20=
-cubieboard2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b1252a58daf4f2499a=
2f5
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun7i-a20-olinuxino-lime2    | arm    | lab-baylibre    | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b25363bbda0690599a2ff

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-sun7=
i-a20-olinuxino-lime2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-sun7=
i-a20-olinuxino-lime2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b25363bbda0690599a=
300
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun7i-a20-olinuxino-lime2    | arm    | lab-baylibre    | gcc-8    | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/615b21ed24c80d4b4799a2e0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/sunxi_defconfig/gcc-8/lab-baylibre/baseline-sun7i-a=
20-olinuxino-lime2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/sunxi_defconfig/gcc-8/lab-baylibre/baseline-sun7i-a=
20-olinuxino-lime2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b21ed24c80d4b4799a=
2e1
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-a33-olinuxino          | arm    | lab-clabbe      | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b150ed46a2c22eb99a2f6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/multi_v7_defconfig/gcc-8/lab-clabbe/baseline-sun8i-=
a33-olinuxino.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/multi_v7_defconfig/gcc-8/lab-clabbe/baseline-sun8i-=
a33-olinuxino.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b150ed46a2c22eb99a=
2f7
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-a33-olinuxino          | arm    | lab-clabbe      | gcc-8    | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/615b12669f8f42a81899a2da

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/sunxi_defconfig/gcc-8/lab-clabbe/baseline-sun8i-a33=
-olinuxino.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/sunxi_defconfig/gcc-8/lab-clabbe/baseline-sun8i-a33=
-olinuxino.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b12669f8f42a81899a=
2db
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-a83t-bananapi-m3       | arm    | lab-clabbe      | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b14d3f6861d7c2699a2f2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/multi_v7_defconfig/gcc-8/lab-clabbe/baseline-sun8i-=
a83t-bananapi-m3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/multi_v7_defconfig/gcc-8/lab-clabbe/baseline-sun8i-=
a83t-bananapi-m3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b14d3f6861d7c2699a=
2f3
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-a83t-bananapi-m3       | arm    | lab-clabbe      | gcc-8    | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/615b125343da6d402f99a2e2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/sunxi_defconfig/gcc-8/lab-clabbe/baseline-sun8i-a83=
t-bananapi-m3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/sunxi_defconfig/gcc-8/lab-clabbe/baseline-sun8i-a83=
t-bananapi-m3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b125343da6d402f99a=
2e3
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h2-plus-orangepi-zero  | arm    | lab-baylibre    | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b150985d25049b999a2ed

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-sun8=
i-h2-plus-orangepi-zero.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-sun8=
i-h2-plus-orangepi-zero.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b150985d25049b999a=
2ee
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h2-plus-orangepi-zero  | arm    | lab-baylibre    | gcc-8    | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/615b1272a5a5f766b899a309

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/sunxi_defconfig/gcc-8/lab-baylibre/baseline-sun8i-h=
2-plus-orangepi-zero.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/sunxi_defconfig/gcc-8/lab-baylibre/baseline-sun8i-h=
2-plus-orangepi-zero.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b1272a5a5f766b899a=
30a
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h3-bananapi-m2-plus    | arm    | lab-baylibre    | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b14e4fb18aead9899a2df

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-sun8=
i-h3-bananapi-m2-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-sun8=
i-h3-bananapi-m2-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b14e4fb18aead9899a=
2e0
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h3-bananapi-m2-plus    | arm    | lab-baylibre    | gcc-8    | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/615b124ca58daf4f2499a2e8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/sunxi_defconfig/gcc-8/lab-baylibre/baseline-sun8i-h=
3-bananapi-m2-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/sunxi_defconfig/gcc-8/lab-baylibre/baseline-sun8i-h=
3-bananapi-m2-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b124ca58daf4f2499a=
2e9
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h3-orangepi-pc         | arm    | lab-clabbe      | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b163ad22c3f030f99a2e0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/multi_v7_defconfig/gcc-8/lab-clabbe/baseline-sun8i-=
h3-orangepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/multi_v7_defconfig/gcc-8/lab-clabbe/baseline-sun8i-=
h3-orangepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b163ad22c3f030f99a=
2e1
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h3-orangepi-pc         | arm    | lab-clabbe      | gcc-8    | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/615b13a6d56284df9c99a2db

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/sunxi_defconfig/gcc-8/lab-clabbe/baseline-sun8i-h3-=
orangepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/sunxi_defconfig/gcc-8/lab-clabbe/baseline-sun8i-h3-=
orangepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b13a6d56284df9c99a=
2dc
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
tegra124-nyan-big            | arm    | lab-collabora   | gcc-8    | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/615b25e20b20deb76e99a302

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-teg=
ra124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-teg=
ra124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b25e20b20deb76e99a=
303
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
tegra124-nyan-big            | arm    | lab-collabora   | gcc-8    | tegra_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/615b295641f985073b99a2f8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/tegra_defconfig/gcc-8/lab-collabora/baseline-tegra1=
24-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-g7f6d4fdae68d/arm/tegra_defconfig/gcc-8/lab-collabora/baseline-tegra1=
24-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b295641f985073b99a=
2f9
        new failure (last pass: v4.14.248-46-g2142aa76a52d) =

 =20
