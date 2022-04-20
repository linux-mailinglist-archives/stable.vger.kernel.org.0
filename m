Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 155B450874E
	for <lists+stable@lfdr.de>; Wed, 20 Apr 2022 13:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240755AbiDTLtx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Apr 2022 07:49:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235688AbiDTLtv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Apr 2022 07:49:51 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ACFE41604
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 04:47:05 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id bx5so1682305pjb.3
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 04:47:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jqBCMH9mN+YGx3wiZMkM7PpXNvxrHzUs6aXPbjGPCxo=;
        b=Oui1tTQijsgRIemBDIc849W+79RgIHpX5jAgR3+8EfUHMzhA0sSzOEKYVOegWOaWxh
         8AkN1HN4FtOxu8pOxZLq/zBqIuVzJ1idRzn+xOZ7MKeJYyVpNNox2Qnyw9UoSsXHPcgq
         fMqVteOsMtoPnLpX7rY/ya/59t61hmXfSYj26jRNqonipj/m49XyWY0uVuyFnHbXV3sH
         flR/bMEPPAzQGAChlB2D1pRXP48BqUgV9vAXH2mureTlC1ErSD3cP8/k2rJroXLgGiVD
         tG5MyoCXzLlbPdKy2AxAhed89YEr9HifvfJmKjnq1R3Mr3ONJGY6esYZym534e0zcCP+
         MKnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jqBCMH9mN+YGx3wiZMkM7PpXNvxrHzUs6aXPbjGPCxo=;
        b=I/ATwX/L6xJlcDdyNHXUEO8/rvl8okGOOnefRSgrUoWdphGaL0YwNIMoXxBa9pRPuN
         i0by/vbd2uvU/brAjW++aa8FyvZDeLgbBIAHgrC2ctZutmvfUUM8Oh0toHJCVdzNXsj1
         KUtsk9/JC2pa3LrksxWgPU54rcysA/guvIUSr1q2tjPjDZYSME7w5IFe32EEL4wgd4Rn
         Rd5X9T9xT4nIdNZgi4AYusXRokKxZt76G4xrZryTYsWiS3l26LQrQF3Am4il1ro5BRIz
         P2jUltWyctzW0KRcDlLLeBCw2+qXsqUlUzfuZkS0yZmriKnDlWcnJIp3oSbIvcb/VtXq
         G/qw==
X-Gm-Message-State: AOAM531EeOvICiajf+43I9D/KRTcufjtl734hPt0PpZpts+pZ7V4IP8m
        uuEpfhflK/k/Rt1Hjz5MT/mEm/s/TK5RRh6/
X-Google-Smtp-Source: ABdhPJy0PYZxLKWPgsGnV1CdCPTzhkuZ9ZVjg178PYXb1P1nzdQxqbwikjJVF/93g3xMJBWuerY2+A==
X-Received: by 2002:a17:90b:390c:b0:1d0:9963:6eb8 with SMTP id ob12-20020a17090b390c00b001d099636eb8mr3897941pjb.59.1650455224799;
        Wed, 20 Apr 2022 04:47:04 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z16-20020a637e10000000b00382b21c6b0bsm19963799pgc.51.2022.04.20.04.47.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 04:47:04 -0700 (PDT)
Message-ID: <625ff2b8.1c69fb81.14fe1.ed4f@mx.google.com>
Date:   Wed, 20 Apr 2022 04:47:04 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Kernel: v5.4.190
X-Kernelci-Report-Type: test
Subject: stable/linux-5.4.y baseline: 124 runs, 5 regressions (v5.4.190)
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

stable/linux-5.4.y baseline: 124 runs, 5 regressions (v5.4.190)

Regressions Summary
-------------------

platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
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


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.190/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.190
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      dc213ac85601199834e7f2d222a5e63d7076d971 =



Test Regressions
---------------- =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/625fbd05dc70669304ae06a2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.190/ar=
m/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv2-uefi.=
txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.190/ar=
m/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv2-uefi.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625fbd05dc70669304ae0=
6a3
        failing since 123 days (last pass: v5.4.166, first fail: v5.4.167) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-broonie   | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/625fbce6dc70669304ae067d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.190/ar=
m/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-virt-gicv2-uefi.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.190/ar=
m/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-virt-gicv2-uefi.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625fbce6dc70669304ae0=
67e
        failing since 123 days (last pass: v5.4.166, first fail: v5.4.167) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/625fbd04dc70669304ae069f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.190/ar=
m/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv3-uefi.=
txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.190/ar=
m/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv3-uefi.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625fbd04dc70669304ae0=
6a0
        failing since 123 days (last pass: v5.4.166, first fail: v5.4.167) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv3-uefi | arm   | lab-broonie   | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/625fbce4664f51083bae067d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.190/ar=
m/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-virt-gicv3-uefi.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.190/ar=
m/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-virt-gicv3-uefi.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625fbce4664f51083bae0=
67e
        failing since 123 days (last pass: v5.4.166, first fail: v5.4.167) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/625fc578242ba6dbf1ae069b

  Results:     88 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.190/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-kev=
in.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.190/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-kev=
in.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/625fc578242ba6dbf1ae06bd
        failing since 42 days (last pass: v5.4.181, first fail: v5.4.183)

    2022-04-20T08:33:46.831476  <8>[   30.366753] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-04-20T08:33:47.842268  /lava-6129253/1/../bin/lava-test-case
    2022-04-20T08:33:47.850726  <8>[   31.387572] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
