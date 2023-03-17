Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 096096BED0B
	for <lists+stable@lfdr.de>; Fri, 17 Mar 2023 16:33:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbjCQPdV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Mar 2023 11:33:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230398AbjCQPdU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Mar 2023 11:33:20 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CFC9AA27D
        for <stable@vger.kernel.org>; Fri, 17 Mar 2023 08:32:43 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id c18so5637874ple.11
        for <stable@vger.kernel.org>; Fri, 17 Mar 2023 08:32:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1679067162;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=YQKvMTNdCRk+hDf8+DJC1+xWUPVLTbLVPyYyIFCXH5g=;
        b=5sTO79esoSn5E8iUCZzHwqZd2YllEi8nvLX99sBxMjwfMnAHRrX0NZFI1b1OuvSepw
         fto6NTVqKOZcVeJ8i//7mIbvi0ya/a438NOZ7iuTENXW0Dty+NBu5gLE0JQZylnGTKY4
         uI7GJVyniZBlUs2bDo1WEk3mqZujGIuIO4OrlKBysJhwmVLdC109ZyYXe3SYhAV+J9uw
         VT8PlQh0ESK7U+0EMlBh8Vmiv7ohEDo2R1SZZjixvpdwRNxBEWblkCJ3nHw+wv0gYIUr
         zbh1LCWVhLqenjWxKBF0xpX5LK7qmEOXRw7x4kwRopZ4tNB+F8Fqq5fEcG4S+tb8P+aG
         UUbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679067162;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YQKvMTNdCRk+hDf8+DJC1+xWUPVLTbLVPyYyIFCXH5g=;
        b=i4Kei+yQeva29krnzpftZhqfuzWWbQLqFibGf8EX9LZSqVi4YTu6nJu+0gqJ9G5nTY
         hcxE1HLPUX624jzHP8d+xnr33g56VhaUa07Gfs00D6Bn6TdF300kY+KwTJDjuKMrtgAf
         hnVCCJ1l3+ymxgtV3mg4CND7BpezW+MGby+9VhiiValnd15fGasCTLmTet32TwmpR9Xr
         LBNznEUfPvzuV9LYmf4sBS/aRmdkS9/O71rNKmGXibP3lPQFCWda0E1UfU4rYEmJ8NlO
         xgx9z85prWoUQfP5epdcS/KZYNHsMFXrrj7uOqRffoN2gqobdZ9NRXnHwHPqtc8vp9ry
         GXDA==
X-Gm-Message-State: AO0yUKVdGklN+FQHTkBAg6ARx6yWyY81zKnTEyJ+qaMX+dNtX0oAsiPh
        k87YFpTJIQkzC3IlGgKszkGpquz3IshnfSvZ0lY=
X-Google-Smtp-Source: AK7set9uXFVsBU/Y12HcV1raD5zlBCKu43cuAOGviwjcXPbKG4ZvMNDImhSeoZZ0eVJ2JoBH6NN+yQ==
X-Received: by 2002:a17:903:482:b0:1a1:241a:9bd0 with SMTP id jj2-20020a170903048200b001a1241a9bd0mr3151434plb.5.1679067160915;
        Fri, 17 Mar 2023 08:32:40 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r1-20020a170902be0100b001a17db3ce58sm1675001pls.247.2023.03.17.08.32.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 08:32:40 -0700 (PDT)
Message-ID: <64148818.170a0220.8237.373f@mx.google.com>
Date:   Fri, 17 Mar 2023 08:32:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.19.278
X-Kernelci-Report-Type: test
Subject: stable/linux-4.19.y baseline: 158 runs, 55 regressions (v4.19.278)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y baseline: 158 runs, 55 regressions (v4.19.278)

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

beaglebone-black             | arm    | lab-cip         | gcc-10   | multi_=
v7_defconfig           | 1          =

beaglebone-black             | arm    | lab-broonie     | gcc-10   | omap2p=
lus_defconfig          | 1          =

cubietruck                   | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =

imx6q-sabrelite              | arm    | lab-collabora   | gcc-10   | multi_=
v7_defconfig           | 1          =

imx6qp-wandboard-revd1       | arm    | lab-pengutronix | gcc-10   | imx_v6=
_v7_defconfig          | 1          =

imx6qp-wandboard-revd1       | arm    | lab-pengutronix | gcc-10   | multi_=
v7_defconfig           | 1          =

imx6sx-sdb                   | arm    | lab-nxp         | gcc-10   | multi_=
v7_defconfig           | 1          =

imx6ul-14x14-evk             | arm    | lab-nxp         | gcc-10   | multi_=
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

qemu_arm64-virt-gicv2-uefi   | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =

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

qemu_arm64-virt-gicv3        | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =

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

qemu_arm64-virt-gicv3-uefi   | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =

r8a7743-iwg20d-q7            | arm    | lab-cip         | gcc-10   | shmobi=
le_defconfig           | 1          =

rk3288-veyron-jaq            | arm    | lab-collabora   | gcc-10   | multi_=
v7_defconfig           | 3          =

rk3399-gru-kevin             | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 2          =

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
fig                    | 1          =

zynqmp-zcu102                | arm64  | lab-cip         | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.278/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.278
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      7e0df88a369006df976f46481292a07f3f68e54b =



Test Regressions
---------------- =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C433TA-AJ0005-rammus    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/641451e516879beef78c8673

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
433TA-AJ0005-rammus.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
433TA-AJ0005-rammus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/641451e516879beef78c867c
        failing since 57 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-03-17T11:41:05.720225  + <8>[   12.371079] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9665121_1.4.2.3.1>

    2023-03-17T11:41:05.723998  set +x

    2023-03-17T11:41:05.825610  /#

    2023-03-17T11:41:05.926679   # #export SHELL=3D/bin/sh

    2023-03-17T11:41:05.926919  =


    2023-03-17T11:41:06.027815  / # export SHELL=3D/bin/sh. /lava-9665121/e=
nvironment

    2023-03-17T11:41:06.028042  =


    2023-03-17T11:41:06.128868  / # . /lava-9665121/environment/lava-966512=
1/bin/lava-test-runner /lava-9665121/1

    2023-03-17T11:41:06.129163  =


    2023-03-17T11:41:06.134541  / # /lava-9665121/bin/lava-test-runner /lav=
a-9665121/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C523NA-A20057-coral     | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/641451e616879beef78c867f

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
523NA-A20057-coral.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
523NA-A20057-coral.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/641451e616879beef78c8688
        failing since 57 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-03-17T11:41:13.232389  + set +x

    2023-03-17T11:41:13.238465  <8>[   12.041430] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9665115_1.4.2.3.1>

    2023-03-17T11:41:13.342143  #

    2023-03-17T11:41:13.443276  / # #export SHELL=3D/bin/sh

    2023-03-17T11:41:13.443443  =


    2023-03-17T11:41:13.544290  / # export SHELL=3D/bin/sh. /lava-9665115/e=
nvironment

    2023-03-17T11:41:13.544460  =


    2023-03-17T11:41:13.645316  / # . /lava-9665115/environment/lava-966511=
5/bin/lava-test-runner /lava-9665115/1

    2023-03-17T11:41:13.645562  =


    2023-03-17T11:41:13.647941  / # /lava-9665115/bin/lava-test-runner /lav=
a-9665115/1
 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
at91sam9g20ek                | arm    | lab-broonie     | gcc-10   | multi_=
v5_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/641453e84d25ce7ef28c8671

  Results:     42 PASS, 9 FAIL, 1 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/641453e84d25ce7ef28c8691
        failing since 39 days (last pass: v4.19.271, first fail: v4.19.272)

    2023-03-17T11:49:18.448948  + set +x
    2023-03-17T11:49:18.454128  <8><LAVA_SIGNAL_ENDRUN 0_dmesg 177912_1.5.2=
.4.1>
    2023-03-17T11:49:18.567752  / # #
    2023-03-17T11:49:18.670480  export SHELL=3D/bin/sh
    2023-03-17T11:49:18.671267  #
    2023-03-17T11:49:18.773161  / # export SHELL=3D/bin/sh. /lava-177912/en=
vironment
    2023-03-17T11:49:18.773967  =

    2023-03-17T11:49:18.875920  / # . /lava-177912/environment/lava-177912/=
bin/lava-test-runner /lava-177912/1
    2023-03-17T11:49:18.877215  =

    2023-03-17T11:49:18.883635  / # /lava-177912/bin/lava-test-runner /lava=
-177912/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beaglebone-black             | arm    | lab-broonie     | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6414537ed804ca8b418c864e

  Results:     24 PASS, 20 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-beaglebone-black.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-beaglebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6414537ed804ca8b418c8679
        failing since 52 days (last pass: v4.19.269, first fail: v4.19.271)

    2023-03-17T11:47:35.500495  <8>[   14.757123] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 177924_1.5.2.4.1>
    2023-03-17T11:47:35.611283  / # #
    2023-03-17T11:47:35.713864  export SHELL=3D/bin/sh
    2023-03-17T11:47:35.714448  #
    2023-03-17T11:47:35.816297  / # export SHELL=3D/bin/sh. /lava-177924/en=
vironment
    2023-03-17T11:47:35.816903  =

    2023-03-17T11:47:35.918948  / # . /lava-177924/environment/lava-177924/=
bin/lava-test-runner /lava-177924/1
    2023-03-17T11:47:35.919813  =

    2023-03-17T11:47:35.922939  / # /lava-177924/bin/lava-test-runner /lava=
-177924/1
    2023-03-17T11:47:35.991150  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beaglebone-black             | arm    | lab-cip         | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/64145363a0ae39ebcc8c86b6

  Results:     24 PASS, 20 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm/multi_v7_defconfig/gcc-10/lab-cip/baseline-beaglebone-black.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm/multi_v7_defconfig/gcc-10/lab-cip/baseline-beaglebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64145363a0ae39ebcc8c86bd
        failing since 52 days (last pass: v4.19.269, first fail: v4.19.271)

    2023-03-17T11:47:09.031186  + set +x
    2023-03-17T11:47:09.033236  <8>[    9.851529] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 878462_1.5.2.4.1>
    2023-03-17T11:47:09.141970  / # #
    2023-03-17T11:47:09.243901  export SHELL=3D/bin/sh
    2023-03-17T11:47:09.244358  #
    2023-03-17T11:47:09.345747  / # export SHELL=3D/bin/sh. /lava-878462/en=
vironment
    2023-03-17T11:47:09.346199  =

    2023-03-17T11:47:09.447571  / # . /lava-878462/environment/lava-878462/=
bin/lava-test-runner /lava-878462/1
    2023-03-17T11:47:09.448315  =

    2023-03-17T11:47:09.449929  / # /lava-878462/bin/lava-test-runner /lava=
-878462/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beaglebone-black             | arm    | lab-broonie     | gcc-10   | omap2p=
lus_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/641456a927c7a504e88c8657

  Results:     41 PASS, 10 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beaglebone-black.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beaglebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/641456a927c7a504e88c868b
        new failure (last pass: v4.19.277)

    2023-03-17T12:01:22.732347  + set +x<8>[   18.164904] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 178034_1.5.2.4.1>
    2023-03-17T12:01:22.732879  =

    2023-03-17T12:01:22.844759  / # #
    2023-03-17T12:01:22.947548  export SHELL=3D/bin/sh
    2023-03-17T12:01:22.948260  #
    2023-03-17T12:01:23.050721  / # export SHELL=3D/bin/sh. /lava-178034/en=
vironment
    2023-03-17T12:01:23.051414  =

    2023-03-17T12:01:23.153532  / # . /lava-178034/environment/lava-178034/=
bin/lava-test-runner /lava-178034/1
    2023-03-17T12:01:23.154791  =

    2023-03-17T12:01:23.159474  / # /lava-178034/bin/lava-test-runner /lava=
-178034/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
cubietruck                   | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6414545d36e4dd6cad8c8644

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6414545d36e4dd6cad8c864d
        failing since 57 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-03-17T11:51:29.240126  <8>[    7.363697] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3420227_1.5.2.4.1>
    2023-03-17T11:51:29.350160  / # #
    2023-03-17T11:51:29.454016  export SHELL=3D/bin/sh
    2023-03-17T11:51:29.455059  #
    2023-03-17T11:51:29.557439  / # export SHELL=3D/bin/sh. /lava-3420227/e=
nvironment
    2023-03-17T11:51:29.558627  =

    2023-03-17T11:51:29.660921  / # . /lava-3420227/environment/lava-342022=
7/bin/lava-test-runner /lava-3420227/1
    2023-03-17T11:51:29.662865  =

    2023-03-17T11:51:29.667696  / # /lava-3420227/bin/lava-test-runner /lav=
a-3420227/1
    2023-03-17T11:51:29.750828  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx6q-sabrelite              | arm    | lab-collabora   | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6414534924e6ad77d98c8652

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-imx6q-sabrelite.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-imx6q-sabrelite.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6414534924e6ad77d98c865b
        failing since 57 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-03-17T11:47:12.374507  + set +x

    2023-03-17T11:47:12.377235  <8>[    7.606168] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9665168_1.5.2.4.1>

    2023-03-17T11:47:12.487104  / # #

    2023-03-17T11:47:12.589729  export SHELL=3D/bin/sh

    2023-03-17T11:47:12.590302  #

    2023-03-17T11:47:12.691791  / # export SHELL=3D/bin/sh. /lava-9665168/e=
nvironment

    2023-03-17T11:47:12.692323  =


    2023-03-17T11:47:12.793893  / # . /lava-9665168/environment/lava-966516=
8/bin/lava-test-runner /lava-9665168/1

    2023-03-17T11:47:12.794876  =


    2023-03-17T11:47:12.799552  / # /lava-9665168/bin/lava-test-runner /lav=
a-9665168/1
 =

    ... (15 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx6qp-wandboard-revd1       | arm    | lab-pengutronix | gcc-10   | imx_v6=
_v7_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/641453ce6e82c134418c86b0

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6qp-wandboard-re=
vd1.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6qp-wandboard-re=
vd1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/641453ce6e82c134418c86b9
        failing since 57 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-03-17T11:49:23.830646  + set +x
    2023-03-17T11:49:23.830819  [    7.094692] <LAVA_SIGNAL_ENDRUN 0_dmesg =
920786_1.5.2.3.1>
    2023-03-17T11:49:23.938509  / # #
    2023-03-17T11:49:24.040278  export SHELL=3D/bin/sh
    2023-03-17T11:49:24.040810  #
    2023-03-17T11:49:24.142152  / # export SHELL=3D/bin/sh. /lava-920786/en=
vironment
    2023-03-17T11:49:24.142781  =

    2023-03-17T11:49:24.244215  / # . /lava-920786/environment/lava-920786/=
bin/lava-test-runner /lava-920786/1
    2023-03-17T11:49:24.245024  =

    2023-03-17T11:49:24.248118  / # /lava-920786/bin/lava-test-runner /lava=
-920786/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx6qp-wandboard-revd1       | arm    | lab-pengutronix | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6414532e5353e00f888c8694

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6qp-wandboard-rev=
d1.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6qp-wandboard-rev=
d1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6414532e5353e00f888c869d
        failing since 57 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-03-17T11:46:43.497754  + set +x
    2023-03-17T11:46:43.497924  [    4.912725] <LAVA_SIGNAL_ENDRUN 0_dmesg =
920784_1.5.2.3.1>
    2023-03-17T11:46:43.604251  / # #
    2023-03-17T11:46:43.706045  export SHELL=3D/bin/sh
    2023-03-17T11:46:43.706597  #
    2023-03-17T11:46:43.808001  / # export SHELL=3D/bin/sh. /lava-920784/en=
vironment
    2023-03-17T11:46:43.808637  =

    2023-03-17T11:46:43.910156  / # . /lava-920784/environment/lava-920784/=
bin/lava-test-runner /lava-920784/1
    2023-03-17T11:46:43.911026  =

    2023-03-17T11:46:43.913584  / # /lava-920784/bin/lava-test-runner /lava=
-920784/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx6sx-sdb                   | arm    | lab-nxp         | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/641453d0e77a9da12d8c8684

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6sx-sdb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6sx-sdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/641453d0e77a9da12d8c868b
        failing since 57 days (last pass: v4.19.265, first fail: v4.19.270)

    2023-03-17T11:49:09.711304  <8>[   18.982754] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 1176463_1.5.2.4.1>
    2023-03-17T11:49:09.816908  / # #
    2023-03-17T11:49:10.976876  export SHELL=3D/bin/sh
    2023-03-17T11:49:10.982578  #
    2023-03-17T11:49:12.529666  / # export SHELL=3D/bin/sh. /lava-1176463/e=
nvironment
    2023-03-17T11:49:12.535415  =

    2023-03-17T11:49:15.356285  / # . /lava-1176463/environment/lava-117646=
3/bin/lava-test-runner /lava-1176463/1
    2023-03-17T11:49:15.362564  =

    2023-03-17T11:49:15.373982  / # /lava-1176463/bin/lava-test-runner /lav=
a-1176463/1
    2023-03-17T11:49:15.421995  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (17 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx6ul-14x14-evk             | arm    | lab-nxp         | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/641453cde77a9da12d8c8676

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul-14x14-evk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul-14x14-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/641453cde77a9da12d8c867d
        new failure (last pass: v4.19.260)

    2023-03-17T11:49:15.331838  + set +x
    2023-03-17T11:49:15.332986  <8>[   22.661308] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 1176461_1.5.2.4.1>
    2023-03-17T11:49:15.442959  =

    2023-03-17T11:49:16.602633  / # #export SHELL=3D/bin/sh
    2023-03-17T11:49:16.608364  =

    2023-03-17T11:49:16.608715  / # export SHELL=3D/bin/sh
    2023-03-17T11:49:18.155862  . /lava-1176461/environment
    2023-03-17T11:49:18.161289  / # . /lava-1176461/environment
    2023-03-17T11:49:20.981830  /lava-1176461/bin/lava-test-runner /lava-11=
76461/1
    2023-03-17T11:49:20.987908  / # /lava-1176461/bin/lava-test-runner /lav=
a-1176461/1 =

    ... (15 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx7d-sdb                    | arm    | lab-nxp         | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/641453f6428b4467518c8648

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sdb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/641453f6428b4467518c864f
        failing since 57 days (last pass: v4.19.267, first fail: v4.19.270)

    2023-03-17T11:49:41.577249  <8>[   12.920490] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 1176462_1.5.2.4.1>
    2023-03-17T11:49:41.682771  / # #
    2023-03-17T11:49:42.842969  export SHELL=3D/bin/sh
    2023-03-17T11:49:42.848652  #
    2023-03-17T11:49:44.396431  / # export SHELL=3D/bin/sh. /lava-1176462/e=
nvironment
    2023-03-17T11:49:44.402128  =

    2023-03-17T11:49:47.224757  / # . /lava-1176462/environment/lava-117646=
2/bin/lava-test-runner /lava-1176462/1
    2023-03-17T11:49:47.230858  =

    2023-03-17T11:49:47.236274  / # /lava-1176462/bin/lava-test-runner /lav=
a-1176462/1
    2023-03-17T11:49:47.338166  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (16 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/641455729c0ddad6a78c863c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/641455729c0ddad6a78c8=
63d
        failing since 193 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-baylibre    | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/64145846a7ada9ffd78c8690

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64145846a7ada9ffd78c8=
691
        failing since 230 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/641456af27c7a504e88c8690

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/641456af27c7a504e88c8=
691
        failing since 193 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-broonie     | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/641458535b14d849538c8651

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/641458535b14d849538c8=
652
        failing since 230 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/6414553056ae83b1478c865c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6414553056ae83b1478c8=
65d
        failing since 193 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/64145827b391e4e15f8c8642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64145827b391e4e15f8c8=
643
        failing since 230 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/641455869c0ddad6a78c865e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/641455869c0ddad6a78c8=
65f
        failing since 193 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-baylibre    | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/64145844a7ada9ffd78c868d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64145844a7ada9ffd78c8=
68e
        failing since 230 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/6414554681a4fce0488c8660

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6414554681a4fce0488c8=
661
        failing since 193 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-broonie     | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/6414583f52eeb046c98c8659

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6414583f52eeb046c98c8=
65a
        failing since 230 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/6414552f56ae83b1478c8632

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv2-uefi.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6414552f56ae83b1478c8=
633
        failing since 193 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/641458215db3f152008c8684

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/641458215db3f152008c8=
685
        failing since 230 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/64145587d5d94a29e88c863a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64145587d5d94a29e88c8=
63b
        failing since 193 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-baylibre    | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/64145848a7ada9ffd78c8696

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64145848a7ada9ffd78c8=
697
        failing since 230 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/6414558221786a45e48c8657

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6414558221786a45e48c8=
658
        failing since 193 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-broonie     | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/641458cb708603ea328c8631

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/641458cb708603ea328c8=
632
        failing since 230 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/641455280cef7c295a8c867a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/641455280cef7c295a8c8=
67b
        failing since 193 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/6414582a52eeb046c98c863e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6414582a52eeb046c98c8=
63f
        failing since 230 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/64145588d5d94a29e88c863d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64145588d5d94a29e88c8=
63e
        failing since 193 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-baylibre    | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/64145847a7ada9ffd78c8693

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64145847a7ada9ffd78c8=
694
        failing since 230 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/641455c157c3f973e58c8642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/641455c157c3f973e58c8=
643
        failing since 193 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-broonie     | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/64145867e9c4cdd3a78c8632

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64145867e9c4cdd3a78c8=
633
        failing since 230 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/6414552956ae83b1478c862f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv3-uefi.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6414552956ae83b1478c8=
630
        failing since 193 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/64145829a7ada9ffd78c8630

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64145829a7ada9ffd78c8=
631
        failing since 230 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
r8a7743-iwg20d-q7            | arm    | lab-cip         | gcc-10   | shmobi=
le_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/641452d10e7d738f808c8644

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/641452d10e7d738f808c8=
645
        failing since 111 days (last pass: v4.19.266, first fail: v4.19.267=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
rk3288-veyron-jaq            | arm    | lab-collabora   | gcc-10   | multi_=
v7_defconfig           | 3          =


  Details:     https://kernelci.org/test/plan/id/6414534b24e6ad77d98c865d

  Results:     61 PASS, 8 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.dwhdmi-rockchip-driver-cec-present: https://kernelci.or=
g/test/case/id/6414534b24e6ad77d98c8691
        failing since 56 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-03-17T11:46:51.922070  BusyBox v1.31.1 (2023-03-10 17:51:43 UTC)<8=
>[   10.246990] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwhdmi-rockchip-driver=
-audio-present RESULT=3Dfail>

    2023-03-17T11:46:51.923576   multi-call binary.

    2023-03-17T11:46:51.923809  =


    2023-03-17T11:46:51.928173  Usage: seq [-w] [-s SEP] [FIRST [INC]] LAST

    2023-03-17T11:46:51.928408  =


    2023-03-17T11:46:51.933351  Print numbers from FIRST to LAST, in steps =
of INC.
   =


  * baseline.bootrr.dwhdmi-rockchip-driver-audio-present: https://kernelci.=
org/test/case/id/6414534b24e6ad77d98c8692
        failing since 56 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-03-17T11:46:51.903654  /lava-9665171/1/../bin/lava-test-case<8>[  =
 10.229922] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwhdmi-rockchip-probed RES=
ULT=3Dpass>

    2023-03-17T11:46:51.903908  =

   =


  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6414534b24e6ad77d98c86a5
        failing since 56 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-03-17T11:46:48.069880  <8>[    6.395711] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>

    2023-03-17T11:46:48.079216  + <8>[    6.407825] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9665171_1.5.2.3.1>

    2023-03-17T11:46:48.079480  set +x

    2023-03-17T11:46:48.186462  #

    2023-03-17T11:46:48.188097  =


    2023-03-17T11:46:48.290534  / # #export SHELL=3D/bin/sh

    2023-03-17T11:46:48.291479  =


    2023-03-17T11:46:48.393440  / # export SHELL=3D/bin/sh. /lava-9665171/e=
nvironment

    2023-03-17T11:46:48.394218  =


    2023-03-17T11:46:48.496339  / # . /lava-9665171/environment/lava-966517=
1/bin/lava-test-runner /lava-9665171/1
 =

    ... (17 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
rk3399-gru-kevin             | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 2          =


  Details:     https://kernelci.org/test/plan/id/6414575e4973d0b9d38c8649

  Results:     77 PASS, 5 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/6414575e4973d0b9d38c8653
        new failure (last pass: v4.19.277)

    2023-03-17T12:04:28.363185  /lava-9665306/1/../bin/lava-test-case<8>[  =
 36.427845] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-usb2phy0-probed R=
ESULT=3Dfail>

    2023-03-17T12:04:28.363279  =


    2023-03-17T12:04:29.376464  /lava-9665306/1/../bin/lava-test-case

    2023-03-17T12:04:29.384880  <8>[   37.449891] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy1-probed RESULT=3Dfail>
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/6414575e4973d0b9d38c8654
        new failure (last pass: v4.19.277)

    2023-03-17T12:04:27.342094  <8>[   35.404981] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy-driver-present RESULT=3Dpass>
   =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun50i-a64-pine64-plus       | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/6414546d2117ee96138c8634

  Results:     23 PASS, 16 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pine64-plus.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pine64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6414546d2117ee96138c865e
        failing since 57 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-03-17T11:51:37.655592  <8>[   15.986860] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 177996_1.5.2.4.1>
    2023-03-17T11:51:37.761851  / # #
    2023-03-17T11:51:37.864686  export SHELL=3D/bin/sh
    2023-03-17T11:51:37.865420  #
    2023-03-17T11:51:37.967707  / # export SHELL=3D/bin/sh. /lava-177996/en=
vironment
    2023-03-17T11:51:37.968477  =

    2023-03-17T11:51:38.070911  / # . /lava-177996/environment/lava-177996/=
bin/lava-test-runner /lava-177996/1
    2023-03-17T11:51:38.072050  =

    2023-03-17T11:51:38.076026  / # /lava-177996/bin/lava-test-runner /lava=
-177996/1
    2023-03-17T11:51:38.108175  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun50i-h6-pine-h64           | arm64  | lab-clabbe      | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/64145438e6b2de1c848c8659

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-pine-h64.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-pine-h64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64145438e6b2de1c848c8662
        failing since 57 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-03-17T11:51:07.088466  <8>[   15.171962] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 414228_1.5.2.4.1>
    2023-03-17T11:51:07.193572  / # #
    2023-03-17T11:51:07.295503  export SHELL=3D/bin/sh
    2023-03-17T11:51:07.296039  #
    2023-03-17T11:51:07.397368  / # export SHELL=3D/bin/sh. /lava-414228/en=
vironment
    2023-03-17T11:51:07.397892  =

    2023-03-17T11:51:07.499270  / # . /lava-414228/environment/lava-414228/=
bin/lava-test-runner /lava-414228/1
    2023-03-17T11:51:07.500051  =

    2023-03-17T11:51:07.504018  / # /lava-414228/bin/lava-test-runner /lava=
-414228/1
    2023-03-17T11:51:07.574128  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun50i-h6-pine-h64           | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/6414544d74a845e0868c8679

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm64/defconfig/gcc-10/lab-collabora/baseline-sun50i-h6-pine-h64.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm64/defconfig/gcc-10/lab-collabora/baseline-sun50i-h6-pine-h64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6414544d74a845e0868c8682
        failing since 57 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-03-17T11:51:26.092696  / # #

    2023-03-17T11:51:26.195675  export SHELL=3D/bin/sh

    2023-03-17T11:51:26.196455  #

    2023-03-17T11:51:26.298454  / # export SHELL=3D/bin/sh. /lava-9665216/e=
nvironment

    2023-03-17T11:51:26.299323  =


    2023-03-17T11:51:26.401427  / # . /lava-9665216/environment/lava-966521=
6/bin/lava-test-runner /lava-9665216/1

    2023-03-17T11:51:26.402753  =


    2023-03-17T11:51:26.413784  / # /lava-9665216/bin/lava-test-runner /lav=
a-9665216/1

    2023-03-17T11:51:26.477857  + export 'TESTRUN_ID=3D1_bootrr'

    2023-03-17T11:51:26.478376  + cd /lava-9665216<8>[   15.643385] <LAVA_S=
IGNAL_STARTRUN 1_bootrr 9665216_1.5.2.4.5>
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-a33-olinuxino          | arm    | lab-clabbe      | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6414536dd804ca8b418c8635

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a33-olinuxino.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a33-olinuxino.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6414536dd804ca8b418c863e
        failing since 57 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-03-17T11:47:31.950551  <8>[   17.176366] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 414222_1.5.2.4.1>
    2023-03-17T11:47:32.057103  / # #
    2023-03-17T11:47:32.159381  export SHELL=3D/bin/sh
    2023-03-17T11:47:32.159939  #
    2023-03-17T11:47:32.261570  / # export SHELL=3D/bin/sh. /lava-414222/en=
vironment
    2023-03-17T11:47:32.262268  =

    2023-03-17T11:47:32.363906  / # . /lava-414222/environment/lava-414222/=
bin/lava-test-runner /lava-414222/1
    2023-03-17T11:47:32.364881  =

    2023-03-17T11:47:32.381565  / # /lava-414222/bin/lava-test-runner /lava=
-414222/1
    2023-03-17T11:47:32.494597  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/64145358a0ae39ebcc8c8665

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h3-libretech-all-=
h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h3-libretech-all-=
h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64145358a0ae39ebcc8c866e
        failing since 57 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-03-17T11:47:07.492730  / # #
    2023-03-17T11:47:07.594829  export SHELL=3D/bin/sh
    2023-03-17T11:47:07.595318  #
    2023-03-17T11:47:07.696842  / # export SHELL=3D/bin/sh. /lava-3420230/e=
nvironment
    2023-03-17T11:47:07.697438  =

    2023-03-17T11:47:07.799010  / # . /lava-3420230/environment/lava-342023=
0/bin/lava-test-runner /lava-3420230/1
    2023-03-17T11:47:07.799896  =

    2023-03-17T11:47:07.817300  / # /lava-3420230/bin/lava-test-runner /lav=
a-3420230/1
    2023-03-17T11:47:07.891189  + export 'TESTRUN_ID=3D1_bootrr'
    2023-03-17T11:47:07.891822  + cd /lava-3420230/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre    | gcc-10   | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/641451758805e2343d8c9f93

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h3-libretech-all-h3-=
cc.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h3-libretech-all-h3-=
cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/641451758805e2343d8c9f9c
        failing since 57 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-03-17T11:39:11.315596  / # #
    2023-03-17T11:39:11.417687  export SHELL=3D/bin/sh
    2023-03-17T11:39:11.418172  #
    2023-03-17T11:39:11.519673  / # export SHELL=3D/bin/sh. /lava-3420184/e=
nvironment
    2023-03-17T11:39:11.520138  =

    2023-03-17T11:39:11.621680  / # . /lava-3420184/environment/lava-342018=
4/bin/lava-test-runner /lava-3420184/1
    2023-03-17T11:39:11.622563  =

    2023-03-17T11:39:11.640365  / # /lava-3420184/bin/lava-test-runner /lav=
a-3420184/1
    2023-03-17T11:39:11.706161  + export 'TESTRUN_ID=3D1_bootrr'
    2023-03-17T11:39:11.706776  + cd /lava-3420184/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h3-orangepi-pc         | arm    | lab-clabbe      | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/641453a9748f3c6c048c876b

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-orangepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-orangepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/641453a9748f3c6c048c8774
        failing since 57 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-03-17T11:48:29.317053  + set +x
    2023-03-17T11:48:29.319108  <8>[   15.825291] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 414220_1.5.2.4.1>
    2023-03-17T11:48:29.427263  / # #
    2023-03-17T11:48:29.529625  export SHELL=3D/bin/sh
    2023-03-17T11:48:29.530275  #
    2023-03-17T11:48:29.632006  / # export SHELL=3D/bin/sh. /lava-414220/en=
vironment
    2023-03-17T11:48:29.632694  =

    2023-03-17T11:48:29.735522  / # . /lava-414220/environment/lava-414220/=
bin/lava-test-runner /lava-414220/1
    2023-03-17T11:48:29.736524  =

    2023-03-17T11:48:29.738599  / # /lava-414220/bin/lava-test-runner /lava=
-414220/1 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h3-orangepi-pc         | arm    | lab-clabbe      | gcc-10   | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/64145255fa81a1a1e18c8657

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-orangepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-orangepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64145255fa81a1a1e18c8660
        failing since 57 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-03-17T11:43:01.539139  + set +x
    2023-03-17T11:43:01.541218  <8>[   14.398562] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 414219_1.5.2.4.1>
    2023-03-17T11:43:01.649482  / # #
    2023-03-17T11:43:01.751903  export SHELL=3D/bin/sh
    2023-03-17T11:43:01.752511  #
    2023-03-17T11:43:01.854198  / # export SHELL=3D/bin/sh. /lava-414219/en=
vironment
    2023-03-17T11:43:01.854750  =

    2023-03-17T11:43:01.956584  / # . /lava-414219/environment/lava-414219/=
bin/lava-test-runner /lava-414219/1
    2023-03-17T11:43:01.957616  =

    2023-03-17T11:43:01.959271  / # /lava-414219/bin/lava-test-runner /lava=
-414219/1 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
tegra124-nyan-big            | arm    | lab-collabora   | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/64145439e6ae8099698c8661

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-tegra124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-tegra124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64145439e6ae8099698c866a
        failing since 56 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-03-17T11:51:07.193750  + set +x

    2023-03-17T11:51:07.201774  <8>[   18.164772] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9665166_1.5.2.3.1>

    2023-03-17T11:51:07.309534  #

    2023-03-17T11:51:07.412161  / # #export SHELL=3D/bin/sh

    2023-03-17T11:51:07.412811  =


    2023-03-17T11:51:07.514399  / # export SHELL=3D/bin/sh. /lava-9665166/e=
nvironment

    2023-03-17T11:51:07.515101  =


    2023-03-17T11:51:07.616719  / # . /lava-9665166/environment/lava-966516=
6/bin/lava-test-runner /lava-9665166/1

    2023-03-17T11:51:07.617835  =


    2023-03-17T11:51:07.620174  / # /lava-9665166/bin/lava-test-runner /lav=
a-9665166/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
tegra124-nyan-big            | arm    | lab-collabora   | gcc-10   | tegra_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/641457968aecd434058c8650

  Results:     3 PASS, 3 FAIL, 1 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/641457968aecd434058c8659
        failing since 56 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-03-17T12:05:26.296189  kern  :emerg : Process udevadm (pid<8>[   1=
8.688003] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3D=
lines MEASUREMENT=3D11>

    2023-03-17T12:05:26.297887  : 139, stack limit =3D 0x(ptrval))

    2023-03-17T12:05:26.307523  kern  :emerg : Stack: <8>[   18.701478] <LA=
VA_SIGNAL_ENDRUN 0_dmesg 9665231_1.5.2.3.1>

    2023-03-17T12:05:26.308006  (0xc2be1f2c to 0xc2be2000)

    2023-03-17T12:05:26.316198  kern  :emerg : 1f20:                       =
     c02e8190 00000000 00000000 c026d82c 00000003

    2023-03-17T12:05:26.324253  kern  :emerg : 1f40: ee36f540 be9f9f74 c2be=
1f80 00000000 c2be0000 00000004 00000003 c02706e0

    2023-03-17T12:05:26.332393  kern  :emerg : 1f60: edfe44e0 c026d82c ee36=
f540 ee36f540 be9f9f74 00000003 c0101264 c0270944

    2023-03-17T12:05:26.340658  kern  :emerg : 1f80: 00000000 00000000 c2be=
1fb0 6e2e129d b6f3a7c0 00000003 b6f3a7c0 be9f9468

    2023-03-17T12:05:26.348750  kern  :emerg : 1fa0: 00000004 c0101000 0000=
0003 b6f3a7c0 00000003 be9f9f74 00000003 00000000

    2023-03-17T12:05:26.356939  kern  :emerg : 1fc0: 00000003 b6f3a7c0 be9f=
9468 00000004 00000003 0003c90c be9f9e58 00000003
 =

    ... (23 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
zynqmp-zcu102                | arm64  | lab-cip         | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/6414542ced0a128e998c8642

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm64/defconfig/gcc-10/lab-cip/baseline-zynqmp-zcu102.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm64/defconfig/gcc-10/lab-cip/baseline-zynqmp-zcu102.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6414542ced0a128e998c8649
        failing since 57 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-03-17T11:50:49.672679  + set +x
    2023-03-17T11:50:49.673774  <8>[    3.757282] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 878480_1.5.2.4.1>
    2023-03-17T11:50:49.776594  / # #
    2023-03-17T11:50:49.877879  export SHELL=3D/bin/sh
    2023-03-17T11:50:49.878214  #
    2023-03-17T11:50:49.979219  / # export SHELL=3D/bin/sh. /lava-878480/en=
vironment
    2023-03-17T11:50:49.979548  =

    2023-03-17T11:50:50.080555  / # . /lava-878480/environment/lava-878480/=
bin/lava-test-runner /lava-878480/1
    2023-03-17T11:50:50.081047  =

    2023-03-17T11:50:50.083696  / # /lava-878480/bin/lava-test-runner /lava=
-878480/1 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
zynqmp-zcu102                | arm64  | lab-cip         | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/6414572394fe26a82c8c8636

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-cip/baseline-zynqmp-zcu102.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.278/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-cip/baseline-zynqmp-zcu102.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6414572394fe26a82c8c863d
        failing since 57 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-03-17T12:03:25.748777  + set +x
    2023-03-17T12:03:25.749831  <8>[    3.727446] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 878492_1.5.2.4.1>
    2023-03-17T12:03:25.854655  / # #
    2023-03-17T12:03:25.955848  export SHELL=3D/bin/sh
    2023-03-17T12:03:25.956081  #
    2023-03-17T12:03:26.057089  / # export SHELL=3D/bin/sh. /lava-878492/en=
vironment
    2023-03-17T12:03:26.057410  =

    2023-03-17T12:03:26.158434  / # . /lava-878492/environment/lava-878492/=
bin/lava-test-runner /lava-878492/1
    2023-03-17T12:03:26.158896  =

    2023-03-17T12:03:26.161710  / # /lava-878492/bin/lava-test-runner /lava=
-878492/1 =

    ... (13 line(s) more)  =

 =20
