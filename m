Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 265174F1AE5
	for <lists+stable@lfdr.de>; Mon,  4 Apr 2022 23:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379307AbiDDVTH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Apr 2022 17:19:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380144AbiDDTBZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Apr 2022 15:01:25 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCA8B24598
        for <stable@vger.kernel.org>; Mon,  4 Apr 2022 11:59:28 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id x31so9815924pfh.9
        for <stable@vger.kernel.org>; Mon, 04 Apr 2022 11:59:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=CGOYpDBulrU5vjiEg1GG5549G0/5LJhpmLXPA3gj5gU=;
        b=gSm7RGfrBgHIKUP7pFXa+vfVD/pu/+8Upd3qdkTOjKiVBIUOlknrTw0WxHVLcujmuo
         CbOmlGXgkGejBNdvOR8vN9Rr565wR+nGTgmzMQC7byrGVrqhGEnPNLeBMQWaabrE1Bdc
         2vajGLHzIh1UQN6RlnpN6yNIqn5bKufg/3WsnMuqUWh31xawg5cOQfAM4WMQVpLaG3Xy
         htD00CCgnYoQ+c91DeBtMWujFK0wOrdc62P5PWbXxBxIyrZcskFEQYZD7Yvd5CWyrJGS
         gdVdjnFUn7ClwH5WW9sen3e8cWdS3QJ7NhvgYC5EW7Zu8d3R5qccqKm1jV5dYWQzs7Me
         L6Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=CGOYpDBulrU5vjiEg1GG5549G0/5LJhpmLXPA3gj5gU=;
        b=2ouS12towsrbODVAShenzcPf3P929XgOoeXU+533QVXf/MQdmWdAxSa4Vcq5O3HcUV
         LHhtUQar/FpusJPsp5y85H3K5erB6u+J7TVlsNpMYLH0pj8nzcg7X0Ob0qyq2p5rSxPS
         rgoBT5Wr3VVlcHdMo9uwzoicv2ScCBP15x8nqYcaI/t940vuMJpmvh+jiCmr9aNuriNw
         MVgWJRO57x46X19MP6GBstiLl9xbz6uSiWheMOYMAUmdWrgSv+f/OXf7ddBhe2irV3/1
         JlPcIgQihkj/oNdu9dRC8svUF34rCwxv3meWgNNT98XIuHsQtoZ8yB6h9PztnOIKpUNg
         HN4A==
X-Gm-Message-State: AOAM531amy2RhrbVgJO7Z6MSQsA4BXgubYWxUAyOXmTMI+ljBFDS9DYG
        VlAQfhBbJMPvU4J/YYEA3KiSbFQLWZS0bazX2zM=
X-Google-Smtp-Source: ABdhPJzHPgkEllls38//tPWlZlCOGXLCWo7UioHHIOi6u7Ha0Y8sLMvL68EhLI6ehFfBmjM4A0mWlw==
X-Received: by 2002:a63:e201:0:b0:382:6afe:f0ec with SMTP id q1-20020a63e201000000b003826afef0ecmr1066905pgh.339.1649098767609;
        Mon, 04 Apr 2022 11:59:27 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u25-20020a62ed19000000b004f140515d56sm13252686pfh.46.2022.04.04.11.59.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Apr 2022 11:59:27 -0700 (PDT)
Message-ID: <624b400f.1c69fb81.4c128.26a6@mx.google.com>
Date:   Mon, 04 Apr 2022 11:59:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Kernel: v5.4.188-369-gfec0077da6ba
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.4.y baseline: 52 runs,
 3 regressions (v5.4.188-369-gfec0077da6ba)
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

stable-rc/linux-5.4.y baseline: 52 runs, 3 regressions (v5.4.188-369-gfec00=
77da6ba)

Regressions Summary
-------------------

platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-broonie   | gcc-10   | multi_v7_defc=
onfig         | 1          =

qemu_arm-virt-gicv3-uefi | arm   | lab-broonie   | gcc-10   | multi_v7_defc=
onfig         | 1          =

rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.188-369-gfec0077da6ba/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.188-369-gfec0077da6ba
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fec0077da6bae2950e39f5171e9a9e0f54f8a1f1 =



Test Regressions
---------------- =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-broonie   | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/624b0e24092b273371ae0683

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.188=
-369-gfec0077da6ba/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_=
arm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.188=
-369-gfec0077da6ba/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_=
arm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/624b0e24092b273371ae0=
684
        failing since 109 days (last pass: v5.4.165, first fail: v5.4.165-1=
9-gb780ab989d60) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv3-uefi | arm   | lab-broonie   | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/624b0e2571c8422cd6ae067c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.188=
-369-gfec0077da6ba/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_=
arm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.188=
-369-gfec0077da6ba/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_=
arm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/624b0e2571c8422cd6ae0=
67d
        failing since 109 days (last pass: v5.4.165, first fail: v5.4.165-1=
9-gb780ab989d60) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/624b1051b834743f7aae0684

  Results:     88 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.188=
-369-gfec0077da6ba/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.188=
-369-gfec0077da6ba/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/624b1051b834743f7aae06a6
        failing since 29 days (last pass: v5.4.181-51-gb77a12b8d613, first =
fail: v5.4.182-54-gf27af6bf3c32)

    2022-04-04T15:35:34.379505  /lava-6017550/1/../bin/lava-test-case
    2022-04-04T15:35:34.388334  <8>[   31.356745] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
