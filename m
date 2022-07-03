Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1B795643B9
	for <lists+stable@lfdr.de>; Sun,  3 Jul 2022 05:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230517AbiGCDdP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Jul 2022 23:33:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230506AbiGCDdO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Jul 2022 23:33:14 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFB69A1B9
        for <stable@vger.kernel.org>; Sat,  2 Jul 2022 20:33:12 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id w185so2319706pfb.4
        for <stable@vger.kernel.org>; Sat, 02 Jul 2022 20:33:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gapvDrakSRT5xLUoafGqInfsu/gGHFR7zBsmiQtKfEQ=;
        b=Sm+YvktrwRcOfiM8sYCKkH0G85U2BhAdvi+A3psxfQ1+F3SbSIIp9+q07luCzYHFYE
         +ZxXb9SjB0YYiGl2Yzu3RWbPxWCNznnIbG6q9NWMdW3R7+I+CSCnjhjrNARxL9BFJdvr
         l7ds6iRBm3O1DpRy6/yD+O4GH1K25bM6zAL1W92pJv/qyV3D2DCInDMkEwK4sv68IvSE
         X3a6cAcYQ73boUq7Y9cmqhnykCxZnIL5uoCGwUZeMJ8+ec/a0KBN6qd3HbzkRuUUvFZC
         sLMJn3EeSuCEOEKwdbEAJ+hTLadc9VftNERUcf9BPnP8f+fFjzfvbLWruNiXdIksdkLY
         RtAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gapvDrakSRT5xLUoafGqInfsu/gGHFR7zBsmiQtKfEQ=;
        b=VwCxN/YSKcHcghmvBGhXxbOrBkx9Us41N7TvvcgizTcHW5Th2FD37C4QZDTQImtx86
         u0E2hZbS/kBvn/wD3s8lptGrWDWvYs/BEtH7TEVTk+qFNM5FTJBYk2pGYDzvO2oWIsMB
         gUV4gKyk1JlamZwzeKjbkoGlRA2AYkpQYKKv/LrwDmvO6Fq72LjN79+GCiohBeqNtbpn
         /y85LYgg2C/Dqt6OI0l6m8FkKor8sUj7H3K6xYI23+s/39Rl9PEVCFZhNR0VZH0CyGOT
         jIZY5CmlnvbHG6GgVLcr+tpTzbluwh2l6g0vnoJxAZoiiebMLXxjLDippKJXeMD1zHlZ
         onFg==
X-Gm-Message-State: AJIora/rn6hTKcSKpIhWAdDsHZh5kZOJbG4Zrz7RoXr2Rvnkuu7LxATA
        g/NdH2tu/ev8uiYm9KlK5JRMRDuU3/N177jQ
X-Google-Smtp-Source: AGRyM1t1mhj6lY4u6sb29jH7xoJQXut+2txz7S4i6q4d8I0dE3Xr1x5vtSCKwXILfDickF8DMI3++g==
X-Received: by 2002:a63:3c03:0:b0:40c:f773:1e07 with SMTP id j3-20020a633c03000000b0040cf7731e07mr18964328pga.443.1656819192053;
        Sat, 02 Jul 2022 20:33:12 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s3-20020a170902c64300b0016a61301293sm17912206pls.212.2022.07.02.20.33.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Jul 2022 20:33:11 -0700 (PDT)
Message-ID: <62c10df7.1c69fb81.6fefd.a2c0@mx.google.com>
Date:   Sat, 02 Jul 2022 20:33:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.128
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.10.y baseline: 149 runs, 10 regressions (v5.10.128)
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

stable/linux-5.10.y baseline: 149 runs, 10 regressions (v5.10.128)

Regressions Summary
-------------------

platform                   | arch  | lab          | compiler | defconfig   =
       | regressions
---------------------------+-------+--------------+----------+-------------=
-------+------------
jetson-tk1                 | arm   | lab-baylibre | gcc-10   | multi_v7_def=
config | 1          =

jetson-tk1                 | arm   | lab-baylibre | gcc-10   | tegra_defcon=
fig    | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-baylibre | gcc-10   | defconfig   =
       | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-broonie  | gcc-10   | defconfig   =
       | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre | gcc-10   | defconfig   =
       | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie  | gcc-10   | defconfig   =
       | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-baylibre | gcc-10   | defconfig   =
       | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie  | gcc-10   | defconfig   =
       | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre | gcc-10   | defconfig   =
       | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie  | gcc-10   | defconfig   =
       | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.128/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.128
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      ea86c1430c83aa91f2c4122408922e34a1279775 =



Test Regressions
---------------- =



platform                   | arch  | lab          | compiler | defconfig   =
       | regressions
---------------------------+-------+--------------+----------+-------------=
-------+------------
jetson-tk1                 | arm   | lab-baylibre | gcc-10   | multi_v7_def=
config | 1          =


  Details:     https://kernelci.org/test/plan/id/62c0d773b65c20c09aa39cb7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.128/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.128/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c0d773b65c20c09aa39=
cb8
        failing since 38 days (last pass: v5.10.115, first fail: v5.10.118) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
       | regressions
---------------------------+-------+--------------+----------+-------------=
-------+------------
jetson-tk1                 | arm   | lab-baylibre | gcc-10   | tegra_defcon=
fig    | 1          =


  Details:     https://kernelci.org/test/plan/id/62c0d52e6ba59cb83fa39bcd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.128/=
arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.128/=
arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c0d52e6ba59cb83fa39=
bce
        failing since 33 days (last pass: v5.10.118, first fail: v5.10.119) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
       | regressions
---------------------------+-------+--------------+----------+-------------=
-------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre | gcc-10   | defconfig   =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/62c0d6ffdd1d735669a39bcd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.128/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.128/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c0d6ffdd1d735669a39=
bce
        failing since 54 days (last pass: v5.10.112, first fail: v5.10.114) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
       | regressions
---------------------------+-------+--------------+----------+-------------=
-------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie  | gcc-10   | defconfig   =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/62c0d6d530cc1ae1f7a39bdd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.128/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.128/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c0d6d530cc1ae1f7a39=
bde
        failing since 54 days (last pass: v5.10.112, first fail: v5.10.114) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
       | regressions
---------------------------+-------+--------------+----------+-------------=
-------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre | gcc-10   | defconfig   =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/62c0d703dd1d735669a39bd3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.128/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.128/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c0d703dd1d735669a39=
bd4
        failing since 54 days (last pass: v5.10.112, first fail: v5.10.114) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
       | regressions
---------------------------+-------+--------------+----------+-------------=
-------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie  | gcc-10   | defconfig   =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/62c0d6ea30cc1ae1f7a39bed

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.128/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.128/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c0d6ea30cc1ae1f7a39=
bee
        failing since 54 days (last pass: v5.10.112, first fail: v5.10.114) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
       | regressions
---------------------------+-------+--------------+----------+-------------=
-------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-baylibre | gcc-10   | defconfig   =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/62c0d701dd1d735669a39bd0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.128/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.128/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c0d701dd1d735669a39=
bd1
        failing since 54 days (last pass: v5.10.112, first fail: v5.10.114) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
       | regressions
---------------------------+-------+--------------+----------+-------------=
-------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie  | gcc-10   | defconfig   =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/62c0d6d630cc1ae1f7a39be4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.128/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.128/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c0d6d630cc1ae1f7a39=
be5
        failing since 54 days (last pass: v5.10.112, first fail: v5.10.114) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
       | regressions
---------------------------+-------+--------------+----------+-------------=
-------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre | gcc-10   | defconfig   =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/62c0d704dd1d735669a39be1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.128/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.128/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c0d704dd1d735669a39=
be2
        failing since 54 days (last pass: v5.10.112, first fail: v5.10.114) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
       | regressions
---------------------------+-------+--------------+----------+-------------=
-------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie  | gcc-10   | defconfig   =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/62c0d6eb30cc1ae1f7a39bf0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.128/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.128/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c0d6eb30cc1ae1f7a39=
bf1
        failing since 54 days (last pass: v5.10.112, first fail: v5.10.114) =

 =20
