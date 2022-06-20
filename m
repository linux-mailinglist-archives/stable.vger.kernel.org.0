Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55A085521B8
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 17:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbiFTP64 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 11:58:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244472AbiFTP6x (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 11:58:53 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AF651FCE7
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 08:58:49 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id g16-20020a17090a7d1000b001ea9f820449so11152354pjl.5
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 08:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8JwNtp/OlaS8JOIn3mIkO1dG8hjrPXyAWBdQtlQalZ8=;
        b=oDKD+w+a4eM2QLh1Yebyhv/C3gq559xjrv67ma/0rMnIFFPM/ysY8xQX0x3adNxQrx
         +AG4mAybPH7tCB2OrLEgNyRHapPVaa3QTbuF5BBzFA7uui2hHVMW5ZvW8c3mvAHdowwP
         OeuOt43eMsZ4syIzOjm2zHvU7XCTj9O2x7ylYPKt2D/cee8cAlDsfcNOukxR3urJxYhn
         cBq6R6bnfoincfP5MCKpmuT//9NiMX96AxsQ8M+K5vleGYiqYh6ea0yGCGtN1pvjWY57
         7NtKvhhSO28nNIoScpabTyH9B+a/1vYfGlJ5oZDdzVL08xbdlA/Fs8W2LkGTiH+7+Sci
         4Z/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8JwNtp/OlaS8JOIn3mIkO1dG8hjrPXyAWBdQtlQalZ8=;
        b=0qoIkEkAXqRCHp/MIBulQEuFlcJEZ6lI3v04pGbl4Sid5dLDdCocCycznGyvr96KM/
         kW4BwSJwRFSK1ITvm2SmJp0fDHE7zyAWrsRWvJ9dBD+ApqS9/1C+DFehvzZOvm6x7Dyx
         QmjRcPHUIkjScelPPTdg74zzAS02bxchCRVvjcKhmSXmlKNIkTgLt1p9QY7YwD8j1rtM
         2+UufC/dwfv2uKiTpKPP3dEAHMwq3PWEb5ffE7WJyS8Pn2QCL0+XMEEoi/gxmnDfqx1i
         lRZ2D9LMJoq8q3rreFtjSdwh6wK0CpwMbVDVvI1LelAO3nI2un2vOO1ME3Q7TMwtwXbo
         i/yw==
X-Gm-Message-State: AJIora9JsI4Qf1euY/YeMbbj7vVj6IDJPkfsI/YLakjqBiFwnztMfbjO
        neYnkjCTWPYZr1xi57aLBBV4KBCgaGyhxxLW+E8=
X-Google-Smtp-Source: AGRyM1szULELPMzGLQkAlPoSBBC7Xx6rfoCSVacBYx89bLmdfaoc7qn5hU2VVonQSoGWrvGKd2Tn4Q==
X-Received: by 2002:a17:90a:f3c3:b0:1ec:9f63:1330 with SMTP id ha3-20020a17090af3c300b001ec9f631330mr8314569pjb.165.1655740728600;
        Mon, 20 Jun 2022 08:58:48 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a1-20020a1709027e4100b0015e8d4eb1b6sm8897054pln.0.2022.06.20.08.58.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jun 2022 08:58:48 -0700 (PDT)
Message-ID: <62b09938.1c69fb81.837a1.c857@mx.google.com>
Date:   Mon, 20 Jun 2022 08:58:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.284-228-gba201f55e315e
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 122 runs,
 18 regressions (v4.14.284-228-gba201f55e315e)
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

stable-rc/queue/4.14 baseline: 122 runs, 18 regressions (v4.14.284-228-gba2=
01f55e315e)

Regressions Summary
-------------------

platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
jetson-tk1                 | arm   | lab-baylibre | gcc-10   | multi_v7_def=
config         | 1          =

jetson-tk1                 | arm   | lab-baylibre | gcc-10   | tegra_defcon=
fig            | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-baylibre | gcc-10   | defconfig+ar=
m64-chromebook | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-baylibre | gcc-10   | defconfig   =
               | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-broonie  | gcc-10   | defconfig+ar=
m64-chromebook | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-broonie  | gcc-10   | defconfig   =
               | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre | gcc-10   | defconfig+ar=
m64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre | gcc-10   | defconfig   =
               | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie  | gcc-10   | defconfig+ar=
m64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie  | gcc-10   | defconfig   =
               | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-baylibre | gcc-10   | defconfig+ar=
m64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-baylibre | gcc-10   | defconfig   =
               | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie  | gcc-10   | defconfig+ar=
m64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie  | gcc-10   | defconfig   =
               | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre | gcc-10   | defconfig+ar=
m64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre | gcc-10   | defconfig   =
               | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie  | gcc-10   | defconfig+ar=
m64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie  | gcc-10   | defconfig   =
               | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.284-228-gba201f55e315e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.284-228-gba201f55e315e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ba201f55e315e7f2ae155b60468d964b4e2b2ba5 =



Test Regressions
---------------- =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
jetson-tk1                 | arm   | lab-baylibre | gcc-10   | multi_v7_def=
config         | 1          =


  Details:     https://kernelci.org/test/plan/id/62b0711d4402669dd0a39bde

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.284=
-228-gba201f55e315e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jet=
son-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.284=
-228-gba201f55e315e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jet=
son-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b0711d4402669dd0a39=
bdf
        failing since 27 days (last pass: v4.14.278-4-g95c4f04a529a, first =
fail: v4.14.280-33-gfbdef5eaf17e4) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
jetson-tk1                 | arm   | lab-baylibre | gcc-10   | tegra_defcon=
fig            | 1          =


  Details:     https://kernelci.org/test/plan/id/62b072c2eaf1c2d74ca39bcf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.284=
-228-gba201f55e315e/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.284=
-228-gba201f55e315e/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b072c2eaf1c2d74ca39=
bd0
        failing since 15 days (last pass: v4.14.281-23-ga0c33ef6408ce, firs=
t fail: v4.14.281-23-g903e234594714) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre | gcc-10   | defconfig+ar=
m64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62b06719f0388d564fa39be9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.284=
-228-gba201f55e315e/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/ba=
seline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.284=
-228-gba201f55e315e/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/ba=
seline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b06719f0388d564fa39=
bea
        failing since 41 days (last pass: v4.14.277-54-gf277f09f64f4, first=
 fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre | gcc-10   | defconfig   =
               | 1          =


  Details:     https://kernelci.org/test/plan/id/62b0695fea462a3ff2a39be8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.284=
-228-gba201f55e315e/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64=
-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.284=
-228-gba201f55e315e/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64=
-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b0695fea462a3ff2a39=
be9
        failing since 41 days (last pass: v4.14.277-54-gfa6de16ffc4e, first=
 fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie  | gcc-10   | defconfig+ar=
m64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62b069245f85f88026a39bff

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.284=
-228-gba201f55e315e/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.284=
-228-gba201f55e315e/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b069245f85f88026a39=
c00
        failing since 41 days (last pass: v4.14.277-54-gf277f09f64f4, first=
 fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie  | gcc-10   | defconfig   =
               | 1          =


  Details:     https://kernelci.org/test/plan/id/62b06bb7d4b2af076aa39bdf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.284=
-228-gba201f55e315e/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.284=
-228-gba201f55e315e/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b06bb7d4b2af076aa39=
be0
        failing since 41 days (last pass: v4.14.277-54-gfa6de16ffc4e, first=
 fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre | gcc-10   | defconfig+ar=
m64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62b0673fe0c3d1a461a39c00

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.284=
-228-gba201f55e315e/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/ba=
seline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.284=
-228-gba201f55e315e/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/ba=
seline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b0673fe0c3d1a461a39=
c01
        failing since 41 days (last pass: v4.14.277-54-gf277f09f64f4, first=
 fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre | gcc-10   | defconfig   =
               | 1          =


  Details:     https://kernelci.org/test/plan/id/62b06960a00d9e8c2ea39bea

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.284=
-228-gba201f55e315e/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.284=
-228-gba201f55e315e/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b06960a00d9e8c2ea39=
beb
        failing since 41 days (last pass: v4.14.277-54-gfa6de16ffc4e, first=
 fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie  | gcc-10   | defconfig+ar=
m64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62b06a3becfd5c061ca39c4c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.284=
-228-gba201f55e315e/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.284=
-228-gba201f55e315e/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b06a3becfd5c061ca39=
c4d
        failing since 41 days (last pass: v4.14.277-54-gf277f09f64f4, first=
 fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie  | gcc-10   | defconfig   =
               | 1          =


  Details:     https://kernelci.org/test/plan/id/62b06bcb560e10da40a39bda

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.284=
-228-gba201f55e315e/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.284=
-228-gba201f55e315e/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b06bcb560e10da40a39=
bdb
        failing since 41 days (last pass: v4.14.277-54-gfa6de16ffc4e, first=
 fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-baylibre | gcc-10   | defconfig+ar=
m64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62b06718705f6524a3a39bef

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.284=
-228-gba201f55e315e/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/ba=
seline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.284=
-228-gba201f55e315e/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/ba=
seline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b06718705f6524a3a39=
bf0
        failing since 41 days (last pass: v4.14.277-54-gf277f09f64f4, first=
 fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-baylibre | gcc-10   | defconfig   =
               | 1          =


  Details:     https://kernelci.org/test/plan/id/62b06948ee4dc337fea39bf7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.284=
-228-gba201f55e315e/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64=
-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.284=
-228-gba201f55e315e/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64=
-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b06948ee4dc337fea39=
bf8
        failing since 41 days (last pass: v4.14.277-54-gfa6de16ffc4e, first=
 fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie  | gcc-10   | defconfig+ar=
m64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62b069235f85f88026a39bfc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.284=
-228-gba201f55e315e/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.284=
-228-gba201f55e315e/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b069235f85f88026a39=
bfd
        failing since 41 days (last pass: v4.14.277-54-gf277f09f64f4, first=
 fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie  | gcc-10   | defconfig   =
               | 1          =


  Details:     https://kernelci.org/test/plan/id/62b06b8f8d641e906ea39c52

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.284=
-228-gba201f55e315e/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.284=
-228-gba201f55e315e/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b06b8f8d641e906ea39=
c53
        failing since 41 days (last pass: v4.14.277-54-gfa6de16ffc4e, first=
 fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre | gcc-10   | defconfig+ar=
m64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62b0672ce1c0cdd5d3a39bd0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.284=
-228-gba201f55e315e/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/ba=
seline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.284=
-228-gba201f55e315e/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/ba=
seline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b0672ce1c0cdd5d3a39=
bd1
        failing since 41 days (last pass: v4.14.277-54-gf277f09f64f4, first=
 fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre | gcc-10   | defconfig   =
               | 1          =


  Details:     https://kernelci.org/test/plan/id/62b0694b9ffaa74b82a39be5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.284=
-228-gba201f55e315e/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.284=
-228-gba201f55e315e/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b0694b9ffaa74b82a39=
be6
        failing since 41 days (last pass: v4.14.277-54-gfa6de16ffc4e, first=
 fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie  | gcc-10   | defconfig+ar=
m64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62b0697354ef63bd57a39bcf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.284=
-228-gba201f55e315e/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.284=
-228-gba201f55e315e/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b0697354ef63bd57a39=
bd0
        failing since 41 days (last pass: v4.14.277-54-gf277f09f64f4, first=
 fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie  | gcc-10   | defconfig   =
               | 1          =


  Details:     https://kernelci.org/test/plan/id/62b06ba316b89876ffa39bd3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.284=
-228-gba201f55e315e/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.284=
-228-gba201f55e315e/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b06ba316b89876ffa39=
bd4
        failing since 41 days (last pass: v4.14.277-54-gfa6de16ffc4e, first=
 fail: v4.14.277-75-g7a298ff98d4a) =

 =20
