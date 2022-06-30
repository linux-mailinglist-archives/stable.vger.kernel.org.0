Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EDB456241A
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 22:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235603AbiF3UYy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 16:24:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232654AbiF3UYx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 16:24:53 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57E2944A0F
        for <stable@vger.kernel.org>; Thu, 30 Jun 2022 13:24:49 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id g4so418775pgc.1
        for <stable@vger.kernel.org>; Thu, 30 Jun 2022 13:24:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=sHvifXHhEmhRxN0k/4pAaQVDQp7BuYGExsY06amlsSQ=;
        b=jrjWUcceRFzueXLIbwgDGY/dLC3Z7EWhkzYvrKvcQds+Vea1DIfm4wKskOcPkBAedz
         gyvSVFoA13dt4kQTVCmLZBO6nHY+8D/XIau48U/jlpoB102Hv6EB/IcY6Wkw6td3rInx
         gJE5AAuoZGxjwvAXFXFNWirIiPIMaV8+CiY7CnO+FeUIaKCrmyN6Bkk8y3CRtgkRkvPD
         oxkVW7psAfCBPkS/GUdasPBlXXPmKTA33Sj2SQYdltlL/RlrugEe2VtUJNudXCBQcPX+
         hcF2PWUUrF+Y6F0hEA7bWObgNffEg2Cv7wx4cZ/bijTafSKovf0Z36+vZsJ/YUxP6poy
         AvBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=sHvifXHhEmhRxN0k/4pAaQVDQp7BuYGExsY06amlsSQ=;
        b=kMxXFMHLyli89iSceNGNWjdEnbJd0KuX66IPhjepvim6bqDzg7OIe/usNi10EXhwJ9
         2snjJJkEhpC0VVpytM3J7RxmehFSumIGcTDqUEXSv3v4zNMNo24wE+ChRrhyEqKDqlzc
         WpZ6oNktdT7hlb7nq0IEbz+22IPCuNVfM90Ceap3c+2lXxqMCpg8UkjKKumP4s0ZVnzI
         QNW3nVq7go1lI11Qbwks4f3J/qX9wS6W83yL1E6OMptiwd5seA/Rvp1dKRjmApIBGZmh
         P0s3XUORBnMwiUOEU27UEWY/gkW7rsremyqdXhxnNEzkmf59ePEsagzabozZ4xD2djeW
         bv/A==
X-Gm-Message-State: AJIora8m4Z/FGUpVAzHabSooABvDmBLzoe528VcK8RbH/NmMRNXvYxAp
        /nA1znLeWohOFBm6FjuKv6yDMEFUAgAzc+AT
X-Google-Smtp-Source: AGRyM1uCitEuDdXAjGyXEBxbxrDKF+aov40uWYiNgSvV7EYdFnFSszcixy1F/ykUX7cKrZRGDnKE+w==
X-Received: by 2002:a63:7a11:0:b0:40c:fbcb:2f12 with SMTP id v17-20020a637a11000000b0040cfbcb2f12mr8696373pgc.180.1656620688151;
        Thu, 30 Jun 2022 13:24:48 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h6-20020a170902680600b0015e8d4eb1f9sm13869319plk.67.2022.06.30.13.24.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 13:24:47 -0700 (PDT)
Message-ID: <62be068f.1c69fb81.9ac89.4438@mx.google.com>
Date:   Thu, 30 Jun 2022 13:24:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.320-30-g32e401239471
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y baseline: 121 runs,
 22 regressions (v4.9.320-30-g32e401239471)
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

stable-rc/linux-4.9.y baseline: 121 runs, 22 regressions (v4.9.320-30-g32e4=
01239471)

Regressions Summary
-------------------

platform                   | arch   | lab           | compiler | defconfig =
                 | regressions
---------------------------+--------+---------------+----------+-----------=
-----------------+------------
at91sam9g20ek              | arm    | lab-broonie   | gcc-10   | at91_dt_de=
fconfig          | 1          =

d2500cc                    | x86_64 | lab-clabbe    | gcc-10   | x86_64_def=
config           | 1          =

jetson-tk1                 | arm    | lab-baylibre  | gcc-10   | multi_v7_d=
efconfig         | 1          =

jetson-tk1                 | arm    | lab-baylibre  | gcc-10   | tegra_defc=
onfig            | 1          =

qemu_arm64-virt-gicv2      | arm64  | lab-baylibre  | gcc-10   | defconfig+=
arm64-chromebook | 1          =

qemu_arm64-virt-gicv2      | arm64  | lab-baylibre  | gcc-10   | defconfig =
                 | 1          =

qemu_arm64-virt-gicv2      | arm64  | lab-broonie   | gcc-10   | defconfig+=
arm64-chromebook | 1          =

qemu_arm64-virt-gicv2      | arm64  | lab-broonie   | gcc-10   | defconfig =
                 | 1          =

qemu_arm64-virt-gicv2-uefi | arm64  | lab-baylibre  | gcc-10   | defconfig+=
arm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64  | lab-baylibre  | gcc-10   | defconfig =
                 | 1          =

qemu_arm64-virt-gicv2-uefi | arm64  | lab-broonie   | gcc-10   | defconfig+=
arm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64  | lab-broonie   | gcc-10   | defconfig =
                 | 1          =

qemu_arm64-virt-gicv3      | arm64  | lab-baylibre  | gcc-10   | defconfig+=
arm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64  | lab-baylibre  | gcc-10   | defconfig =
                 | 1          =

qemu_arm64-virt-gicv3      | arm64  | lab-broonie   | gcc-10   | defconfig+=
arm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64  | lab-broonie   | gcc-10   | defconfig =
                 | 1          =

qemu_arm64-virt-gicv3-uefi | arm64  | lab-baylibre  | gcc-10   | defconfig+=
arm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64  | lab-baylibre  | gcc-10   | defconfig =
                 | 1          =

qemu_arm64-virt-gicv3-uefi | arm64  | lab-broonie   | gcc-10   | defconfig+=
arm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64  | lab-broonie   | gcc-10   | defconfig =
                 | 1          =

tegra124-nyan-big          | arm    | lab-collabora | gcc-10   | multi_v7_d=
efconfig         | 1          =

tegra124-nyan-big          | arm    | lab-collabora | gcc-10   | tegra_defc=
onfig            | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.320-30-g32e401239471/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.320-30-g32e401239471
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      32e4012394718d2eabab7e19b3c5787f5d3cd368 =



Test Regressions
---------------- =



platform                   | arch   | lab           | compiler | defconfig =
                 | regressions
---------------------------+--------+---------------+----------+-----------=
-----------------+------------
at91sam9g20ek              | arm    | lab-broonie   | gcc-10   | at91_dt_de=
fconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/62bdd2ec250c040c86a39c07

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: at91_dt_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.320=
-30-g32e401239471/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam=
9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.320=
-30-g32e401239471/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam=
9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62bdd2ec250c040c86a39=
c08
        failing since 10 days (last pass: v4.9.319, first fail: v4.9.319-25=
1-g5de156af25f62) =

 =



platform                   | arch   | lab           | compiler | defconfig =
                 | regressions
---------------------------+--------+---------------+----------+-----------=
-----------------+------------
d2500cc                    | x86_64 | lab-clabbe    | gcc-10   | x86_64_def=
config           | 1          =


  Details:     https://kernelci.org/test/plan/id/62bdd3ff0edf2a8c74a39bec

  Results:     3 PASS, 2 FAIL, 2 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.320=
-30-g32e401239471/x86_64/x86_64_defconfig/gcc-10/lab-clabbe/baseline-d2500c=
c.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.320=
-30-g32e401239471/x86_64/x86_64_defconfig/gcc-10/lab-clabbe/baseline-d2500c=
c.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/x86/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/62bdd3ff0edf2a8=
c74a39bf1
        new failure (last pass: v4.9.319-265-g00d9858d20e4)
        1 lines

    2022-06-30T16:48:50.445051  kern  :emerg : do_IRQ: 0.236 No irq handler=
 for vector
    2022-06-30T16:48:50.456659  [    7.993314] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>
    2022-06-30T16:48:50.457092  + set +x   =

 =



platform                   | arch   | lab           | compiler | defconfig =
                 | regressions
---------------------------+--------+---------------+----------+-----------=
-----------------+------------
jetson-tk1                 | arm    | lab-baylibre  | gcc-10   | multi_v7_d=
efconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62bddf3b3e3ea5e7dca39bce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.320=
-30-g32e401239471/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetso=
n-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.320=
-30-g32e401239471/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetso=
n-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62bddf3b3e3ea5e7dca39=
bcf
        failing since 37 days (last pass: v4.9.314-19-g42670125a2b8, first =
fail: v4.9.315-26-gbe4ec3e3faa1c) =

 =



platform                   | arch   | lab           | compiler | defconfig =
                 | regressions
---------------------------+--------+---------------+----------+-----------=
-----------------+------------
jetson-tk1                 | arm    | lab-baylibre  | gcc-10   | tegra_defc=
onfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/62bde1f8a6e238d857a39bf2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.320=
-30-g32e401239471/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-t=
k1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.320=
-30-g32e401239471/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-t=
k1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62bde1f8a6e238d857a39=
bf3
        failing since 37 days (last pass: v4.9.314, first fail: v4.9.315-26=
-gbe4ec3e3faa1c) =

 =



platform                   | arch   | lab           | compiler | defconfig =
                 | regressions
---------------------------+--------+---------------+----------+-----------=
-----------------+------------
qemu_arm64-virt-gicv2      | arm64  | lab-baylibre  | gcc-10   | defconfig+=
arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62bdd396b1d863d9fda39bdf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.320=
-30-g32e401239471/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.320=
-30-g32e401239471/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62bdd396b1d863d9fda39=
be0
        failing since 51 days (last pass: v4.9.312-36-gbfd3fd9fa677, first =
fail: v4.9.312-60-g806e59090c6c) =

 =



platform                   | arch   | lab           | compiler | defconfig =
                 | regressions
---------------------------+--------+---------------+----------+-----------=
-----------------+------------
qemu_arm64-virt-gicv2      | arm64  | lab-baylibre  | gcc-10   | defconfig =
                 | 1          =


  Details:     https://kernelci.org/test/plan/id/62bdd45f3be76433a0a39bda

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.320=
-30-g32e401239471/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.320=
-30-g32e401239471/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62bdd45f3be76433a0a39=
bdb
        failing since 51 days (last pass: v4.9.312-44-g77a374c13dc5, first =
fail: v4.9.312-60-g806e59090c6c) =

 =



platform                   | arch   | lab           | compiler | defconfig =
                 | regressions
---------------------------+--------+---------------+----------+-----------=
-----------------+------------
qemu_arm64-virt-gicv2      | arm64  | lab-broonie   | gcc-10   | defconfig+=
arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62bdd3a9b14e0ccd82a39bef

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.320=
-30-g32e401239471/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.320=
-30-g32e401239471/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62bdd3a9b14e0ccd82a39=
bf0
        failing since 51 days (last pass: v4.9.312-36-gbfd3fd9fa677, first =
fail: v4.9.312-60-g806e59090c6c) =

 =



platform                   | arch   | lab           | compiler | defconfig =
                 | regressions
---------------------------+--------+---------------+----------+-----------=
-----------------+------------
qemu_arm64-virt-gicv2      | arm64  | lab-broonie   | gcc-10   | defconfig =
                 | 1          =


  Details:     https://kernelci.org/test/plan/id/62bdd511de4f63d452a39bdd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.320=
-30-g32e401239471/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.320=
-30-g32e401239471/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62bdd511de4f63d452a39=
bde
        failing since 51 days (last pass: v4.9.312-44-g77a374c13dc5, first =
fail: v4.9.312-60-g806e59090c6c) =

 =



platform                   | arch   | lab           | compiler | defconfig =
                 | regressions
---------------------------+--------+---------------+----------+-----------=
-----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64  | lab-baylibre  | gcc-10   | defconfig+=
arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62bdd399b14e0ccd82a39bce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.320=
-30-g32e401239471/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.320=
-30-g32e401239471/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62bdd399b14e0ccd82a39=
bcf
        failing since 51 days (last pass: v4.9.312-36-gbfd3fd9fa677, first =
fail: v4.9.312-60-g806e59090c6c) =

 =



platform                   | arch   | lab           | compiler | defconfig =
                 | regressions
---------------------------+--------+---------------+----------+-----------=
-----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64  | lab-baylibre  | gcc-10   | defconfig =
                 | 1          =


  Details:     https://kernelci.org/test/plan/id/62bdd4ffc90ba35e74a39c3f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.320=
-30-g32e401239471/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.320=
-30-g32e401239471/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62bdd4ffc90ba35e74a39=
c40
        failing since 51 days (last pass: v4.9.312-44-g77a374c13dc5, first =
fail: v4.9.312-60-g806e59090c6c) =

 =



platform                   | arch   | lab           | compiler | defconfig =
                 | regressions
---------------------------+--------+---------------+----------+-----------=
-----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64  | lab-broonie   | gcc-10   | defconfig+=
arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62bdd3adb14e0ccd82a39c03

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.320=
-30-g32e401239471/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.320=
-30-g32e401239471/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62bdd3adb14e0ccd82a39=
c04
        failing since 51 days (last pass: v4.9.312-36-gbfd3fd9fa677, first =
fail: v4.9.312-60-g806e59090c6c) =

 =



platform                   | arch   | lab           | compiler | defconfig =
                 | regressions
---------------------------+--------+---------------+----------+-----------=
-----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64  | lab-broonie   | gcc-10   | defconfig =
                 | 1          =


  Details:     https://kernelci.org/test/plan/id/62bdd527de4f63d452a39c01

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.320=
-30-g32e401239471/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.320=
-30-g32e401239471/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62bdd527de4f63d452a39=
c02
        failing since 51 days (last pass: v4.9.312-44-g77a374c13dc5, first =
fail: v4.9.312-60-g806e59090c6c) =

 =



platform                   | arch   | lab           | compiler | defconfig =
                 | regressions
---------------------------+--------+---------------+----------+-----------=
-----------------+------------
qemu_arm64-virt-gicv3      | arm64  | lab-baylibre  | gcc-10   | defconfig+=
arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62bdd397223b66936ba39c00

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.320=
-30-g32e401239471/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.320=
-30-g32e401239471/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62bdd397223b66936ba39=
c01
        failing since 51 days (last pass: v4.9.312-36-gbfd3fd9fa677, first =
fail: v4.9.312-60-g806e59090c6c) =

 =



platform                   | arch   | lab           | compiler | defconfig =
                 | regressions
---------------------------+--------+---------------+----------+-----------=
-----------------+------------
qemu_arm64-virt-gicv3      | arm64  | lab-baylibre  | gcc-10   | defconfig =
                 | 1          =


  Details:     https://kernelci.org/test/plan/id/62bdd4c2767372d635a39bf7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.320=
-30-g32e401239471/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.320=
-30-g32e401239471/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62bdd4c2767372d635a39=
bf8
        failing since 51 days (last pass: v4.9.312-44-g77a374c13dc5, first =
fail: v4.9.312-60-g806e59090c6c) =

 =



platform                   | arch   | lab           | compiler | defconfig =
                 | regressions
---------------------------+--------+---------------+----------+-----------=
-----------------+------------
qemu_arm64-virt-gicv3      | arm64  | lab-broonie   | gcc-10   | defconfig+=
arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62bdd395223b66936ba39bfa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.320=
-30-g32e401239471/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.320=
-30-g32e401239471/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62bdd395223b66936ba39=
bfb
        failing since 51 days (last pass: v4.9.312-36-gbfd3fd9fa677, first =
fail: v4.9.312-60-g806e59090c6c) =

 =



platform                   | arch   | lab           | compiler | defconfig =
                 | regressions
---------------------------+--------+---------------+----------+-----------=
-----------------+------------
qemu_arm64-virt-gicv3      | arm64  | lab-broonie   | gcc-10   | defconfig =
                 | 1          =


  Details:     https://kernelci.org/test/plan/id/62bdd525de4f63d452a39bfe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.320=
-30-g32e401239471/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.320=
-30-g32e401239471/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62bdd525de4f63d452a39=
bff
        failing since 51 days (last pass: v4.9.312-44-g77a374c13dc5, first =
fail: v4.9.312-60-g806e59090c6c) =

 =



platform                   | arch   | lab           | compiler | defconfig =
                 | regressions
---------------------------+--------+---------------+----------+-----------=
-----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64  | lab-baylibre  | gcc-10   | defconfig+=
arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62bdd398b1d863d9fda39be5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.320=
-30-g32e401239471/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.320=
-30-g32e401239471/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62bdd398b1d863d9fda39=
be6
        failing since 51 days (last pass: v4.9.312-36-gbfd3fd9fa677, first =
fail: v4.9.312-60-g806e59090c6c) =

 =



platform                   | arch   | lab           | compiler | defconfig =
                 | regressions
---------------------------+--------+---------------+----------+-----------=
-----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64  | lab-baylibre  | gcc-10   | defconfig =
                 | 1          =


  Details:     https://kernelci.org/test/plan/id/62bdd527de4f63d452a39c04

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.320=
-30-g32e401239471/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.320=
-30-g32e401239471/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62bdd527de4f63d452a39=
c05
        failing since 51 days (last pass: v4.9.312-44-g77a374c13dc5, first =
fail: v4.9.312-60-g806e59090c6c) =

 =



platform                   | arch   | lab           | compiler | defconfig =
                 | regressions
---------------------------+--------+---------------+----------+-----------=
-----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64  | lab-broonie   | gcc-10   | defconfig+=
arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62bdd3abb14e0ccd82a39bf5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.320=
-30-g32e401239471/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.320=
-30-g32e401239471/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62bdd3abb14e0ccd82a39=
bf6
        failing since 51 days (last pass: v4.9.312-36-gbfd3fd9fa677, first =
fail: v4.9.312-60-g806e59090c6c) =

 =



platform                   | arch   | lab           | compiler | defconfig =
                 | regressions
---------------------------+--------+---------------+----------+-----------=
-----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64  | lab-broonie   | gcc-10   | defconfig =
                 | 1          =


  Details:     https://kernelci.org/test/plan/id/62bdd528de4f63d452a39c07

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.320=
-30-g32e401239471/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.320=
-30-g32e401239471/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62bdd528de4f63d452a39=
c08
        failing since 51 days (last pass: v4.9.312-44-g77a374c13dc5, first =
fail: v4.9.312-60-g806e59090c6c) =

 =



platform                   | arch   | lab           | compiler | defconfig =
                 | regressions
---------------------------+--------+---------------+----------+-----------=
-----------------+------------
tegra124-nyan-big          | arm    | lab-collabora | gcc-10   | multi_v7_d=
efconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62bde048560974e61ca39bda

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.320=
-30-g32e401239471/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-tegr=
a124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.320=
-30-g32e401239471/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-tegr=
a124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62bde048560974e61ca39=
bdb
        failing since 37 days (last pass: v4.9.315, first fail: v4.9.315-26=
-gbe4ec3e3faa1c) =

 =



platform                   | arch   | lab           | compiler | defconfig =
                 | regressions
---------------------------+--------+---------------+----------+-----------=
-----------------+------------
tegra124-nyan-big          | arm    | lab-collabora | gcc-10   | tegra_defc=
onfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/62bde2f6aceb4ac3a4a39bec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.320=
-30-g32e401239471/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra12=
4-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.320=
-30-g32e401239471/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra12=
4-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62bde2f6aceb4ac3a4a39=
bed
        failing since 37 days (last pass: v4.9.315, first fail: v4.9.315-26=
-gbe4ec3e3faa1c) =

 =20
