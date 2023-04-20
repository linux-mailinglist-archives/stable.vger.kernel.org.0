Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42DC16E981A
	for <lists+stable@lfdr.de>; Thu, 20 Apr 2023 17:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231706AbjDTPLi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Apr 2023 11:11:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230483AbjDTPLh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Apr 2023 11:11:37 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B8D45581
        for <stable@vger.kernel.org>; Thu, 20 Apr 2023 08:11:32 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id 98e67ed59e1d1-24736992dd3so708697a91.1
        for <stable@vger.kernel.org>; Thu, 20 Apr 2023 08:11:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1682003492; x=1684595492;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=gvxQMDB7WeR70HxN9xULe2YoCEy1Q1cLF/ySf9l/ja4=;
        b=wUUttOEjwwdS2hEZVSr2/Sq/H9GblKWOfhpZpXIs/CNILgNDwxpwFVZUnrCsFNLTyT
         c31CfERNgJTBLdQAYbrzWCwoR6R/YgCA4N2t1qxouVulnPTk54lbsuyflVh/7rPKtfge
         SwjH0YICNH9DlVahm7fXdx4rBQv5if+wGm0Yue5WINW/1gtyMEuXczqfbSEu+S8frAsQ
         uFAdWL8ikMeJQ0+VuWKYHfbOcGIfVmIJ6G6Qq6d7qr1RiFoXA28oI+bLLSD4vw6Dgj+b
         cBoUxL+cbvcxFuDGxffIz2pk+uszKrox/IganJvVEp1JqsvoIWbPyEQPM/hl4AOybvCH
         kxIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682003492; x=1684595492;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gvxQMDB7WeR70HxN9xULe2YoCEy1Q1cLF/ySf9l/ja4=;
        b=OwmjbHo2EwlpDlL+ub6UoNNzZY2+cfKDfaNys3jR6/HbwZWvfcZtXqL6YO7527w4Z8
         H6t4/NKnSZJceiMwm80HbokRD5KcihQG9kYeH0ev01zjVLax7XmyBoZaWlewC1AO3XJk
         Naigs1trkSuzH84r+jSrsFGRHia5kuX72yl5nKy0yN4WxVOaI9qhWGd9gxSfJXkzYFVa
         QkSSYHGtoDZkf48jAxjsShJ0nfGhNv7mRYmOYinF1gUYtSCBktVdf6tJEtNUCT753zKC
         DWLYgJS/IkMdiWKOVfaHidy/oGEBy/ZRp/IA4z9MnlKAWDscutnBX99ntpGiJwBWzLGd
         P0hQ==
X-Gm-Message-State: AAQBX9cLhUSDiD9yiKJ4tQH5XvTgFrnWw6tx7v4ci9n0XG3J9Q0Sj5lh
        WW5cOAPTcanF9cVohVBC0e9xhqDKYflJBE+8AblZ0BKw
X-Google-Smtp-Source: AKy350Zl7luJ9ut388jUY107xqdmlzLE2U6RpM+En+SfhLs5hykQfYcDE5oWUapRrgILkJu34jhiKg==
X-Received: by 2002:a17:90a:d793:b0:234:5d3c:b02b with SMTP id z19-20020a17090ad79300b002345d3cb02bmr1993812pju.42.1682003490796;
        Thu, 20 Apr 2023 08:11:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s2-20020a170902988200b0019a7d58e595sm1281089plp.143.2023.04.20.08.11.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 08:11:30 -0700 (PDT)
Message-ID: <64415622.170a0220.e4515.2620@mx.google.com>
Date:   Thu, 20 Apr 2023 08:11:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.19.281
X-Kernelci-Report-Type: test
Subject: stable/linux-4.19.y baseline: 116 runs, 40 regressions (v4.19.281)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y baseline: 116 runs, 40 regressions (v4.19.281)

Regressions Summary
-------------------

platform                   | arch   | lab             | compiler | defconfi=
g                    | regressions
---------------------------+--------+-----------------+----------+---------=
---------------------+------------
asus-C433TA-AJ0005-rammus  | x86_64 | lab-collabora   | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

asus-C523NA-A20057-coral   | x86_64 | lab-collabora   | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

at91sam9g20ek              | arm    | lab-broonie     | gcc-10   | multi_v5=
_defconfig           | 1          =

beagle-xm                  | arm    | lab-baylibre    | gcc-10   | omap2plu=
s_defconfig          | 1          =

beaglebone-black           | arm    | lab-broonie     | gcc-10   | multi_v7=
_defconfig           | 1          =

beaglebone-black           | arm    | lab-cip         | gcc-10   | multi_v7=
_defconfig           | 1          =

beaglebone-black           | arm    | lab-cip         | gcc-10   | omap2plu=
s_defconfig          | 1          =

cubietruck                 | arm    | lab-baylibre    | gcc-10   | multi_v7=
_defconfig           | 1          =

dove-cubox                 | arm    | lab-pengutronix | gcc-10   | mvebu_v7=
_defconfig           | 1          =

imx6q-sabrelite            | arm    | lab-collabora   | gcc-10   | multi_v7=
_defconfig           | 1          =

imx6qp-wandboard-revd1     | arm    | lab-pengutronix | gcc-10   | imx_v6_v=
7_defconfig          | 1          =

imx6qp-wandboard-revd1     | arm    | lab-pengutronix | gcc-10   | multi_v7=
_defconfig           | 1          =

imx6ul-14x14-evk           | arm    | lab-nxp         | gcc-10   | multi_v7=
_defconfig           | 1          =

imx7d-sdb                  | arm    | lab-nxp         | gcc-10   | multi_v7=
_defconfig           | 1          =

qemu_arm64-virt-gicv2      | arm64  | lab-broonie     | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv2      | arm64  | lab-broonie     | gcc-10   | defconfi=
g                    | 1          =

qemu_arm64-virt-gicv2      | arm64  | lab-collabora   | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv2      | arm64  | lab-collabora   | gcc-10   | defconfi=
g                    | 1          =

qemu_arm64-virt-gicv2-uefi | arm64  | lab-broonie     | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv2-uefi | arm64  | lab-broonie     | gcc-10   | defconfi=
g                    | 1          =

qemu_arm64-virt-gicv2-uefi | arm64  | lab-collabora   | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv2-uefi | arm64  | lab-collabora   | gcc-10   | defconfi=
g                    | 1          =

qemu_arm64-virt-gicv3      | arm64  | lab-broonie     | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv3      | arm64  | lab-broonie     | gcc-10   | defconfi=
g                    | 1          =

qemu_arm64-virt-gicv3      | arm64  | lab-collabora   | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv3      | arm64  | lab-collabora   | gcc-10   | defconfi=
g                    | 1          =

qemu_arm64-virt-gicv3-uefi | arm64  | lab-broonie     | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv3-uefi | arm64  | lab-broonie     | gcc-10   | defconfi=
g                    | 1          =

qemu_arm64-virt-gicv3-uefi | arm64  | lab-collabora   | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv3-uefi | arm64  | lab-collabora   | gcc-10   | defconfi=
g                    | 1          =

r8a7743-iwg20d-q7          | arm    | lab-cip         | gcc-10   | shmobile=
_defconfig           | 1          =

rk3288-veyron-jaq          | arm    | lab-collabora   | gcc-10   | multi_v7=
_defconfig           | 3          =

rk3399-gru-kevin           | arm64  | lab-collabora   | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =

sun50i-a64-pine64-plus     | arm64  | lab-broonie     | gcc-10   | defconfi=
g                    | 1          =

sun50i-h6-pine-h64         | arm64  | lab-collabora   | gcc-10   | defconfi=
g                    | 1          =

zynqmp-zcu102              | arm64  | lab-cip         | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =

zynqmp-zcu102              | arm64  | lab-cip         | gcc-10   | defconfi=
g                    | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.281/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.281
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      a5b79a58cfc02977cd4d5c1e20454cd98e88f749 =



Test Regressions
---------------- =



platform                   | arch   | lab             | compiler | defconfi=
g                    | regressions
---------------------------+--------+-----------------+----------+---------=
---------------------+------------
asus-C433TA-AJ0005-rammus  | x86_64 | lab-collabora   | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64412264c367dac2472e85f3

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
433TA-AJ0005-rammus.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
433TA-AJ0005-rammus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64412264c367dac2472e85f8
        failing since 91 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-04-20T11:30:25.910749  + set +x

    2023-04-20T11:30:25.917129  <8>[   11.000612] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10060735_1.4.2.3.1>

    2023-04-20T11:30:26.022136  / # #

    2023-04-20T11:30:26.123107  export SHELL=3D/bin/sh

    2023-04-20T11:30:26.123283  #

    2023-04-20T11:30:26.224180  / # export SHELL=3D/bin/sh. /lava-10060735/=
environment

    2023-04-20T11:30:26.224363  =


    2023-04-20T11:30:26.325261  / # . /lava-10060735/environment/lava-10060=
735/bin/lava-test-runner /lava-10060735/1

    2023-04-20T11:30:26.325569  =


    2023-04-20T11:30:26.330868  / # /lava-10060735/bin/lava-test-runner /la=
va-10060735/1
 =

    ... (12 line(s) more)  =

 =



platform                   | arch   | lab             | compiler | defconfi=
g                    | regressions
---------------------------+--------+-----------------+----------+---------=
---------------------+------------
asus-C523NA-A20057-coral   | x86_64 | lab-collabora   | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/644122639f32f94da22e8648

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
523NA-A20057-coral.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
523NA-A20057-coral.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644122639f32f94da22e864d
        failing since 91 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-04-20T11:30:31.011220  + set +x

    2023-04-20T11:30:31.018123  <8>[   11.705479] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10060716_1.4.2.3.1>

    2023-04-20T11:30:31.123027  / # #

    2023-04-20T11:30:31.223764  export SHELL=3D/bin/sh

    2023-04-20T11:30:31.223984  #

    2023-04-20T11:30:31.324914  / # export SHELL=3D/bin/sh. /lava-10060716/=
environment

    2023-04-20T11:30:31.325132  =


    2023-04-20T11:30:31.426140  / # . /lava-10060716/environment/lava-10060=
716/bin/lava-test-runner /lava-10060716/1

    2023-04-20T11:30:31.426551  =


    2023-04-20T11:30:31.431414  / # /lava-10060716/bin/lava-test-runner /la=
va-10060716/1
 =

    ... (13 line(s) more)  =

 =



platform                   | arch   | lab             | compiler | defconfi=
g                    | regressions
---------------------------+--------+-----------------+----------+---------=
---------------------+------------
at91sam9g20ek              | arm    | lab-broonie     | gcc-10   | multi_v5=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/644123e848c1fb2a212e862f

  Results:     42 PASS, 9 FAIL, 1 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644123e848c1fb2a212e8661
        failing since 73 days (last pass: v4.19.271, first fail: v4.19.272)

    2023-04-20T11:36:34.529672  + set +x
    2023-04-20T11:36:34.534873  <8><LAVA_SIGNAL_ENDRUN 0_dmesg 360452_1.5.2=
.4.1>
    2023-04-20T11:36:34.647988  / # #
    2023-04-20T11:36:34.750780  export SHELL=3D/bin/sh
    2023-04-20T11:36:34.751542  #
    2023-04-20T11:36:34.853383  / # export SHELL=3D/bin/sh. /lava-360452/en=
vironment
    2023-04-20T11:36:34.854215  =

    2023-04-20T11:36:34.956135  / # . /lava-360452/environment/lava-360452/=
bin/lava-test-runner /lava-360452/1
    2023-04-20T11:36:34.957368  =

    2023-04-20T11:36:34.963880  / # /lava-360452/bin/lava-test-runner /lava=
-360452/1 =

    ... (12 line(s) more)  =

 =



platform                   | arch   | lab             | compiler | defconfi=
g                    | regressions
---------------------------+--------+-----------------+----------+---------=
---------------------+------------
beagle-xm                  | arm    | lab-baylibre    | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/6441239f4fc74883472e85ee

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6441239f4fc74883472e85f3
        failing since 86 days (last pass: v4.19.268, first fail: v4.19.271)

    2023-04-20T11:35:39.899311  + set +x<8>[   25.280731] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3515780_1.5.2.4.1>
    2023-04-20T11:35:39.899976  =

    2023-04-20T11:35:40.013727  / # #
    2023-04-20T11:35:40.117718  export SHELL=3D/bin/sh
    2023-04-20T11:35:40.118597  #
    2023-04-20T11:35:40.220594  / # export SHELL=3D/bin/sh. /lava-3515780/e=
nvironment
    2023-04-20T11:35:40.221442  =

    2023-04-20T11:35:40.323550  / # . /lava-3515780/environment/lava-351578=
0/bin/lava-test-runner /lava-3515780/1
    2023-04-20T11:35:40.324862  =

    2023-04-20T11:35:40.329633  / # /lava-3515780/bin/lava-test-runner /lav=
a-3515780/1 =

    ... (12 line(s) more)  =

 =



platform                   | arch   | lab             | compiler | defconfi=
g                    | regressions
---------------------------+--------+-----------------+----------+---------=
---------------------+------------
beaglebone-black           | arm    | lab-broonie     | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/644121861df3bfe5832e85f6

  Results:     24 PASS, 20 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-beaglebone-black.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-beaglebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644121861df3bfe5832e8621
        failing since 91 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-04-20T11:26:12.652966  <8>[   11.821472] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 360381_1.5.2.4.1>
    2023-04-20T11:26:12.760645  / # #
    2023-04-20T11:26:12.863038  export SHELL=3D/bin/sh
    2023-04-20T11:26:12.863662  #
    2023-04-20T11:26:12.965405  / # export SHELL=3D/bin/sh. /lava-360381/en=
vironment
    2023-04-20T11:26:12.966092  =

    2023-04-20T11:26:13.067662  / # . /lava-360381/environment/lava-360381/=
bin/lava-test-runner /lava-360381/1
    2023-04-20T11:26:13.068408  =

    2023-04-20T11:26:13.071890  / # /lava-360381/bin/lava-test-runner /lava=
-360381/1
    2023-04-20T11:26:13.140579  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                   | arch   | lab             | compiler | defconfi=
g                    | regressions
---------------------------+--------+-----------------+----------+---------=
---------------------+------------
beaglebone-black           | arm    | lab-cip         | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/644129bb3ed73c7b7a2e85e8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
arm/multi_v7_defconfig/gcc-10/lab-cip/baseline-beaglebone-black.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
arm/multi_v7_defconfig/gcc-10/lab-cip/baseline-beaglebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/644129bb3ed73c7b7a2e8=
5e9
        new failure (last pass: v4.19.280) =

 =



platform                   | arch   | lab             | compiler | defconfi=
g                    | regressions
---------------------------+--------+-----------------+----------+---------=
---------------------+------------
beaglebone-black           | arm    | lab-cip         | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/644135a70bdbe94d6c2e85eb

  Results:     41 PASS, 10 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
arm/omap2plus_defconfig/gcc-10/lab-cip/baseline-beaglebone-black.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
arm/omap2plus_defconfig/gcc-10/lab-cip/baseline-beaglebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644135a70bdbe94d6c2e85ee
        failing since 15 days (last pass: v4.19.279, first fail: v4.19.280)

    2023-04-20T12:52:16.831924  + set +x<8>[   10.536801] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 910535_1.5.2.4.1>
    2023-04-20T12:52:16.832407  =

    2023-04-20T12:52:16.945248  / # #
    2023-04-20T12:52:17.047397  export SHELL=3D/bin/sh
    2023-04-20T12:52:17.048049  #
    2023-04-20T12:52:17.149875  / # export SHELL=3D/bin/sh. /lava-910535/en=
vironment
    2023-04-20T12:52:17.150573  =

    2023-04-20T12:52:17.252407  / # . /lava-910535/environment/lava-910535/=
bin/lava-test-runner /lava-910535/1
    2023-04-20T12:52:17.253550  =

    2023-04-20T12:52:17.259760  / # /lava-910535/bin/lava-test-runner /lava=
-910535/1 =

    ... (12 line(s) more)  =

 =



platform                   | arch   | lab             | compiler | defconfi=
g                    | regressions
---------------------------+--------+-----------------+----------+---------=
---------------------+------------
cubietruck                 | arm    | lab-baylibre    | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/644121225e6620478e2e85ea

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644121225e6620478e2e85ef
        failing since 91 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-04-20T11:25:05.016331  <8>[    7.356788] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3515733_1.5.2.4.1>
    2023-04-20T11:25:05.126934  / # #
    2023-04-20T11:25:05.230015  export SHELL=3D/bin/sh
    2023-04-20T11:25:05.230895  #
    2023-04-20T11:25:05.332819  / # export SHELL=3D/bin/sh. /lava-3515733/e=
nvironment
    2023-04-20T11:25:05.333743  =

    2023-04-20T11:25:05.435765  / # . /lava-3515733/environment/lava-351573=
3/bin/lava-test-runner /lava-3515733/1
    2023-04-20T11:25:05.437249  =

    2023-04-20T11:25:05.442200  / # /lava-3515733/bin/lava-test-runner /lav=
a-3515733/1
    2023-04-20T11:25:05.527519  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                   | arch   | lab             | compiler | defconfi=
g                    | regressions
---------------------------+--------+-----------------+----------+---------=
---------------------+------------
dove-cubox                 | arm    | lab-pengutronix | gcc-10   | mvebu_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/64412340fba54b17d52e861b

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: mvebu_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
arm/mvebu_v7_defconfig/gcc-10/lab-pengutronix/baseline-dove-cubox.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
arm/mvebu_v7_defconfig/gcc-10/lab-pengutronix/baseline-dove-cubox.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64412340fba54b17d52e8620
        failing since 91 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-04-20T11:34:06.780911  + set +x
    2023-04-20T11:34:06.781103  [    4.242668] <LAVA_SIGNAL_ENDRUN 0_dmesg =
932152_1.5.2.3.1>
    2023-04-20T11:34:06.887574  / # #
    2023-04-20T11:34:06.989054  export SHELL=3D/bin/sh
    2023-04-20T11:34:06.989478  #
    2023-04-20T11:34:07.090747  / # export SHELL=3D/bin/sh. /lava-932152/en=
vironment
    2023-04-20T11:34:07.091148  =

    2023-04-20T11:34:07.192340  / # . /lava-932152/environment/lava-932152/=
bin/lava-test-runner /lava-932152/1
    2023-04-20T11:34:07.192938  =

    2023-04-20T11:34:07.195895  / # /lava-932152/bin/lava-test-runner /lava=
-932152/1 =

    ... (12 line(s) more)  =

 =



platform                   | arch   | lab             | compiler | defconfi=
g                    | regressions
---------------------------+--------+-----------------+----------+---------=
---------------------+------------
imx6q-sabrelite            | arm    | lab-collabora   | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6441210041f77a3ed32e8605

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-imx6q-sabrelite.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-imx6q-sabrelite.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6441210041f77a3ed32e860a
        failing since 91 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-04-20T11:24:34.125900  / # #

    2023-04-20T11:24:34.228993  export SHELL=3D/bin/sh

    2023-04-20T11:24:34.229775  #

    2023-04-20T11:24:34.331894  / # export SHELL=3D/bin/sh. /lava-10060641/=
environment

    2023-04-20T11:24:34.332724  =


    2023-04-20T11:24:34.434855  / # . /lava-10060641/environment/lava-10060=
641/bin/lava-test-runner /lava-10060641/1

    2023-04-20T11:24:34.436017  =


    2023-04-20T11:24:34.448068  / # /lava-10060641/bin/lava-test-runner /la=
va-10060641/1

    2023-04-20T11:24:34.496180  + export 'TESTRUN_ID=3D1_bootrr'

    2023-04-20T11:24:34.553113  + cd /lava-10060641/1/tests/1_bootrr
 =

    ... (13 line(s) more)  =

 =



platform                   | arch   | lab             | compiler | defconfi=
g                    | regressions
---------------------------+--------+-----------------+----------+---------=
---------------------+------------
imx6qp-wandboard-revd1     | arm    | lab-pengutronix | gcc-10   | imx_v6_v=
7_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/64412250a0e3f349492e85ea

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6qp-wandboard-re=
vd1.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6qp-wandboard-re=
vd1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64412250a0e3f349492e85ef
        failing since 91 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-04-20T11:30:13.409030  + set +x[    7.332608] <LAVA_SIGNAL_ENDRUN =
0_dmesg 932146_1.5.2.3.1>
    2023-04-20T11:30:13.409253  =

    2023-04-20T11:30:13.516708  / # #
    2023-04-20T11:30:13.618461  export SHELL=3D/bin/sh
    2023-04-20T11:30:13.618932  #
    2023-04-20T11:30:13.720236  / # export SHELL=3D/bin/sh. /lava-932146/en=
vironment
    2023-04-20T11:30:13.720732  =

    2023-04-20T11:30:13.822053  / # . /lava-932146/environment/lava-932146/=
bin/lava-test-runner /lava-932146/1
    2023-04-20T11:30:13.822754  =

    2023-04-20T11:30:13.825322  / # /lava-932146/bin/lava-test-runner /lava=
-932146/1 =

    ... (12 line(s) more)  =

 =



platform                   | arch   | lab             | compiler | defconfi=
g                    | regressions
---------------------------+--------+-----------------+----------+---------=
---------------------+------------
imx6qp-wandboard-revd1     | arm    | lab-pengutronix | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6441214c2044a327f72e8618

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6qp-wandboard-rev=
d1.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6qp-wandboard-rev=
d1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6441214c2044a327f72e861d
        failing since 91 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-04-20T11:25:40.348002  + set +x
    2023-04-20T11:25:40.348169  [    4.828852] <LAVA_SIGNAL_ENDRUN 0_dmesg =
932134_1.5.2.3.1>
    2023-04-20T11:25:40.454593  / # #
    2023-04-20T11:25:40.556318  export SHELL=3D/bin/sh
    2023-04-20T11:25:40.556780  #
    2023-04-20T11:25:40.658051  / # export SHELL=3D/bin/sh. /lava-932134/en=
vironment
    2023-04-20T11:25:40.658601  =

    2023-04-20T11:25:40.759941  / # . /lava-932134/environment/lava-932134/=
bin/lava-test-runner /lava-932134/1
    2023-04-20T11:25:40.760503  =

    2023-04-20T11:25:40.762790  / # /lava-932134/bin/lava-test-runner /lava=
-932134/1 =

    ... (12 line(s) more)  =

 =



platform                   | arch   | lab             | compiler | defconfi=
g                    | regressions
---------------------------+--------+-----------------+----------+---------=
---------------------+------------
imx6ul-14x14-evk           | arm    | lab-nxp         | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/644121fcd13a83c2222e85e6

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul-14x14-evk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul-14x14-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644121fcd13a83c2222e85eb
        failing since 33 days (last pass: v4.19.260, first fail: v4.19.278)

    2023-04-20T11:28:06.528638  + set +x
    2023-04-20T11:28:06.529639  <8>[   23.278421] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 1204564_1.5.2.4.1>
    2023-04-20T11:28:06.639090  =

    2023-04-20T11:28:07.797075  / # #export SHELL=3D/bin/sh
    2023-04-20T11:28:07.802478  =

    2023-04-20T11:28:07.802647  / # export SHELL=3D/bin/sh
    2023-04-20T11:28:09.347862  . /lava-1204564/environment
    2023-04-20T11:28:09.353258  / # . /lava-1204564/environment
    2023-04-20T11:28:12.172090  /lava-1204564/bin/lava-test-runner /lava-12=
04564/1
    2023-04-20T11:28:12.177664  / # /lava-1204564/bin/lava-test-runner /lav=
a-1204564/1 =

    ... (15 line(s) more)  =

 =



platform                   | arch   | lab             | compiler | defconfi=
g                    | regressions
---------------------------+--------+-----------------+----------+---------=
---------------------+------------
imx7d-sdb                  | arm    | lab-nxp         | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/64412138f39a12a96d2e8602

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sdb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64412138f39a12a96d2e8607
        failing since 91 days (last pass: v4.19.267, first fail: v4.19.270)

    2023-04-20T11:25:26.226129  <8>[   12.913470] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 1204563_1.5.2.4.1>
    2023-04-20T11:25:26.331634  / # #
    2023-04-20T11:25:27.491482  export SHELL=3D/bin/sh
    2023-04-20T11:25:27.497177  #
    2023-04-20T11:25:29.045010  / # export SHELL=3D/bin/sh. /lava-1204563/e=
nvironment
    2023-04-20T11:25:29.050686  =

    2023-04-20T11:25:31.873302  / # . /lava-1204563/environment/lava-120456=
3/bin/lava-test-runner /lava-1204563/1
    2023-04-20T11:25:31.879393  =

    2023-04-20T11:25:31.885856  / # /lava-1204563/bin/lava-test-runner /lav=
a-1204563/1
    2023-04-20T11:25:31.988826  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (16 line(s) more)  =

 =



platform                   | arch   | lab             | compiler | defconfi=
g                    | regressions
---------------------------+--------+-----------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv2      | arm64  | lab-broonie     | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/644129162c63c56ea12e8646

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/644129162c63c56ea12e8=
647
        failing since 264 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                   | arch   | lab             | compiler | defconfi=
g                    | regressions
---------------------------+--------+-----------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv2      | arm64  | lab-broonie     | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/644135abf8a6b5b5b42e860d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/644135abf8a6b5b5b42e8=
60e
        failing since 226 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                   | arch   | lab             | compiler | defconfi=
g                    | regressions
---------------------------+--------+-----------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv2      | arm64  | lab-collabora   | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/644123f98cfe4496662e862e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/644123f98cfe4496662e8=
62f
        failing since 264 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                   | arch   | lab             | compiler | defconfi=
g                    | regressions
---------------------------+--------+-----------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv2      | arm64  | lab-collabora   | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/644124fd833df1805d2e85fa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/644124fd833df1805d2e8=
5fb
        failing since 226 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                   | arch   | lab             | compiler | defconfi=
g                    | regressions
---------------------------+--------+-----------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv2-uefi | arm64  | lab-broonie     | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/644129152c63c56ea12e8643

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/644129152c63c56ea12e8=
644
        failing since 264 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                   | arch   | lab             | compiler | defconfi=
g                    | regressions
---------------------------+--------+-----------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv2-uefi | arm64  | lab-broonie     | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/64412aba7407b432f92e8653

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64412aba7407b432f92e8=
654
        failing since 226 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                   | arch   | lab             | compiler | defconfi=
g                    | regressions
---------------------------+--------+-----------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv2-uefi | arm64  | lab-collabora   | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/644123f78cfe4496662e862b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/644123f78cfe4496662e8=
62c
        failing since 264 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                   | arch   | lab             | compiler | defconfi=
g                    | regressions
---------------------------+--------+-----------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv2-uefi | arm64  | lab-collabora   | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/644124fa79cb5c927e2e85e7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv2-uefi.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/644124fa79cb5c927e2e8=
5e8
        failing since 226 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                   | arch   | lab             | compiler | defconfi=
g                    | regressions
---------------------------+--------+-----------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv3      | arm64  | lab-broonie     | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/644127aec6961e87692e85f6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/644127aec6961e87692e8=
5f7
        failing since 264 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                   | arch   | lab             | compiler | defconfi=
g                    | regressions
---------------------------+--------+-----------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv3      | arm64  | lab-broonie     | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/64412ab9693f15e9f02e85f7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64412ab9693f15e9f02e8=
5f8
        failing since 226 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                   | arch   | lab             | compiler | defconfi=
g                    | regressions
---------------------------+--------+-----------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv3      | arm64  | lab-collabora   | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/644123ceecefe051222e8641

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/644123ceecefe051222e8=
642
        failing since 264 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                   | arch   | lab             | compiler | defconfi=
g                    | regressions
---------------------------+--------+-----------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv3      | arm64  | lab-collabora   | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/644124f9833df1805d2e85ee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/644124f9833df1805d2e8=
5ef
        failing since 226 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                   | arch   | lab             | compiler | defconfi=
g                    | regressions
---------------------------+--------+-----------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv3-uefi | arm64  | lab-broonie     | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/644127ad2e315ecbde2e862d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/644127ad2e315ecbde2e8=
62e
        failing since 264 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                   | arch   | lab             | compiler | defconfi=
g                    | regressions
---------------------------+--------+-----------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv3-uefi | arm64  | lab-broonie     | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/6441355b54b21bc80c2e85f0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6441355b54b21bc80c2e8=
5f1
        failing since 226 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                   | arch   | lab             | compiler | defconfi=
g                    | regressions
---------------------------+--------+-----------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv3-uefi | arm64  | lab-collabora   | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/644123cdecefe051222e863e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/644123cdecefe051222e8=
63f
        failing since 264 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                   | arch   | lab             | compiler | defconfi=
g                    | regressions
---------------------------+--------+-----------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv3-uefi | arm64  | lab-collabora   | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/644124fc833df1805d2e85f4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv3-uefi.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/644124fc833df1805d2e8=
5f5
        failing since 226 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                   | arch   | lab             | compiler | defconfi=
g                    | regressions
---------------------------+--------+-----------------+----------+---------=
---------------------+------------
r8a7743-iwg20d-q7          | arm    | lab-cip         | gcc-10   | shmobile=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/64412f925ae92a71c02e85f6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64412f925ae92a71c02e8=
5f7
        new failure (last pass: v4.19.280) =

 =



platform                   | arch   | lab             | compiler | defconfi=
g                    | regressions
---------------------------+--------+-----------------+----------+---------=
---------------------+------------
rk3288-veyron-jaq          | arm    | lab-collabora   | gcc-10   | multi_v7=
_defconfig           | 3          =


  Details:     https://kernelci.org/test/plan/id/644121044f382866712e85f9

  Results:     61 PASS, 8 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.dwhdmi-rockchip-driver-cec-present: https://kernelci.or=
g/test/case/id/644121044f382866712e8608
        failing since 90 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-04-20T11:24:38.231018  BusyBox v1.31.1 (2023-04-14 10:59:35 UTC)<8=
>[   10.294551] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwhdmi-rockchip-driver=
-audio-present RESULT=3Dfail>

    2023-04-20T11:24:38.232227   multi-call binary.

    2023-04-20T11:24:38.232695  =


    2023-04-20T11:24:38.237103  Usage: seq [-w] [-s SEP] [FIRST [INC]] LAST

    2023-04-20T11:24:38.237578  =


    2023-04-20T11:24:38.242195  Print numbers from FIRST to LAST, in steps =
of INC.

    2023-04-20T11:24:38.252611  FIRST,<8>[   10.313348] <LAVA_SIGNAL_TESTCA=
SE TEST_CASE_ID=3Ddwhdmi-rockchip-driver-cec-present RESULT=3Dfail>
   =


  * baseline.bootrr.dwhdmi-rockchip-driver-audio-present: https://kernelci.=
org/test/case/id/644121044f382866712e8609
        failing since 90 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-04-20T11:24:38.212264  <8>[   10.276972] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwhdmi-rockchip-probed RESULT=3Dpass>
   =


  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644121044f382866712e863d
        failing since 90 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-04-20T11:24:34.380319  <8>[    6.445303] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>

    2023-04-20T11:24:34.388771  + <8>[    6.457536] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 10060636_1.5.2.3.1>

    2023-04-20T11:24:34.391150  set +x

    2023-04-20T11:24:34.497043  #

    2023-04-20T11:24:34.599076  / # #export SHELL=3D/bin/sh

    2023-04-20T11:24:34.599513  =


    2023-04-20T11:24:34.700912  / # export SHELL=3D/bin/sh. /lava-10060636/=
environment

    2023-04-20T11:24:34.701389  =


    2023-04-20T11:24:34.802772  / # . /lava-10060636/environment/lava-10060=
636/bin/lava-test-runner /lava-10060636/1

    2023-04-20T11:24:34.803451  =

 =

    ... (16 line(s) more)  =

 =



platform                   | arch   | lab             | compiler | defconfi=
g                    | regressions
---------------------------+--------+-----------------+----------+---------=
---------------------+------------
rk3399-gru-kevin           | arm64  | lab-collabora   | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =


  Details:     https://kernelci.org/test/plan/id/6441232b361ce7f9822e860e

  Results:     77 PASS, 5 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/6441232b361ce7f9822e8614
        failing since 33 days (last pass: v4.19.277, first fail: v4.19.278)

    2023-04-20T11:33:46.379279  /lava-10060776/1/../bin/lava-test-case

    2023-04-20T11:33:46.388621  <8>[   37.296912] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy1-probed RESULT=3Dfail>
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/6441232b361ce7f9822e8615
        failing since 33 days (last pass: v4.19.277, first fail: v4.19.278)

    2023-04-20T11:33:44.341658  <8>[   35.249742] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy-driver-present RESULT=3Dpass>

    2023-04-20T11:33:45.357201  /lava-10060776/1/../bin/lava-test-case

    2023-04-20T11:33:45.366754  <8>[   36.275147] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>
   =

 =



platform                   | arch   | lab             | compiler | defconfi=
g                    | regressions
---------------------------+--------+-----------------+----------+---------=
---------------------+------------
sun50i-a64-pine64-plus     | arm64  | lab-broonie     | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/6441241df5d63abc3e2e8674

  Results:     23 PASS, 16 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pine64-plus.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pine64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6441241df5d63abc3e2e8698
        failing since 91 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-04-20T11:37:20.856452  <8>[   15.953992] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 360465_1.5.2.4.1>
    2023-04-20T11:37:20.961624  / # #
    2023-04-20T11:37:21.063427  export SHELL=3D/bin/sh
    2023-04-20T11:37:21.063870  #
    2023-04-20T11:37:21.165418  / # export SHELL=3D/bin/sh. /lava-360465/en=
vironment
    2023-04-20T11:37:21.166010  =

    2023-04-20T11:37:21.267410  / # . /lava-360465/environment/lava-360465/=
bin/lava-test-runner /lava-360465/1
    2023-04-20T11:37:21.268061  =

    2023-04-20T11:37:21.272909  / # /lava-360465/bin/lava-test-runner /lava=
-360465/1
    2023-04-20T11:37:21.304517  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                   | arch   | lab             | compiler | defconfi=
g                    | regressions
---------------------------+--------+-----------------+----------+---------=
---------------------+------------
sun50i-h6-pine-h64         | arm64  | lab-collabora   | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/644123fc8cfe4496662e8631

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
arm64/defconfig/gcc-10/lab-collabora/baseline-sun50i-h6-pine-h64.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
arm64/defconfig/gcc-10/lab-collabora/baseline-sun50i-h6-pine-h64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644123fc8cfe4496662e8636
        failing since 91 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-04-20T11:37:27.568577  / # #

    2023-04-20T11:37:27.671179  export SHELL=3D/bin/sh

    2023-04-20T11:37:27.671909  #

    2023-04-20T11:37:27.773744  / # export SHELL=3D/bin/sh. /lava-10060787/=
environment

    2023-04-20T11:37:27.774468  =


    2023-04-20T11:37:27.876313  / # . /lava-10060787/environment/lava-10060=
787/bin/lava-test-runner /lava-10060787/1

    2023-04-20T11:37:27.877435  =


    2023-04-20T11:37:27.892377  / # /lava-10060787/bin/lava-test-runner /la=
va-10060787/1

    2023-04-20T11:37:27.934134  + export 'TESTRUN_ID=3D1_bootrr'

    2023-04-20T11:37:27.950301  + cd /lava-1006078<8>[   15.639389] <LAVA_S=
IGNAL_STARTRUN 1_bootrr 10060787_1.5.2.4.5>
 =

    ... (11 line(s) more)  =

 =



platform                   | arch   | lab             | compiler | defconfi=
g                    | regressions
---------------------------+--------+-----------------+----------+---------=
---------------------+------------
zynqmp-zcu102              | arm64  | lab-cip         | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/644122c7f911b63f862e85fa

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-cip/baseline-zynqmp-zcu102.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-cip/baseline-zynqmp-zcu102.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644122c7f911b63f862e85fd
        failing since 91 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-04-20T11:32:04.508693  / # #
    2023-04-20T11:32:04.609742  export SHELL=3D/bin/sh
    2023-04-20T11:32:04.610142  #
    2023-04-20T11:32:04.711165  / # export SHELL=3D/bin/sh. /lava-910526/en=
vironment
    2023-04-20T11:32:04.711586  =

    2023-04-20T11:32:04.812626  / # . /lava-910526/environment/lava-910526/=
bin/lava-test-runner /lava-910526/1
    2023-04-20T11:32:04.813120  =

    2023-04-20T11:32:04.815479  / # /lava-910526/bin/lava-test-runner /lava=
-910526/1
    2023-04-20T11:32:04.852481  + export 'TESTRUN_ID=3D1_bootrr'
    2023-04-20T11:32:04.852870  + cd /lava-910526/1/tests/1_bootrr =

    ... (11 line(s) more)  =

 =



platform                   | arch   | lab             | compiler | defconfi=
g                    | regressions
---------------------------+--------+-----------------+----------+---------=
---------------------+------------
zynqmp-zcu102              | arm64  | lab-cip         | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/644123df48c1fb2a212e8611

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
arm64/defconfig/gcc-10/lab-cip/baseline-zynqmp-zcu102.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.281/=
arm64/defconfig/gcc-10/lab-cip/baseline-zynqmp-zcu102.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644123df48c1fb2a212e8614
        failing since 91 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-04-20T11:36:59.354280  + set +x
    2023-04-20T11:36:59.355338  <8>[    3.745010] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 910537_1.5.2.4.1>
    2023-04-20T11:36:59.462097  / # #
    2023-04-20T11:36:59.563647  export SHELL=3D/bin/sh
    2023-04-20T11:36:59.564128  #
    2023-04-20T11:36:59.665301  / # export SHELL=3D/bin/sh. /lava-910537/en=
vironment
    2023-04-20T11:36:59.665770  =

    2023-04-20T11:36:59.766962  / # . /lava-910537/environment/lava-910537/=
bin/lava-test-runner /lava-910537/1
    2023-04-20T11:36:59.767540  =

    2023-04-20T11:36:59.770260  / # /lava-910537/bin/lava-test-runner /lava=
-910537/1 =

    ... (13 line(s) more)  =

 =20
