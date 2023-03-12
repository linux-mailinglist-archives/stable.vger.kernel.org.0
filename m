Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B525C6B63EC
	for <lists+stable@lfdr.de>; Sun, 12 Mar 2023 10:15:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbjCLJPE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Mar 2023 05:15:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCLJPD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Mar 2023 05:15:03 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4635039BBB
        for <stable@vger.kernel.org>; Sun, 12 Mar 2023 01:14:59 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id y2so9222111pjg.3
        for <stable@vger.kernel.org>; Sun, 12 Mar 2023 01:14:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1678612498;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=VPpXHWBS8HmIKtaAzDCaduixot9A9XPu+KQ6LFTtiKA=;
        b=JJGri/kyAo+vAekAe+ij/gSbjXL4MBO8ybUj0XbwJ+6fj3HVZ24VmTN8DzxAYbHxqq
         UXxXYtZKDgtx+ki04FdXErxo4dOoffATD4PrnjPEoI9Sr00hApWbHMT2Dn4d+a4z1hV8
         NWbZ45Qg0degMwuJlj2G8gKWNCsOnvpXIQ4mTppUXt7mhxXg/+cJ+yubU/y+G0aH0XTk
         zZ45E0eRXvwvOZc5ZS3VO+HmU5+Iiaaa9rElJY/84q38NJTvtkBKbO8nyCkOBy6PVkgU
         Nvb7ZjE9i5uQlbVWa3JSaWzNZZlx9NIX+LwLS6GTfEU18enOK+WamyZhMNGaWcx1idQo
         jWhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678612498;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VPpXHWBS8HmIKtaAzDCaduixot9A9XPu+KQ6LFTtiKA=;
        b=4JP3ucMYyOpwMrjOXFqjIFZJDhdLQ6JwCRrCWxOhxmZVfISQjB0G/0gV9eHThDqTa2
         2Xy094f4Wo3vjdX2ZwdogCDobEAgffgLv1m+zFqMoIg/A3sUraCjFPSLyr95P6OrGgwd
         audsJkKDd3g8pn9M0wkbcoq2uz+MQxVJgXV5oUxGzcfPPj5rGufebqsOr1isgHny6oyv
         uykyw9yegtyuwdSJTb4Cs7WN5HTDgSBvbeZGdoTIgJMkaARNp/a+iIuwkAF62QSvX/WH
         KXiPT6jqRUeLMa+Zw07BCkNNUH5ZCn/vlJiSrM+88U22RHmkE7msy36So1zw2Iti8dsL
         yx7g==
X-Gm-Message-State: AO0yUKU+aug0j+T08vbADtkCHUwAb5YLJVylTOgE9L3RqmUFzaJ+GJZD
        4OTq+e96dt55PILlJqdWzOnGEBejFSe9qWBcYSs=
X-Google-Smtp-Source: AK7set/ASjS9k/aVmTyxRtu3HV6c/CzM9LPCDL/3IQ6x+Kb3ygWjeZEqoAl0Xn5nE7J+5QWL9l2miw==
X-Received: by 2002:a17:903:2452:b0:19d:1c6e:d31e with SMTP id l18-20020a170903245200b0019d1c6ed31emr33657223pls.60.1678612496991;
        Sun, 12 Mar 2023 01:14:56 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i7-20020a63cd07000000b004facdf070d6sm2567814pgg.39.2023.03.12.01.14.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Mar 2023 01:14:56 -0800 (PST)
Message-ID: <640d9810.630a0220.82ebe.447f@mx.google.com>
Date:   Sun, 12 Mar 2023 01:14:56 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.19.276
X-Kernelci-Report-Type: test
Subject: stable/linux-4.19.y baseline: 155 runs, 59 regressions (v4.19.276)
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

stable/linux-4.19.y baseline: 155 runs, 59 regressions (v4.19.276)

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

beagle-xm                    | arm    | lab-baylibre    | gcc-10   | omap2p=
lus_defconfig          | 1          =

beaglebone-black             | arm    | lab-broonie     | gcc-10   | multi_=
v7_defconfig           | 1          =

beaglebone-black             | arm    | lab-cip         | gcc-10   | multi_=
v7_defconfig           | 1          =

beaglebone-black             | arm    | lab-broonie     | gcc-10   | omap2p=
lus_defconfig          | 1          =

beaglebone-black             | arm    | lab-cip         | gcc-10   | omap2p=
lus_defconfig          | 1          =

cubietruck                   | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =

imx6q-sabrelite              | arm    | lab-collabora   | gcc-10   | multi_=
v7_defconfig           | 1          =

imx6qp-wandboard-revd1       | arm    | lab-pengutronix | gcc-10   | imx_v6=
_v7_defconfig          | 1          =

imx6qp-wandboard-revd1       | arm    | lab-pengutronix | gcc-10   | multi_=
v7_defconfig           | 1          =

imx7d-sdb                    | arm    | lab-nxp         | gcc-10   | multi_=
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
fig+arm64-chromebook   | 1          =

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
fig+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =

r8a7743-iwg20d-q7            | arm    | lab-cip         | gcc-10   | shmobi=
le_defconfig           | 1          =

r8a7796-m3ulcb               | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =

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
/v4.19.276/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.276
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      6a98afd74b4c2016fb87f5c3b7ce1c53ac215c13 =



Test Regressions
---------------- =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C433TA-AJ0005-rammus    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640d5f2a3c5a91f14c8c8658

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
433TA-AJ0005-rammus.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
433TA-AJ0005-rammus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640d5f2a3c5a91f14c8c8661
        failing since 52 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-03-12T05:11:50.759916  + set +x<8>[    8.650137] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 9566955_1.4.2.3.1>

    2023-03-12T05:11:50.760015  =


    2023-03-12T05:11:50.862044  #

    2023-03-12T05:11:50.963317  / # #export SHELL=3D/bin/sh

    2023-03-12T05:11:50.963532  =


    2023-03-12T05:11:51.064391  / # export SHELL=3D/bin/sh. /lava-9566955/e=
nvironment

    2023-03-12T05:11:51.064607  =


    2023-03-12T05:11:51.165526  / # . /lava-9566955/environment/lava-956695=
5/bin/lava-test-runner /lava-9566955/1

    2023-03-12T05:11:51.165825  =


    2023-03-12T05:11:51.170480  / # /lava-9566955/bin/lava-test-runner /lav=
a-9566955/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C523NA-A20057-coral     | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640d5f227aeac1c8988c863d

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
523NA-A20057-coral.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
523NA-A20057-coral.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640d5f227aeac1c8988c8646
        failing since 52 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-03-12T05:11:51.478743  <8>[   12.529924] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>

    2023-03-12T05:11:51.480201  + set +x

    2023-03-12T05:11:51.486076  <8>[   12.540374] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9566892_1.4.2.3.1>

    2023-03-12T05:11:51.590854  / #

    2023-03-12T05:11:51.692119  # #export SHELL=3D/bin/sh

    2023-03-12T05:11:51.692333  =


    2023-03-12T05:11:51.793204  / # export SHELL=3D/bin/sh. /lava-9566892/e=
nvironment

    2023-03-12T05:11:51.793455  =


    2023-03-12T05:11:51.894346  / # . /lava-9566892/environment/lava-956689=
2/bin/lava-test-runner /lava-9566892/1

    2023-03-12T05:11:51.894800  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
at91sam9g20ek                | arm    | lab-broonie     | gcc-10   | multi_=
v5_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/640d5fface2d87122f8c863a

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640d5fface2d87122f8c8643
        failing since 33 days (last pass: v4.19.271, first fail: v4.19.272)

    2023-03-12T05:15:17.666735  + set +x
    2023-03-12T05:15:17.671966  <8><LAVA_SIGNAL_ENDRUN 0_dmesg 147936_1.5.2=
.4.1>
    2023-03-12T05:15:17.785985  / # #
    2023-03-12T05:15:17.889041  export SHELL=3D/bin/sh
    2023-03-12T05:15:17.889886  #
    2023-03-12T05:15:17.991838  / # export SHELL=3D/bin/sh. /lava-147936/en=
vironment
    2023-03-12T05:15:17.992619  =

    2023-03-12T05:15:18.094627  / # . /lava-147936/environment/lava-147936/=
bin/lava-test-runner /lava-147936/1
    2023-03-12T05:15:18.096187  =

    2023-03-12T05:15:18.102343  / # /lava-147936/bin/lava-test-runner /lava=
-147936/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beagle-xm                    | arm    | lab-baylibre    | gcc-10   | omap2p=
lus_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/640d5f2d676875c92c8c8647

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640d5f2d676875c92c8c8650
        failing since 46 days (last pass: v4.19.268, first fail: v4.19.271)

    2023-03-12T05:11:56.524652  + set +x<8>[   25.456787] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3406341_1.5.2.4.1>
    2023-03-12T05:11:56.525287  =

    2023-03-12T05:11:56.639250  / # #
    2023-03-12T05:11:56.742740  export SHELL=3D/bin/sh
    2023-03-12T05:11:56.743942  #
    2023-03-12T05:11:56.846186  / # export SHELL=3D/bin/sh. /lava-3406341/e=
nvironment
    2023-03-12T05:11:56.847321  =

    2023-03-12T05:11:56.949623  / # . /lava-3406341/environment/lava-340634=
1/bin/lava-test-runner /lava-3406341/1
    2023-03-12T05:11:56.951326  =

    2023-03-12T05:11:56.957014  / # /lava-3406341/bin/lava-test-runner /lav=
a-3406341/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beaglebone-black             | arm    | lab-broonie     | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/640d5fefd4903e1c0a8c86be

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-beaglebone-black.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-beaglebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640d5fefd4903e1c0a8c86c7
        failing since 52 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-03-12T05:15:05.792594  <8>[   16.790410] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 147971_1.5.2.4.1>
    2023-03-12T05:15:05.901187  / # #
    2023-03-12T05:15:06.004128  export SHELL=3D/bin/sh
    2023-03-12T05:15:06.004920  #
    2023-03-12T05:15:06.107287  / # export SHELL=3D/bin/sh. /lava-147971/en=
vironment
    2023-03-12T05:15:06.108048  =

    2023-03-12T05:15:06.210431  / # . /lava-147971/environment/lava-147971/=
bin/lava-test-runner /lava-147971/1
    2023-03-12T05:15:06.211606  =

    2023-03-12T05:15:06.216297  / # /lava-147971/bin/lava-test-runner /lava=
-147971/1
    2023-03-12T05:15:06.284404  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beaglebone-black             | arm    | lab-cip         | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/640d62bf0a2a0e7b4e8c862f

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm/multi_v7_defconfig/gcc-10/lab-cip/baseline-beaglebone-black.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm/multi_v7_defconfig/gcc-10/lab-cip/baseline-beaglebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640d62bf0a2a0e7b4e8c8636
        failing since 52 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-03-12T05:27:09.104540  <8>[    8.943050] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 873062_1.5.2.4.1>
    2023-03-12T05:27:09.214388  / # #
    2023-03-12T05:27:09.317200  export SHELL=3D/bin/sh
    2023-03-12T05:27:09.317963  #
    2023-03-12T05:27:09.419898  / # export SHELL=3D/bin/sh. /lava-873062/en=
vironment
    2023-03-12T05:27:09.420662  =

    2023-03-12T05:27:09.522593  / # . /lava-873062/environment/lava-873062/=
bin/lava-test-runner /lava-873062/1
    2023-03-12T05:27:09.523869  =

    2023-03-12T05:27:09.529786  / # /lava-873062/bin/lava-test-runner /lava=
-873062/1
    2023-03-12T05:27:09.597158  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beaglebone-black             | arm    | lab-broonie     | gcc-10   | omap2p=
lus_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/640d5f4f6bdc8657628c8630

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beaglebone-black.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beaglebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640d5f4f6bdc8657628c8639
        new failure (last pass: v4.19.275)

    2023-03-12T05:12:26.643454  + set +x<8>[   18.306368] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 147944_1.5.2.4.1>
    2023-03-12T05:12:26.643782  =

    2023-03-12T05:12:26.754895  / # #
    2023-03-12T05:12:26.857034  export SHELL=3D/bin/sh
    2023-03-12T05:12:26.857580  #
    2023-03-12T05:12:26.959104  / # export SHELL=3D/bin/sh. /lava-147944/en=
vironment
    2023-03-12T05:12:26.959639  =

    2023-03-12T05:12:27.061150  / # . /lava-147944/environment/lava-147944/=
bin/lava-test-runner /lava-147944/1
    2023-03-12T05:12:27.062018  =

    2023-03-12T05:12:27.067076  / # /lava-147944/bin/lava-test-runner /lava=
-147944/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beaglebone-black             | arm    | lab-cip         | gcc-10   | omap2p=
lus_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/640d5f3bc6a79b716d8c8658

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm/omap2plus_defconfig/gcc-10/lab-cip/baseline-beaglebone-black.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm/omap2plus_defconfig/gcc-10/lab-cip/baseline-beaglebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640d5f3bc6a79b716d8c865f
        new failure (last pass: v4.19.275)

    2023-03-12T05:12:11.303354  + set +x<8>[   11.761585] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 873050_1.5.2.4.1>
    2023-03-12T05:12:11.303896  =

    2023-03-12T05:12:11.417791  / # #
    2023-03-12T05:12:11.520516  export SHELL=3D/bin/sh
    2023-03-12T05:12:11.521290  #
    2023-03-12T05:12:11.623215  / # export SHELL=3D/bin/sh. /lava-873050/en=
vironment
    2023-03-12T05:12:11.624015  =

    2023-03-12T05:12:11.725991  / # . /lava-873050/environment/lava-873050/=
bin/lava-test-runner /lava-873050/1
    2023-03-12T05:12:11.727240  =

    2023-03-12T05:12:11.733644  / # /lava-873050/bin/lava-test-runner /lava=
-873050/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
cubietruck                   | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/640d601c3bd74f015b8c8641

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640d601c3bd74f015b8c864a
        failing since 52 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-03-12T05:15:51.694998  <8>[    7.378689] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3406352_1.5.2.4.1>
    2023-03-12T05:15:51.804916  / # #
    2023-03-12T05:15:51.908864  export SHELL=3D/bin/sh
    2023-03-12T05:15:51.909984  #
    2023-03-12T05:15:52.012343  / # export SHELL=3D/bin/sh. /lava-3406352/e=
nvironment
    2023-03-12T05:15:52.013355  =

    2023-03-12T05:15:52.115643  / # . /lava-3406352/environment/lava-340635=
2/bin/lava-test-runner /lava-3406352/1
    2023-03-12T05:15:52.118335  =

    2023-03-12T05:15:52.122271  / # /lava-3406352/bin/lava-test-runner /lav=
a-3406352/1
    2023-03-12T05:15:52.208126  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx6q-sabrelite              | arm    | lab-collabora   | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/640d5fddd4903e1c0a8c8684

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-imx6q-sabrelite.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-imx6q-sabrelite.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640d5fddd4903e1c0a8c868d
        failing since 52 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-03-12T05:14:53.694593  / # #

    2023-03-12T05:14:53.797414  export SHELL=3D/bin/sh

    2023-03-12T05:14:53.798250  #

    2023-03-12T05:14:53.900417  / # export SHELL=3D/bin/sh. /lava-9566982/e=
nvironment

    2023-03-12T05:14:53.901260  =


    2023-03-12T05:14:54.003383  / # . /lava-9566982/environment/lava-956698=
2/bin/lava-test-runner /lava-9566982/1

    2023-03-12T05:14:54.004649  =


    2023-03-12T05:14:54.016775  / # /lava-9566982/bin/lava-test-runner /lav=
a-9566982/1

    2023-03-12T05:14:54.115687  + export 'TESTRUN_ID=3D1_bootrr'

    2023-03-12T05:14:54.116254  + cd /lava-9566982/1/tests/1_bootrr
 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx6qp-wandboard-revd1       | arm    | lab-pengutronix | gcc-10   | imx_v6=
_v7_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/640d5ebdd6fd9b0bf48c8636

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6qp-wandboard-re=
vd1.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6qp-wandboard-re=
vd1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640d5ebdd6fd9b0bf48c863f
        failing since 52 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-03-12T05:10:11.751819  + set +x[    7.030688] <LAVA_SIGNAL_ENDRUN =
0_dmesg 919687_1.5.2.3.1>
    2023-03-12T05:10:11.752052  =

    2023-03-12T05:10:11.859365  / # #
    2023-03-12T05:10:11.960920  export SHELL=3D/bin/sh
    2023-03-12T05:10:11.961316  #
    2023-03-12T05:10:12.062477  / # export SHELL=3D/bin/sh. /lava-919687/en=
vironment
    2023-03-12T05:10:12.062838  =

    2023-03-12T05:10:12.164145  / # . /lava-919687/environment/lava-919687/=
bin/lava-test-runner /lava-919687/1
    2023-03-12T05:10:12.164749  =

    2023-03-12T05:10:12.167363  / # /lava-919687/bin/lava-test-runner /lava=
-919687/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx6qp-wandboard-revd1       | arm    | lab-pengutronix | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/640d5f998a3e5ea0128c867d

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6qp-wandboard-rev=
d1.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6qp-wandboard-rev=
d1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640d5f998a3e5ea0128c8686
        failing since 52 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-03-12T05:13:48.987400  + set +x
    2023-03-12T05:13:48.987570  [    4.855752] <LAVA_SIGNAL_ENDRUN 0_dmesg =
919688_1.5.2.3.1>
    2023-03-12T05:13:49.093630  / # #
    2023-03-12T05:13:49.195263  export SHELL=3D/bin/sh
    2023-03-12T05:13:49.195728  #
    2023-03-12T05:13:49.296964  / # export SHELL=3D/bin/sh. /lava-919688/en=
vironment
    2023-03-12T05:13:49.297411  =

    2023-03-12T05:13:49.398816  / # . /lava-919688/environment/lava-919688/=
bin/lava-test-runner /lava-919688/1
    2023-03-12T05:13:49.399450  =

    2023-03-12T05:13:49.401741  / # /lava-919688/bin/lava-test-runner /lava=
-919688/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx7d-sdb                    | arm    | lab-nxp         | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/640d5febd4903e1c0a8c86a8

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sdb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640d5febd4903e1c0a8c86af
        failing since 52 days (last pass: v4.19.267, first fail: v4.19.270)

    2023-03-12T05:14:54.468928  <8>[   12.933193] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 1170914_1.5.2.4.1>
    2023-03-12T05:14:54.574456  / # #
    2023-03-12T05:14:55.734778  export SHELL=3D/bin/sh
    2023-03-12T05:14:55.740485  #
    2023-03-12T05:14:57.288343  / # export SHELL=3D/bin/sh. /lava-1170914/e=
nvironment
    2023-03-12T05:14:57.294036  =

    2023-03-12T05:15:00.116625  / # . /lava-1170914/environment/lava-117091=
4/bin/lava-test-runner /lava-1170914/1
    2023-03-12T05:15:00.122732  =

    2023-03-12T05:15:00.123519  / # /lava-1170914/bin/lava-test-runner /lav=
a-1170914/1
    2023-03-12T05:15:00.232301  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (16 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-baylibre    | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/640d601f4df78120228c863e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640d601f4df78120228c8=
63f
        failing since 225 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/640d61b10aa77844388c8636

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640d61b10aa77844388c8=
637
        failing since 187 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-broonie     | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/640d602c93f197f0208c8647

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640d602c93f197f0208c8=
648
        failing since 225 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/640d61e3de2b18b2a58c8630

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640d61e3de2b18b2a58c8=
631
        failing since 187 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/640d601593f197f0208c8637

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640d601593f197f0208c8=
638
        failing since 225 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/640d61aaf0cb8543138c864d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640d61aaf0cb8543138c8=
64e
        failing since 187 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-baylibre    | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/640d601d1b60c7b29c8c8646

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640d601d1b60c7b29c8c8=
647
        failing since 225 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/640d61ad9900e133438c86a5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640d61ad9900e133438c8=
6a6
        failing since 303 days (last pass: v4.19.239, first fail: v4.19.242=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-broonie     | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/640d602ae34885ab968c862f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640d602ae34885ab968c8=
630
        failing since 225 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/640d61ba0aa77844388c863c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640d61ba0aa77844388c8=
63d
        failing since 303 days (last pass: v4.19.239, first fail: v4.19.242=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/640d60139a83bda6428c8633

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640d60139a83bda6428c8=
634
        failing since 225 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-baylibre    | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/640d601eb471be719e8c864c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640d601eb471be719e8c8=
64d
        failing since 225 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/640d61af51a5667a018c862f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640d61af51a5667a018c8=
630
        failing since 187 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-broonie     | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/640d602b93f197f0208c8642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640d602b93f197f0208c8=
643
        failing since 225 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/640d61e2a86fc934e18c86f7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640d61e2a86fc934e18c8=
6f8
        failing since 187 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/640d60144df78120228c8638

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640d60144df78120228c8=
639
        failing since 225 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/640d61a99900e133438c869f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640d61a99900e133438c8=
6a0
        failing since 187 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-baylibre    | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/640d602193f197f0208c863d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640d602193f197f0208c8=
63e
        failing since 225 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/640d61af0aa77844388c862f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640d61af0aa77844388c8=
630
        failing since 187 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-broonie     | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/640d603e3bd74f015b8c8676

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640d603e3bd74f015b8c8=
677
        failing since 225 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/640d61ce51a5667a018c8654

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640d61ce51a5667a018c8=
655
        failing since 187 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/640d601892eac970648c8635

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640d601892eac970648c8=
636
        failing since 225 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/640d61a3f0cb8543138c8642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv3-uefi.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640d61a3f0cb8543138c8=
643
        failing since 187 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
r8a7743-iwg20d-q7            | arm    | lab-cip         | gcc-10   | shmobi=
le_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/640d5e970d89b663988c862f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640d5e970d89b663988c8=
630
        failing since 106 days (last pass: v4.19.266, first fail: v4.19.267=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
r8a7796-m3ulcb               | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/640d60b2070e74ca608c8645

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm64/defconfig/gcc-10/lab-collabora/baseline-r8a7796-m3ulcb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm64/defconfig/gcc-10/lab-collabora/baseline-r8a7796-m3ulcb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640d60b2070e74ca608c864e
        failing since 52 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-03-12T05:18:22.641401  / # #

    2023-03-12T05:18:22.744329  export SHELL=3D/bin/sh

    2023-03-12T05:18:22.745170  #

    2023-03-12T05:18:22.847125  / # export SHELL=3D/bin/sh. /lava-9567019/e=
nvironment

    2023-03-12T05:18:22.847590  =


    2023-03-12T05:18:22.949106  / # . /lava-9567019/environment/lava-956701=
9/bin/lava-test-runner /lava-9567019/1

    2023-03-12T05:18:22.950445  =


    2023-03-12T05:18:22.962840  / # /lava-9567019/bin/lava-test-runner /lav=
a-9567019/1

    2023-03-12T05:18:23.011949  + export 'TESTRUN_ID=3D1_bootrr'

    2023-03-12T05:18:23.012486  + cd /lav<8>[   17.717703] <LAVA_SIGNAL_STA=
RTRUN 1_bootrr 9567019_1.5.2.4.5>
 =

    ... (10 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
rk3288-veyron-jaq            | arm    | lab-collabora   | gcc-10   | multi_=
v7_defconfig           | 3          =


  Details:     https://kernelci.org/test/plan/id/640d5fd800f39e2b248c8671

  Results:     61 PASS, 8 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.dwhdmi-rockchip-driver-cec-present: https://kernelci.or=
g/test/case/id/640d5fd800f39e2b248c86a5
        failing since 51 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-03-12T05:14:35.846068  BusyBox v1.31.1 (2023-03-03 12:54:59 UTC)<8=
>[   13.079340] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwhdmi-rockchip-driver=
-audio-present RESULT=3Dfail>

    2023-03-12T05:14:35.848869   multi-call binary.

    2023-03-12T05:14:35.849184  =


    2023-03-12T05:14:35.862640  Usage: seq [-w] [-s SEP] [FIRST [INC]] LA<8=
>[   13.097977] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwhdmi-rockchip-driver=
-cec-present RESULT=3Dfail>
   =


  * baseline.bootrr.dwhdmi-rockchip-driver-audio-present: https://kernelci.=
org/test/case/id/640d5fd800f39e2b248c86a6
        failing since 51 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-03-12T05:14:35.827035  <8>[   13.061802] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwhdmi-rockchip-probed RESULT=3Dpass>
   =


  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640d5fd800f39e2b248c86b9
        failing since 51 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-03-12T05:14:32.003119  + <8>[    9.242234] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9566976_1.5.2.3.1>

    2023-03-12T05:14:32.005254  set +x

    2023-03-12T05:14:32.111935  =


    2023-03-12T05:14:32.213583  / # #export SHELL=3D/bin/sh

    2023-03-12T05:14:32.214121  =


    2023-03-12T05:14:32.315402  / # export SHELL=3D/bin/sh. /lava-9566976/e=
nvironment

    2023-03-12T05:14:32.315922  =


    2023-03-12T05:14:32.417251  / # . /lava-9566976/environment/lava-956697=
6/bin/lava-test-runner /lava-9566976/1

    2023-03-12T05:14:32.417975  =


    2023-03-12T05:14:32.420203  / # /lava-9566976/bin/lava-test-runner /lav=
a-9566976/1
 =

    ... (17 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
rk3399-gru-kevin             | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 5          =


  Details:     https://kernelci.org/test/plan/id/640d5f339b8fb811e98c8660

  Results:     79 PASS, 9 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/640d5f339b8fb811e98c8686
        failing since 360 days (last pass: v4.19.231, first fail: v4.19.235)

    2023-03-12T05:12:02.539246  <8>[   34.926132] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>

    2023-03-12T05:12:03.554962  /lava-9566863/1/../bin/lava-test-case

    2023-03-12T05:12:03.563546  <8>[   35.950005] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>
   =


  * baseline.bootrr.rk3399-gru-sound-driver-rt5514-present: https://kernelc=
i.org/test/case/id/640d5f339b8fb811e98c869b
        failing since 52 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-03-12T05:12:02.078472  12:31:33 UTC) multi-call binary.

    2023-03-12T05:12:02.078881  =


    2023-03-12T05:12:02.083013  Usage: seq [-w] [-s SEP] [FIRST [INC]] LAST

    2023-03-12T05:12:02.083266  =


    2023-03-12T05:12:02.097696  Print numbers from FIRST to LAST, in steps =
of<8>[   34.480260] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drk3399-gru-sound-d=
river-rt5514-present RESULT=3Dfail>
   =


  * baseline.bootrr.rk3399-gru-sound-driver-max98357A-present: https://kern=
elci.org/test/case/id/640d5f339b8fb811e98c869c
        failing since 52 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-03-12T05:12:02.052436  	<8>[   34.435600] <LAVA_SIGNAL_TESTCASE TE=
ST_CASE_ID=3Drk3399-gru-sound-driver-dp-present RESULT=3Dfail>

    2023-03-12T05:12:02.055755  -w	Pad to last with leading zeros

    2023-03-12T05:12:02.058053  	-s SEP	String separator

    2023-03-12T05:12:02.062048  /lava-9566863/1/../bin/lava-test-case

    2023-03-12T05:12:02.075055  BusyBox v1.31.1 (2023-03-03 <8>[   34.45714=
1] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drk3399-gru-sound-driver-max98357A-p=
resent RESULT=3Dfail>
   =


  * baseline.bootrr.rk3399-gru-sound-driver-dp-present: https://kernelci.or=
g/test/case/id/640d5f339b8fb811e98c869d
        failing since 52 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-03-12T05:12:02.034235  Usage: seq [-w] [-s SEP] [FIRST [INC]] LAST

    2023-03-12T05:12:02.034685  =


    2023-03-12T05:12:02.039473  Print numbers from FIRST to LAST, in steps =
of INC.

    2023-03-12T05:12:02.042220  FIRST, INC default to 1.

    2023-03-12T05:12:02.042542  =

   =


  * baseline.bootrr.rk3399-gru-sound-driver-da7219-present: https://kernelc=
i.org/test/case/id/640d5f339b8fb811e98c869e
        failing since 52 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-03-12T05:12:02.019257  BusyBox v1.31.1 (2023-03-03 12:31:33 UTC) m=
ulti-call binary.

    2023-03-12T05:12:02.019854  =


    2023-03-12T05:12:02.029815  <8>[   34.412239] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drk3399-gru-sound-driver-da7219-present RESULT=3Dfail>
   =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun50i-a64-bananapi-m64      | arm64  | lab-clabbe      | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/640d60b6070e74ca608c8670

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bananapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bananapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640d60b6070e74ca608c8679
        failing since 52 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-03-12T05:18:24.149512  + set +x
    2023-03-12T05:18:24.151442  <8>[   17.172756] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 411999_1.5.2.4.1>
    2023-03-12T05:18:24.259503  / # #
    2023-03-12T05:18:24.362079  export SHELL=3D/bin/sh
    2023-03-12T05:18:24.362611  #
    2023-03-12T05:18:24.362970  / # <3>[   17.335913] brcmfmac: brcmf_sdio_=
htclk: HT Avail timeout (1000000): clkctl 0x50
    2023-03-12T05:18:24.464563  export SHELL=3D/bin/sh. /lava-411999/enviro=
nment
    2023-03-12T05:18:24.465118  =

    2023-03-12T05:18:24.566998  / # . /lava-411999/environment/lava-411999/=
bin/lava-test-runner /lava-411999/1
    2023-03-12T05:18:24.567930   =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun50i-a64-pine64-plus       | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/640d60a19f8a01c5fc8c86b0

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pine64-plus.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pine64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640d60a19f8a01c5fc8c86b9
        failing since 52 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-03-12T05:18:07.205381  <8>[   15.970535] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 147992_1.5.2.4.1>
    2023-03-12T05:18:07.311042  / # #
    2023-03-12T05:18:07.415349  export SHELL=3D/bin/sh
    2023-03-12T05:18:07.415958  #
    2023-03-12T05:18:07.518081  / # export SHELL=3D/bin/sh. /lava-147992/en=
vironment
    2023-03-12T05:18:07.518673  =

    2023-03-12T05:18:07.620516  / # . /lava-147992/environment/lava-147992/=
bin/lava-test-runner /lava-147992/1
    2023-03-12T05:18:07.621435  =

    2023-03-12T05:18:07.624769  / # /lava-147992/bin/lava-test-runner /lava=
-147992/1
    2023-03-12T05:18:07.657315  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun50i-h6-pine-h64           | arm64  | lab-clabbe      | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/640d60a69f8a01c5fc8c86bb

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-pine-h64.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-pine-h64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640d60a69f8a01c5fc8c86c4
        failing since 52 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-03-12T05:18:14.674254  <8>[   15.171930] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 412000_1.5.2.4.1>
    2023-03-12T05:18:14.780746  / # #
    2023-03-12T05:18:14.882967  export SHELL=3D/bin/sh
    2023-03-12T05:18:14.883532  #
    2023-03-12T05:18:14.985116  / # export SHELL=3D/bin/sh. /lava-412000/en=
vironment
    2023-03-12T05:18:14.985681  =

    2023-03-12T05:18:15.087296  / # . /lava-412000/environment/lava-412000/=
bin/lava-test-runner /lava-412000/1
    2023-03-12T05:18:15.088328  =

    2023-03-12T05:18:15.105207  / # /lava-412000/bin/lava-test-runner /lava=
-412000/1
    2023-03-12T05:18:15.162237  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun50i-h6-pine-h64           | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/640d60b3070e74ca608c8650

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm64/defconfig/gcc-10/lab-collabora/baseline-sun50i-h6-pine-h64.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm64/defconfig/gcc-10/lab-collabora/baseline-sun50i-h6-pine-h64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640d60b3070e74ca608c8659
        failing since 52 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-03-12T05:18:37.696754  / # #

    2023-03-12T05:18:37.799623  export SHELL=3D/bin/sh

    2023-03-12T05:18:37.800460  #

    2023-03-12T05:18:37.902453  / # export SHELL=3D/bin/sh. /lava-9567022/e=
nvironment

    2023-03-12T05:18:37.903311  =


    2023-03-12T05:18:38.005431  / # . /lava-9567022/environment/lava-956702=
2/bin/lava-test-runner /lava-9567022/1

    2023-03-12T05:18:38.006761  =


    2023-03-12T05:18:38.017329  / # /lava-9567022/bin/lava-test-runner /lav=
a-9567022/1

    2023-03-12T05:18:38.081689  + export 'TESTRUN_ID=3D1_bootrr'

    2023-03-12T05:18:38.082206  + cd /lava-9567022<8>[   15.633891] <LAVA_S=
IGNAL_STARTRUN 1_bootrr 9567022_1.5.2.4.5>
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-a33-olinuxino          | arm    | lab-clabbe      | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/640d5feed4903e1c0a8c86b3

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a33-olinuxino.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a33-olinuxino.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640d5feed4903e1c0a8c86bc
        failing since 52 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-03-12T05:15:03.806839  <8>[   17.273604] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 411995_1.5.2.4.1>
    2023-03-12T05:15:03.913494  / # #
    2023-03-12T05:15:04.015472  export SHELL=3D/bin/sh
    2023-03-12T05:15:04.016145  #
    2023-03-12T05:15:04.117549  / # export SHELL=3D/bin/sh. /lava-411995/en=
vironment
    2023-03-12T05:15:04.118288  =

    2023-03-12T05:15:04.219935  / # . /lava-411995/environment/lava-411995/=
bin/lava-test-runner /lava-411995/1
    2023-03-12T05:15:04.220978  =

    2023-03-12T05:15:04.237746  / # /lava-411995/bin/lava-test-runner /lava=
-411995/1
    2023-03-12T05:15:04.358979  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/640d5fcdc459d047148c8653

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h3-libretech-all-=
h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h3-libretech-all-=
h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640d5fcdc459d047148c865c
        failing since 52 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-03-12T05:14:31.189183  / # #
    2023-03-12T05:14:31.290909  export SHELL=3D/bin/sh
    2023-03-12T05:14:31.291328  #
    2023-03-12T05:14:31.392678  / # export SHELL=3D/bin/sh. /lava-3406357/e=
nvironment
    2023-03-12T05:14:31.393253  =

    2023-03-12T05:14:31.494658  / # . /lava-3406357/environment/lava-340635=
7/bin/lava-test-runner /lava-3406357/1
    2023-03-12T05:14:31.495430  =

    2023-03-12T05:14:31.500420  / # /lava-3406357/bin/lava-test-runner /lav=
a-3406357/1
    2023-03-12T05:14:31.598283  + export 'TESTRUN_ID=3D1_bootrr'
    2023-03-12T05:14:31.598771  + cd /lava-3406357/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre    | gcc-10   | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/640d5f051c7714f5ed8c8658

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h3-libretech-all-h3-=
cc.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h3-libretech-all-h3-=
cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640d5f051c7714f5ed8c8661
        failing since 52 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-03-12T05:11:08.726789  / # #
    2023-03-12T05:11:08.828514  export SHELL=3D/bin/sh
    2023-03-12T05:11:08.828936  #
    2023-03-12T05:11:08.930311  / # export SHELL=3D/bin/sh. /lava-3406340/e=
nvironment
    2023-03-12T05:11:08.930789  =

    2023-03-12T05:11:09.032184  / # . /lava-3406340/environment/lava-340634=
0/bin/lava-test-runner /lava-3406340/1
    2023-03-12T05:11:09.032887  =

    2023-03-12T05:11:09.038029  / # /lava-3406340/bin/lava-test-runner /lav=
a-3406340/1
    2023-03-12T05:11:09.116002  + export 'TESTRUN_ID=3D1_bootrr'
    2023-03-12T05:11:09.116572  + cd /lava-3406340/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h3-orangepi-pc         | arm    | lab-clabbe      | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/640d602a4df78120228c8643

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-orangepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-orangepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640d602a4df78120228c864c
        failing since 52 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-03-12T05:15:55.791962  + set +x
    2023-03-12T05:15:55.792392  <8>[   11.387496] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 411997_1.5.2.4.1>
    2023-03-12T05:15:55.980161  / # #
    2023-03-12T05:15:56.084144  export SHELL=3D/bin/sh
    2023-03-12T05:15:56.084773  #
    2023-03-12T05:15:56.193134  / # export SHELL=3D/bin/sh. /lava-411997/en=
vironment
    2023-03-12T05:15:56.193856  =

    2023-03-12T05:15:56.297088  / # . /lava-411997/environment/lava-411997/=
bin/lava-test-runner /lava-411997/1
    2023-03-12T05:15:56.297803  =

    2023-03-12T05:15:56.300269  / # /lava-411997/bin/lava-test-runner /lava=
-411997/1 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h3-orangepi-pc         | arm    | lab-clabbe      | gcc-10   | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/640d5f768a3e5ea0128c865a

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-orangepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-orangepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640d5f768a3e5ea0128c8663
        failing since 52 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-03-12T05:13:12.622932  + set +x
    2023-03-12T05:13:12.624876  <8>[   14.405077] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 411994_1.5.2.4.1>
    2023-03-12T05:13:12.732917  / # #
    2023-03-12T05:13:12.835458  export SHELL=3D/bin/sh
    2023-03-12T05:13:12.836046  #
    2023-03-12T05:13:12.937438  / # export SHELL=3D/bin/sh. /lava-411994/en=
vironment
    2023-03-12T05:13:12.938078  =

    2023-03-12T05:13:13.039678  / # . /lava-411994/environment/lava-411994/=
bin/lava-test-runner /lava-411994/1
    2023-03-12T05:13:13.040614  =

    2023-03-12T05:13:13.042519  / # /lava-411994/bin/lava-test-runner /lava=
-411994/1 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
tegra124-nyan-big            | arm    | lab-collabora   | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/640d5fd9d4903e1c0a8c8650

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-tegra124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-tegra124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640d5fd9d4903e1c0a8c8659
        failing since 50 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-03-12T05:14:55.880089  <8>[   17.977782] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>

    2023-03-12T05:14:55.883905  + set +x

    2023-03-12T05:14:55.890980  <8>[   17.990183] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9566980_1.5.2.3.1>

    2023-03-12T05:14:55.998786  =


    2023-03-12T05:14:56.100201  / # #export SHELL=3D/bin/sh

    2023-03-12T05:14:56.100548  =


    2023-03-12T05:14:56.201784  / # export SHELL=3D/bin/sh. /lava-9566980/e=
nvironment

    2023-03-12T05:14:56.202137  =


    2023-03-12T05:14:56.303414  / # . /lava-9566980/environment/lava-956698=
0/bin/lava-test-runner /lava-9566980/1

    2023-03-12T05:14:56.304063  =

 =

    ... (15 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
tegra124-nyan-big            | arm    | lab-collabora   | gcc-10   | tegra_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/640d5efac8efaa5bc78c863e

  Results:     3 PASS, 3 FAIL, 1 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640d5efac8efaa5bc78c8647
        failing since 50 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-03-12T05:11:02.588778  adm (pid: 139, stack limit =3D 0x(ptrval))

    2023-03-12T05:11:02.595680  kern  :emerg :<8>[   18.447601] <LAVA_SIGNA=
L_ENDRUN 0_dmesg 9566847_1.5.2.3.1>

    2023-03-12T05:11:02.598882   Stack: (0xc2c4df2c to 0xc2c4e000)

    2023-03-12T05:11:02.606860  kern  :emerg : df20:                       =
     c02e8180 00000000 00000000 c026d82c 00000003

    2023-03-12T05:11:02.615168  kern  :emerg : df40: c2bef900 be895f74 c2c4=
df80 00000000 c2c4c000 00000004 00000003 c02706e0

    2023-03-12T05:11:02.623228  kern  :emerg : df60: edfd14e0 c026d82c c2be=
f900 c2bef900 be895f74 00000003 c0101264 c0270944

    2023-03-12T05:11:02.631334  kern  :emerg : df80: 00000000 00000000 c2c4=
dfb0 9513ed21 b6fb67c0 00000003 b6fb67c0 be895468

    2023-03-12T05:11:02.639445  kern  :emerg : dfa0: 00000004 c0101000 0000=
0003 b6fb67c0 00000003 be895f74 00000003 00000000

    2023-03-12T05:11:02.647741  kern  :emerg : dfc0: 00000003 b6fb67c0 be89=
5468 00000004 00000003 0003c90c be895e58 00000003

    2023-03-12T05:11:02.655957  kern  :emerg : dfe0: 00059120 be895440 b6c7=
c960 b6c7c97c 60000010 00000003 00000000 00000000
 =

    ... (21 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
zynqmp-zcu102                | arm64  | lab-cip         | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/640d5f33e7cb6b513c8c8642

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-cip/baseline-zynqmp-zcu102.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-cip/baseline-zynqmp-zcu102.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640d5f33e7cb6b513c8c8649
        failing since 52 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-03-12T05:12:01.002844  + set +x
    2023-03-12T05:12:01.003861  <8>[    3.724467] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 873055_1.5.2.4.1>
    2023-03-12T05:12:01.112321  / # #
    2023-03-12T05:12:01.214649  export SHELL=3D/bin/sh
    2023-03-12T05:12:01.215762  #
    2023-03-12T05:12:01.317372  / # export SHELL=3D/bin/sh. /lava-873055/en=
vironment
    2023-03-12T05:12:01.318049  =

    2023-03-12T05:12:01.419499  / # . /lava-873055/environment/lava-873055/=
bin/lava-test-runner /lava-873055/1
    2023-03-12T05:12:01.420118  =

    2023-03-12T05:12:01.422723  / # /lava-873055/bin/lava-test-runner /lava=
-873055/1 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
zynqmp-zcu102                | arm64  | lab-cip         | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/640d609b9f8a01c5fc8c8689

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm64/defconfig/gcc-10/lab-cip/baseline-zynqmp-zcu102.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.276/=
arm64/defconfig/gcc-10/lab-cip/baseline-zynqmp-zcu102.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640d609b9f8a01c5fc8c8690
        failing since 52 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-03-12T05:17:57.006065  <8>[    3.750116] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 873077_1.5.2.4.1>
    2023-03-12T05:17:57.110842  / # #
    2023-03-12T05:17:57.212084  export SHELL=3D/bin/sh
    2023-03-12T05:17:57.212351  #
    2023-03-12T05:17:57.313254  / # export SHELL=3D/bin/sh. /lava-873077/en=
vironment
    2023-03-12T05:17:57.313513  =

    2023-03-12T05:17:57.414521  / # . /lava-873077/environment/lava-873077/=
bin/lava-test-runner /lava-873077/1
    2023-03-12T05:17:57.415016  =

    2023-03-12T05:17:57.417920  / # /lava-873077/bin/lava-test-runner /lava=
-873077/1
    2023-03-12T05:17:57.454842  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (12 line(s) more)  =

 =20
