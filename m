Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAF2E5A52DC
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 19:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231504AbiH2RMc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 13:12:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231506AbiH2RMK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 13:12:10 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 042BC6BCC2
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 10:11:44 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id q3so5402731pjg.3
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 10:11:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=iKpKebm1EaoF/EYxnwckjXMgRStc+Zs3JRo3iNXd1Xc=;
        b=DEWh5RjmvE/AnOk4ueh3RmOouHZUzgyFOpdUEmB9wh6iWwHRYGNvqDtGaFXsWSuhyJ
         m6zHhapXawSj5ScBuv6WRNcwprh4eeUfT5tUQct/P990kLEW+MBqXql2kX3GDQGmhTxw
         5yWgTlaJU/JxnbsdfCzqZQPMebB4/ZeglJ5+d52jKo74U2TpkWoFjKH4J3xTI60vcZaX
         YeJyHOKVHCOzi/trk8MBPbR+lE6PqUbgIiJHIVeLyTsS6ZV6J3YPmjeXeyxSZYf/4diA
         dOKiPw+MHgr5QWizbA7boq2CqGxGLP7KzJXSHhaLy8ELnKEvz1PUZKqECReEf00VqADr
         7y6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=iKpKebm1EaoF/EYxnwckjXMgRStc+Zs3JRo3iNXd1Xc=;
        b=z2FdNIoDB7PREwcbaKkk+tc3QIXCvu4is6GEu3M2FCFySF1OxL2Av7p5/4PE4FBql9
         Vtu62VhRERzjK9JlKZvGERz//fm6OAhfP9Wb9zQWCtyh0l2+S938v6YT6GHI9XUQ9pXe
         SSL8wt0dWWTqNMRv9fWBi8YPHWvXUVpKdVV60KOA27IGIq5Gqc8c1HmsaUQbWKFJL1Ue
         mqw9k5HFKcsM3VVx4QycoUlgP1GB2DQx6pAZcFv+eQCI7C12l/xJneTf4YSEpNEVIi8H
         nbHpRktZawLC3W1seJSmt2rkJRwX/So1S+8F35Z0rLavtuF4vRHjqeHH2qLccK3623vh
         4CgQ==
X-Gm-Message-State: ACgBeo257D5Z9sHgOb1D3Uw8JDXcdozx77Er1GwjSRFj7C69+RlQ0q74
        eltNxjZtkhh6kDqbsQ95V2siEHGs3uk7SqgIaf8=
X-Google-Smtp-Source: AA6agR6YR6LYWQATKxJ84BTMAvebKo80msTXk7nj8NvQ6f2oLiIZzZHlcItdLJeUn52hSN4s4c913A==
X-Received: by 2002:a17:90b:1812:b0:1fd:d509:93e5 with SMTP id lw18-20020a17090b181200b001fdd50993e5mr5378200pjb.25.1661793089886;
        Mon, 29 Aug 2022 10:11:29 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u8-20020a170902e5c800b0016edd557412sm7943395plf.201.2022.08.29.10.11.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Aug 2022 10:11:29 -0700 (PDT)
Message-ID: <630cf341.170a0220.706cc.da7f@mx.google.com>
Date:   Mon, 29 Aug 2022 10:11:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.291-26-g12df2028ff31
Subject: stable-rc/linux-4.14.y baseline: 110 runs,
 6 regressions (v4.14.291-26-g12df2028ff31)
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

stable-rc/linux-4.14.y baseline: 110 runs, 6 regressions (v4.14.291-26-g12d=
f2028ff31)

Regressions Summary
-------------------

platform                   | arch  | lab          | compiler | defconfig   =
       | regressions
---------------------------+-------+--------------+----------+-------------=
-------+------------
at91sam9g20ek              | arm   | lab-broonie  | gcc-10   | multi_v5_def=
config | 1          =

meson-gxl-s905x-khadas-vim | arm64 | lab-baylibre | gcc-10   | defconfig   =
       | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-broonie  | gcc-10   | defconfig   =
       | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie  | gcc-10   | defconfig   =
       | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie  | gcc-10   | defconfig   =
       | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie  | gcc-10   | defconfig   =
       | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.291-26-g12df2028ff31/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.291-26-g12df2028ff31
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      12df2028ff3172c28cd71c40b0df787144a15ae0 =



Test Regressions
---------------- =



platform                   | arch  | lab          | compiler | defconfig   =
       | regressions
---------------------------+-------+--------------+----------+-------------=
-------+------------
at91sam9g20ek              | arm   | lab-broonie  | gcc-10   | multi_v5_def=
config | 1          =


  Details:     https://kernelci.org/test/plan/id/630cc097d942c1a8d5355675

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
91-26-g12df2028ff31/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91=
sam9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
91-26-g12df2028ff31/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91=
sam9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/630cc097d942c1a8d5355=
676
        new failure (last pass: v4.14.290-230-g4d54ef55c38e) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
       | regressions
---------------------------+-------+--------------+----------+-------------=
-------+------------
meson-gxl-s905x-khadas-vim | arm64 | lab-baylibre | gcc-10   | defconfig   =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/630cc1c4bf577866c335565f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
91-26-g12df2028ff31/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-=
s905x-khadas-vim.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
91-26-g12df2028ff31/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-=
s905x-khadas-vim.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/630cc1c4bf577866c3355=
660
        failing since 55 days (last pass: v4.14.285, first fail: v4.14.286) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
       | regressions
---------------------------+-------+--------------+----------+-------------=
-------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie  | gcc-10   | defconfig   =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/630cc233259577800935566d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
91-26-g12df2028ff31/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
91-26-g12df2028ff31/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/630cc2332595778009355=
66e
        failing since 110 days (last pass: v4.14.277-55-gfb8b8dfe0168, firs=
t fail: v4.14.277-79-ga6b67a30bbcc) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
       | regressions
---------------------------+-------+--------------+----------+-------------=
-------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie  | gcc-10   | defconfig   =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/630cc2345b50c760da35567c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
91-26-g12df2028ff31/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
91-26-g12df2028ff31/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/630cc2345b50c760da355=
67d
        failing since 110 days (last pass: v4.14.277-55-gfb8b8dfe0168, firs=
t fail: v4.14.277-79-ga6b67a30bbcc) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
       | regressions
---------------------------+-------+--------------+----------+-------------=
-------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie  | gcc-10   | defconfig   =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/630cc20bbfcfd9fd56355654

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
91-26-g12df2028ff31/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
91-26-g12df2028ff31/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/630cc20bbfcfd9fd56355=
655
        failing since 110 days (last pass: v4.14.277-55-gfb8b8dfe0168, firs=
t fail: v4.14.277-79-ga6b67a30bbcc) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
       | regressions
---------------------------+-------+--------------+----------+-------------=
-------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie  | gcc-10   | defconfig   =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/630cc21f259577800935565f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
91-26-g12df2028ff31/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
91-26-g12df2028ff31/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/630cc21f2595778009355=
660
        failing since 110 days (last pass: v4.14.277-55-gfb8b8dfe0168, firs=
t fail: v4.14.277-79-ga6b67a30bbcc) =

 =20
