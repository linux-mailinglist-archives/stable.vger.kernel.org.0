Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 926756CCE79
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 02:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbjC2AGt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 20:06:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjC2AGt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 20:06:49 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02BDF1B5
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 17:06:48 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id r7-20020a17090b050700b002404be7920aso12846077pjz.5
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 17:06:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1680048407;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Ma84/Wd7DuhtA2FMUFL7Izza0rjlK8RAYAKTDcyES5U=;
        b=py50TFx1RnCt2Pk08i6TOM8U8Lgqg42Sc99MwH3cjwgXtibuXj830JKSLGuJ4uSjeT
         Nde/WHmIYz9dsFmCoMzar0wWAolqWWW8Eu1gVODfbfmTolOOfecJNB/MdKwCCQlPUBwM
         55MPmKTvXupijyIF1GGSOzN3Sz0HLB8dJAh6OmoZNU3ERvVdeP5H8mThCV7xGbgFdd+c
         PDmPK1GgtSwqXZ1xqjWkhViXdGQEhW5ypW0GvjX4YrAAxauqs+eqpfQFMytiGA5SLO1K
         +q4Z99mlDGu+oncJrPhGaqS4l9kQjmUxU6lG7OqFrYOScpFqfx09SeUVizpiWaoImwo9
         Py8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680048407;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ma84/Wd7DuhtA2FMUFL7Izza0rjlK8RAYAKTDcyES5U=;
        b=RrUqJPvRYnhpJhF0RA8CaJIaCyc5S58dvxmJRMxmjmWko9MrtoScPM+H1rG6QpRZXZ
         vyL3bGVBEEZ9/ds/fjLF8ajGEavuJRw0dpYGcFOLMbYH0kqd7o0mkFTYsRrG7XtOZIsd
         y/jc91y3Jy03iTlJzyNjI+vZtxPKqbIo4q0l7LQcZpeioxfXLfe6qMgcf5sCSxn1psYU
         htSBQwMcz2jrtbqkGB6GSvpUVCv209w5zfpmjjCXLCN6ESeZP3CFF0bb/bxisbeoyF2S
         1y947Gnh9VIfOWUMTaVBS65+Bqfq+cCx08WwqEmLLTvo6Z9pUfQg+l0aUju0yPCvyip5
         bpcQ==
X-Gm-Message-State: AAQBX9e+zW7FYHJvxY0DcimHWWoDEMWemwfggmma7fuGLYPwB9ZvpVLZ
        iLUpsGSu+oEPg97REbUS8CJpwApGAeIou3qDwUSgdQ==
X-Google-Smtp-Source: AKy350ZzOpR+luI3yLLMDpefL0B8QEQf2xIgbo4IB8BW73SYf23bNwFzqpDkCBgbGzBbx4juBPyDgw==
X-Received: by 2002:a05:6a21:789c:b0:da:b616:87bd with SMTP id bf28-20020a056a21789c00b000dab61687bdmr396898pzc.14.1680048407088;
        Tue, 28 Mar 2023 17:06:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k2-20020a632402000000b005136b93f8e9sm3066225pgk.14.2023.03.28.17.06.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 17:06:46 -0700 (PDT)
Message-ID: <64238116.630a0220.c5b08.63c8@mx.google.com>
Date:   Tue, 28 Mar 2023 17:06:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.176-105-g18265b240021
Subject: stable-rc/linux-5.10.y baseline: 133 runs,
 5 regressions (v5.10.176-105-g18265b240021)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 133 runs, 5 regressions (v5.10.176-105-g18=
265b240021)

Regressions Summary
-------------------

platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

r8a7743-iwg20d-q7            | arm    | lab-cip       | gcc-10   | shmobile=
_defconfig           | 1          =

rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.176-105-g18265b240021/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.176-105-g18265b240021
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      18265b240021ee39c9f67a99575572761bca0cb5 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64234b1082f8e65c3a62f7ba

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-105-g18265b240021/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-105-g18265b240021/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64234b1082f8e65c3a62f7bf
        new failure (last pass: v5.10.176)

    2023-03-28T20:16:03.900923  + set +x

    2023-03-28T20:16:03.907288  <8>[   15.232622] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9798974_1.4.2.3.1>

    2023-03-28T20:16:04.012006  / # #

    2023-03-28T20:16:04.112851  export SHELL=3D/bin/sh

    2023-03-28T20:16:04.113100  #

    2023-03-28T20:16:04.213983  / # export SHELL=3D/bin/sh. /lava-9798974/e=
nvironment

    2023-03-28T20:16:04.214192  =


    2023-03-28T20:16:04.315080  / # . /lava-9798974/environment/lava-979897=
4/bin/lava-test-runner /lava-9798974/1

    2023-03-28T20:16:04.315416  =


    2023-03-28T20:16:04.319578  / # /lava-9798974/bin/lava-test-runner /lav=
a-9798974/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64234b517ec8d305e362f788

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-105-g18265b240021/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-105-g18265b240021/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64234b517ec8d305e362f78d
        new failure (last pass: v5.10.176)

    2023-03-28T20:17:06.577223  <8>[   12.548661] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9798937_1.4.2.3.1>

    2023-03-28T20:17:06.580869  + set +x

    2023-03-28T20:17:06.684951  =


    2023-03-28T20:17:06.787039  / # #export SHELL=3D/bin/sh

    2023-03-28T20:17:06.787911  =


    2023-03-28T20:17:06.889562  / # export SHELL=3D/bin/sh. /lava-9798937/e=
nvironment

    2023-03-28T20:17:06.890427  =


    2023-03-28T20:17:06.992015  / # . /lava-9798937/environment/lava-979893=
7/bin/lava-test-runner /lava-9798937/1

    2023-03-28T20:17:06.993249  =


    2023-03-28T20:17:06.998811  / # /lava-9798937/bin/lava-test-runner /lav=
a-9798937/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
r8a7743-iwg20d-q7            | arm    | lab-cip       | gcc-10   | shmobile=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/642346b39f927e299a62f79e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-105-g18265b240021/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743=
-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-105-g18265b240021/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743=
-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/642346b39f927e299a62f=
79f
        failing since 5 days (last pass: v5.10.175-100-g1686e1df6521, first=
 fail: v5.10.176) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =


  Details:     https://kernelci.org/test/plan/id/642350c3cedbfd257462f799

  Results:     84 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-105-g18265b240021/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-105-g18265b240021/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/642350c3cedbfd257462f79f
        failing since 14 days (last pass: v5.10.173, first fail: v5.10.173-=
4-g955623617f2f)

    2023-03-28T20:40:27.732484  /lava-9798897/1/../bin/lava-test-case

    2023-03-28T20:40:27.743200  <8>[   61.997859] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy1-probed RESULT=3Dfail>
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/642350c3cedbfd257462f7a0
        failing since 14 days (last pass: v5.10.173, first fail: v5.10.173-=
4-g955623617f2f)

    2023-03-28T20:40:25.670538  <8>[   59.922672] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy-driver-present RESULT=3Dpass>

    2023-03-28T20:40:26.695695  /lava-9798897/1/../bin/lava-test-case

    2023-03-28T20:40:26.706910  <8>[   60.961236] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>
   =

 =20
