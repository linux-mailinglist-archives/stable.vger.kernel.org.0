Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B447149ABD5
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 06:44:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235229AbiAYFj4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 00:39:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233401AbiAYFh2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 00:37:28 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 849A4C0419CF
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 19:57:01 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id 133so17266688pgb.0
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 19:57:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=E3cufVllqS2hIpi9vOTGMIRNj5kFmgkMI+LbU4brhU0=;
        b=z03d4xIXI1NEDgmKFGqcgxGqt/mnSM+np0Eag0g3xR2376pLsZoX1IIrYNMMuG5Era
         ofXd54G6OqE2azM8z1yBRQLnWQZkE+g+rhbg8ZVlV4P9ICPawtnrQXtlvo6Q5UU2SCIw
         PSbzAtrJy0Jcf/xWHBhsmk5lfGlvKz3ilXKEGXCnco7+iEn9K2Htu8jXJ3rKLEBMkkjw
         q8t6cC9guuPRz5eXHt3OgnAaC3dJHh+paoQ8oSf0b76N1MC3fD7JA5wTrjO74/jYzxiJ
         g5VBIM5v/hu/hDR+o2DnwgRZgNs4PLALywq86CszHAExFyboGa4MLrB3H9XaarN0Gv+5
         8DuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=E3cufVllqS2hIpi9vOTGMIRNj5kFmgkMI+LbU4brhU0=;
        b=jm8ZiFva3PsWfTSk+10eBt54z5/bQKKEP4x6QnQ505dJhKBb23VahE7l4pSxUg64vW
         tz+Xzie+C141uJm4o0/hK7ZtK2dLzTMd4hSj/q/4/coZI9/KjzifNaNUlD7lAAdzdGdx
         jCmIY9bFsSl8vei6TMAczWjUevWsgm4jnD/kDz1kTgEIPIfvFsv0v/K3j4cBufKz2Cxc
         6o9gHKtwIJKtKY+nAE7a0/TIyuyTucrh+odL0IYCZxWMDxsIs/shtDVh4jQzl56i65cp
         B9Kxz6CU7ILsi/il6NjBZdaSqLV+6IGvGqIRzQ+NKPZr464RFXOOVMuoMbbs6kj1oJwX
         X9Yw==
X-Gm-Message-State: AOAM532eesJUZpsCHfJ6QfCDT7/rL5E5N4/6LD0qUU3G3OWnhim/gR8y
        kEbfikLF1z00lctEQ64rWCPYMgBTyUtnTSlR
X-Google-Smtp-Source: ABdhPJxUYnL+2zaTpQjVITfJS4fvXmv9NAmmXm6Sgd376F7WMmF9UH1qhotXqDiga/z4NiB29uNmwQ==
X-Received: by 2002:aa7:85c7:0:b0:4bc:ac23:64a2 with SMTP id z7-20020aa785c7000000b004bcac2364a2mr16625515pfn.20.1643083020864;
        Mon, 24 Jan 2022 19:57:00 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f13sm16579383pfn.141.2022.01.24.19.57.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 19:57:00 -0800 (PST)
Message-ID: <61ef750c.1c69fb81.647fa.f1f6@mx.google.com>
Date:   Mon, 24 Jan 2022 19:57:00 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.173-321-g34a12dd3db7f
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 155 runs,
 5 regressions (v5.4.173-321-g34a12dd3db7f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 155 runs, 5 regressions (v5.4.173-321-g34a1=
2dd3db7f)

Regressions Summary
-------------------

platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
hifive-unleashed-a00     | riscv | lab-baylibre | gcc-10   | defconfig     =
     | 1          =

qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre | gcc-10   | multi_v7_defco=
nfig | 1          =

qemu_arm-virt-gicv2-uefi | arm   | lab-broonie  | gcc-10   | multi_v7_defco=
nfig | 1          =

qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre | gcc-10   | multi_v7_defco=
nfig | 1          =

qemu_arm-virt-gicv3-uefi | arm   | lab-broonie  | gcc-10   | multi_v7_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.173-321-g34a12dd3db7f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.173-321-g34a12dd3db7f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      34a12dd3db7fef70acea32b5c7797ef9b9a8b196 =



Test Regressions
---------------- =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
hifive-unleashed-a00     | riscv | lab-baylibre | gcc-10   | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/61ef39a58a2c3c92bcabbd2a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.173=
-321-g34a12dd3db7f/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unle=
ashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.173=
-321-g34a12dd3db7f/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unle=
ashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61ef39a58a2c3c92bcabb=
d2b
        failing since 4 days (last pass: v5.4.171-35-g6a507169a5ff, first f=
ail: v5.4.173) =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre | gcc-10   | multi_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61ef3ad0708c96088babbd47

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.173=
-321-g34a12dd3db7f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu=
_arm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.173=
-321-g34a12dd3db7f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu=
_arm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61ef3ad0708c96088babb=
d48
        failing since 40 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-broonie  | gcc-10   | multi_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61ef3a95a3f69bc8bdabbd2a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.173=
-321-g34a12dd3db7f/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_=
arm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.173=
-321-g34a12dd3db7f/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_=
arm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61ef3a95a3f69bc8bdabb=
d2b
        failing since 40 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre | gcc-10   | multi_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61ef3a97a3f69bc8bdabbd2d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.173=
-321-g34a12dd3db7f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu=
_arm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.173=
-321-g34a12dd3db7f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu=
_arm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61ef3a97a3f69bc8bdabb=
d2e
        failing since 40 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
qemu_arm-virt-gicv3-uefi | arm   | lab-broonie  | gcc-10   | multi_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61ef3a6b488cf20bc1abbd3d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.173=
-321-g34a12dd3db7f/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_=
arm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.173=
-321-g34a12dd3db7f/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_=
arm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61ef3a6b488cf20bc1abb=
d3e
        failing since 40 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =20
