Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0000C568DC7
	for <lists+stable@lfdr.de>; Wed,  6 Jul 2022 17:44:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234376AbiGFPfy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jul 2022 11:35:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234315AbiGFPfP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jul 2022 11:35:15 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFBB02A718
        for <stable@vger.kernel.org>; Wed,  6 Jul 2022 08:33:17 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id r22so7390447pgr.2
        for <stable@vger.kernel.org>; Wed, 06 Jul 2022 08:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=p127qaOJz8amw9SxrXtgrjo3q8Bk9rFS+crm8ip5uzQ=;
        b=FdkcvjFBT+MxzxqvysKKoxQb2c9d47Dq1m1CbBENVahxtWSESZlrlhMQVtvzqendOE
         vAQjmNUlJXsFN2D4E4gEygTLiBKrYQRUDpMTzGHIcLzEkARS0TFY71A3iSW7M8bFqmMa
         0ZJfgbQ1eydotfP0Y08VIB3lXbimqJrLGST1Pr21peVfJlOm7uaRBnopkjJgs7E8UpfF
         yCRc+UQKCgp/Kx4t6+kCexPXoOKLhUFD9jYrTd5BsAxMO0BvpU2+EQ5PVeLghN3yoRh3
         Sf7Ghm0pvmFdwiKWgY5NgH/JJpwnz1U+rtQaItG8BiXuRKsSz3dUk101lVk75Mm4kvbD
         0I3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=p127qaOJz8amw9SxrXtgrjo3q8Bk9rFS+crm8ip5uzQ=;
        b=S9h8W9AXaZUlsp3xtKxRX0rNyuNIAQVWg6219KLWrJ/C1Lt9NJcxEnBznnNDKK0wAf
         dNbgyxUZfEx49mAPD8L6nNQAUYo+Es3TEmC2h3ZQ4UmVHGYeQtAXzZCuywohLXE8/QhZ
         HL8wPCJYLYl6jE3SWdahWu+hD7q6HfCN3he14gRvsgP6GDvaAICvP66845hFfQuN+SWT
         AaDodxJZ+BzeHDrTrs3Mqw0rzBdvaAyTz0G7+F4ygcWBOEkJXN4XRe4U9OuZqPNF7Poo
         S3wRF6XEW1EtbQTMKG94nP2Lwdbo8DWPe2qzkZa8ZqbF3vjcrCQkm023k2pqE/sdJ1zd
         s20g==
X-Gm-Message-State: AJIora9OKwpi0XdenKWTNNyR/qlSbfZ7dgLgkYzJNFzXNPP/EHYSWxC9
        42j2Ym+ci1le/Wc+JfXJ5yXW+DN4DdhNQFVN
X-Google-Smtp-Source: AGRyM1sShbunFjyhhyyLTkvlZxlYxz5QDtmJjYqP+RyImX7VXcyChDOjBjx38y5V6RtCf8Vc0AOH+g==
X-Received: by 2002:a05:6a00:c84:b0:528:3c39:f42d with SMTP id a4-20020a056a000c8400b005283c39f42dmr28474960pfv.76.1657121596481;
        Wed, 06 Jul 2022 08:33:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h29-20020a056a00001d00b0051bb61c0eacsm3816730pfk.20.2022.07.06.08.33.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 08:33:16 -0700 (PDT)
Message-ID: <62c5ab3c.1c69fb81.11d31.5d0f@mx.google.com>
Date:   Wed, 06 Jul 2022 08:33:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.321-30-gaf28a1763ea8
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y baseline: 95 runs,
 13 regressions (v4.9.321-30-gaf28a1763ea8)
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

stable-rc/linux-4.9.y baseline: 95 runs, 13 regressions (v4.9.321-30-gaf28a=
1763ea8)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig  =
        | regressions
---------------------------+-------+---------------+----------+------------=
--------+------------
jetson-tk1                 | arm   | lab-baylibre  | gcc-10   | multi_v7_de=
fconfig | 1          =

jetson-tk1                 | arm   | lab-baylibre  | gcc-10   | tegra_defco=
nfig    | 1          =

meson-gxbb-p200            | arm64 | lab-baylibre  | gcc-10   | defconfig  =
        | 1          =

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

tegra124-nyan-big          | arm   | lab-collabora | gcc-10   | multi_v7_de=
fconfig | 1          =

tegra124-nyan-big          | arm   | lab-collabora | gcc-10   | tegra_defco=
nfig    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.321-30-gaf28a1763ea8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.321-30-gaf28a1763ea8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      af28a1763ea89ae07f1fdbcc0b07489a876718c1 =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig  =
        | regressions
---------------------------+-------+---------------+----------+------------=
--------+------------
jetson-tk1                 | arm   | lab-baylibre  | gcc-10   | multi_v7_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62c4523adff69662e0a39bcd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.321=
-30-gaf28a1763ea8/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetso=
n-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.321=
-30-gaf28a1763ea8/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetso=
n-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c4523adff69662e0a39=
bce
        failing since 42 days (last pass: v4.9.314-19-g42670125a2b8, first =
fail: v4.9.315-26-gbe4ec3e3faa1c) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
        | regressions
---------------------------+-------+---------------+----------+------------=
--------+------------
jetson-tk1                 | arm   | lab-baylibre  | gcc-10   | tegra_defco=
nfig    | 1          =


  Details:     https://kernelci.org/test/plan/id/62c44e035983d57dd0a39bd4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.321=
-30-gaf28a1763ea8/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-t=
k1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.321=
-30-gaf28a1763ea8/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-t=
k1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c44e035983d57dd0a39=
bd5
        failing since 42 days (last pass: v4.9.314, first fail: v4.9.315-26=
-gbe4ec3e3faa1c) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
        | regressions
---------------------------+-------+---------------+----------+------------=
--------+------------
meson-gxbb-p200            | arm64 | lab-baylibre  | gcc-10   | defconfig  =
        | 1          =


  Details:     https://kernelci.org/test/plan/id/62c43b96f8e5fbc2d0a39be6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.321=
-30-gaf28a1763ea8/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p=
200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.321=
-30-gaf28a1763ea8/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p=
200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c43b96f8e5fbc2d0a39=
be7
        new failure (last pass: v4.9.320-30-g32e401239471) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
        | regressions
---------------------------+-------+---------------+----------+------------=
--------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre  | gcc-10   | defconfig  =
        | 1          =


  Details:     https://kernelci.org/test/plan/id/62c43ac03915c28a04a39bd0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.321=
-30-gaf28a1763ea8/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.321=
-30-gaf28a1763ea8/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c43ac03915c28a04a39=
bd1
        failing since 56 days (last pass: v4.9.312-44-g77a374c13dc5, first =
fail: v4.9.312-60-g806e59090c6c) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
        | regressions
---------------------------+-------+---------------+----------+------------=
--------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig  =
        | 1          =


  Details:     https://kernelci.org/test/plan/id/62c43f998613214a15a39bdb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.321=
-30-gaf28a1763ea8/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.321=
-30-gaf28a1763ea8/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c43f998613214a15a39=
bdc
        failing since 56 days (last pass: v4.9.312-44-g77a374c13dc5, first =
fail: v4.9.312-60-g806e59090c6c) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
        | regressions
---------------------------+-------+---------------+----------+------------=
--------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig  =
        | 1          =


  Details:     https://kernelci.org/test/plan/id/62c43ae6fba09b11c1a39bf6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.321=
-30-gaf28a1763ea8/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.321=
-30-gaf28a1763ea8/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c43ae6fba09b11c1a39=
bf7
        failing since 56 days (last pass: v4.9.312-44-g77a374c13dc5, first =
fail: v4.9.312-60-g806e59090c6c) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
        | regressions
---------------------------+-------+---------------+----------+------------=
--------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig  =
        | 1          =


  Details:     https://kernelci.org/test/plan/id/62c43e6d8fbe2ae4c8a39c43

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.321=
-30-gaf28a1763ea8/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.321=
-30-gaf28a1763ea8/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c43e6d8fbe2ae4c8a39=
c44
        failing since 56 days (last pass: v4.9.312-44-g77a374c13dc5, first =
fail: v4.9.312-60-g806e59090c6c) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
        | regressions
---------------------------+-------+---------------+----------+------------=
--------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-baylibre  | gcc-10   | defconfig  =
        | 1          =


  Details:     https://kernelci.org/test/plan/id/62c43b0ea247616d00a39bf5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.321=
-30-gaf28a1763ea8/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.321=
-30-gaf28a1763ea8/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c43b0ea247616d00a39=
bf6
        failing since 56 days (last pass: v4.9.312-44-g77a374c13dc5, first =
fail: v4.9.312-60-g806e59090c6c) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
        | regressions
---------------------------+-------+---------------+----------+------------=
--------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig  =
        | 1          =


  Details:     https://kernelci.org/test/plan/id/62c43fae53435cc593a39c30

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.321=
-30-gaf28a1763ea8/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.321=
-30-gaf28a1763ea8/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c43fae53435cc593a39=
c31
        failing since 56 days (last pass: v4.9.312-44-g77a374c13dc5, first =
fail: v4.9.312-60-g806e59090c6c) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
        | regressions
---------------------------+-------+---------------+----------+------------=
--------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig  =
        | 1          =


  Details:     https://kernelci.org/test/plan/id/62c43ac2751448f499a39bdc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.321=
-30-gaf28a1763ea8/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.321=
-30-gaf28a1763ea8/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c43ac2751448f499a39=
bdd
        failing since 56 days (last pass: v4.9.312-44-g77a374c13dc5, first =
fail: v4.9.312-60-g806e59090c6c) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
        | regressions
---------------------------+-------+---------------+----------+------------=
--------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig  =
        | 1          =


  Details:     https://kernelci.org/test/plan/id/62c43faddfc3fbced6a39bcf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.321=
-30-gaf28a1763ea8/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.321=
-30-gaf28a1763ea8/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c43faddfc3fbced6a39=
bd0
        failing since 56 days (last pass: v4.9.312-44-g77a374c13dc5, first =
fail: v4.9.312-60-g806e59090c6c) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
        | regressions
---------------------------+-------+---------------+----------+------------=
--------+------------
tegra124-nyan-big          | arm   | lab-collabora | gcc-10   | multi_v7_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62c45860a37cd377b1a39bd6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.321=
-30-gaf28a1763ea8/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-tegr=
a124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.321=
-30-gaf28a1763ea8/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-tegr=
a124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c45860a37cd377b1a39=
bd7
        failing since 42 days (last pass: v4.9.315, first fail: v4.9.315-26=
-gbe4ec3e3faa1c) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
        | regressions
---------------------------+-------+---------------+----------+------------=
--------+------------
tegra124-nyan-big          | arm   | lab-collabora | gcc-10   | tegra_defco=
nfig    | 1          =


  Details:     https://kernelci.org/test/plan/id/62c456fd553358fb5ea39c04

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.321=
-30-gaf28a1763ea8/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra12=
4-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.321=
-30-gaf28a1763ea8/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra12=
4-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c456fd553358fb5ea39=
c05
        failing since 42 days (last pass: v4.9.315, first fail: v4.9.315-26=
-gbe4ec3e3faa1c) =

 =20
