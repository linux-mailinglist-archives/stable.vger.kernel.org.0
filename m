Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77510639126
	for <lists+stable@lfdr.de>; Fri, 25 Nov 2022 22:39:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbiKYVjI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Nov 2022 16:39:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiKYVjH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Nov 2022 16:39:07 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D86D756D73
        for <stable@vger.kernel.org>; Fri, 25 Nov 2022 13:39:05 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id v3-20020a17090ac90300b00218441ac0f6so8401698pjt.0
        for <stable@vger.kernel.org>; Fri, 25 Nov 2022 13:39:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=7mTGkvlamc1lp8Sww3jAYDyNjnsYN0bJUlexqCOx1IE=;
        b=puQRuvvkgY89aOQySl8okhgxUZt9HA4bRtdsu0hGejAlDdO66cfg0wcjX6nsxDjnS9
         4BsJHwxua+nZQlco3M0FnbAWq4GBOesbfXmW22y18ah461QSKXbqnPAvJoGTnd50G1yP
         mPnglPuK4k3Lan7Pt3F5bwRlizp5J8WAIlGxAl+pMawBcq2D9QszZoIxsJkC1W6ZklJJ
         q4jpyBwbffJTD4YXX1VnN06vELjTIRoVoMMW/7AlBIX3H9K7yAvsoeP4OQA7SCQphSFc
         wbk9DIFbLTimuAbMg9664XYVXO8bgdfsbwl0hZeG3kYSoYI/CSQW/X9ZXFbdfdP9kZSk
         udkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7mTGkvlamc1lp8Sww3jAYDyNjnsYN0bJUlexqCOx1IE=;
        b=wxu89y62T7iH896BD7AeaVVj8acKSreyqKGYxQPdJyTxRS6fZi/G5hQP+h+JkAo6Nc
         o2cr8nSvJ+UeXTzxxAXqh2+AuzuYVPad8LFDa9tUAvffIMc6JReCRkUKbxMCGGRviPOn
         8/81hMiTpgAU6bXMoHUmrFkQPEdcfJ0UjZ1YpuKvPXAqMam5tw5b9xoLR7NsHGCLxfAD
         rrMa8FVxobfm1YPl+zWbc2D+spQGh252aOt1WcC62rB16AAQY1HFn7kI6Z6FZrNjybIc
         43iXTvClThR8phVIZxbzf/L6oGdM8zhmMwFk7JM7Ni433qhRtBTWzzTTJ12t9rGCwqUC
         fhCw==
X-Gm-Message-State: ANoB5pmoRDSmvUL7bLrUnXr9U68OO+To/sRjHOmrjSSxTk7PqHbIrYgP
        07ripKFq708L1jRIzmeNT4D5IfvBaLLxACtmxWo=
X-Google-Smtp-Source: AA0mqf6xQpJnbOIsz1gVZ3Soq7Mue3ZVf0QLkBaFde2qNkFKBkHX5P7VIP9CuKUR1B+CVcsZ65lThA==
X-Received: by 2002:a17:902:e012:b0:188:f0c9:d8 with SMTP id o18-20020a170902e01200b00188f0c900d8mr33149113plo.79.1669412344917;
        Fri, 25 Nov 2022 13:39:04 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j13-20020a17090a318d00b002132adb61ccsm423058pjb.48.2022.11.25.13.39.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Nov 2022 13:39:04 -0800 (PST)
Message-ID: <638135f8.170a0220.a3a41.0a22@mx.google.com>
Date:   Fri, 25 Nov 2022 13:39:04 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.300
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
Subject: stable/linux-4.14.y baseline: 71 runs, 10 regressions (v4.14.300)
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

stable/linux-4.14.y baseline: 71 runs, 10 regressions (v4.14.300)

Regressions Summary
-------------------

platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
meson-gxl-s905x-khadas-vim | arm64 | lab-baylibre | gcc-10   | defconfig   =
               | 1          =

meson8b-odroidc1           | arm   | lab-baylibre | gcc-10   | multi_v7_def=
config         | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-baylibre | gcc-10   | defconfig   =
               | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-baylibre | gcc-10   | defconfig+ar=
m64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre | gcc-10   | defconfig   =
               | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre | gcc-10   | defconfig+ar=
m64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-baylibre | gcc-10   | defconfig   =
               | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-baylibre | gcc-10   | defconfig+ar=
m64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre | gcc-10   | defconfig   =
               | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre | gcc-10   | defconfig+ar=
m64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.14.y/kernel=
/v4.14.300/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.14.y
  Describe: v4.14.300
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      179ef7fe86775fe32bd1bfe791887d1994ddcfb0 =



Test Regressions
---------------- =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
meson-gxl-s905x-khadas-vim | arm64 | lab-baylibre | gcc-10   | defconfig   =
               | 1          =


  Details:     https://kernelci.org/test/plan/id/6381051d7be7fc3aaf2abd20

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.300/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s905x-khadas-vim.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.300/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s905x-khadas-vim.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6381051d7be7fc3aaf2ab=
d21
        failing since 140 days (last pass: v4.14.275, first fail: v4.14.287=
) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
meson8b-odroidc1           | arm   | lab-baylibre | gcc-10   | multi_v7_def=
config         | 1          =


  Details:     https://kernelci.org/test/plan/id/63810551796848faa72abd2f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.300/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.300/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63810551796848faa72ab=
d30
        failing since 282 days (last pass: v4.14.266, first fail: v4.14.267=
) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre | gcc-10   | defconfig   =
               | 1          =


  Details:     https://kernelci.org/test/plan/id/63810d5de80e1fa3bc2abd07

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.300/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.300/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63810d5de80e1fa3bc2ab=
d08
        failing since 197 days (last pass: v4.14.275, first fail: v4.14.278=
) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre | gcc-10   | defconfig+ar=
m64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63811e44d0406916ca2abd16

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.300/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.300/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63811e44d0406916ca2ab=
d17
        failing since 197 days (last pass: v4.14.275, first fail: v4.14.278=
) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre | gcc-10   | defconfig   =
               | 1          =


  Details:     https://kernelci.org/test/plan/id/63810d5be80e1fa3bc2abcfe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.300/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.300/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63810d5be80e1fa3bc2ab=
cff
        failing since 197 days (last pass: v4.14.275, first fail: v4.14.278=
) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre | gcc-10   | defconfig+ar=
m64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63811e40007f66efa22abd11

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.300/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.300/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63811e40007f66efa22ab=
d12
        failing since 197 days (last pass: v4.14.275, first fail: v4.14.278=
) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-baylibre | gcc-10   | defconfig   =
               | 1          =


  Details:     https://kernelci.org/test/plan/id/63810d5fe80e1fa3bc2abd0a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.300/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.300/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63810d5fe80e1fa3bc2ab=
d0b
        failing since 197 days (last pass: v4.14.275, first fail: v4.14.278=
) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-baylibre | gcc-10   | defconfig+ar=
m64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63811e42007f66efa22abd17

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.300/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.300/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63811e42007f66efa22ab=
d18
        failing since 197 days (last pass: v4.14.275, first fail: v4.14.278=
) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre | gcc-10   | defconfig   =
               | 1          =


  Details:     https://kernelci.org/test/plan/id/63810d59da15c74f9f2abd03

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.300/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.300/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63810d59da15c74f9f2ab=
d04
        failing since 197 days (last pass: v4.14.275, first fail: v4.14.278=
) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre | gcc-10   | defconfig+ar=
m64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63811e3ed0406916ca2abd04

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.300/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.300/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63811e3ed0406916ca2ab=
d05
        failing since 197 days (last pass: v4.14.275, first fail: v4.14.278=
) =

 =20
