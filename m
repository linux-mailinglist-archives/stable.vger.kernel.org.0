Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 373EC5F329F
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 17:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbiJCPge (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 11:36:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230244AbiJCPgK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 11:36:10 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 228DC2CDC9
        for <stable@vger.kernel.org>; Mon,  3 Oct 2022 08:35:44 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id c3so5637610pfb.12
        for <stable@vger.kernel.org>; Mon, 03 Oct 2022 08:35:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=MCt33wkzC2XMpDOxmyddMrzh3cFFwpxdguaScy/zV8w=;
        b=l+/YpEggdK/EfA3HIuMD8t30jSrpist15iDTg7DFkiMk+7ggypBQjMrQRo+0P1afIR
         LX4sQLoV4MopsqbQKnKY021gIGgG0Jqt5poeG+JG0wL65F/oOShzNUiOQWyNHDx+vfC6
         1n/58J3FTCaUXjMH79DkLKZcoZ3PWTKrGW7qUw6Mus1W4h70c9zt6YtQd+rf/nuV7ba6
         U6PN9EZ7JKT0MIiia/b5iJ059Zw+OCLiScw8LJAux97AwupjM8M2OXUlsfQmzQDivrYV
         g2nhHwBki1ZOSIAoHPNreCxp0tJ73/3dxPps65G2IDVNW33gONucRi1V3H8V0UPNgWO1
         CBxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=MCt33wkzC2XMpDOxmyddMrzh3cFFwpxdguaScy/zV8w=;
        b=gzoGPhUJB++czryzcpXEdMKj7aeSGmG+plq9A06NcAaBJfDGa/i25Dj9X9g0XxulS4
         pD3/YhidLaZgKE7oZ9F1iHznUhs227h9M4vYTjK4jV7NvlOIDfiMf12uFTPmtJuarvhD
         +UU88/vw7YJ6m4tDJd1GiQ4C98NJdXoSZgq+tZbbGycFyW1a2F5iI3NncnZjl9oaFZ08
         r44F8J/uk/JpMnfmZnNsB9yrAaFbmUuTyDOof9y63gNyqk7uCFpWjSMCOk51dVckPmn1
         2oE3RA40fI9ttzv6nlPXEKna+nSxKkFlTsMp5iBJK1FFrMJUF1nsfKtG4Lj68cfcIzLP
         neJg==
X-Gm-Message-State: ACrzQf1s1lWceAb1ZtYTKzt41eCq3gPiblWtQJuXS44fYvuVqOjMFY83
        1wqEXngK6fc7JMbRlbK/tErpEJAnWgNGsuAgL00=
X-Google-Smtp-Source: AMsMyM6mspTUZO7PLGJHw6r+o88+8jG4XznGErUYxLlAE9aYi8jX19UeCbRlfkkMiX7WnojoWuiN9g==
X-Received: by 2002:aa7:864a:0:b0:53f:dcdf:4614 with SMTP id a10-20020aa7864a000000b0053fdcdf4614mr23149727pfo.38.1664811342893;
        Mon, 03 Oct 2022 08:35:42 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b187-20020a62cfc4000000b0056125cf1465sm3411860pfg.13.2022.10.03.08.35.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Oct 2022 08:35:42 -0700 (PDT)
Message-ID: <633b014e.620a0220.4ed82.5692@mx.google.com>
Date:   Mon, 03 Oct 2022 08:35:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.146-53-g9d377edf70b6
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 142 runs,
 8 regressions (v5.10.146-53-g9d377edf70b6)
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

stable-rc/linux-5.10.y baseline: 142 runs, 8 regressions (v5.10.146-53-g9d3=
77edf70b6)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
panda                      | arm   | lab-baylibre  | gcc-10   | multi_v7_de=
fconfig  | 1          =

panda                      | arm   | lab-baylibre  | gcc-10   | omap2plus_d=
efconfig | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig  =
         | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig  =
         | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig  =
         | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig  =
         | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig  =
         | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig  =
         | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.146-53-g9d377edf70b6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.146-53-g9d377edf70b6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9d377edf70b6af4c3d7f6ebe67b0216146c0d752 =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
panda                      | arm   | lab-baylibre  | gcc-10   | multi_v7_de=
fconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/633acd9cffe7456c38ec4eb4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
46-53-g9d377edf70b6/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
46-53-g9d377edf70b6/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633acd9cffe7456c38ec4=
eb5
        failing since 34 days (last pass: v5.10.136, first fail: v5.10.138-=
89-g10c6bbc07890) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
panda                      | arm   | lab-baylibre  | gcc-10   | omap2plus_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/633ad1359dc3fa6511ec4ec6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
46-53-g9d377edf70b6/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
46-53-g9d377edf70b6/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633ad1359dc3fa6511ec4=
ec7
        failing since 34 days (last pass: v5.10.137, first fail: v5.10.138-=
89-g10c6bbc07890) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/633ae7018c2bfe1522cab5f2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
46-53-g9d377edf70b6/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
46-53-g9d377edf70b6/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633ae7018c2bfe1522cab=
5f3
        failing since 146 days (last pass: v5.10.113-130-g0412f4bd3360, fir=
st fail: v5.10.113-187-g3dca4fac0d16) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/633ae5af447bda4044cab6b5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
46-53-g9d377edf70b6/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
46-53-g9d377edf70b6/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633ae5af447bda4044cab=
6b6
        failing since 46 days (last pass: v5.10.101-87-g1f48487c6f05, first=
 fail: v5.10.136) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/633ad0d49dc3fa6511ec4ebb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
46-53-g9d377edf70b6/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm6=
4-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
46-53-g9d377edf70b6/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm6=
4-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633ad0d49dc3fa6511ec4=
ebc
        failing since 46 days (last pass: v5.10.101-87-g1f48487c6f05, first=
 fail: v5.10.136) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/633ae59952af9b8dadcab676

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
46-53-g9d377edf70b6/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
46-53-g9d377edf70b6/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633ae59952af9b8dadcab=
677
        failing since 146 days (last pass: v5.10.113-130-g0412f4bd3360, fir=
st fail: v5.10.113-187-g3dca4fac0d16) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/633ae5ae52af9b8dadcab679

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
46-53-g9d377edf70b6/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
46-53-g9d377edf70b6/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633ae5ae52af9b8dadcab=
67a
        failing since 19 days (last pass: v5.10.101-87-g1f48487c6f05, first=
 fail: v5.10.142-80-gd4bb3d725075) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/633ad0d2266bed004aec4eb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
46-53-g9d377edf70b6/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm6=
4-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
46-53-g9d377edf70b6/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm6=
4-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633ad0d2266bed004aec4=
eba
        failing since 19 days (last pass: v5.10.101-87-g1f48487c6f05, first=
 fail: v5.10.142-80-gd4bb3d725075) =

 =20
