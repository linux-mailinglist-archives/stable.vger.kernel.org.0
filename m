Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2CB4E326A
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 22:47:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbiCUVsE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 17:48:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiCUVsD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 17:48:03 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50D403AB365
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 14:43:50 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id b8so14095993pjb.4
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 14:43:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LPlo8f5flVstZUbcLYTOqHTmI7WeyH8CbRnkICVyIvU=;
        b=JetKkGbtLqKsi2p4Nr788R5pL3guRtOAFV8iMKSQddLKhALm7Gln6EFe4Megx1m4Kv
         NCEMeXonvBW+hqgMIk+HjFEDiRVXEoZhO4YM40jIrt3Dqk1RvsTqnqiWcXezlc+9HiVA
         hp/xvWREkRpC3Ga+NqVZS6Hh6FE3RI/gBmjhotd83bMR0DOEDY+XJc/O5CbXI2VZSdcL
         9g9vB1zTWhupMllb4M6TGheE+8Yu/0aIr0KpKOCYfGDLA1n6KuOFMfojaMkCw51XwXvA
         FO96VGD7UDnYFHgPVvkBfe5tuo/mStm4RsTKKytj8e1ROHLw01mL2XLZL0ZLlSBu1/gR
         8Y7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LPlo8f5flVstZUbcLYTOqHTmI7WeyH8CbRnkICVyIvU=;
        b=u4otOsV7K/uFcFIVT7ikybF5mUqk2xipkdHWpSGa+f4S3zR0U9Isqc7IbXgqFO66oo
         pIJpdAOmnReNjSvBgOQ6JlxqKXF8A8u+CnUjldTtGRR6AGs+x10gNyZbTJ3vl3MliGIg
         rSMb4YRT4o0IaMVz4Nyj7aHCX80iRQusKGZZyP4PG4Ru8VKAPOXlq1VkIZGT53I/D0nj
         QbCSTisfILI/YLY3D2gROrX2Wi3uLQsTmrrWLtsTdQuy7xegOROOSGxRi5s6YVwPExe+
         EQiYANKDpEOEZ3C6cmhW5oJIPSDybGqupdv/W+9hYDabkwhJcfcBnnr3X5RmTxVFmPZ4
         4XYA==
X-Gm-Message-State: AOAM530LyOI2J0VByAf+NNZRSkCIk3YsWwAnzTaXAivCnAmkP7n/3xbX
        OFlF5azu7SMETIxjg+nV5Uu5iPGizoSb87ugB10=
X-Google-Smtp-Source: ABdhPJwbIqgyC2rHConS3Uwg57N+NO7CzZNOrRq90FPIpfzdzvx/fGsGAQ8kxFhPrBYOYl75ywMCTg==
X-Received: by 2002:a17:90b:3a86:b0:1c6:5971:5980 with SMTP id om6-20020a17090b3a8600b001c659715980mr1268363pjb.68.1647898992295;
        Mon, 21 Mar 2022 14:43:12 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u25-20020a62ed19000000b004f140515d56sm20287272pfh.46.2022.03.21.14.43.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 14:43:12 -0700 (PDT)
Message-ID: <6238f170.1c69fb81.aeed8.8315@mx.google.com>
Date:   Mon, 21 Mar 2022 14:43:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.186-18-g7f44fdc1563d
Subject: stable-rc/linux-5.4.y baseline: 54 runs,
 3 regressions (v5.4.186-18-g7f44fdc1563d)
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

stable-rc/linux-5.4.y baseline: 54 runs, 3 regressions (v5.4.186-18-g7f44fd=
c1563d)

Regressions Summary
-------------------

platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =

qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =

rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.186-18-g7f44fdc1563d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.186-18-g7f44fdc1563d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7f44fdc1563d6bca95ee9fb4414e4b8286bccb0c =



Test Regressions
---------------- =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/6238b2374acb8121922172b9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.186=
-18-g7f44fdc1563d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.186=
-18-g7f44fdc1563d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6238b2374acb812192217=
2ba
        failing since 95 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/6238b23654109e04012172c2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.186=
-18-g7f44fdc1563d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.186=
-18-g7f44fdc1563d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6238b23654109e0401217=
2c3
        failing since 95 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6238b4bca3a2d089862172ce

  Results:     88 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.186=
-18-g7f44fdc1563d/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.186=
-18-g7f44fdc1563d/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6238b4bca3a2d089862172f0
        failing since 15 days (last pass: v5.4.181-51-gb77a12b8d613, first =
fail: v5.4.182-54-gf27af6bf3c32)

    2022-03-21T17:24:04.424573  /lava-5915326/1/../bin/lava-test-case   =

 =20
