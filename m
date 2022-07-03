Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B0FD56438F
	for <lists+stable@lfdr.de>; Sun,  3 Jul 2022 03:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbiGCBct (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Jul 2022 21:32:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbiGCBcs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Jul 2022 21:32:48 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94B51B4AC
        for <stable@vger.kernel.org>; Sat,  2 Jul 2022 18:32:45 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id g7so1124097pfb.10
        for <stable@vger.kernel.org>; Sat, 02 Jul 2022 18:32:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9s83zSAzeajgeHtNxvnn9Z1m/wbmGCZdtaluan/uc1k=;
        b=NOUoq7hE9vyi+E7bzgopk9TmDfXJrCci+p3rC2GTawv93ifZOevIJufbS73xYxY22K
         4iSuMF1wFtepEHjzWoSMKfBpKXlnitE3Hgpgrius2YoKk2g7HcnxvzW2XG/axDTL6aWx
         c9Wyk1NHZVnaeVm6alzu8vbKrdd2lclxmF1E4f3wjSr44ii2BVpCn4QbAIypn3Yy1szu
         jRX5t1vh1+r9tvmvvzyGa0Sic4jcVu3dvNS5qlDZ6U3cghUV34ajff+169eafV0sZGEu
         RZ7W8nCtGaA6ewTkM5CNOeQtkZE5/ZUxW1qt+r4kAPRlNQXTXrthpEwUTEjDZtNvrtGI
         CfTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9s83zSAzeajgeHtNxvnn9Z1m/wbmGCZdtaluan/uc1k=;
        b=cO3JZLYvUjQI4a0evOBsSZAkoyKZlN3bv7JzNZErKH9LFdp2cojbrjGlaJbPwAf3LL
         L/eTbJ6363d0b4draZ9VsCXQpPsWBfwUzf5jDZnhNpZ0NWVczlpGQInG1Pfy6Rs90nKb
         PBwkSps+CX/23ZxyXhBibBEbplTiEOKQoTbS3EmI2ki92D238VKRXucfB8nkTNaxHkbD
         cqzbZzQK/ptQWaNup5SqgqxAygcsOj9Rcco9GmSy2dsBJaCJ7sVKL1oHcLd3J9Bn8akm
         D3VqTbDgNN1uUabEL3sG1GL4glHh60RniS3pVIgWeEpuLoniQBIx8hylNgIze8uzwF6s
         X8jw==
X-Gm-Message-State: AJIora/wDZtv89Fl5YcZjF4tkxa5uRX0j9s2Sx3vNxUagjoHxp3SlnXt
        jjg73oLnqBmyN/lBRkGSKdWEEioiMDMoVMKx
X-Google-Smtp-Source: AGRyM1ua4vtnuz4ZByGUIvg7Te9G1iArvld4E4SBtu5iZxklpKl0K7EG+91gtm7SgIcbYRJOYVZpEg==
X-Received: by 2002:a05:6a00:114c:b0:528:2c7a:6302 with SMTP id b12-20020a056a00114c00b005282c7a6302mr12212410pfm.37.1656811964610;
        Sat, 02 Jul 2022 18:32:44 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d63-20020a621d42000000b0052532d9cb18sm18138763pfd.183.2022.07.02.18.32.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Jul 2022 18:32:43 -0700 (PDT)
Message-ID: <62c0f1bb.1c69fb81.e594d.98f3@mx.google.com>
Date:   Sat, 02 Jul 2022 18:32:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.203
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.4.y baseline: 102 runs, 9 regressions (v5.4.203)
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

stable/linux-5.4.y baseline: 102 runs, 9 regressions (v5.4.203)

Regressions Summary
-------------------

platform                   | arch  | lab          | compiler | defconfig   =
    | regressions
---------------------------+-------+--------------+----------+-------------=
----+------------
jetson-tk1                 | arm   | lab-baylibre | gcc-10   | tegra_defcon=
fig | 1          =

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


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.203/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.203
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      871cbc208bf0aded1946cd1e3eebec75799d31e8 =



Test Regressions
---------------- =



platform                   | arch  | lab          | compiler | defconfig   =
    | regressions
---------------------------+-------+--------------+----------+-------------=
----+------------
jetson-tk1                 | arm   | lab-baylibre | gcc-10   | tegra_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/62c0b9345bc516e4b2a39c02

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.203/ar=
m/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.203/ar=
m/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c0b9345bc516e4b2a39=
c03
        failing since 38 days (last pass: v5.4.194, first fail: v5.4.196) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
    | regressions
---------------------------+-------+--------------+----------+-------------=
----+------------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre | gcc-10   | defconfig   =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/62c0bad83ce62b9a43a39be2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.203/ar=
m64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.203/ar=
m64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c0bad83ce62b9a43a39=
be3
        failing since 54 days (last pass: v5.4.190, first fail: v5.4.192) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
    | regressions
---------------------------+-------+--------------+----------+-------------=
----+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie  | gcc-10   | defconfig   =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/62c0bb003ce62b9a43a39c0a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.203/ar=
m64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.203/ar=
m64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c0bb003ce62b9a43a39=
c0b
        failing since 54 days (last pass: v5.4.190, first fail: v5.4.192) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
    | regressions
---------------------------+-------+--------------+----------+-------------=
----+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre | gcc-10   | defconfig   =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/62c0baea3ce62b9a43a39bf6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.203/ar=
m64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.203/ar=
m64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c0baea3ce62b9a43a39=
bf7
        failing since 54 days (last pass: v5.4.190, first fail: v5.4.192) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
    | regressions
---------------------------+-------+--------------+----------+-------------=
----+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie  | gcc-10   | defconfig   =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/62c0bb01f80261c51da39bcd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.203/ar=
m64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.203/ar=
m64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c0bb01f80261c51da39=
bce
        failing since 54 days (last pass: v5.4.190, first fail: v5.4.192) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
    | regressions
---------------------------+-------+--------------+----------+-------------=
----+------------
qemu_arm64-virt-gicv3      | arm64 | lab-baylibre | gcc-10   | defconfig   =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/62c0bae935b5555bbfa39bf2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.203/ar=
m64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.203/ar=
m64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c0bae935b5555bbfa39=
bf3
        failing since 54 days (last pass: v5.4.190, first fail: v5.4.192) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
    | regressions
---------------------------+-------+--------------+----------+-------------=
----+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie  | gcc-10   | defconfig   =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/62c0bac43ce62b9a43a39bcd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.203/ar=
m64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.203/ar=
m64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c0bac43ce62b9a43a39=
bce
        failing since 54 days (last pass: v5.4.190, first fail: v5.4.192) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
    | regressions
---------------------------+-------+--------------+----------+-------------=
----+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre | gcc-10   | defconfig   =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/62c0baeb35b5555bbfa39bf8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.203/ar=
m64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.203/ar=
m64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c0baeb35b5555bbfa39=
bf9
        failing since 54 days (last pass: v5.4.190, first fail: v5.4.192) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
    | regressions
---------------------------+-------+--------------+----------+-------------=
----+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie  | gcc-10   | defconfig   =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/62c0bb14d351fc7d3ba39be0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.203/ar=
m64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.203/ar=
m64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c0bb14d351fc7d3ba39=
be1
        failing since 54 days (last pass: v5.4.190, first fail: v5.4.192) =

 =20
