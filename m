Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BDCF567413
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 18:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232838AbiGEQUU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 12:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232713AbiGEQUT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 12:20:19 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DD951D0E7
        for <stable@vger.kernel.org>; Tue,  5 Jul 2022 09:20:17 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id o5-20020a17090a3d4500b001ef76490983so8564644pjf.2
        for <stable@vger.kernel.org>; Tue, 05 Jul 2022 09:20:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=EPFCTYzmxd/gJ673HWGZxnunFYGizK/u9JT/K1pG270=;
        b=25sY/wU6Rd0aVD8OER81PwsrLNJCH7R3Ff1Rh9b95ajSS819pd+/BULmSJwUcIvu+r
         wuyZIqM0NSZ9Mrg9/xuRaGb7u+1wS9oQy5mAQ28ufCYNSxu8au2CILQ8+3JhBLyE7NAE
         rpW3Iz09Mrh2ez4p/sLJ6D8pha7tDKzLp+KBpm5mwonw8sW+RqOhjQDekJ59iHmfcZyN
         6eqIeEJr9DxfBjOOhk01qA/aIW4VHLUcFlKO6P+IdtdYG3hC1MQLSeg1z1hTWDuBO+3J
         VqTCTf9QDy+QXG+3qzM2s6ntOEshzvwXhL9zV4CIofJ0uvR9UDmi64P7QsrhNl9UlU2v
         LLEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=EPFCTYzmxd/gJ673HWGZxnunFYGizK/u9JT/K1pG270=;
        b=2ddfr0kkTtsbXzOBniDVL1hHR4nbNnHAGFb5CIs6ij6O+CRyQBW+u+EF6/76zRWeBl
         HJa3qT2I/ER0AX3UbgImuPt9psw6Mz8tQeqS0yBP7yFT2/ZpXQCet1YBw36W/ft3Vey5
         4bFwuZ5eg+iBOhoqBbLLdrgetJZCfPRaC6fZ5hfCTzHQUePOwkoGgb80ADBVP4NjaSUu
         gPtHVZjsPlLFDY+x5dd0LE3UaQi73q4K6hhu8I+aNeCX2Cnn6j+6f2Rr+7p2ah4CzgaX
         hHnVxOq5F1ydkBWqeR/uKUaO0U91z9j8ooa8sh02xh+emgwJuuroLqtvklzrx5Ldd1L2
         u8rg==
X-Gm-Message-State: AJIora+kNQnB3pp/PUprXzcsS+TdrgQjmfbdD1wcm8ARIZeTwVxWwK4h
        cYUzyHuc8mzaAm/g0aUAIms14hqvSisCk+Cg
X-Google-Smtp-Source: AGRyM1uwsgWcca5nwik8QdM9y0yE8EdBEDBVuyKu/2YY57X2+Nq0gwJpuQPwdnRneEC6qc0jU1HC8Q==
X-Received: by 2002:a17:902:cccf:b0:168:c4c3:e8ca with SMTP id z15-20020a170902cccf00b00168c4c3e8camr44155376ple.40.1657038016728;
        Tue, 05 Jul 2022 09:20:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s14-20020a17090302ce00b001678a65d75bsm23614442plk.81.2022.07.05.09.20.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 09:20:16 -0700 (PDT)
Message-ID: <62c464c0.1c69fb81.41786.1eb9@mx.google.com>
Date:   Tue, 05 Jul 2022 09:20:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.203-50-g45a66af36ff8
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 126 runs,
 10 regressions (v5.4.203-50-g45a66af36ff8)
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

stable-rc/queue/5.4 baseline: 126 runs, 10 regressions (v5.4.203-50-g45a66a=
f36ff8)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig  =
     | regressions
---------------------------+-------+---------------+----------+------------=
-----+------------
jetson-tk1                 | arm   | lab-baylibre  | gcc-10   | tegra_defco=
nfig | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-baylibre  | gcc-10   | defconfig  =
     | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig  =
     | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig  =
     | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig  =
     | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-baylibre  | gcc-10   | defconfig  =
     | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig  =
     | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig  =
     | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig  =
     | 1          =

tegra124-nyan-big          | arm   | lab-collabora | gcc-10   | tegra_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.203-50-g45a66af36ff8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.203-50-g45a66af36ff8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      45a66af36ff85a40a30dcc238ae6404b9f8ddc9a =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig  =
     | regressions
---------------------------+-------+---------------+----------+------------=
-----+------------
jetson-tk1                 | arm   | lab-baylibre  | gcc-10   | tegra_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62c43c660509a24560a39bce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.203-5=
0-g45a66af36ff8/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.203-5=
0-g45a66af36ff8/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c43c660509a24560a39=
bcf
        failing since 18 days (last pass: v5.4.198-15-g2ff259ec549cc, first=
 fail: v5.4.199-3-gfa1633c6dfd3a) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
     | regressions
---------------------------+-------+---------------+----------+------------=
-----+------------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre  | gcc-10   | defconfig  =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/62c43448220c7fa4f8a39bde

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.203-5=
0-g45a66af36ff8/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.203-5=
0-g45a66af36ff8/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c43448220c7fa4f8a39=
bdf
        failing since 56 days (last pass: v5.4.191-77-g1a3b249e415b, first =
fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
     | regressions
---------------------------+-------+---------------+----------+------------=
-----+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig  =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/62c4351f7ac21cf48ba39bf9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.203-5=
0-g45a66af36ff8/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.203-5=
0-g45a66af36ff8/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c4351f7ac21cf48ba39=
bfa
        failing since 56 days (last pass: v5.4.191-77-g1a3b249e415b, first =
fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
     | regressions
---------------------------+-------+---------------+----------+------------=
-----+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig  =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/62c43471c0e0ad8b37a39be4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.203-5=
0-g45a66af36ff8/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.203-5=
0-g45a66af36ff8/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c43471c0e0ad8b37a39=
be5
        failing since 56 days (last pass: v5.4.191-77-g1a3b249e415b, first =
fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
     | regressions
---------------------------+-------+---------------+----------+------------=
-----+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig  =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/62c435ad22c66db07da39bd4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.203-5=
0-g45a66af36ff8/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.203-5=
0-g45a66af36ff8/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c435ad22c66db07da39=
bd5
        failing since 56 days (last pass: v5.4.191-77-g1a3b249e415b, first =
fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
     | regressions
---------------------------+-------+---------------+----------+------------=
-----+------------
qemu_arm64-virt-gicv3      | arm64 | lab-baylibre  | gcc-10   | defconfig  =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/62c4344a8ca1d620b2a39bd1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.203-5=
0-g45a66af36ff8/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.203-5=
0-g45a66af36ff8/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c4344a8ca1d620b2a39=
bd2
        failing since 56 days (last pass: v5.4.191-77-g1a3b249e415b, first =
fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
     | regressions
---------------------------+-------+---------------+----------+------------=
-----+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig  =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/62c435abbeb42bc430a39bcd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.203-5=
0-g45a66af36ff8/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.203-5=
0-g45a66af36ff8/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c435abbeb42bc430a39=
bce
        failing since 56 days (last pass: v5.4.191-77-g1a3b249e415b, first =
fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
     | regressions
---------------------------+-------+---------------+----------+------------=
-----+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig  =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/62c4346fdde38ce29ca39c12

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.203-5=
0-g45a66af36ff8/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.203-5=
0-g45a66af36ff8/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c4346fdde38ce29ca39=
c13
        failing since 56 days (last pass: v5.4.191-77-g1a3b249e415b, first =
fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
     | regressions
---------------------------+-------+---------------+----------+------------=
-----+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig  =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/62c435ac22c66db07da39bd1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.203-5=
0-g45a66af36ff8/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.203-5=
0-g45a66af36ff8/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c435ac22c66db07da39=
bd2
        failing since 56 days (last pass: v5.4.191-77-g1a3b249e415b, first =
fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
     | regressions
---------------------------+-------+---------------+----------+------------=
-----+------------
tegra124-nyan-big          | arm   | lab-collabora | gcc-10   | tegra_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62c43dbe02a70d273da39beb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.203-5=
0-g45a66af36ff8/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra124-=
nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.203-5=
0-g45a66af36ff8/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra124-=
nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c43dbe02a70d273da39=
bec
        failing since 4 days (last pass: v5.4.202-4-g48eb52a32146, first fa=
il: v5.4.202-16-gbb26d01fe2e3) =

 =20
