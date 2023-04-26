Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 295A16EF624
	for <lists+stable@lfdr.de>; Wed, 26 Apr 2023 16:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240949AbjDZOQi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Apr 2023 10:16:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239964AbjDZOQh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Apr 2023 10:16:37 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FF146A52
        for <stable@vger.kernel.org>; Wed, 26 Apr 2023 07:16:32 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-63b67a26069so9215580b3a.0
        for <stable@vger.kernel.org>; Wed, 26 Apr 2023 07:16:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1682518591; x=1685110591;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=PsJ9DUHTnbhtobclFSjsiLLlhUN+rGFF0E1KYQ0jmnQ=;
        b=mU0JUExhAYi6l/3D0NCA9rw5edeQEoQHt+P4OAp7pvKc8Ypa6KweLQXyTzEpHFLmZK
         teX5/WX1J2et1wVhqoI4ajNf6FFxC7W31/vZ9hgzFWmrZb0wHZQiVZIel7s2iekCm47P
         dtmNHDbWTgS2fOMfNXoBsH+Byw8axfXee2dUm1YmunI/DoRyl7vstpvSig01Nk8ynu0e
         izKlIA/MS0f4NOtjYgVs1CokRs1/UtE7j/qPZgJoOe2es9DPk/xtR8K72U366heOP+Aw
         gRhtMMDn4GYDJCvaAECLxdzLFpzk2eKHx/oXo5p9EH7U8nQ46thy9bOz0w96kASsCmkP
         KIEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682518591; x=1685110591;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PsJ9DUHTnbhtobclFSjsiLLlhUN+rGFF0E1KYQ0jmnQ=;
        b=Je0ueSNhbmxZeSghQk89sPD6nP09uunrjIl5PLn3r+QOQWZxSwwe8YItLw7Mev501G
         dVxfmLfV5lGdSjs8Q99xW3J7yZ1odIcQjOiwLg3E6DY7Tgh7YFd2TjldS0g0TW0FuZGX
         h8JQOMTM3WtvHNIgoNGqhRdQ2MkrkyPSap63fUlYPAjKijDBV/yPZ9m4B3RbcbEmra2O
         OTI51BpbOpU3HNLpmPJdo5Z4hhh0l2TXUi48/cpu/CgxyQnOFtf/RrCcFqHhimGAJhQ4
         bSHlOhLnPbQdE+lFYsi7rODgN+e/7olGnMP9tyJXKqDfZCuCNjSU4smCiEpmEAneBAov
         8TTw==
X-Gm-Message-State: AC+VfDxrvGYu22O2B3oG3X+fD+RZOW/dtldF6rJZ3DKm2lJMocs+F/bK
        ODP/P6PW9bp1czKNAVGNs7mNCw9ds08efLYE6Xr0VA==
X-Google-Smtp-Source: ACHHUZ4kWRMSmNtF4A5DP5JHTkKaYMDOFnlxOmmyKuLnrkbwvfDVPlzQAMcViy/5sfomoAYT70QRdQ==
X-Received: by 2002:a05:6a00:218e:b0:641:a6d:46b0 with SMTP id h14-20020a056a00218e00b006410a6d46b0mr1908714pfi.22.1682518590411;
        Wed, 26 Apr 2023 07:16:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d17-20020a056a0024d100b0063d47bfcdd5sm11431775pfv.111.2023.04.26.07.16.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Apr 2023 07:16:29 -0700 (PDT)
Message-ID: <6449323d.050a0220.18d0b.68a5@mx.google.com>
Date:   Wed, 26 Apr 2023 07:16:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.19.282
X-Kernelci-Report-Type: test
Subject: stable/linux-4.19.y baseline: 99 runs, 34 regressions (v4.19.282)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y baseline: 99 runs, 34 regressions (v4.19.282)

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

beaglebone-black           | arm    | lab-broonie     | gcc-10   | multi_v7=
_defconfig           | 1          =

beaglebone-black           | arm    | lab-cip         | gcc-10   | multi_v7=
_defconfig           | 1          =

beaglebone-black           | arm    | lab-broonie     | gcc-10   | omap2plu=
s_defconfig          | 1          =

dove-cubox                 | arm    | lab-pengutronix | gcc-10   | mvebu_v7=
_defconfig           | 1          =

imx6q-sabrelite            | arm    | lab-collabora   | gcc-10   | multi_v7=
_defconfig           | 1          =

imx6qp-wandboard-revd1     | arm    | lab-pengutronix | gcc-10   | imx_v6_v=
7_defconfig          | 1          =

imx6qp-wandboard-revd1     | arm    | lab-pengutronix | gcc-10   | multi_v7=
_defconfig           | 1          =

qemu_arm64-virt-gicv2      | arm64  | lab-broonie     | gcc-10   | defconfi=
g                    | 1          =

qemu_arm64-virt-gicv2      | arm64  | lab-broonie     | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv2      | arm64  | lab-collabora   | gcc-10   | defconfi=
g                    | 1          =

qemu_arm64-virt-gicv2      | arm64  | lab-collabora   | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv2-uefi | arm64  | lab-broonie     | gcc-10   | defconfi=
g                    | 1          =

qemu_arm64-virt-gicv2-uefi | arm64  | lab-broonie     | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv2-uefi | arm64  | lab-collabora   | gcc-10   | defconfi=
g                    | 1          =

qemu_arm64-virt-gicv2-uefi | arm64  | lab-collabora   | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv3      | arm64  | lab-broonie     | gcc-10   | defconfi=
g                    | 1          =

qemu_arm64-virt-gicv3      | arm64  | lab-broonie     | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv3      | arm64  | lab-collabora   | gcc-10   | defconfi=
g                    | 1          =

qemu_arm64-virt-gicv3      | arm64  | lab-collabora   | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv3-uefi | arm64  | lab-broonie     | gcc-10   | defconfi=
g                    | 1          =

qemu_arm64-virt-gicv3-uefi | arm64  | lab-broonie     | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv3-uefi | arm64  | lab-collabora   | gcc-10   | defconfi=
g                    | 1          =

qemu_arm64-virt-gicv3-uefi | arm64  | lab-collabora   | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =

rk3288-veyron-jaq          | arm    | lab-collabora   | gcc-10   | multi_v7=
_defconfig           | 3          =

rk3399-gru-kevin           | arm64  | lab-collabora   | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =

sun50i-a64-pine64-plus     | arm64  | lab-broonie     | gcc-10   | defconfi=
g                    | 1          =

sun50i-h6-pine-h64         | arm64  | lab-collabora   | gcc-10   | defconfi=
g                    | 1          =

zynqmp-zcu102              | arm64  | lab-cip         | gcc-10   | defconfi=
g                    | 1          =

zynqmp-zcu102              | arm64  | lab-cip         | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.282/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.282
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      cdfda37ab2cfc783a190b563806cda611c35d1e3 =



Test Regressions
---------------- =



platform                   | arch   | lab             | compiler | defconfi=
g                    | regressions
---------------------------+--------+-----------------+----------+---------=
---------------------+------------
asus-C433TA-AJ0005-rammus  | x86_64 | lab-collabora   | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64490110f1a42cff332e85f4

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.282/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
433TA-AJ0005-rammus.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.282/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
433TA-AJ0005-rammus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64490110f1a42cff332e85f9
        failing since 97 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-04-26T10:46:18.081660  + set +x<8>[    9.893381] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 10129060_1.4.2.3.1>

    2023-04-26T10:46:18.081777  =


    2023-04-26T10:46:18.184037  #

    2023-04-26T10:46:18.184373  =


    2023-04-26T10:46:18.284941  / # #export SHELL=3D/bin/sh

    2023-04-26T10:46:18.285136  =


    2023-04-26T10:46:18.385616  / # export SHELL=3D/bin/sh. /lava-10129060/=
environment

    2023-04-26T10:46:18.385819  =


    2023-04-26T10:46:18.486364  / # . /lava-10129060/environment/lava-10129=
060/bin/lava-test-runner /lava-10129060/1

    2023-04-26T10:46:18.486678  =

 =

    ... (13 line(s) more)  =

 =



platform                   | arch   | lab             | compiler | defconfi=
g                    | regressions
---------------------------+--------+-----------------+----------+---------=
---------------------+------------
asus-C523NA-A20057-coral   | x86_64 | lab-collabora   | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/644900f37287dff9f72e8626

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.282/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
523NA-A20057-coral.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.282/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
523NA-A20057-coral.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644900f37287dff9f72e862b
        failing since 97 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-04-26T10:45:58.649160  <8>[   12.269231] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>

    2023-04-26T10:45:58.651136  + set +x

    2023-04-26T10:45:58.657396  <8>[   12.279483] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10129000_1.4.2.3.1>

    2023-04-26T10:45:58.761477  / # #

    2023-04-26T10:45:58.862028  export SHELL=3D/bin/sh

    2023-04-26T10:45:58.862213  #

    2023-04-26T10:45:58.962750  / # export SHELL=3D/bin/sh. /lava-10129000/=
environment

    2023-04-26T10:45:58.962962  =


    2023-04-26T10:45:59.063490  / # . /lava-10129000/environment/lava-10129=
000/bin/lava-test-runner /lava-10129000/1

    2023-04-26T10:45:59.063741  =

 =

    ... (14 line(s) more)  =

 =



platform                   | arch   | lab             | compiler | defconfi=
g                    | regressions
---------------------------+--------+-----------------+----------+---------=
---------------------+------------
beaglebone-black           | arm    | lab-broonie     | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6448ffd15f62591e392e86a8

  Results:     24 PASS, 20 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.282/=
arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-beaglebone-black.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.282/=
arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-beaglebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6448ffd25f62591e392e86d3
        failing since 97 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-04-26T10:40:29.690653  <8>[   15.299362] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 389472_1.5.2.4.1>
    2023-04-26T10:40:29.834046  / # #
    2023-04-26T10:40:29.948606  export SHELL=3D/bin/sh
    2023-04-26T10:40:29.953490  <6>[   15.395530] usb 1-1: new low-speed US=
B device number 3 using musb-hdrc
    2023-04-26T10:40:29.956015  #
    2023-04-26T10:40:29.958086  / # export SHELL=3D/bin/sh<3>[   15.545511]=
 usb 1-1: device descriptor read/64, error -71
    2023-04-26T10:40:29.960862  =

    2023-04-26T10:40:30.068401  / # . /lava-389472/environment
    2023-04-26T10:40:30.177636  /lava-389472/bin/lava-test-runner /lava-389=
472/1
    2023-04-26T10:40:30.185260  . /lava-389472/environment =

    ... (17 line(s) more)  =

 =



platform                   | arch   | lab             | compiler | defconfi=
g                    | regressions
---------------------------+--------+-----------------+----------+---------=
---------------------+------------
beaglebone-black           | arm    | lab-cip         | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/644919e9a5c55ca90d2e85e7

  Results:     24 PASS, 20 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.282/=
arm/multi_v7_defconfig/gcc-10/lab-cip/baseline-beaglebone-black.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.282/=
arm/multi_v7_defconfig/gcc-10/lab-cip/baseline-beaglebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644919e9a5c55ca90d2e85ea
        failing since 97 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-04-26T12:32:02.834748  + set +x
    2023-04-26T12:32:02.836811  <8>[    9.762483] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 917188_1.5.2.4.1>
    2023-04-26T12:32:02.945452  / # #
    2023-04-26T12:32:03.047327  export SHELL=3D/bin/sh
    2023-04-26T12:32:03.047793  #
    2023-04-26T12:32:03.149224  / # export SHELL=3D/bin/sh. /lava-917188/en=
vironment
    2023-04-26T12:32:03.149726  =

    2023-04-26T12:32:03.251171  / # . /lava-917188/environment/lava-917188/=
bin/lava-test-runner /lava-917188/1
    2023-04-26T12:32:03.251960  =

    2023-04-26T12:32:03.253509  / # /lava-917188/bin/lava-test-runner /lava=
-917188/1 =

    ... (12 line(s) more)  =

 =



platform                   | arch   | lab             | compiler | defconfi=
g                    | regressions
---------------------------+--------+-----------------+----------+---------=
---------------------+------------
beaglebone-black           | arm    | lab-broonie     | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/6448ffd05f62591e392e8654

  Results:     41 PASS, 10 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.282/=
arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beaglebone-black.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.282/=
arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beaglebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6448ffd05f62591e392e8686
        new failure (last pass: v4.19.281)

    2023-04-26T10:40:53.818110  + set +x<8>[   17.433378] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 389508_1.5.2.4.1>
    2023-04-26T10:40:53.818591  =

    2023-04-26T10:40:53.930224  / # #
    2023-04-26T10:40:54.032984  export SHELL=3D/bin/sh
    2023-04-26T10:40:54.033619  #
    2023-04-26T10:40:54.135117  / # export SHELL=3D/bin/sh. /lava-389508/en=
vironment
    2023-04-26T10:40:54.135703  =

    2023-04-26T10:40:54.237522  / # . /lava-389508/environment/lava-389508/=
bin/lava-test-runner /lava-389508/1
    2023-04-26T10:40:54.238535  =

    2023-04-26T10:40:54.243083  / # /lava-389508/bin/lava-test-runner /lava=
-389508/1 =

    ... (12 line(s) more)  =

 =



platform                   | arch   | lab             | compiler | defconfi=
g                    | regressions
---------------------------+--------+-----------------+----------+---------=
---------------------+------------
dove-cubox                 | arm    | lab-pengutronix | gcc-10   | mvebu_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6448fc4c3ab78520d92e860a

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: mvebu_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.282/=
arm/mvebu_v7_defconfig/gcc-10/lab-pengutronix/baseline-dove-cubox.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.282/=
arm/mvebu_v7_defconfig/gcc-10/lab-pengutronix/baseline-dove-cubox.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6448fc4c3ab78520d92e860f
        failing since 97 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-04-26T10:26:03.657512  + set +x
    2023-04-26T10:26:03.657723  [    4.253454] <LAVA_SIGNAL_ENDRUN 0_dmesg =
938160_1.5.2.3.1>
    2023-04-26T10:26:03.764319  / # #
    2023-04-26T10:26:03.865984  export SHELL=3D/bin/sh
    2023-04-26T10:26:03.866468  #
    2023-04-26T10:26:03.967764  / # export SHELL=3D/bin/sh. /lava-938160/en=
vironment
    2023-04-26T10:26:03.968239  =

    2023-04-26T10:26:04.069491  / # . /lava-938160/environment/lava-938160/=
bin/lava-test-runner /lava-938160/1
    2023-04-26T10:26:04.070107  =

    2023-04-26T10:26:04.072965  / # /lava-938160/bin/lava-test-runner /lava=
-938160/1 =

    ... (12 line(s) more)  =

 =



platform                   | arch   | lab             | compiler | defconfi=
g                    | regressions
---------------------------+--------+-----------------+----------+---------=
---------------------+------------
imx6q-sabrelite            | arm    | lab-collabora   | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6448fe6a9c719770cb2e865f

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.282/=
arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-imx6q-sabrelite.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.282/=
arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-imx6q-sabrelite.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6448fe6a9c719770cb2e8664
        failing since 97 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-04-26T10:35:06.802847  / # #

    2023-04-26T10:35:06.905519  export SHELL=3D/bin/sh

    2023-04-26T10:35:06.906279  #

    2023-04-26T10:35:07.007897  / # export SHELL=3D/bin/sh. /lava-10128884/=
environment

    2023-04-26T10:35:07.008667  =


    2023-04-26T10:35:07.110589  / # . /lava-10128884/environment/lava-10128=
884/bin/lava-test-runner /lava-10128884/1

    2023-04-26T10:35:07.111777  =


    2023-04-26T10:35:07.125704  / # /lava-10128884/bin/lava-test-runner /la=
va-10128884/1

    2023-04-26T10:35:07.224786  + export 'TESTRUN_ID=3D1_bootrr'

    2023-04-26T10:35:07.225335  + cd /lava-10128884/1/tests/1_bootrr
 =

    ... (13 line(s) more)  =

 =



platform                   | arch   | lab             | compiler | defconfi=
g                    | regressions
---------------------------+--------+-----------------+----------+---------=
---------------------+------------
imx6qp-wandboard-revd1     | arm    | lab-pengutronix | gcc-10   | imx_v6_v=
7_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/6448ffe6dd140cce712e861b

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.282/=
arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6qp-wandboard-re=
vd1.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.282/=
arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6qp-wandboard-re=
vd1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6448ffe6dd140cce712e8620
        failing since 97 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-04-26T10:41:19.841168  + set +x[    7.350257] <LAVA_SIGNAL_ENDRUN =
0_dmesg 938172_1.5.2.3.1>
    2023-04-26T10:41:19.841418  =

    2023-04-26T10:41:19.948925  / # #
    2023-04-26T10:41:20.050754  export SHELL=3D/bin/sh
    2023-04-26T10:41:20.051319  #
    2023-04-26T10:41:20.152736  / # export SHELL=3D/bin/sh. /lava-938172/en=
vironment
    2023-04-26T10:41:20.153214  =

    2023-04-26T10:41:20.254622  / # . /lava-938172/environment/lava-938172/=
bin/lava-test-runner /lava-938172/1
    2023-04-26T10:41:20.255220  =

    2023-04-26T10:41:20.257817  / # /lava-938172/bin/lava-test-runner /lava=
-938172/1 =

    ... (12 line(s) more)  =

 =



platform                   | arch   | lab             | compiler | defconfi=
g                    | regressions
---------------------------+--------+-----------------+----------+---------=
---------------------+------------
imx6qp-wandboard-revd1     | arm    | lab-pengutronix | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6448fe40c5ba63cbb22e85fd

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.282/=
arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6qp-wandboard-rev=
d1.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.282/=
arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6qp-wandboard-rev=
d1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6448fe40c5ba63cbb22e8602
        failing since 97 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-04-26T10:34:28.987696  + set +x
    2023-04-26T10:34:28.987859  [    4.908066] <LAVA_SIGNAL_ENDRUN 0_dmesg =
938161_1.5.2.3.1>
    2023-04-26T10:34:29.094401  / # #
    2023-04-26T10:34:29.196266  export SHELL=3D/bin/sh
    2023-04-26T10:34:29.196815  #
    2023-04-26T10:34:29.298058  / # export SHELL=3D/bin/sh. /lava-938161/en=
vironment
    2023-04-26T10:34:29.298700  =

    2023-04-26T10:34:29.399993  / # . /lava-938161/environment/lava-938161/=
bin/lava-test-runner /lava-938161/1
    2023-04-26T10:34:29.400581  =

    2023-04-26T10:34:29.403113  / # /lava-938161/bin/lava-test-runner /lava=
-938161/1 =

    ... (12 line(s) more)  =

 =



platform                   | arch   | lab             | compiler | defconfi=
g                    | regressions
---------------------------+--------+-----------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv2      | arm64  | lab-broonie     | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/64490bf34bcd77438f2e85f2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.282/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.282/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64490bf34bcd77438f2e8=
5f3
        failing since 232 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                   | arch   | lab             | compiler | defconfi=
g                    | regressions
---------------------------+--------+-----------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv2      | arm64  | lab-broonie     | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/64490d97b4178297c62e85f7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.282/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.282/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64490d97b4178297c62e8=
5f8
        failing since 270 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                   | arch   | lab             | compiler | defconfi=
g                    | regressions
---------------------------+--------+-----------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv2      | arm64  | lab-collabora   | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/644900010dcd26c8562e85f8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.282/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.282/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/644900010dcd26c8562e8=
5f9
        failing since 232 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                   | arch   | lab             | compiler | defconfi=
g                    | regressions
---------------------------+--------+-----------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv2      | arm64  | lab-collabora   | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/6449016e4854fe7da42e85f2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.282/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.282/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6449016e4854fe7da42e8=
5f3
        failing since 270 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                   | arch   | lab             | compiler | defconfi=
g                    | regressions
---------------------------+--------+-----------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv2-uefi | arm64  | lab-broonie     | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/64490bf24bcd77438f2e85ec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.282/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.282/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64490bf24bcd77438f2e8=
5ed
        failing since 232 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                   | arch   | lab             | compiler | defconfi=
g                    | regressions
---------------------------+--------+-----------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv2-uefi | arm64  | lab-broonie     | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/64490efecdaab953f92e8628

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.282/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.282/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64490efecdaab953f92e8=
629
        failing since 270 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                   | arch   | lab             | compiler | defconfi=
g                    | regressions
---------------------------+--------+-----------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv2-uefi | arm64  | lab-collabora   | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/6448ffec0cedb572ee2e85f2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.282/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.282/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv2-uefi.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6448ffec0cedb572ee2e8=
5f3
        failing since 232 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                   | arch   | lab             | compiler | defconfi=
g                    | regressions
---------------------------+--------+-----------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv2-uefi | arm64  | lab-collabora   | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/6449016f4854fe7da42e85f5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.282/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.282/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6449016f4854fe7da42e8=
5f6
        failing since 270 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                   | arch   | lab             | compiler | defconfi=
g                    | regressions
---------------------------+--------+-----------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv3      | arm64  | lab-broonie     | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/64490a8b1c5e9fea6a2e85ec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.282/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.282/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64490a8b1c5e9fea6a2e8=
5ed
        failing since 232 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                   | arch   | lab             | compiler | defconfi=
g                    | regressions
---------------------------+--------+-----------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv3      | arm64  | lab-broonie     | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/644910665aec668cbe2e860e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.282/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.282/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/644910665aec668cbe2e8=
60f
        failing since 270 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                   | arch   | lab             | compiler | defconfi=
g                    | regressions
---------------------------+--------+-----------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv3      | arm64  | lab-collabora   | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/6448fff30cedb572ee2e85fa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.282/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.282/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6448fff30cedb572ee2e8=
5fb
        failing since 232 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                   | arch   | lab             | compiler | defconfi=
g                    | regressions
---------------------------+--------+-----------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv3      | arm64  | lab-collabora   | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/644901684854fe7da42e85e9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.282/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.282/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/644901684854fe7da42e8=
5ea
        failing since 270 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                   | arch   | lab             | compiler | defconfi=
g                    | regressions
---------------------------+--------+-----------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv3-uefi | arm64  | lab-broonie     | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/64490a8a0608b7c77e2e8618

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.282/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.282/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64490a8a0608b7c77e2e8=
619
        failing since 232 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                   | arch   | lab             | compiler | defconfi=
g                    | regressions
---------------------------+--------+-----------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv3-uefi | arm64  | lab-broonie     | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/64490effcfcfcc8bc12e85f4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.282/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.282/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64490effcfcfcc8bc12e8=
5f5
        failing since 270 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                   | arch   | lab             | compiler | defconfi=
g                    | regressions
---------------------------+--------+-----------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv3-uefi | arm64  | lab-collabora   | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/6448fff22ed6a771d52e8600

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.282/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.282/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv3-uefi.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6448fff22ed6a771d52e8=
601
        failing since 232 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                   | arch   | lab             | compiler | defconfi=
g                    | regressions
---------------------------+--------+-----------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv3-uefi | arm64  | lab-collabora   | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/644901704854fe7da42e85fa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.282/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.282/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/644901704854fe7da42e8=
5fb
        failing since 270 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                   | arch   | lab             | compiler | defconfi=
g                    | regressions
---------------------------+--------+-----------------+----------+---------=
---------------------+------------
rk3288-veyron-jaq          | arm    | lab-collabora   | gcc-10   | multi_v7=
_defconfig           | 3          =


  Details:     https://kernelci.org/test/plan/id/6448fe669c719770cb2e85f7

  Results:     61 PASS, 8 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.282/=
arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.282/=
arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6448fe669c719770cb2e8623
        failing since 96 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-04-26T10:34:53.148566  <8>[    6.512615] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>

    2023-04-26T10:34:53.157943  + <8>[    6.524793] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 10128875_1.5.2.3.1>

    2023-04-26T10:34:53.158831  set +x

    2023-04-26T10:34:53.264845  =


    2023-04-26T10:34:53.366532  / # #export SHELL=3D/bin/sh

    2023-04-26T10:34:53.367253  =


    2023-04-26T10:34:53.468641  / # export SHELL=3D/bin/sh. /lava-10128875/=
environment

    2023-04-26T10:34:53.469412  =


    2023-04-26T10:34:53.570900  / # . /lava-10128875/environment/lava-10128=
875/bin/lava-test-runner /lava-10128875/1

    2023-04-26T10:34:53.571998  =

 =

    ... (17 line(s) more)  =


  * baseline.bootrr.dwhdmi-rockchip-driver-cec-present: https://kernelci.or=
g/test/case/id/6448fe669c719770cb2e862b
        failing since 96 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-04-26T10:34:56.999002  BusyBox v1.31.1 (2023-04-14 10:59:35 UTC)<8=
>[   10.361603] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwhdmi-rockchip-driver=
-audio-present RESULT=3Dfail>

    2023-04-26T10:34:57.000782   multi-call binary.

    2023-04-26T10:34:57.001009  =


    2023-04-26T10:34:57.005384  Usage: seq [-w] [-s SEP] [FIRST [INC]] LAST

    2023-04-26T10:34:57.005605  =


    2023-04-26T10:34:57.010618  Print numbers from FIRST to LAST, in steps =
of INC.
   =


  * baseline.bootrr.dwhdmi-rockchip-driver-audio-present: https://kernelci.=
org/test/case/id/6448fe669c719770cb2e862c
        failing since 96 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-04-26T10:34:56.980164  <8>[   10.343972] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwhdmi-rockchip-probed RESULT=3Dpass>
   =

 =



platform                   | arch   | lab             | compiler | defconfi=
g                    | regressions
---------------------------+--------+-----------------+----------+---------=
---------------------+------------
rk3399-gru-kevin           | arm64  | lab-collabora   | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =


  Details:     https://kernelci.org/test/plan/id/644903f35bd51e1b272e85ff

  Results:     77 PASS, 5 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.282/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.282/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/644903f35bd51e1b272e8605
        failing since 39 days (last pass: v4.19.277, first fail: v4.19.278)

    2023-04-26T10:58:39.159252  /lava-10128981/1/../bin/lava-test-case<8>[ =
  36.449227] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-usb2phy0-probed =
RESULT=3Dfail>

    2023-04-26T10:58:39.159359  =


    2023-04-26T10:58:40.172439  /lava-10128981/1/../bin/lava-test-case

    2023-04-26T10:58:40.180736  <8>[   37.470897] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy1-probed RESULT=3Dfail>
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/644903f35bd51e1b272e8606
        failing since 39 days (last pass: v4.19.277, first fail: v4.19.278) =

 =



platform                   | arch   | lab             | compiler | defconfi=
g                    | regressions
---------------------------+--------+-----------------+----------+---------=
---------------------+------------
sun50i-a64-pine64-plus     | arm64  | lab-broonie     | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/6448ff2e4e2879bf262e85e6

  Results:     23 PASS, 16 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.282/=
arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pine64-plus.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.282/=
arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pine64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6448ff2e4e2879bf262e8607
        failing since 97 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-04-26T10:37:59.834214  <8>[   16.006692] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 389519_1.5.2.4.1>
    2023-04-26T10:37:59.944284  / # #
    2023-04-26T10:38:00.046976  export SHELL=3D/bin/sh
    2023-04-26T10:38:00.047604  #
    2023-04-26T10:38:00.149201  / # export SHELL=3D/bin/sh. /lava-389519/en=
vironment
    2023-04-26T10:38:00.149902  =

    2023-04-26T10:38:00.251752  / # . /lava-389519/environment/lava-389519/=
bin/lava-test-runner /lava-389519/1
    2023-04-26T10:38:00.252955  =

    2023-04-26T10:38:00.257305  / # /lava-389519/bin/lava-test-runner /lava=
-389519/1
    2023-04-26T10:38:00.288960  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                   | arch   | lab             | compiler | defconfi=
g                    | regressions
---------------------------+--------+-----------------+----------+---------=
---------------------+------------
sun50i-h6-pine-h64         | arm64  | lab-collabora   | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/6448ff03ec2c18b9e62e85f4

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.282/=
arm64/defconfig/gcc-10/lab-collabora/baseline-sun50i-h6-pine-h64.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.282/=
arm64/defconfig/gcc-10/lab-collabora/baseline-sun50i-h6-pine-h64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6448ff03ec2c18b9e62e85f9
        failing since 97 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-04-26T10:37:48.181748  / # #

    2023-04-26T10:37:48.283883  export SHELL=3D/bin/sh

    2023-04-26T10:37:48.284586  #

    2023-04-26T10:37:48.385980  / # export SHELL=3D/bin/sh. /lava-10128954/=
environment

    2023-04-26T10:37:48.386691  =


    2023-04-26T10:37:48.488103  / # . /lava-10128954/environment/lava-10128=
954/bin/lava-test-runner /lava-10128954/1

    2023-04-26T10:37:48.489177  =


    2023-04-26T10:37:48.505977  / # /lava-10128954/bin/lava-test-runner /la=
va-10128954/1

    2023-04-26T10:37:48.550143  + export 'TESTRUN_ID=3D1_bootrr'

    2023-04-26T10:37:48.563864  + cd /lava-1012895<8>[   15.611565] <LAVA_S=
IGNAL_STARTRUN 1_bootrr 10128954_1.5.2.4.5>
 =

    ... (11 line(s) more)  =

 =



platform                   | arch   | lab             | compiler | defconfi=
g                    | regressions
---------------------------+--------+-----------------+----------+---------=
---------------------+------------
zynqmp-zcu102              | arm64  | lab-cip         | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/6448fef50faeaa55432e865a

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.282/=
arm64/defconfig/gcc-10/lab-cip/baseline-zynqmp-zcu102.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.282/=
arm64/defconfig/gcc-10/lab-cip/baseline-zynqmp-zcu102.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6448fef50faeaa55432e865d
        failing since 97 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-04-26T10:37:17.537752  / # #
    2023-04-26T10:37:17.638925  export SHELL=3D/bin/sh
    2023-04-26T10:37:17.639289  #
    2023-04-26T10:37:17.740280  / # export SHELL=3D/bin/sh. /lava-917214/en=
vironment
    2023-04-26T10:37:17.740552  =

    2023-04-26T10:37:17.841537  / # . /lava-917214/environment/lava-917214/=
bin/lava-test-runner /lava-917214/1
    2023-04-26T10:37:17.841956  =

    2023-04-26T10:37:17.844872  / # /lava-917214/bin/lava-test-runner /lava=
-917214/1
    2023-04-26T10:37:17.881887  + export 'TESTRUN_ID=3D1_bootrr'
    2023-04-26T10:37:17.882268  + cd /lava-917214/1/tests/1_bootrr =

    ... (11 line(s) more)  =

 =



platform                   | arch   | lab             | compiler | defconfi=
g                    | regressions
---------------------------+--------+-----------------+----------+---------=
---------------------+------------
zynqmp-zcu102              | arm64  | lab-cip         | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/644900981c889067082e85e6

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.282/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-cip/baseline-zynqmp-zcu102.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.282/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-cip/baseline-zynqmp-zcu102.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644900981c889067082e85e9
        failing since 97 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-04-26T10:44:19.794951  <8>[    3.724475] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 917231_1.5.2.4.1>
    2023-04-26T10:44:19.900355  / # #
    2023-04-26T10:44:20.002241  export SHELL=3D/bin/sh
    2023-04-26T10:44:20.002801  #
    2023-04-26T10:44:20.104234  / # export SHELL=3D/bin/sh. /lava-917231/en=
vironment
    2023-04-26T10:44:20.104686  =

    2023-04-26T10:44:20.206111  / # . /lava-917231/environment/lava-917231/=
bin/lava-test-runner /lava-917231/1
    2023-04-26T10:44:20.206891  =

    2023-04-26T10:44:20.209308  / # /lava-917231/bin/lava-test-runner /lava=
-917231/1
    2023-04-26T10:44:20.247317  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (12 line(s) more)  =

 =20
