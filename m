Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD7F4F6F05
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 02:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbiDGARm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 20:17:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiDGARl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 20:17:41 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54633931BC
        for <stable@vger.kernel.org>; Wed,  6 Apr 2022 17:15:43 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id b13so4024293pfv.0
        for <stable@vger.kernel.org>; Wed, 06 Apr 2022 17:15:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wZM8Kfj0/8gqHBRtvrGWeNA8MpXRsvimeVYKZjIgBTw=;
        b=tRu8pB+o+9MK7UDEYyH/jLLfpGiFEojMmPsou9CTYvnIiWzni1V8vfTP6YXd+nANu/
         +tkfbG3SCKqkX5nFY2Z9ifzb0+kVuukJOhqVbQ8xQI6czXUJ1kVd5GVuiZn4WClR7w5q
         //zHWD67znzJ+0ECjtUwYFaL564nwEcMdzNANUinMFHwfRR+cgSxAYsPFc2Zmh+7X7hr
         ia8rCDxQhJd7TPixsIOpVoYa6UifV8o6NADBIzj5g3E4tDM/9h3+J/DO3BdQ/Fr3HzbY
         5GlJqvFZXxeYXRP16k3YgH4vPJBtX3cscTeOG+UTwW+1f24d4SJUpZqCBv8IXXppKgZf
         szng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wZM8Kfj0/8gqHBRtvrGWeNA8MpXRsvimeVYKZjIgBTw=;
        b=IFDAUAId9mYem5v1ATaxcbCGXkqoZ/xOCTz+O70X9LW9hd5hOim9bOarWU3qHgesgT
         Y6UehHkqrE4psta07u4Bt+suBKha/4LRq6oJSTWLalcXNgfItPHagckRdQuWemaYeF10
         hQh14RWMp7k7eQ2+DoMZ3RL+ska20GJO0itBWUBcSRSzxPXuhUTapulATx62JooXB6gg
         kKkptS1O/2NNa8vjrEBtQop4shEl00W/8xQwZ2qk+4EhgxBMmdSEXa5EaGD3JNId3zre
         dsvVpeP2mxVBw8cfn/UJuSLW0D1Lfam+Yvfb1K6HW9AhB2lE/Y6IRIjpxY3dsdwYjQqN
         0CbQ==
X-Gm-Message-State: AOAM532Uy8l/bEgB9YTgXUEVy485wnIcEHEJL4UrAXkcbk66mh+65UZn
        N6eJqaDi52W1Bv7TzyTkIeMs3VRJRAUbvKQWHmQ=
X-Google-Smtp-Source: ABdhPJzxWRRNzwo8ktp+ITTKFyOabIQ3AWGnaomyw4QGbTDD9Bjir6kgQbjjLc8tDznUxqDrXshUzQ==
X-Received: by 2002:a65:410a:0:b0:399:38b9:8ba with SMTP id w10-20020a65410a000000b0039938b908bamr9010845pgp.526.1649290542651;
        Wed, 06 Apr 2022 17:15:42 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m17-20020a17090a859100b001bc20ddcc67sm6506915pjn.34.2022.04.06.17.15.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 17:15:42 -0700 (PDT)
Message-ID: <624e2d2e.1c69fb81.494d.30d1@mx.google.com>
Date:   Wed, 06 Apr 2022 17:15:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Kernel: v5.4.188-368-ga24be10a1a9ef
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.4.y baseline: 89 runs,
 6 regressions (v5.4.188-368-ga24be10a1a9ef)
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

stable-rc/linux-5.4.y baseline: 89 runs, 6 regressions (v5.4.188-368-ga24be=
10a1a9ef)

Regressions Summary
-------------------

platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
hifive-unleashed-a00     | riscv | lab-baylibre  | gcc-10   | defconfig    =
              | 1          =

qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =

qemu_arm-virt-gicv2-uefi | arm   | lab-broonie   | gcc-10   | multi_v7_defc=
onfig         | 1          =

qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =

qemu_arm-virt-gicv3-uefi | arm   | lab-broonie   | gcc-10   | multi_v7_defc=
onfig         | 1          =

rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.188-368-ga24be10a1a9ef/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.188-368-ga24be10a1a9ef
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a24be10a1a9ef528d667b9e23479cbd9cb058b30 =



Test Regressions
---------------- =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
hifive-unleashed-a00     | riscv | lab-baylibre  | gcc-10   | defconfig    =
              | 1          =


  Details:     https://kernelci.org/test/plan/id/624df754adb1804dfbae06b9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.188=
-368-ga24be10a1a9ef/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unl=
eashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.188=
-368-ga24be10a1a9ef/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unl=
eashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/624df754adb1804dfbae0=
6ba
        new failure (last pass: v5.4.188-371-g48b29a8f8ae0) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/624e1ca8e54c0e3a98ae069c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.188=
-368-ga24be10a1a9ef/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qem=
u_arm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.188=
-368-ga24be10a1a9ef/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qem=
u_arm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/624e1ca8e54c0e3a98ae0=
69d
        failing since 111 days (last pass: v5.4.165, first fail: v5.4.165-1=
9-gb780ab989d60) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-broonie   | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/624df9c0d7a2169fe0ae07b0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.188=
-368-ga24be10a1a9ef/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu=
_arm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.188=
-368-ga24be10a1a9ef/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu=
_arm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/624df9c0d7a2169fe0ae0=
7b1
        failing since 111 days (last pass: v5.4.165, first fail: v5.4.165-1=
9-gb780ab989d60) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/624e1c80e54c0e3a98ae067c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.188=
-368-ga24be10a1a9ef/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qem=
u_arm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.188=
-368-ga24be10a1a9ef/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qem=
u_arm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/624e1c80e54c0e3a98ae0=
67d
        failing since 111 days (last pass: v5.4.165, first fail: v5.4.165-1=
9-gb780ab989d60) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv3-uefi | arm   | lab-broonie   | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/624df9bff234a71ec7ae0685

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.188=
-368-ga24be10a1a9ef/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu=
_arm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.188=
-368-ga24be10a1a9ef/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu=
_arm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/624df9bff234a71ec7ae0=
686
        failing since 111 days (last pass: v5.4.165, first fail: v5.4.165-1=
9-gb780ab989d60) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/624df7f17b0768f9f0ae0689

  Results:     88 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.188=
-368-ga24be10a1a9ef/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.188=
-368-ga24be10a1a9ef/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/624df7f17b0768f9f0ae06ab
        failing since 31 days (last pass: v5.4.181-51-gb77a12b8d613, first =
fail: v5.4.182-54-gf27af6bf3c32)

    2022-04-06T20:28:10.936927  /lava-6040814/1/../bin/lava-test-case
    2022-04-06T20:28:10.945266  <8>[   32.802489] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
