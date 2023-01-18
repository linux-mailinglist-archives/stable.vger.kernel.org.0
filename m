Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 627A3672481
	for <lists+stable@lfdr.de>; Wed, 18 Jan 2023 18:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbjARRKM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Jan 2023 12:10:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231154AbjARRJu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Jan 2023 12:09:50 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ED1A56880
        for <stable@vger.kernel.org>; Wed, 18 Jan 2023 09:09:45 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id jl3so2460635plb.8
        for <stable@vger.kernel.org>; Wed, 18 Jan 2023 09:09:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Yl3o7GTm4dGxaonmHFZQ2icLZd0FhwRvKL3S+OZJKHA=;
        b=TwdbTIjrb0aC1N2lM+5TUuelcDbu2Qh3+JGayCr9+olrYBEUaolHawp3DY73HvUD+w
         pr0XajesV5q7Pwo9G61KlL3iVo2p8XrNyzvxtgQnZTeVlmvNwD8tIa+w1cgL+zvp7p7C
         PLRc+C7gouJpzEnlnvvOCqQ+XKuD/WBZw/Wr6y1EkEyEwR/SuxzlKtCKCmkGm3yKHe2y
         uLNgMpZiyvrM3F4DMkgdW6DhubgN9+eNsFNQf/R65u2kRHJXrneemY63QnZIR+4cE6tw
         11U7NuSzM2rAz2YEgQHLcY/Sc6/x5JUxwSkS+YgQzYK2bo2bjBRHvkL0JRVnFehkJFKe
         uO4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Yl3o7GTm4dGxaonmHFZQ2icLZd0FhwRvKL3S+OZJKHA=;
        b=NBK8Y9fxOLdVF8fD+hX63k7df+nb32GV+QMZ2mxWPpLgKxZoZdSa6/4ZiyEVps4YdF
         JO6PvWyOtucIyxL7j+c3VTD4+Io/iCdthLPjEXux4gw2oc3nqHv7wtk83HM0FqDx2oKj
         KW5n2ajQgqjRIUFQPZLSEaG9zKeiQePbeUivi9G5f7Krd0vMj2iyjRVf0PCi5yLbblkk
         eZDPpqQfMfN7OmVw3bTGQ5RKWkofViIsTqsM+uRC44D4MwoNkBcUOEKbc+HsVF6UMEkx
         STfAHsZNll320ucWA4uy/PRfwEsdqDeLnnlCtjnk137Q0ReLaKUOkkicZaYPMmnff70y
         +ZPA==
X-Gm-Message-State: AFqh2kqISutBZ0PurPeOlKLS544NY0OEU3roNQK0DOWzu6RoyEYzw+pT
        chh4Ebirw2ADVErwV7bs5CVDFZAoVSL7gvBjMbttBQ==
X-Google-Smtp-Source: AMrXdXt1i+2zqDdwPnaOSxI0YZsqwn+IZD4qsvS9AEdlMnnUr4ka1KNq0daMTVBNRnZmbpNyEHABNg==
X-Received: by 2002:a17:90a:4302:b0:219:9da5:40d3 with SMTP id q2-20020a17090a430200b002199da540d3mr8109900pjg.1.1674061782216;
        Wed, 18 Jan 2023 09:09:42 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o10-20020a17090aac0a00b002291295fc2dsm1618465pjq.17.2023.01.18.09.09.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 09:09:41 -0800 (PST)
Message-ID: <63c827d5.170a0220.65ee5.2801@mx.google.com>
Date:   Wed, 18 Jan 2023 09:09:41 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.270
X-Kernelci-Report-Type: test
Subject: stable/linux-4.19.y baseline: 145 runs, 55 regressions (v4.19.270)
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

stable/linux-4.19.y baseline: 145 runs, 55 regressions (v4.19.270)

Regressions Summary
-------------------

platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C433TA-AJ0005-rammus    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

asus-C523NA-A20057-coral     | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

at91sam9g20ek                | arm    | lab-broonie     | gcc-10   | multi_=
v5_defconfig           | 1          =

beaglebone-black             | arm    | lab-broonie     | gcc-10   | multi_=
v7_defconfig           | 1          =

beaglebone-black             | arm    | lab-cip         | gcc-10   | omap2p=
lus_defconfig          | 1          =

cubietruck                   | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =

dove-cubox                   | arm    | lab-pengutronix | gcc-10   | mvebu_=
v7_defconfig           | 1          =

imx6q-sabrelite              | arm    | lab-collabora   | gcc-10   | multi_=
v7_defconfig           | 1          =

imx6qp-wandboard-revd1       | arm    | lab-pengutronix | gcc-10   | imx_v6=
_v7_defconfig          | 1          =

imx6qp-wandboard-revd1       | arm    | lab-pengutronix | gcc-10   | multi_=
v7_defconfig           | 1          =

imx6sx-sdb                   | arm    | lab-nxp         | gcc-10   | multi_=
v7_defconfig           | 1          =

imx7d-sdb                    | arm    | lab-nxp         | gcc-10   | multi_=
v7_defconfig           | 1          =

qemu_arm64-virt-gicv2        | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =

qemu_arm64-virt-gicv2        | arm64  | lab-baylibre    | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv2        | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =

qemu_arm64-virt-gicv2        | arm64  | lab-broonie     | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv2        | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =

qemu_arm64-virt-gicv2        | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64  | lab-baylibre    | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64  | lab-broonie     | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =

qemu_arm64-virt-gicv3        | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =

qemu_arm64-virt-gicv3        | arm64  | lab-baylibre    | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv3        | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =

qemu_arm64-virt-gicv3        | arm64  | lab-broonie     | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv3        | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64  | lab-baylibre    | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64  | lab-broonie     | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =

r8a7743-iwg20d-q7            | arm    | lab-cip         | gcc-10   | shmobi=
le_defconfig           | 1          =

rk3399-gru-kevin             | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 5          =

sun50i-a64-bananapi-m64      | arm64  | lab-clabbe      | gcc-10   | defcon=
fig                    | 1          =

sun50i-a64-pine64-plus       | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =

sun50i-h6-pine-h64           | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =

sun50i-h6-pine-h64           | arm64  | lab-clabbe      | gcc-10   | defcon=
fig                    | 1          =

sun50i-h6-pine-h64           | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =

sun8i-a33-olinuxino          | arm    | lab-clabbe      | gcc-10   | multi_=
v7_defconfig           | 1          =

sun8i-a83t-bananapi-m3       | arm    | lab-clabbe      | gcc-10   | multi_=
v7_defconfig           | 1          =

sun8i-a83t-bananapi-m3       | arm    | lab-clabbe      | gcc-10   | sunxi_=
defconfig              | 1          =

sun8i-h2-plus...ch-all-h3-cc | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =

sun8i-h2-plus...ch-all-h3-cc | arm    | lab-baylibre    | gcc-10   | sunxi_=
defconfig              | 1          =

sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =

sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre    | gcc-10   | sunxi_=
defconfig              | 1          =

sun8i-h3-orangepi-pc         | arm    | lab-clabbe      | gcc-10   | multi_=
v7_defconfig           | 1          =

sun8i-h3-orangepi-pc         | arm    | lab-clabbe      | gcc-10   | sunxi_=
defconfig              | 1          =

zynqmp-zcu102                | arm64  | lab-cip         | gcc-10   | defcon=
fig                    | 1          =

zynqmp-zcu102                | arm64  | lab-cip         | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.270/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.270
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      dc109cc857dc3649a86bd3efc8fabf3a85716dd9 =



Test Regressions
---------------- =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C433TA-AJ0005-rammus    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63c7fd53eaef1a8b8c915ee5

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
433TA-AJ0005-rammus.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
433TA-AJ0005-rammus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63c7fd53eaef1a8b8c915eea
        new failure (last pass: v4.19.269)

    2023-01-18T14:07:58.527704  + set<8>[    9.486519] <LAVA_SIGNAL_ENDRUN =
0_dmesg 8775241_1.4.2.3.1>
    2023-01-18T14:07:58.528411   +x
    2023-01-18T14:07:58.632081  / # #
    2023-01-18T14:07:58.733047  export SHELL=3D/bin/sh
    2023-01-18T14:07:58.733808  #
    2023-01-18T14:07:58.835509  / # export SHELL=3D/bin/sh. /lava-8775241/e=
nvironment
    2023-01-18T14:07:58.836239  =

    2023-01-18T14:07:58.937968  / # . /lava-8775241/environment/lava-877524=
1/bin/lava-test-runner /lava-8775241/1
    2023-01-18T14:07:58.939079  =

    2023-01-18T14:07:58.941073  / # /lava-8775241/bin/lava-test-runner /lav=
a-8775241/1 =

    ... (16 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C523NA-A20057-coral     | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63c80217b9cbd9dd6b915ecd

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
523NA-A20057-coral.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
523NA-A20057-coral.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63c80217b9cbd9dd6b915ed2
        new failure (last pass: v4.19.269)

    2023-01-18T14:28:20.576996  + set +x
    2023-01-18T14:28:20.583558  <8>[   10.584020] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 8775286_1.4.2.3.1>
    2023-01-18T14:28:20.688608  / # #
    2023-01-18T14:28:20.789419  export SHELL=3D/bin/sh
    2023-01-18T14:28:20.789673  #
    2023-01-18T14:28:20.890628  / # export SHELL=3D/bin/sh. /lava-8775286/e=
nvironment
    2023-01-18T14:28:20.890870  =

    2023-01-18T14:28:20.991737  / # . /lava-8775286/environment/lava-877528=
6/bin/lava-test-runner /lava-8775286/1
    2023-01-18T14:28:20.992044  =

    2023-01-18T14:28:20.997008  / # /lava-8775286/bin/lava-test-runner /lav=
a-8775286/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
at91sam9g20ek                | arm    | lab-broonie     | gcc-10   | multi_=
v5_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63c7f76288080da614915eb9

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63c7f76288080da614915ebe
        new failure (last pass: v4.19.268)

    2023-01-18T13:42:46.272387  + set +x
    2023-01-18T13:42:46.277608  <8><LAVA_SIGNAL_ENDRUN 0_dmesg 134578_1.5.2=
.4.1>
    2023-01-18T13:42:46.387999  / # #
    2023-01-18T13:42:46.489839  export SHELL=3D/bin/sh
    2023-01-18T13:42:46.490350  #
    2023-01-18T13:42:46.591585  / # export SHELL=3D/bin/sh. /lava-134578/en=
vironment
    2023-01-18T13:42:46.592113  =

    2023-01-18T13:42:46.693509  / # . /lava-134578/environment/lava-134578/=
bin/lava-test-runner /lava-134578/1
    2023-01-18T13:42:46.694295  =

    2023-01-18T13:42:46.700628  / # /lava-134578/bin/lava-test-runner /lava=
-134578/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beaglebone-black             | arm    | lab-broonie     | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63c7f331627bf328e0915ed8

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-beaglebone-black.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-beaglebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63c7f331627bf328e0915edd
        new failure (last pass: v4.19.269)

    2023-01-18T13:24:46.745926  <8>[   16.780694] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 134564_1.5.2.4.1>
    2023-01-18T13:24:46.852136  / # #
    2023-01-18T13:24:46.954089  export SHELL=3D/bin/sh
    2023-01-18T13:24:46.954760  #
    2023-01-18T13:24:47.056159  / # export SHELL=3D/bin/sh. /lava-134564/en=
vironment
    2023-01-18T13:24:47.057118  =

    2023-01-18T13:24:47.159297  / # . /lava-134564/environment/lava-134564/=
bin/lava-test-runner /lava-134564/1
    2023-01-18T13:24:47.160503  =

    2023-01-18T13:24:47.164862  / # /lava-134564/bin/lava-test-runner /lava=
-134564/1
    2023-01-18T13:24:47.231897  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beaglebone-black             | arm    | lab-cip         | gcc-10   | omap2p=
lus_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/63c7f7e3d8e877866f915ed0

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm/omap2plus_defconfig/gcc-10/lab-cip/baseline-beaglebone-black.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm/omap2plus_defconfig/gcc-10/lab-cip/baseline-beaglebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63c7f7e3d8e877866f915ed3
        new failure (last pass: v4.19.269)

    2023-01-18T13:44:49.874900  + set +x<8>[   10.696451] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 827643_1.5.2.4.1>
    2023-01-18T13:44:49.875396  =

    2023-01-18T13:44:49.989826  / # #
    2023-01-18T13:44:50.092450  export SHELL=3D/bin/sh
    2023-01-18T13:44:50.093121  #
    2023-01-18T13:44:50.194865  / # export SHELL=3D/bin/sh. /lava-827643/en=
vironment
    2023-01-18T13:44:50.195590  =

    2023-01-18T13:44:50.297489  / # . /lava-827643/environment/lava-827643/=
bin/lava-test-runner /lava-827643/1
    2023-01-18T13:44:50.298699  =

    2023-01-18T13:44:50.304586  / # /lava-827643/bin/lava-test-runner /lava=
-827643/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
cubietruck                   | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63c8228df21814319a915ec1

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63c8228df21814319a915ec6
        new failure (last pass: v4.19.268)

    2023-01-18T16:46:38.404776  <8>[    7.454115] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3157892_1.5.2.4.1>
    2023-01-18T16:46:38.518083  / # #
    2023-01-18T16:46:38.620935  export SHELL=3D/bin/sh
    2023-01-18T16:46:38.622257  #
    2023-01-18T16:46:38.724253  / # export SHELL=3D/bin/sh. /lava-3157892/e=
nvironment
    2023-01-18T16:46:38.725332  =

    2023-01-18T16:46:38.829951  / # . /lava-3157892/environment/lava-315789=
2/bin/lava-test-runner /lava-3157892/1
    2023-01-18T16:46:38.831696  =

    2023-01-18T16:46:38.838026  / # /lava-3157892/bin/lava-test-runner /lav=
a-3157892/1
    2023-01-18T16:46:38.913899  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
dove-cubox                   | arm    | lab-pengutronix | gcc-10   | mvebu_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63c7f8f6750b8a39cf915f23

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: mvebu_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm/mvebu_v7_defconfig/gcc-10/lab-pengutronix/baseline-dove-cubox.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm/mvebu_v7_defconfig/gcc-10/lab-pengutronix/baseline-dove-cubox.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63c7f8f6750b8a39cf915f28
        new failure (last pass: v4.19.269)

    2023-01-18T13:49:28.089745  + set +x
    2023-01-18T13:49:28.089911  [    4.231584] <LAVA_SIGNAL_ENDRUN 0_dmesg =
882154_1.5.2.3.1>
    2023-01-18T13:49:28.196498  / # #
    2023-01-18T13:49:28.298196  export SHELL=3D/bin/sh
    2023-01-18T13:49:28.298745  #
    2023-01-18T13:49:28.399999  / # export SHELL=3D/bin/sh. /lava-882154/en=
vironment
    2023-01-18T13:49:28.400500  =

    2023-01-18T13:49:28.501824  / # . /lava-882154/environment/lava-882154/=
bin/lava-test-runner /lava-882154/1
    2023-01-18T13:49:28.502575  =

    2023-01-18T13:49:28.505091  / # /lava-882154/bin/lava-test-runner /lava=
-882154/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx6q-sabrelite              | arm    | lab-collabora   | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63c7f304392919a10b915ee2

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-imx6q-sabrelite.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-imx6q-sabrelite.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63c7f304392919a10b915ee7
        new failure (last pass: v4.19.269)

    2023-01-18T13:24:04.915428  / # #
    2023-01-18T13:24:05.018315  export SHELL=3D/bin/sh
    2023-01-18T13:24:05.019158  #
    2023-01-18T13:24:05.121188  / # export SHELL=3D/bin/sh. /lava-8774836/e=
nvironment
    2023-01-18T13:24:05.122018  =

    2023-01-18T13:24:05.224319  / # . /lava-8774836/environment/lava-877483=
6/bin/lava-test-runner /lava-8774836/1
    2023-01-18T13:24:05.225590  =

    2023-01-18T13:24:05.237810  / # /lava-8774836/bin/lava-test-runner /lav=
a-8774836/1
    2023-01-18T13:24:05.345652  + export 'TESTRUN_ID=3D1_bootrr'
    2023-01-18T13:24:05.346193  + cd /lava-8774836/1/tests/1_bootrr =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx6qp-wandboard-revd1       | arm    | lab-pengutronix | gcc-10   | imx_v6=
_v7_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/63c7f2ca18c9f57b05915ef1

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6qp-wandboard-re=
vd1.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6qp-wandboard-re=
vd1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63c7f2ca18c9f57b05915ef6
        new failure (last pass: v4.19.269)

    2023-01-18T13:23:06.194987  [    7.140910] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2023-01-18T13:23:06.202469  + set +x[    7.151683] <LAVA_SIGNAL_ENDRUN =
0_dmesg 882157_1.5.2.3.1>
    2023-01-18T13:23:06.202626  =

    2023-01-18T13:23:06.310201  / # #
    2023-01-18T13:23:06.414394  export SHELL=3D/bin/sh
    2023-01-18T13:23:06.415118  #
    2023-01-18T13:23:06.522235  / # export SHELL=3D/bin/sh. /lava-882157/en=
vironment
    2023-01-18T13:23:06.524894  =

    2023-01-18T13:23:06.628216  / # . /lava-882157/environment/lava-882157/=
bin/lava-test-runner /lava-882157/1
    2023-01-18T13:23:06.629004   =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx6qp-wandboard-revd1       | arm    | lab-pengutronix | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63c7f308fcee1166e3915edb

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6qp-wandboard-rev=
d1.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6qp-wandboard-rev=
d1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63c7f308fcee1166e3915ee0
        new failure (last pass: v4.19.269)

    2023-01-18T13:24:13.756964  + set +x
    2023-01-18T13:24:13.757140  [    4.894127] <LAVA_SIGNAL_ENDRUN 0_dmesg =
882161_1.5.2.3.1>
    2023-01-18T13:24:13.863370  / # #
    2023-01-18T13:24:13.964808  export SHELL=3D/bin/sh
    2023-01-18T13:24:13.965284  #
    2023-01-18T13:24:14.066672  / # export SHELL=3D/bin/sh. /lava-882161/en=
vironment
    2023-01-18T13:24:14.067028  =

    2023-01-18T13:24:14.168356  / # . /lava-882161/environment/lava-882161/=
bin/lava-test-runner /lava-882161/1
    2023-01-18T13:24:14.168900  =

    2023-01-18T13:24:14.171842  / # /lava-882161/bin/lava-test-runner /lava=
-882161/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx6sx-sdb                   | arm    | lab-nxp         | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63c7f396eb7316e570915eb9

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6sx-sdb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6sx-sdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63c7f396eb7316e570915ebc
        new failure (last pass: v4.19.265)

    2023-01-18T13:26:13.523880  / # #
    2023-01-18T13:26:14.682830  export SHELL=3D/bin/sh
    2023-01-18T13:26:14.688333  #
    2023-01-18T13:26:16.235549  / # export SHELL=3D/bin/sh. /lava-1139673/e=
nvironment
    2023-01-18T13:26:16.241265  =

    2023-01-18T13:26:19.064112  / # . /lava-1139673/environment/lava-113967=
3/bin/lava-test-runner /lava-1139673/1
    2023-01-18T13:26:19.070152  =

    2023-01-18T13:26:19.083439  / # /lava-1139673/bin/lava-test-runner /lav=
a-1139673/1
    2023-01-18T13:26:19.166324  + export 'TESTRUN_ID=3D1_bootrr'
    2023-01-18T13:26:19.166659  + cd /lava-1139673/1/tests/1_bootrr =

    ... (15 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx7d-sdb                    | arm    | lab-nxp         | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63c7f3822cba59cda8915ec3

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sdb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63c7f3822cba59cda8915ec6
        new failure (last pass: v4.19.267)

    2023-01-18T13:25:59.816172  <8>[   12.928909] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 1139674_1.5.2.4.1>
    2023-01-18T13:25:59.921723  / # #
    2023-01-18T13:26:01.082022  export SHELL=3D/bin/sh
    2023-01-18T13:26:01.087735  #
    2023-01-18T13:26:02.635397  / # export SHELL=3D/bin/sh. /lava-1139674/e=
nvironment
    2023-01-18T13:26:02.640891  =

    2023-01-18T13:26:05.463284  / # . /lava-1139674/environment/lava-113967=
4/bin/lava-test-runner /lava-1139674/1
    2023-01-18T13:26:05.469350  =

    2023-01-18T13:26:05.475803  / # /lava-1139674/bin/lava-test-runner /lav=
a-1139674/1
    2023-01-18T13:26:05.576974  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (16 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63c7f43952d08b9be5915ee2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63c7f43952d08b9be5915=
ee3
        failing since 135 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-baylibre    | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63c7f4efa4be887c6b915edd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63c7f4efa4be887c6b915=
ede
        failing since 172 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63c7f806acf3167ad6915eb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63c7f806acf3167ad6915=
eba
        failing since 135 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-broonie     | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63c7fac265aeef1503915ecd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63c7fac365aeef1503915=
ece
        failing since 172 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63c7f36b9fbc310ff6915ebe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63c7f36b9fbc310ff6915=
ebf
        failing since 135 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63c7f4d3b54e05f862915ed3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63c7f4d3b54e05f862915=
ed4
        failing since 172 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63c7f43b2b40b400a1915ee0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63c7f43b2b40b400a1915=
ee1
        failing since 135 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-baylibre    | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63c7f4eea4be887c6b915ed7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63c7f4eea4be887c6b915=
ed8
        failing since 251 days (last pass: v4.19.239, first fail: v4.19.242=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63c7f8ce3eb42d8c65915ece

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63c7f8ce3eb42d8c65915=
ecf
        failing since 135 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-broonie     | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63c7faae8305af8c21915efc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63c7faae8305af8c21915=
efd
        failing since 251 days (last pass: v4.19.239, first fail: v4.19.242=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63c7f36c111875376a915ebf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv2-uefi.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63c7f36c111875376a915=
ec0
        failing since 135 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63c7f437367f69936f915ec2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63c7f437367f69936f915=
ec3
        failing since 135 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-baylibre    | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63c7f501be41e571ca915ed6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63c7f501be41e571ca915=
ed7
        failing since 251 days (last pass: v4.19.239, first fail: v4.19.242=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63c7f72aa6391ddd4f915ed3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63c7f72aa6391ddd4f915=
ed4
        failing since 135 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-broonie     | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63c7fc1768cb0b7c9f915f17

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63c7fc1768cb0b7c9f915=
f18
        failing since 251 days (last pass: v4.19.239, first fail: v4.19.242=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63c7f36348eccf7e12915ec7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63c7f36348eccf7e12915=
ec8
        failing since 135 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63c7f43852d08b9be5915edf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63c7f43852d08b9be5915=
ee0
        failing since 135 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-baylibre    | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63c7f500be41e571ca915ed0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63c7f500be41e571ca915=
ed1
        failing since 251 days (last pass: v4.19.239, first fail: v4.19.242=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63c7f77ad4b060eb6f915ee0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63c7f77ad4b060eb6f915=
ee1
        failing since 135 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-broonie     | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63c7fbc785298656a5915eea

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63c7fbc785298656a5915=
eeb
        failing since 251 days (last pass: v4.19.239, first fail: v4.19.242=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63c7f36485f7d836d3915ec8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv3-uefi.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63c7f36485f7d836d3915=
ec9
        failing since 135 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
r8a7743-iwg20d-q7            | arm    | lab-cip         | gcc-10   | shmobi=
le_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63c7f31f554e20f77b915ec0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63c7f31f554e20f77b915=
ec1
        failing since 53 days (last pass: v4.19.266, first fail: v4.19.267) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
rk3399-gru-kevin             | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 5          =


  Details:     https://kernelci.org/test/plan/id/63c7f64ae25e21c2e8915ebd

  Results:     79 PASS, 9 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/63c7f64ae25e21c2e8915edf
        failing since 307 days (last pass: v4.19.231, first fail: v4.19.235)

    2023-01-18T13:38:08.494493  <8>[   34.841557] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2023-01-18T13:38:09.511169  /lava-8774912/1/../bin/lava-test-case
    2023-01-18T13:38:09.519568  <8>[   35.867090] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =


  * baseline.bootrr.rk3399-gru-sound-driver-rt5514-present: https://kernelc=
i.org/test/case/id/63c7f64ae25e21c2e8915ef4
        new failure (last pass: v4.19.268)

    2023-01-18T13:38:08.002675  	-w	Pa<8>[   34.343828] <LAVA_SIGNAL_TESTCA=
SE TEST_CASE_ID=3Drk3399-gru-sound-driver-max98357A-present RESULT=3Dfail>
    2023-01-18T13:38:08.005641  d to last with leading zeros
    2023-01-18T13:38:08.007890  	-s SEP	String separator
    2023-01-18T13:38:08.011724  /lava-8774912/1/../bin/lava-test-case
    2023-01-18T13:38:08.017508  BusyBox v1.31.1 (2023-01-15 00:20:44 UTC) m=
ulti-call binary.
    2023-01-18T13:38:08.017594  =

    2023-01-18T13:38:08.017840  =

    2023-01-18T13:38:08.031180  Usage: seq [-w] [-s SEP] [FIRST [<8>[   34.=
373105] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drk3399-gru-sound-driver-rt5514=
-present RESULT=3Dfail>   =


  * baseline.bootrr.rk3399-gru-sound-driver-max98357A-present: https://kern=
elci.org/test/case/id/63c7f64ae25e21c2e8915ef5
        new failure (last pass: v4.19.268)

    2023-01-18T13:38:07.978666  ox v1.31.1 (2023-01-15 00:20:44 UTC) multi-=
call binary.
    2023-01-18T13:38:07.979003  =

    2023-01-18T13:38:07.983201  Usage: seq [-w] [-s SEP] [FIRST [INC]] LAST
    2023-01-18T13:38:07.983543  =

    2023-01-18T13:38:07.983621  =

    2023-01-18T13:38:07.988278  Print numbers from FIRST to LAST, in steps =
of INC.
    2023-01-18T13:38:07.988697  =

    2023-01-18T13:38:07.991265  FIRST, INC default to 1.
    2023-01-18T13:38:07.991342     =


  * baseline.bootrr.rk3399-gru-sound-driver-dp-present: https://kernelci.or=
g/test/case/id/63c7f64ae25e21c2e8915ef6
        new failure (last pass: v4.19.268)

    2023-01-18T13:38:07.945543  =

    2023-01-18T13:38:07.950468  Print numbers from FIRST to LAST, in steps =
of INC.
    2023-01-18T13:38:07.952809  FIRST, INC default to 1.
    2023-01-18T13:38:07.953188  =

    2023-01-18T13:38:07.953272  =

    2023-01-18T13:38:07.956438  	-w	Pad to last with leading zeros
    2023-01-18T13:38:07.958836  	-s SEP	String separator
    2023-01-18T13:38:07.962613  /lava-8774912/1/../bin/lava-test-case
    2023-01-18T13:38:07.973192  BusyB<8>[   34.315378] <LAVA_SIGNAL_TESTCAS=
E TEST_CASE_ID=3Drk3399-gru-sound-driver-dp-present RESULT=3Dfail>   =


  * baseline.bootrr.rk3399-gru-sound-driver-da7219-present: https://kernelc=
i.org/test/case/id/63c7f64ae25e21c2e8915ef7
        new failure (last pass: v4.19.268)

    2023-01-18T13:38:07.918519  <8>[   34.264210] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drk3399-gru-sound-driver-present RESULT=3Dpass>
    2023-01-18T13:38:07.930126  BusyBox v1.31.1 (2023-01-15 00:20:44 UTC) m=
ulti-call binary.
    2023-01-18T13:38:07.930510  =

    2023-01-18T13:38:07.930591  =

    2023-01-18T13:38:07.944971  Usage: seq [-w] [-s SEP] [FIRST [INC]] LA<8=
>[   34.284447] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drk3399-gru-sound-drive=
r-da7219-present RESULT=3Dfail>
    2023-01-18T13:38:07.945062  ST   =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun50i-a64-bananapi-m64      | arm64  | lab-clabbe      | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63c7f26ed56144c9bf915ebb

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bananapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bananapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63c7f26ed56144c9bf915ebe
        new failure (last pass: v4.19.268)

    2023-01-18T13:21:26.933229  + set +x
    2023-01-18T13:21:26.935321  <8>[   17.159228] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 381701_1.5.2.4.1>
    2023-01-18T13:21:27.043107  / # #
    2023-01-18T13:21:27.145892  export SHELL=3D/bin/sh
    2023-01-18T13:21:27.146495  #
    2023-01-18T13:21:27.146837  / # export SHELL=3D/bin/sh<3>[   17.345984]=
 brcmfmac: brcmf_sdio_htclk: HT Avail timeout (1000000): clkctl 0x50
    2023-01-18T13:21:27.248418  . /lava-381701/environment
    2023-01-18T13:21:27.249007  =

    2023-01-18T13:21:27.350842  / # . /lava-381701/environment/lava-381701/=
bin/lava-test-runner /lava-381701/1
    2023-01-18T13:21:27.351893   =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun50i-a64-pine64-plus       | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63c7f9ea4f9c407c71915eb9

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pine64-plus.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pine64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63c7f9ea4f9c407c71915ebe
        new failure (last pass: v4.19.268)

    2023-01-18T13:53:29.909462  <8>[   15.911198] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 134487_1.5.2.4.1>
    2023-01-18T13:53:30.016545  / # #
    2023-01-18T13:53:30.119291  export SHELL=3D/bin/sh
    2023-01-18T13:53:30.120022  #
    2023-01-18T13:53:30.222415  / # export SHELL=3D/bin/sh. /lava-134487/en=
vironment
    2023-01-18T13:53:30.223143  =

    2023-01-18T13:53:30.325523  / # . /lava-134487/environment/lava-134487/=
bin/lava-test-runner /lava-134487/1
    2023-01-18T13:53:30.326693  =

    2023-01-18T13:53:30.331244  / # /lava-134487/bin/lava-test-runner /lava=
-134487/1
    2023-01-18T13:53:30.362980  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun50i-h6-pine-h64           | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63c7f27ed56144c9bf915eec

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-h6-pine-h64.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-h6-pine-h64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63c7f27ed56144c9bf915ef1
        new failure (last pass: v4.19.268)

    2023-01-18T13:21:32.961938  / # #
    2023-01-18T13:21:33.063602  export SHELL=3D/bin/sh
    2023-01-18T13:21:33.063951  #
    2023-01-18T13:21:33.165271  / # export SHELL=3D/bin/sh. /lava-3157853/e=
nvironment
    2023-01-18T13:21:33.165632  =

    2023-01-18T13:21:33.266965  / # . /lava-3157853/environment/lava-315785=
3/bin/lava-test-runner /lava-3157853/1
    2023-01-18T13:21:33.267591  =

    2023-01-18T13:21:33.273870  / # /lava-3157853/bin/lava-test-runner /lav=
a-3157853/1
    2023-01-18T13:21:33.343147  + export 'TESTRUN_ID=3D1_bootrr'
    2023-01-18T13:21:33.343628  + cd /lava-3157853<8>[   15.617398] <LAVA_S=
IGNAL_STARTRUN 1_bootrr 3157853_1.5.2.4.5> =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun50i-h6-pine-h64           | arm64  | lab-clabbe      | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63c7f25ae02108ed38915f47

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-pine-h64.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-pine-h64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63c7f25ae02108ed38915f4a
        new failure (last pass: v4.19.268)

    2023-01-18T13:21:16.158232  <8>[   15.163892] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 381700_1.5.2.4.1>
    2023-01-18T13:21:16.265111  / # #
    2023-01-18T13:21:16.367395  export SHELL=3D/bin/sh
    2023-01-18T13:21:16.368107  #
    2023-01-18T13:21:16.469670  / # export SHELL=3D/bin/sh. /lava-381700/en=
vironment
    2023-01-18T13:21:16.470300  =

    2023-01-18T13:21:16.571924  / # . /lava-381700/environment/lava-381700/=
bin/lava-test-runner /lava-381700/1
    2023-01-18T13:21:16.572964  =

    2023-01-18T13:21:16.589178  / # /lava-381700/bin/lava-test-runner /lava=
-381700/1
    2023-01-18T13:21:16.605251  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun50i-h6-pine-h64           | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63c7f26e6c145aa9d4915ed0

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm64/defconfig/gcc-10/lab-collabora/baseline-sun50i-h6-pine-h64.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm64/defconfig/gcc-10/lab-collabora/baseline-sun50i-h6-pine-h64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63c7f26e6c145aa9d4915ed5
        new failure (last pass: v4.19.268)

    2023-01-18T13:21:30.529233  / # #
    2023-01-18T13:21:30.631481  export SHELL=3D/bin/sh
    2023-01-18T13:21:30.632661  #
    2023-01-18T13:21:30.734127  / # export SHELL=3D/bin/sh. /lava-8774817/e=
nvironment
    2023-01-18T13:21:30.735208  =

    2023-01-18T13:21:30.836887  / # . /lava-8774817/environment/lava-877481=
7/bin/lava-test-runner /lava-8774817/1
    2023-01-18T13:21:30.837889  =

    2023-01-18T13:21:30.854334  / # /lava-8774817/bin/lava-test-runner /lav=
a-8774817/1
    2023-01-18T13:21:30.897317  + export 'TESTRUN_ID=3D1_bootrr'
    2023-01-18T13:21:30.913028  + cd /lava-8774817<8>[   15.607858] <LAVA_S=
IGNAL_STARTRUN 1_bootrr 8774817_1.5.2.4.5> =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-a33-olinuxino          | arm    | lab-clabbe      | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63c7f322627bf328e0915ebd

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a33-olinuxino.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a33-olinuxino.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63c7f322627bf328e0915ec0
        new failure (last pass: v4.19.269)

    2023-01-18T13:24:27.405710  <8>[   17.213455] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 381703_1.5.2.4.1>
    2023-01-18T13:24:27.512339  / # #
    2023-01-18T13:24:27.614600  export SHELL=3D/bin/sh
    2023-01-18T13:24:27.615202  #
    2023-01-18T13:24:27.716779  / # export SHELL=3D/bin/sh. /lava-381703/en=
vironment
    2023-01-18T13:24:27.717505  =

    2023-01-18T13:24:27.819097  / # . /lava-381703/environment/lava-381703/=
bin/lava-test-runner /lava-381703/1
    2023-01-18T13:24:27.820167  =

    2023-01-18T13:24:27.836776  / # /lava-381703/bin/lava-test-runner /lava=
-381703/1
    2023-01-18T13:24:27.916949  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-a83t-bananapi-m3       | arm    | lab-clabbe      | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63c7f2f3392919a10b915eb9

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a83t-bananapi-m3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a83t-bananapi-m3.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63c7f2f3392919a10b915ebc
        new failure (last pass: v4.19.258)

    2023-01-18T13:23:40.807752  [    6.241301] <LAVA_SIGNAL_ENDRUN 0_dmesg =
381705_1.5.2.4.1>
    2023-01-18T13:23:40.913043  / # #
    2023-01-18T13:23:41.015023  export SHELL=3D/bin/sh
    2023-01-18T13:23:41.015609  #
    2023-01-18T13:23:41.116957  / # export SHELL=3D/bin/sh. /lava-381705/en=
vironment
    2023-01-18T13:23:41.117531  =

    2023-01-18T13:23:41.218920  / # . /lava-381705/environment/lava-381705/=
bin/lava-test-runner /lava-381705/1
    2023-01-18T13:23:41.219790  =

    2023-01-18T13:23:41.222766  / # /lava-381705/bin/lava-test-runner /lava=
-381705/1
    2023-01-18T13:23:41.302815  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-a83t-bananapi-m3       | arm    | lab-clabbe      | gcc-10   | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/63c7f1dccdb2a4f7b7915ede

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a83t-bananapi-m3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a83t-bananapi-m3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63c7f1dccdb2a4f7b7915ee1
        new failure (last pass: v4.19.258)

    2023-01-18T13:19:13.646573  / # #
    2023-01-18T13:19:13.748510  export SHELL=3D/bin/sh
    2023-01-18T13:19:13.749100  #
    2023-01-18T13:19:13.850443  / # export SHELL=3D/bin/sh. /lava-381699/en=
vironment
    2023-01-18T13:19:13.851007  =

    2023-01-18T13:19:13.952402  / # . /lava-381699/environment/lava-381699/=
bin/lava-test-runner /lava-381699/1
    2023-01-18T13:19:13.953271  =

    2023-01-18T13:19:13.956246  / # /lava-381699/bin/lava-test-runner /lava=
-381699/1
    2023-01-18T13:19:14.047472  + export 'TESTRUN_ID=3D1_bootrr'
    2023-01-18T13:19:14.047776  + cd /lava-381699/1/tests/1_bootrr =

    ... (9 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h2-plus...ch-all-h3-cc | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63c7f30d392919a10b915f0a

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h2-plus-libretech=
-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h2-plus-libretech=
-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63c7f30d392919a10b915f0f
        new failure (last pass: v4.19.269)

    2023-01-18T13:24:13.784901  / # #
    2023-01-18T13:24:13.886623  export SHELL=3D/bin/sh
    2023-01-18T13:24:13.886975  #
    2023-01-18T13:24:13.988359  / # export SHELL=3D/bin/sh. /lava-3157893/e=
nvironment
    2023-01-18T13:24:13.988714  =

    2023-01-18T13:24:14.090081  / # . /lava-3157893/environment/lava-315789=
3/bin/lava-test-runner /lava-3157893/1
    2023-01-18T13:24:14.090750  =

    2023-01-18T13:24:14.096223  / # /lava-3157893/bin/lava-test-runner /lav=
a-3157893/1
    2023-01-18T13:24:14.193182  + export 'TESTRUN_ID=3D1_bootrr'
    2023-01-18T13:24:14.193486  + cd /lava-3157893/1/tests/1_bootrr =

    ... (9 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h2-plus...ch-all-h3-cc | arm    | lab-baylibre    | gcc-10   | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/63c7f20c07a1f527be915ec7

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h2-plus-libretech-al=
l-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h2-plus-libretech-al=
l-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63c7f20c07a1f527be915ecc
        new failure (last pass: v4.19.269)

    2023-01-18T13:19:50.219926  + set +x<8>[    7.852623] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3157823_1.5.2.4.1>
    2023-01-18T13:19:50.220191  =

    2023-01-18T13:19:50.325263  / # #
    2023-01-18T13:19:50.426951  export SHELL=3D/bin/sh
    2023-01-18T13:19:50.427359  #
    2023-01-18T13:19:50.528692  / # export SHELL=3D/bin/sh. /lava-3157823/e=
nvironment
    2023-01-18T13:19:50.529116  =

    2023-01-18T13:19:50.630510  / # . /lava-3157823/environment/lava-315782=
3/bin/lava-test-runner /lava-3157823/1
    2023-01-18T13:19:50.631279  =

    2023-01-18T13:19:50.650641  / # /lava-3157823/bin/lava-test-runner /lav=
a-3157823/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63c7f311836a3cdbdf915ec1

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h3-libretech-all-=
h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h3-libretech-all-=
h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63c7f311836a3cdbdf915ec6
        new failure (last pass: v4.19.269)

    2023-01-18T13:24:03.784290  / # #
    2023-01-18T13:24:03.885956  export SHELL=3D/bin/sh
    2023-01-18T13:24:03.886301  #
    2023-01-18T13:24:03.987607  / # export SHELL=3D/bin/sh. /lava-3157899/e=
nvironment
    2023-01-18T13:24:03.987953  =

    2023-01-18T13:24:04.089275  / # . /lava-3157899/environment/lava-315789=
9/bin/lava-test-runner /lava-3157899/1
    2023-01-18T13:24:04.089871  =

    2023-01-18T13:24:04.095709  / # /lava-3157899/bin/lava-test-runner /lav=
a-3157899/1
    2023-01-18T13:24:04.222626  + export 'TESTRUN_ID=3D1_bootrr'
    2023-01-18T13:24:04.223148  + cd /lava-3157899/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre    | gcc-10   | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/63c7f20aa8cf1caaed915ed3

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h3-libretech-all-h3-=
cc.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h3-libretech-all-h3-=
cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63c7f20aa8cf1caaed915ed8
        new failure (last pass: v4.19.269)

    2023-01-18T13:19:48.011682  <8>[    7.890340] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3157820_1.5.2.4.1>
    2023-01-18T13:19:48.116733  / # #
    2023-01-18T13:19:48.218380  export SHELL=3D/bin/sh
    2023-01-18T13:19:48.218784  #
    2023-01-18T13:19:48.320099  / # export SHELL=3D/bin/sh. /lava-3157820/e=
nvironment
    2023-01-18T13:19:48.320506  =

    2023-01-18T13:19:48.421859  / # . /lava-3157820/environment/lava-315782=
0/bin/lava-test-runner /lava-3157820/1
    2023-01-18T13:19:48.422577  =

    2023-01-18T13:19:48.442323  / # /lava-3157820/bin/lava-test-runner /lav=
a-3157820/1
    2023-01-18T13:19:48.506198  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h3-orangepi-pc         | arm    | lab-clabbe      | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63c7f35ed824daf588915ecb

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-orangepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-orangepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63c7f35ed824daf588915ece
        new failure (last pass: v4.19.269)

    2023-01-18T13:25:21.471963  + set +x
    2023-01-18T13:25:21.473968  <8>[   14.690534] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 381706_1.5.2.4.1>
    2023-01-18T13:25:21.581431  / # #
    2023-01-18T13:25:21.683551  export SHELL=3D/bin/sh
    2023-01-18T13:25:21.684243  #
    2023-01-18T13:25:21.785455  / # export SHELL=3D/bin/sh. /lava-381706/en=
vironment
    2023-01-18T13:25:21.786053  =

    2023-01-18T13:25:21.889885  / # . /lava-381706/environment/lava-381706/=
bin/lava-test-runner /lava-381706/1
    2023-01-18T13:25:21.890851  =

    2023-01-18T13:25:21.898196  / # /lava-381706/bin/lava-test-runner /lava=
-381706/1 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h3-orangepi-pc         | arm    | lab-clabbe      | gcc-10   | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/63c7f247ad01faa668915ec6

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-orangepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-orangepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63c7f247ad01faa668915ec9
        new failure (last pass: v4.19.269)

    2023-01-18T13:20:52.821000  + set +x
    2023-01-18T13:20:52.822995  <8>[   10.315101] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 381695_1.5.2.4.1>
    2023-01-18T13:20:52.930135  / # #
    2023-01-18T13:20:53.032239  export SHELL=3D/bin/sh
    2023-01-18T13:20:53.032800  #
    2023-01-18T13:20:53.134215  / # export SHELL=3D/bin/sh. /lava-381695/en=
vironment
    2023-01-18T13:20:53.134807  =

    2023-01-18T13:20:53.236220  / # . /lava-381695/environment/lava-381695/=
bin/lava-test-runner /lava-381695/1
    2023-01-18T13:20:53.237096  =

    2023-01-18T13:20:53.238643  / # /lava-381695/bin/lava-test-runner /lava=
-381695/1 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
zynqmp-zcu102                | arm64  | lab-cip         | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63c7f245e9c9839682915ebd

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm64/defconfig/gcc-10/lab-cip/baseline-zynqmp-zcu102.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm64/defconfig/gcc-10/lab-cip/baseline-zynqmp-zcu102.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63c7f245e9c9839682915ec0
        new failure (last pass: v4.19.268)

    2023-01-18T13:20:56.013116  + set +x
    2023-01-18T13:20:56.014250  <8>[    3.750225] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 827626_1.5.2.4.1>
    2023-01-18T13:20:56.119787  / # #
    2023-01-18T13:20:56.221715  export SHELL=3D/bin/sh
    2023-01-18T13:20:56.222310  #
    2023-01-18T13:20:56.323764  / # export SHELL=3D/bin/sh. /lava-827626/en=
vironment
    2023-01-18T13:20:56.324218  =

    2023-01-18T13:20:56.425667  / # . /lava-827626/environment/lava-827626/=
bin/lava-test-runner /lava-827626/1
    2023-01-18T13:20:56.426413  =

    2023-01-18T13:20:56.429030  / # /lava-827626/bin/lava-test-runner /lava=
-827626/1 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
zynqmp-zcu102                | arm64  | lab-cip         | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63c7f3adc2b4fb49c3915ebd

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-cip/baseline-zynqmp-zcu102.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.270/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-cip/baseline-zynqmp-zcu102.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63c7f3adc2b4fb49c3915ec0
        new failure (last pass: v4.19.268)

    2023-01-18T13:27:01.611041  + set +x
    2023-01-18T13:27:01.612197  <8>[    3.720301] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 827647_1.5.2.4.1>
    2023-01-18T13:27:01.717658  / # #
    2023-01-18T13:27:01.819578  export SHELL=3D/bin/sh
    2023-01-18T13:27:01.820027  #
    2023-01-18T13:27:01.921381  / # export SHELL=3D/bin/sh. /lava-827647/en=
vironment
    2023-01-18T13:27:01.921825  =

    2023-01-18T13:27:02.023222  / # . /lava-827647/environment/lava-827647/=
bin/lava-test-runner /lava-827647/1
    2023-01-18T13:27:02.023942  =

    2023-01-18T13:27:02.026928  / # /lava-827647/bin/lava-test-runner /lava=
-827647/1 =

    ... (13 line(s) more)  =

 =20
