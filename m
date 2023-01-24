Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F40A6798F0
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 14:09:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233396AbjAXNJZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 08:09:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231749AbjAXNJY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 08:09:24 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F781BB81
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 05:09:20 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id be8so1772967plb.7
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 05:09:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=dCtRoPWa1rNN8f6X6qJy3QIRpLeYS2slhTiVsE4lFk4=;
        b=m224vyfaoztaCJoWfjBtVGTc+6SjDUhBWV5yh7s+Ow8lAs+HeyYmAubYC7Zst5zSqy
         pinr/OTyvB3uMQKz0KemMYFZHc3AXWV6aISR8p8mgiVv3+shzeAtqBO232bNhqo0FvIn
         2Jda6JzSWprOfVIISxiZ681XSRUs3HgUaPSf8uk5PaXM+M9SSmL5sweT8zh+oa85ELEy
         lDbAq/K2wtHx+LnEASc5BryKye/YTk8maEYBm1wvJ3nUM4NQ1gfw/654gS9K2cj1iIiF
         d7BBxokOsLinEWqEx79KBuby6RUxeQQ4CghdzApDN8CCVDiAV1LVcsCZk7CoxlSXULoq
         ch+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dCtRoPWa1rNN8f6X6qJy3QIRpLeYS2slhTiVsE4lFk4=;
        b=jMeFkJOZwIlveLWQEXejZ6MLZAwYZ4LNW9iU7Q/2tKTX4PGfGX2YhTCM5IaDe6pX++
         fgwL3Erxjy9vmkdibjP5VvksU1em3nYBjHiOSB/v4gOZSDF6/C0PSDNh5SprGTZQDvgI
         4PHCzDntpUZcvznAUIVVWSj1hMZHH7da98kpqY8cL/hq53SCwLjoRpwtOeUbuFBxj74i
         7dLZPNsqOcsyRatN3ZzgbC7zBSIcIT/wYv6lMFbukD2aWxur02rk7ml1Nad18y7ylqWp
         YYNnVAvy6VtOLZme+qxJSlmJ72oJNUzuEJoA5ilRvp/2pE++tvt/RIVNLmL4aheDJ1cI
         kWaA==
X-Gm-Message-State: AFqh2kp1CSCL3FQnN3KKs9QYgR2+ESToMcRgfSK+Y22wJCZiEipwOktR
        32grtEXAO7m4CNzPrMkPJJpRkH0ybz3uiAtjYLk=
X-Google-Smtp-Source: AMrXdXtHkuDCEDysRA3roLF1VM5nUCUhESrurteiKP84fR+OsbxqZHXNLOQyXLk4ouKnHAGUtPu7BA==
X-Received: by 2002:a17:902:f70e:b0:194:6c1b:60b9 with SMTP id h14-20020a170902f70e00b001946c1b60b9mr34059358plo.25.1674565757763;
        Tue, 24 Jan 2023 05:09:17 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m5-20020a1709026bc500b00192c5327021sm1598096plt.200.2023.01.24.05.09.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 05:09:17 -0800 (PST)
Message-ID: <63cfd87d.170a0220.7ff21.2996@mx.google.com>
Date:   Tue, 24 Jan 2023 05:09:17 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.271
X-Kernelci-Report-Type: test
Subject: stable/linux-4.19.y baseline: 151 runs, 59 regressions (v4.19.271)
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

stable/linux-4.19.y baseline: 151 runs, 59 regressions (v4.19.271)

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

beagle-xm                    | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =

beagle-xm                    | arm    | lab-baylibre    | gcc-10   | omap2p=
lus_defconfig          | 1          =

beaglebone-black             | arm    | lab-broonie     | gcc-10   | multi_=
v7_defconfig           | 1          =

beaglebone-black             | arm    | lab-cip         | gcc-10   | multi_=
v7_defconfig           | 1          =

beaglebone-black             | arm    | lab-broonie     | gcc-10   | omap2p=
lus_defconfig          | 1          =

cubietruck                   | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =

hip07-d05                    | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =

imx6q-sabrelite              | arm    | lab-collabora   | gcc-10   | multi_=
v7_defconfig           | 1          =

imx6qp-wandboard-revd1       | arm    | lab-pengutronix | gcc-10   | imx_v6=
_v7_defconfig          | 1          =

imx6qp-wandboard-revd1       | arm    | lab-pengutronix | gcc-10   | multi_=
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
fig+arm64-chromebook   | 1          =

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

qemu_arm64-virt-gicv3-uefi   | arm64  | lab-baylibre    | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64  | lab-broonie     | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =

r8a7743-iwg20d-q7            | arm    | lab-cip         | gcc-10   | shmobi=
le_defconfig           | 1          =

rk3288-veyron-jaq            | arm    | lab-collabora   | gcc-10   | multi_=
v7_defconfig           | 3          =

rk3399-gru-kevin             | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 5          =

sun50i-a64-bananapi-m64      | arm64  | lab-clabbe      | gcc-10   | defcon=
fig                    | 1          =

sun50i-a64-pine64-plus       | arm64  | lab-broonie     | gcc-10   | defcon=
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

tegra124-nyan-big            | arm    | lab-collabora   | gcc-10   | multi_=
v7_defconfig           | 1          =

tegra124-nyan-big            | arm    | lab-collabora   | gcc-10   | tegra_=
defconfig              | 1          =

zynqmp-zcu102                | arm64  | lab-cip         | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =

zynqmp-zcu102                | arm64  | lab-cip         | gcc-10   | defcon=
fig                    | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.271/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.271
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      b17faf2c4e88ac0deb894f068bda67ace57e9c0a =



Test Regressions
---------------- =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C433TA-AJ0005-rammus    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfa437000b6369f5915ec1

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
433TA-AJ0005-rammus.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
433TA-AJ0005-rammus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63cfa437000b6369f5915ec6
        failing since 5 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-01-24T09:25:55.052585  + set +x<8>[    9.320616] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 8851597_1.4.2.3.1>
    2023-01-24T09:25:55.052670  =

    2023-01-24T09:25:55.154743  #
    2023-01-24T09:25:55.155092  =

    2023-01-24T09:25:55.256038  / # #export SHELL=3D/bin/sh
    2023-01-24T09:25:55.256252  =

    2023-01-24T09:25:55.357128  / # export SHELL=3D/bin/sh. /lava-8851597/e=
nvironment
    2023-01-24T09:25:55.357342  =

    2023-01-24T09:25:55.458236  / # . /lava-8851597/environment/lava-885159=
7/bin/lava-test-runner /lava-8851597/1
    2023-01-24T09:25:55.458533   =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C523NA-A20057-coral     | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfa5f547fbf7c0b8915ebb

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
523NA-A20057-coral.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
523NA-A20057-coral.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63cfa5f547fbf7c0b8915ec0
        failing since 5 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-01-24T09:33:22.715080  + set +x
    2023-01-24T09:33:22.720685  <8>[   10.738026] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 8851546_1.4.2.3.1>
    2023-01-24T09:33:22.829446  / # #
    2023-01-24T09:33:22.931735  export SHELL=3D/bin/sh
    2023-01-24T09:33:22.932178  #
    2023-01-24T09:33:23.033464  / # export SHELL=3D/bin/sh. /lava-8851546/e=
nvironment
    2023-01-24T09:33:23.034248  =

    2023-01-24T09:33:23.135857  / # . /lava-8851546/environment/lava-885154=
6/bin/lava-test-runner /lava-8851546/1
    2023-01-24T09:33:23.137051  =

    2023-01-24T09:33:23.138934  / # /lava-8851546/bin/lava-test-runner /lav=
a-8851546/1 =

    ... (14 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beagle-xm                    | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfa694fb06ce5f8e915ee4

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63cfa694fb06ce5f8e915ee9
        new failure (last pass: v4.19.268)

    2023-01-24T09:36:05.717967  <8>[   20.950103] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3197580_1.5.2.4.1>
    2023-01-24T09:36:05.827160  / # #
    2023-01-24T09:36:05.930381  export SHELL=3D/bin/sh
    2023-01-24T09:36:05.931527  #
    2023-01-24T09:36:06.033790  / # export SHELL=3D/bin/sh. /lava-3197580/e=
nvironment
    2023-01-24T09:36:06.034697  =

    2023-01-24T09:36:06.136584  / # . /lava-3197580/environment/lava-319758=
0/bin/lava-test-runner /lava-3197580/1
    2023-01-24T09:36:06.137912  =

    2023-01-24T09:36:06.142738  / # /lava-3197580/bin/lava-test-runner /lav=
a-3197580/1
    2023-01-24T09:36:06.234696  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beagle-xm                    | arm    | lab-baylibre    | gcc-10   | omap2p=
lus_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfa60f245129ab1d915ebe

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63cfa60f245129ab1d915ec3
        new failure (last pass: v4.19.268)

    2023-01-24T09:33:32.526287  + set +x<8>[   25.510742] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3197571_1.5.2.4.1>
    2023-01-24T09:33:32.526822  =

    2023-01-24T09:33:32.638691  / # #
    2023-01-24T09:33:32.741126  export SHELL=3D/bin/sh
    2023-01-24T09:33:32.742069  #
    2023-01-24T09:33:32.843988  / # export SHELL=3D/bin/sh. /lava-3197571/e=
nvironment
    2023-01-24T09:33:32.844810  =

    2023-01-24T09:33:32.946759  / # . /lava-3197571/environment/lava-319757=
1/bin/lava-test-runner /lava-3197571/1
    2023-01-24T09:33:32.947940  =

    2023-01-24T09:33:32.953011  / # /lava-3197571/bin/lava-test-runner /lav=
a-3197571/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beaglebone-black             | arm    | lab-broonie     | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfa453aba28ef1bf915edc

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-beaglebone-black.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-beaglebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63cfa453aba28ef1bf915ee1
        failing since 5 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-01-24T09:26:24.670331  <8>[   16.213705] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 163739_1.5.2.4.1>
    2023-01-24T09:26:24.778355  / # #
    2023-01-24T09:26:24.880241  export SHELL=3D/bin/sh
    2023-01-24T09:26:24.880857  #
    2023-01-24T09:26:24.982475  / # export SHELL=3D/bin/sh. /lava-163739/en=
vironment
    2023-01-24T09:26:24.983084  =

    2023-01-24T09:26:25.084861  / # . /lava-163739/environment/lava-163739/=
bin/lava-test-runner /lava-163739/1
    2023-01-24T09:26:25.085657  =

    2023-01-24T09:26:25.088971  / # /lava-163739/bin/lava-test-runner /lava=
-163739/1
    2023-01-24T09:26:25.157865  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beaglebone-black             | arm    | lab-cip         | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfa46b56ee347f5b915ee1

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm/multi_v7_defconfig/gcc-10/lab-cip/baseline-beaglebone-black.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm/multi_v7_defconfig/gcc-10/lab-cip/baseline-beaglebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63cfa46b56ee347f5b915ee4
        failing since 5 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-01-24T09:26:48.569497  + set +x
    2023-01-24T09:26:48.571566  <8>[    9.844162] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 831815_1.5.2.4.1>
    2023-01-24T09:26:48.679697  / # #
    2023-01-24T09:26:48.781640  export SHELL=3D/bin/sh
    2023-01-24T09:26:48.782145  #
    2023-01-24T09:26:48.883549  / # export SHELL=3D/bin/sh. /lava-831815/en=
vironment
    2023-01-24T09:26:48.884080  =

    2023-01-24T09:26:48.985497  / # . /lava-831815/environment/lava-831815/=
bin/lava-test-runner /lava-831815/1
    2023-01-24T09:26:48.986281  =

    2023-01-24T09:26:48.987836  / # /lava-831815/bin/lava-test-runner /lava=
-831815/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beaglebone-black             | arm    | lab-broonie     | gcc-10   | omap2p=
lus_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfa3db6c15f60091915ef0

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beaglebone-black.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beaglebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63cfa3db6c15f60091915ef5
        new failure (last pass: v4.19.270)

    2023-01-24T09:24:26.061688  + set +x<8>[   18.548370] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 163719_1.5.2.4.1>
    2023-01-24T09:24:26.062204  =

    2023-01-24T09:24:26.174000  / # #
    2023-01-24T09:24:26.277717  export SHELL=3D/bin/sh
    2023-01-24T09:24:26.278435  #
    2023-01-24T09:24:26.380876  / # export SHELL=3D/bin/sh. /lava-163719/en=
vironment
    2023-01-24T09:24:26.381596  =

    2023-01-24T09:24:26.483905  / # . /lava-163719/environment/lava-163719/=
bin/lava-test-runner /lava-163719/1
    2023-01-24T09:24:26.485212  =

    2023-01-24T09:24:26.490080  / # /lava-163719/bin/lava-test-runner /lava=
-163719/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
cubietruck                   | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfa7128c50540ac5915eba

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63cfa7128c50540ac5915ebf
        failing since 5 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-01-24T09:37:54.954333  + set +x
    2023-01-24T09:37:54.962985  <8>[    7.357360] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3197586_1.5.2.4.1>
    2023-01-24T09:37:55.070398  / # #
    2023-01-24T09:37:55.172791  export SHELL=3D/bin/sh
    2023-01-24T09:37:55.173715  #
    2023-01-24T09:37:55.280310  / # export SHELL=3D/bin/sh. /lava-3197586/e=
nvironment
    2023-01-24T09:37:55.280701  =

    2023-01-24T09:37:55.381771  / # . /lava-3197586/environment/lava-319758=
6/bin/lava-test-runner /lava-3197586/1
    2023-01-24T09:37:55.382361  =

    2023-01-24T09:37:55.387410  / # /lava-3197586/bin/lava-test-runner /lav=
a-3197586/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hip07-d05                    | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfa4c78270a4936f915f63

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-hip07-d05.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cfa4c78270a4936f915=
f64
        new failure (last pass: v4.19.270) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx6q-sabrelite              | arm    | lab-collabora   | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfa3d96c15f60091915ee2

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-imx6q-sabrelite.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-imx6q-sabrelite.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63cfa3d96c15f60091915ee7
        failing since 5 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-01-24T09:24:25.755171  / # #
    2023-01-24T09:24:25.858041  export SHELL=3D/bin/sh
    2023-01-24T09:24:25.858863  #
    2023-01-24T09:24:25.960566  / # export SHELL=3D/bin/sh. /lava-8851845/e=
nvironment
    2023-01-24T09:24:25.961395  =

    2023-01-24T09:24:26.063298  / # . /lava-8851845/environment/lava-885184=
5/bin/lava-test-runner /lava-8851845/1
    2023-01-24T09:24:26.064563  =

    2023-01-24T09:24:26.078287  / # /lava-8851845/bin/lava-test-runner /lav=
a-8851845/1
    2023-01-24T09:24:26.177302  + export 'TESTRUN_ID=3D1_bootrr'
    2023-01-24T09:24:26.177853  + cd /lava-8851845/1/tests/1_bootrr =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx6qp-wandboard-revd1       | arm    | lab-pengutronix | gcc-10   | imx_v6=
_v7_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfa3a8c46b14bdb1915ebb

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6qp-wandboard-re=
vd1.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6qp-wandboard-re=
vd1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63cfa3a8c46b14bdb1915ec0
        failing since 5 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-01-24T09:23:44.270931  + set +x[    7.122883] <LAVA_SIGNAL_ENDRUN =
0_dmesg 885985_1.5.2.3.1>
    2023-01-24T09:23:44.271097  =

    2023-01-24T09:23:44.378594  / # #
    2023-01-24T09:23:44.480210  export SHELL=3D/bin/sh
    2023-01-24T09:23:44.480660  #
    2023-01-24T09:23:44.582036  / # export SHELL=3D/bin/sh. /lava-885985/en=
vironment
    2023-01-24T09:23:44.582485  =

    2023-01-24T09:23:44.683793  / # . /lava-885985/environment/lava-885985/=
bin/lava-test-runner /lava-885985/1
    2023-01-24T09:23:44.684445  =

    2023-01-24T09:23:44.686867  / # /lava-885985/bin/lava-test-runner /lava=
-885985/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx6qp-wandboard-revd1       | arm    | lab-pengutronix | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfa3e433d46c868b915eda

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6qp-wandboard-rev=
d1.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6qp-wandboard-rev=
d1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63cfa3e433d46c868b915edf
        failing since 5 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-01-24T09:24:44.668569  + set +x
    2023-01-24T09:24:44.668760  [    4.912018] <LAVA_SIGNAL_ENDRUN 0_dmesg =
885988_1.5.2.3.1>
    2023-01-24T09:24:44.775203  / # #
    2023-01-24T09:24:44.877049  export SHELL=3D/bin/sh
    2023-01-24T09:24:44.877681  #
    2023-01-24T09:24:44.979122  / # export SHELL=3D/bin/sh. /lava-885988/en=
vironment
    2023-01-24T09:24:44.979904  =

    2023-01-24T09:24:45.081461  / # . /lava-885988/environment/lava-885988/=
bin/lava-test-runner /lava-885988/1
    2023-01-24T09:24:45.082273  =

    2023-01-24T09:24:45.084337  / # /lava-885988/bin/lava-test-runner /lava=
-885988/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-baylibre    | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfa299cc95edf462915ed3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cfa299cc95edf462915=
ed4
        failing since 256 days (last pass: v4.19.239, first fail: v4.19.242=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfa6acb3e7444049915ec2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cfa6acb3e7444049915=
ec3
        failing since 140 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-broonie     | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfc04ca0a71e2efd915eb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cfc04ca0a71e2efd915=
eba
        failing since 256 days (last pass: v4.19.239, first fail: v4.19.242=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfce73c5e79bea89915ec9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cfce73c5e79bea89915=
eca
        failing since 140 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfa54ec4c5fe29bf915ee6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cfa54ec4c5fe29bf915=
ee7
        failing since 140 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-baylibre    | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfa281fdab46fad2915eda

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cfa281fdab46fad2915=
edb
        failing since 178 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfa69dfb06ce5f8e915ef5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cfa69dfb06ce5f8e915=
ef6
        failing since 256 days (last pass: v4.19.239, first fail: v4.19.242=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-broonie     | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfc1a1887084ca77915ed3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cfc1a1887084ca77915=
ed4
        failing since 178 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfcd1f7490125540915ee3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cfcd1f7490125540915=
ee4
        failing since 256 days (last pass: v4.19.239, first fail: v4.19.242=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfa1f9cf66fb80c6915eb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cfa1f9cf66fb80c6915=
eba
        failing since 178 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-baylibre    | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfa2835e89c6493d916321

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cfa2835e89c6493d916=
322
        failing since 178 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfa69bfb06ce5f8e915ef2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cfa69bfb06ce5f8e915=
ef3
        failing since 256 days (last pass: v4.19.239, first fail: v4.19.242=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-broonie     | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfc1b588b41f2410915ed5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cfc1b588b41f2410915=
ed6
        failing since 178 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfcd0a899281459e915ec6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cfcd0a899281459e915=
ec7
        failing since 256 days (last pass: v4.19.239, first fail: v4.19.242=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfa1faee0634e851915ebd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cfa1faee0634e851915=
ebe
        failing since 178 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-baylibre    | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfa2976838cf5c4a915ec6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cfa2976838cf5c4a915=
ec7
        failing since 178 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfa6993aa34ff265915ebc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cfa6993aa34ff265915=
ebd
        failing since 140 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-broonie     | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfc038db7b45cc00915eca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cfc038db7b45cc00915=
ecb
        failing since 178 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfcbb659265ce1e7915ebf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cfcbb659265ce1e7915=
ec0
        failing since 140 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfa1dc9060cae540915eba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cfa1dc9060cae540915=
ebb
        failing since 178 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfa54df333126a6a915f42

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv3-uefi.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cfa54df333126a6a915=
f43
        failing since 140 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
r8a7743-iwg20d-q7            | arm    | lab-cip         | gcc-10   | shmobi=
le_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfa3e933d46c868b915efe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cfa3e933d46c868b915=
eff
        failing since 59 days (last pass: v4.19.266, first fail: v4.19.267) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
rk3288-veyron-jaq            | arm    | lab-collabora   | gcc-10   | multi_=
v7_defconfig           | 3          =


  Details:     https://kernelci.org/test/plan/id/63cfd4525176aef7ef915edb

  Results:     61 PASS, 8 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.dwhdmi-rockchip-driver-cec-present: https://kernelci.or=
g/test/case/id/63cfd4525176aef7ef915f0b
        failing since 4 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-01-24T12:51:11.642394  BusyBox v1.31.1 (2023-01-20 19:46:12 UTC)<8=
>[   12.481962] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwhdmi-rockchip-driver=
-audio-present RESULT=3Dfail>
    2023-01-24T12:51:11.643610   multi-call binary.
    2023-01-24T12:51:11.644070  =

    2023-01-24T12:51:11.648214  Usage: seq [-w] [-s SEP] [FIRST [INC]] LAST
    2023-01-24T12:51:11.648441  =

    2023-01-24T12:51:11.648934  =

    2023-01-24T12:51:11.653593  Print numbers from FIRST to LAST, in steps =
of INC.
    2023-01-24T12:51:11.663957  FIRST,<8>[   12.500883] <LAVA_SIGNAL_TESTCA=
SE TEST_CASE_ID=3Ddwhdmi-rockchip-driver-cec-present RESULT=3Dfail>   =


  * baseline.bootrr.dwhdmi-rockchip-driver-audio-present: https://kernelci.=
org/test/case/id/63cfd4525176aef7ef915f0c
        failing since 4 days (last pass: v4.19.269, first fail: v4.19.270) =


  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63cfd4525176aef7ef915f1f
        failing since 4 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-01-24T12:51:07.790119  =

    2023-01-24T12:51:07.796879  + <8>[    8.641947] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 8851830_1.5.2.3.1>
    2023-01-24T12:51:07.799071  set +x
    2023-01-24T12:51:07.907277  =

    2023-01-24T12:51:08.010153  / # #export SHELL=3D/bin/sh
    2023-01-24T12:51:08.011096  =

    2023-01-24T12:51:08.113289  / # export SHELL=3D/bin/sh. /lava-8851830/e=
nvironment
    2023-01-24T12:51:08.114193  =

    2023-01-24T12:51:08.216177  / # . /lava-8851830/environment/lava-885183=
0/bin/lava-test-runner /lava-8851830/1
    2023-01-24T12:51:08.217378   =

    ... (22 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
rk3399-gru-kevin             | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 5          =


  Details:     https://kernelci.org/test/plan/id/63cfa76d2750bc838c915ee3

  Results:     79 PASS, 9 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/63cfa76d2750bc838c915f07
        failing since 313 days (last pass: v4.19.231, first fail: v4.19.235)

    2023-01-24T09:39:51.746062  /lava-8851340/1/../bin/lava-test-case
    2023-01-24T09:39:51.753977  <8>[   36.015413] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =


  * baseline.bootrr.rk3399-gru-sound-driver-rt5514-present: https://kernelc=
i.org/test/case/id/63cfa76d2750bc838c915f1c
        failing since 5 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-01-24T09:39:50.240754   [FIRST [INC]] LAST
    2023-01-24T09:39:50.241139  =

    2023-01-24T09:39:50.241849  =

    2023-01-24T09:39:50.246030  Print numbers from FIRST to LAST, in steps =
of INC.
    2023-01-24T09:39:50.248766  FIRST, INC default to 1.
    2023-01-24T09:39:50.249541  =

    2023-01-24T09:39:50.252283  	-w	Pad to last with leading zeros
    2023-01-24T09:39:50.254350  	-s SEP	String separator
    2023-01-24T09:39:50.255081  =

    2023-01-24T09:39:50.268312  /lava-8851340/1/../bin/lava<8>[   34.524091=
] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drk3399-gru-sound-driver-rt5514-prese=
nt RESULT=3Dfail>   =


  * baseline.bootrr.rk3399-gru-sound-driver-max98357A-present: https://kern=
elci.org/test/case/id/63cfa76d2750bc838c915f1d
        failing since 5 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-01-24T09:39:50.216215  =

    2023-01-24T09:39:50.219825  /lava-8851340/1/../bin/lava-test-case
    2023-01-24T09:39:50.226031  BusyBox v1.31.1 (2023-01-20 17:48:38 UTC) m=
ulti-call binary.
    2023-01-24T09:39:50.226466  =

    2023-01-24T09:39:50.238630  Usage: seq [-w] [-s SEP]<8>[   34.493797] <=
LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drk3399-gru-sound-driver-max98357A-prese=
nt RESULT=3Dfail>   =


  * baseline.bootrr.rk3399-gru-sound-driver-dp-present: https://kernelci.or=
g/test/case/id/63cfa76d2750bc838c915f1e
        failing since 5 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-01-24T09:39:50.181814  =

    2023-01-24T09:39:50.182229  =

    2023-01-24T09:39:50.182581  =

    2023-01-24T09:39:50.184724  Usage: seq [-w] [-s SEP] [FIRST [INC]] LAST
    2023-01-24T09:39:50.185207  =

    2023-01-24T09:39:50.189492  Print numbers from FIRST to LAST, in steps =
of INC.
    2023-01-24T09:39:50.192208  FIRST, INC default to 1.
    2023-01-24T09:39:50.192644  =

    2023-01-24T09:39:50.196452  	-w	Pad to last with leading zeros
    2023-01-24T09:39:50.199378  	-s SEP	String separator =

    ... (1 line(s) more)  =


  * baseline.bootrr.rk3399-gru-sound-driver-da7219-present: https://kernelc=
i.org/test/case/id/63cfa76d2750bc838c915f1f
        failing since 5 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-01-24T09:39:50.179619  BusyBox v1.31.1 (2023-01-20 17:48:38 UTC) m=
ulti-call binary.<8>[   34.437979] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drk3=
399-gru-sound-driver-da7219-present RESULT=3Dfail>   =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun50i-a64-bananapi-m64      | arm64  | lab-clabbe      | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfadeb5ab0ec1c7e915ebb

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bananapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bananapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63cfadeb5ab0ec1c7e915ebe
        failing since 5 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-01-24T10:07:11.931775  + set +x
    2023-01-24T10:07:11.937711  <8>[   17.135010] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 384640_1.5.2.4.1>
    2023-01-24T10:07:12.043430  / # #
    2023-01-24T10:07:12.145839  export SHELL=3D/bin/sh
    2023-01-24T10:07:12.146580  #
    2023-01-24T10:07:12.248832  / # export SHELL=3D/bin/sh. /lava-384640/en=
vironment
    2023-01-24T10:07:12.249544  =

    2023-01-24T10:07:12.249805  / # <3>[   17.359067] brcmfmac: brcmf_sdio_=
htclk: HT Avail timeout (1000000): clkctl 0x50
    2023-01-24T10:07:12.351109  . /lava-384640/environment/lava-384640/bin/=
lava-test-runner /lava-384640/1
    2023-01-24T10:07:12.352110   =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun50i-a64-pine64-plus       | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfa6c0122697fe35915eba

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pine64-plus.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pine64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63cfa6c0122697fe35915ebf
        failing since 5 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-01-24T09:36:50.845830  <8>[   15.918055] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 163791_1.5.2.4.1>
    2023-01-24T09:36:50.956214  / # #
    2023-01-24T09:36:51.058940  export SHELL=3D/bin/sh
    2023-01-24T09:36:51.059550  #
    2023-01-24T09:36:51.161856  / # export SHELL=3D/bin/sh. /lava-163791/en=
vironment
    2023-01-24T09:36:51.162597  =

    2023-01-24T09:36:51.264882  / # . /lava-163791/environment/lava-163791/=
bin/lava-test-runner /lava-163791/1
    2023-01-24T09:36:51.266509  =

    2023-01-24T09:36:51.269466  / # /lava-163791/bin/lava-test-runner /lava=
-163791/1
    2023-01-24T09:36:51.301576  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun50i-h6-pine-h64           | arm64  | lab-clabbe      | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfa57848627c01d1915ec1

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-pine-h64.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-pine-h64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63cfa57848627c01d1915ec4
        failing since 5 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-01-24T09:31:20.305069  <8>[   15.166728] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 384638_1.5.2.4.1>
    2023-01-24T09:31:20.411653  / # #
    2023-01-24T09:31:20.513919  export SHELL=3D/bin/sh
    2023-01-24T09:31:20.514508  #
    2023-01-24T09:31:20.616125  / # export SHELL=3D/bin/sh. /lava-384638/en=
vironment
    2023-01-24T09:31:20.616770  =

    2023-01-24T09:31:20.718411  / # . /lava-384638/environment/lava-384638/=
bin/lava-test-runner /lava-384638/1
    2023-01-24T09:31:20.719372  =

    2023-01-24T09:31:20.736017  / # /lava-384638/bin/lava-test-runner /lava=
-384638/1
    2023-01-24T09:31:20.752136  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun50i-h6-pine-h64           | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfa4c841981407d7915ebc

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm64/defconfig/gcc-10/lab-collabora/baseline-sun50i-h6-pine-h64.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm64/defconfig/gcc-10/lab-collabora/baseline-sun50i-h6-pine-h64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63cfa4c841981407d7915ec1
        failing since 5 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-01-24T09:28:24.017439  / # #
    2023-01-24T09:28:24.119492  export SHELL=3D/bin/sh
    2023-01-24T09:28:24.120074  #
    2023-01-24T09:28:24.221590  / # export SHELL=3D/bin/sh. /lava-8851865/e=
nvironment
    2023-01-24T09:28:24.222215  =

    2023-01-24T09:28:24.323616  / # . /lava-8851865/environment/lava-885186=
5/bin/lava-test-runner /lava-8851865/1
    2023-01-24T09:28:24.324506  =

    2023-01-24T09:28:24.340709  / # /lava-8851865/bin/lava-test-runner /lav=
a-8851865/1
    2023-01-24T09:28:24.385038  + export 'TESTRUN_ID=3D1_bootrr'
    2023-01-24T09:28:24.399832  + cd /lava-8851865<8>[   15.629570] <LAVA_S=
IGNAL_STARTRUN 1_bootrr 8851865_1.5.2.4.5> =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-a33-olinuxino          | arm    | lab-clabbe      | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfc9a6a632f94545915ed0

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a33-olinuxino.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a33-olinuxino.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63cfc9a6a632f94545915ed3
        failing since 5 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-01-24T12:05:28.923721  / # #
    2023-01-24T12:05:29.026185  export SHELL=3D/bin/sh
    2023-01-24T12:05:29.026939  #
    2023-01-24T12:05:29.128562  / # export SHELL=3D/bin/sh. /lava-384635/en=
vironment
    2023-01-24T12:05:29.129231  =

    2023-01-24T12:05:29.230894  / # . /lava-384635/environment/lava-384635/=
bin/lava-test-runner /lava-384635/1
    2023-01-24T12:05:29.231906  =

    2023-01-24T12:05:29.245909  / # /lava-384635/bin/lava-test-runner /lava=
-384635/1
    2023-01-24T12:05:29.373906  + export 'TESTRUN_ID=3D1_bootrr'
    2023-01-24T12:05:29.374392  + cd /lava-384635/1/tests/1_bootrr =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-a83t-bananapi-m3       | arm    | lab-clabbe      | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfa3f23944769ed5915ecb

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a83t-bananapi-m3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a83t-bananapi-m3.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63cfa3f23944769ed5915ece
        failing since 5 days (last pass: v4.19.258, first fail: v4.19.270)

    2023-01-24T09:24:45.181477  / # #
    2023-01-24T09:24:45.283457  export SHELL=3D/bin/sh
    2023-01-24T09:24:45.284079  #
    2023-01-24T09:24:45.385424  / # export SHELL=3D/bin/sh. /lava-384632/en=
vironment
    2023-01-24T09:24:45.386046  =

    2023-01-24T09:24:45.487401  / # . /lava-384632/environment/lava-384632/=
bin/lava-test-runner /lava-384632/1
    2023-01-24T09:24:45.488243  =

    2023-01-24T09:24:45.491921  / # /lava-384632/bin/lava-test-runner /lava=
-384632/1
    2023-01-24T09:24:45.609014  + export 'TESTRUN_ID=3D1_bootrr'
    2023-01-24T09:24:45.609630  + cd /lava-384632/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-a83t-bananapi-m3       | arm    | lab-clabbe      | gcc-10   | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfa3a2ff8b59a546915ee1

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a83t-bananapi-m3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a83t-bananapi-m3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63cfa3a2ff8b59a546915ee4
        failing since 5 days (last pass: v4.19.258, first fail: v4.19.270)

    2023-01-24T09:23:35.306739  [    4.640446] <LAVA_SIGNAL_ENDRUN 0_dmesg =
384631_1.5.2.4.1>
    2023-01-24T09:23:35.413484  / # #
    2023-01-24T09:23:35.515839  export SHELL=3D/bin/sh
    2023-01-24T09:23:35.516621  #
    2023-01-24T09:23:35.618137  / # export SHELL=3D/bin/sh. /lava-384631/en=
vironment
    2023-01-24T09:23:35.618755  =

    2023-01-24T09:23:35.720381  / # . /lava-384631/environment/lava-384631/=
bin/lava-test-runner /lava-384631/1
    2023-01-24T09:23:35.721387  =

    2023-01-24T09:23:35.737319  / # /lava-384631/bin/lava-test-runner /lava=
-384631/1
    2023-01-24T09:23:35.817557  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h2-plus...ch-all-h3-cc | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfa3e433d46c868b915ecf

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h2-plus-libretech=
-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h2-plus-libretech=
-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63cfa3e433d46c868b915ed4
        failing since 5 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-01-24T09:24:21.552226  / # #
    2023-01-24T09:24:21.654150  export SHELL=3D/bin/sh
    2023-01-24T09:24:21.654677  #
    2023-01-24T09:24:21.756045  / # export SHELL=3D/bin/sh. /lava-3197582/e=
nvironment
    2023-01-24T09:24:21.756536  =

    2023-01-24T09:24:21.857943  / # . /lava-3197582/environment/lava-319758=
2/bin/lava-test-runner /lava-3197582/1
    2023-01-24T09:24:21.858751  =

    2023-01-24T09:24:21.863419  / # /lava-3197582/bin/lava-test-runner /lav=
a-3197582/1
    2023-01-24T09:24:21.960314  + export 'TESTRUN_ID=3D1_bootrr'
    2023-01-24T09:24:21.960809  + cd /lava-3197582/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h2-plus...ch-all-h3-cc | arm    | lab-baylibre    | gcc-10   | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfa35937955af3bf915eb9

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h2-plus-libretech-al=
l-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h2-plus-libretech-al=
l-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63cfa35937955af3bf915ebe
        failing since 5 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-01-24T09:21:58.544305  <8>[    7.852753] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2023-01-24T09:21:58.544573  + set +x
    2023-01-24T09:21:58.546587  <8>[    7.862503] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3197564_1.5.2.4.1>
    2023-01-24T09:21:58.652525  / # #
    2023-01-24T09:21:58.754286  export SHELL=3D/bin/sh
    2023-01-24T09:21:58.754664  #
    2023-01-24T09:21:58.856064  / # export SHELL=3D/bin/sh. /lava-3197564/e=
nvironment
    2023-01-24T09:21:58.856420  =

    2023-01-24T09:21:58.957805  / # . /lava-3197564/environment/lava-319756=
4/bin/lava-test-runner /lava-3197564/1
    2023-01-24T09:21:58.958430   =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfa3e633d46c868b915ee5

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h3-libretech-all-=
h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h3-libretech-all-=
h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63cfa3e633d46c868b915eea
        failing since 5 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-01-24T09:24:20.689387  / # #
    2023-01-24T09:24:20.791386  export SHELL=3D/bin/sh
    2023-01-24T09:24:20.791830  #
    2023-01-24T09:24:20.893191  / # export SHELL=3D/bin/sh. /lava-3197584/e=
nvironment
    2023-01-24T09:24:20.893541  =

    2023-01-24T09:24:20.994937  / # . /lava-3197584/environment/lava-319758=
4/bin/lava-test-runner /lava-3197584/1
    2023-01-24T09:24:20.995820  =

    2023-01-24T09:24:21.000587  / # /lava-3197584/bin/lava-test-runner /lav=
a-3197584/1
    2023-01-24T09:24:21.097646  + export 'TESTRUN_ID=3D1_bootrr'
    2023-01-24T09:24:21.098326  + cd /lava-3197584/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre    | gcc-10   | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfa35b7957e778b3915ebd

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h3-libretech-all-h3-=
cc.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h3-libretech-all-h3-=
cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63cfa35b7957e778b3915ec2
        failing since 5 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-01-24T09:21:52.197085  <8>[    7.914391] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3197570_1.5.2.4.1>
    2023-01-24T09:21:52.302264  / # #
    2023-01-24T09:21:52.403991  export SHELL=3D/bin/sh
    2023-01-24T09:21:52.404480  #
    2023-01-24T09:21:52.505826  / # export SHELL=3D/bin/sh. /lava-3197570/e=
nvironment
    2023-01-24T09:21:52.506182  =

    2023-01-24T09:21:52.607548  / # . /lava-3197570/environment/lava-319757=
0/bin/lava-test-runner /lava-3197570/1
    2023-01-24T09:21:52.608228  =

    2023-01-24T09:21:52.627837  / # /lava-3197570/bin/lava-test-runner /lav=
a-3197570/1
    2023-01-24T09:21:52.691714  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h3-orangepi-pc         | arm    | lab-clabbe      | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfcfab92bc06275b915fd4

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-orangepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-orangepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63cfcfab92bc06275b915fd7
        failing since 5 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-01-24T12:31:11.350079  + set +x
    2023-01-24T12:31:11.351976  <8>[   15.860195] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 384636_1.5.2.4.1>
    2023-01-24T12:31:11.459172  / # #
    2023-01-24T12:31:11.561472  export SHELL=3D/bin/sh
    2023-01-24T12:31:11.562057  #
    2023-01-24T12:31:11.663485  / # export SHELL=3D/bin/sh. /lava-384636/en=
vironment
    2023-01-24T12:31:11.664142  =

    2023-01-24T12:31:11.765552  / # . /lava-384636/environment/lava-384636/=
bin/lava-test-runner /lava-384636/1
    2023-01-24T12:31:11.766413  =

    2023-01-24T12:31:11.767998  / # /lava-384636/bin/lava-test-runner /lava=
-384636/1 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h3-orangepi-pc         | arm    | lab-clabbe      | gcc-10   | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfcf47557bdb6639915ee2

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-orangepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-orangepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63cfcf47557bdb6639915ee5
        failing since 5 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-01-24T12:29:45.234784  + set +x
    2023-01-24T12:29:45.236862  <8>[   13.788730] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 384627_1.5.2.4.1>
    2023-01-24T12:29:45.346107  / # #
    2023-01-24T12:29:45.448976  export SHELL=3D/bin/sh
    2023-01-24T12:29:45.449688  #
    2023-01-24T12:29:45.551800  / # export SHELL=3D/bin/sh. /lava-384627/en=
vironment
    2023-01-24T12:29:45.552616  =

    2023-01-24T12:29:45.654495  / # . /lava-384627/environment/lava-384627/=
bin/lava-test-runner /lava-384627/1
    2023-01-24T12:29:45.655838  =

    2023-01-24T12:29:45.657163  / # /lava-384627/bin/lava-test-runner /lava=
-384627/1 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
tegra124-nyan-big            | arm    | lab-collabora   | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfcf7a73ea28e8eb915ec7

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-tegra124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-tegra124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63cfcf7a73ea28e8eb915ecc
        failing since 4 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-01-24T12:30:28.765781  <8>[   18.048245] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2023-01-24T12:30:28.769230  + set +x
    2023-01-24T12:30:28.776208  <8>[   18.060578] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 8851848_1.5.2.3.1>
    2023-01-24T12:30:28.884172  #
    2023-01-24T12:30:28.884916  =

    2023-01-24T12:30:28.986419  / # #export SHELL=3D/bin/sh
    2023-01-24T12:30:28.986856  =

    2023-01-24T12:30:29.088113  / # export SHELL=3D/bin/sh. /lava-8851848/e=
nvironment
    2023-01-24T12:30:29.088472  =

    2023-01-24T12:30:29.189788  / # . /lava-8851848/environment/lava-885184=
8/bin/lava-test-runner /lava-8851848/1 =

    ... (20 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
tegra124-nyan-big            | arm    | lab-collabora   | gcc-10   | tegra_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfc76752a44dea24915ed3

  Results:     3 PASS, 3 FAIL, 1 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63cfc76752a44dea24915ed8
        failing since 4 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-01-24T11:56:18.857776  kern  :emerg : Process udevadm (pid<8>[   1=
8.415697] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3D=
lines MEASUREMENT=3D11>
    2023-01-24T11:56:18.860024  : 140, stack limit =3D 0x(ptrval))
    2023-01-24T11:56:18.860477  =

    2023-01-24T11:56:18.867481  kern  :emerg : Stack: <8>[   18.429808] <LA=
VA_SIGNAL_ENDRUN 0_dmesg 8851460_1.5.2.3.1>
    2023-01-24T11:56:18.869268  =

    2023-01-24T11:56:18.870350  (0xc2c7ff2c to 0xc2c80000)
    2023-01-24T11:56:18.878261  kern  :emerg : ff20:                       =
     c02e7e88 00000000 00000000 c026d53c 00000003
    2023-01-24T11:56:18.878720  =

    2023-01-24T11:56:18.886313  kern  :emerg : ff40: c2b97240 beb17f74 c2c7=
ff80 00000000 c2c7e000 00000004 00000003 c02703f0
    2023-01-24T11:56:18.886770   =

    ... (31 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
zynqmp-zcu102                | arm64  | lab-cip         | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfa0fb6eb4f18447915f81

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-cip/baseline-zynqmp-zcu102.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-cip/baseline-zynqmp-zcu102.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63cfa0fb6eb4f18447915f84
        failing since 5 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-01-24T09:12:09.924969  + set +x
    2023-01-24T09:12:09.926058  <8>[    3.690907] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 831738_1.5.2.4.1>
    2023-01-24T09:12:10.032482  / # #
    2023-01-24T09:12:10.133840  export SHELL=3D/bin/sh
    2023-01-24T09:12:10.134154  #
    2023-01-24T09:12:10.235242  / # export SHELL=3D/bin/sh. /lava-831738/en=
vironment
    2023-01-24T09:12:10.235482  =

    2023-01-24T09:12:10.336510  / # . /lava-831738/environment/lava-831738/=
bin/lava-test-runner /lava-831738/1
    2023-01-24T09:12:10.337034  =

    2023-01-24T09:12:10.340050  / # /lava-831738/bin/lava-test-runner /lava=
-831738/1 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
zynqmp-zcu102                | arm64  | lab-cip         | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfa443aba28ef1bf915ecf

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm64/defconfig/gcc-10/lab-cip/baseline-zynqmp-zcu102.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.271/=
arm64/defconfig/gcc-10/lab-cip/baseline-zynqmp-zcu102.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63cfa443aba28ef1bf915ed2
        failing since 5 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-01-24T09:26:06.235033  <8>[    3.751291] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 831824_1.5.2.4.1>
    2023-01-24T09:26:06.340714  / # #
    2023-01-24T09:26:06.442680  export SHELL=3D/bin/sh
    2023-01-24T09:26:06.443318  #
    2023-01-24T09:26:06.544705  / # export SHELL=3D/bin/sh. /lava-831824/en=
vironment
    2023-01-24T09:26:06.545156  =

    2023-01-24T09:26:06.646601  / # . /lava-831824/environment/lava-831824/=
bin/lava-test-runner /lava-831824/1
    2023-01-24T09:26:06.647404  =

    2023-01-24T09:26:06.650101  / # /lava-831824/bin/lava-test-runner /lava=
-831824/1
    2023-01-24T09:26:06.687121  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (12 line(s) more)  =

 =20
