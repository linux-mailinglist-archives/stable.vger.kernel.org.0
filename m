Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE4D2612C17
	for <lists+stable@lfdr.de>; Sun, 30 Oct 2022 18:57:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbiJ3R5f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 Oct 2022 13:57:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbiJ3R5a (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 Oct 2022 13:57:30 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0184B4AD
        for <stable@vger.kernel.org>; Sun, 30 Oct 2022 10:57:22 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id y13so8876196pfp.7
        for <stable@vger.kernel.org>; Sun, 30 Oct 2022 10:57:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=tGgrH1ZlZo8h+BMhPH9jRByvWsgKymkrrXgYuD1IbJU=;
        b=pNfLz2Uy1rnTwH0FM30pr1+2ZFXCn3LoOyfbIMbUJ0/hy1JWGy5Yiqx2BneQKkBynQ
         0UNweegKridYantp4lWOdKtmnxx3O9VhSBV5N0sTuptfHmdTWWX/Q3TAI88mPmzpQN/B
         B23GRdIViSJE9pBoMip2o6Vp1005COlO/8di1YzN7N9+fVEmKHMOSJRXaNXQkOAIy2jA
         OsNpPfpduEOb/jMsK9/sFHx4f3jfVRxkkDXFLa8pO8CE/HWN3fXpEVjOmzTlRb99oBti
         RNprLzK9byqP4NGIhCe412uu26GRJEGD2L1P8E9PVkJVBmbY4Dqvmotylslbq4gUE7td
         sT+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tGgrH1ZlZo8h+BMhPH9jRByvWsgKymkrrXgYuD1IbJU=;
        b=wMvFMKh2s9G+EwTw56QXCN7hUSJ8KOxq4olYhVLlNqYuotvCiuBqInkfFHQRy2E+v/
         ij+H5rhJ0JVVUYWHlpxbckeGevDlQITkTm8HwqU+5lTYJSY8/PF+QoID3kqgYmTHSA4X
         WW7IE+PHyXVWdai3YoYsZhRZiXd63E1ZkWo7pomPOAlscOQTeLkeb2ea7TPmocxuGp8N
         fHYnMtiWfcogvDsMBZbljXr6/fWyJLIUI8qboPB3poNIRlBcyK2ZKVxaZgc/dTHIbVNz
         OyJba2Z4Z6t/5vZAeRRD/4n3f5GKINdOPupSRZQVoUTUyj5r6LIS1i9KyAJF6z7ennEJ
         ++3Q==
X-Gm-Message-State: ACrzQf1ZQGdfosk+TlEt6YP6KdSqaan8in5HwNo2bfVqQxkisHxf1P46
        SWZc/njriLHVSfpvUGBj6mCwxLnfZQ7daV4H
X-Google-Smtp-Source: AMsMyM7xSO/EXKhRJzSgRmT5tizVTseb72QXUJoW8hUMyMsR5f7vRma3CU1Iox8VZwOP0wMBt+S9zQ==
X-Received: by 2002:a63:1609:0:b0:45c:7c1c:4e7d with SMTP id w9-20020a631609000000b0045c7c1c4e7dmr8909895pgl.265.1667152641416;
        Sun, 30 Oct 2022 10:57:21 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m5-20020a170902db0500b00186aaf1644asm2962836plx.87.2022.10.30.10.57.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Oct 2022 10:57:21 -0700 (PDT)
Message-ID: <635ebb01.170a0220.9f28c.4994@mx.google.com>
Date:   Sun, 30 Oct 2022 10:57:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.296-16-gbcf2261fa0b0
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 94 runs,
 11 regressions (v4.14.296-16-gbcf2261fa0b0)
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

stable-rc/queue/4.14 baseline: 94 runs, 11 regressions (v4.14.296-16-gbcf22=
61fa0b0)

Regressions Summary
-------------------

platform                     | arch  | lab          | compiler | defconfig =
         | regressions
-----------------------------+-------+--------------+----------+-----------=
---------+------------
at91sam9g20ek                | arm   | lab-broonie  | gcc-10   | multi_v5_d=
efconfig | 1          =

meson-gxl-s905x-khadas-vim   | arm64 | lab-baylibre | gcc-10   | defconfig =
         | 1          =

meson-gxl-s905x-libretech-cc | arm64 | lab-broonie  | gcc-10   | defconfig =
         | 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-baylibre | gcc-10   | defconfig =
         | 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-broonie  | gcc-10   | defconfig =
         | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-baylibre | gcc-10   | defconfig =
         | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie  | gcc-10   | defconfig =
         | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-baylibre | gcc-10   | defconfig =
         | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-broonie  | gcc-10   | defconfig =
         | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-baylibre | gcc-10   | defconfig =
         | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie  | gcc-10   | defconfig =
         | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.296-16-gbcf2261fa0b0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.296-16-gbcf2261fa0b0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bcf2261fa0b0a73667542f92410faa953cdcd3e9 =



Test Regressions
---------------- =



platform                     | arch  | lab          | compiler | defconfig =
         | regressions
-----------------------------+-------+--------------+----------+-----------=
---------+------------
at91sam9g20ek                | arm   | lab-broonie  | gcc-10   | multi_v5_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/635e871166f15c1889e7db52

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.296=
-16-gbcf2261fa0b0/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sa=
m9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.296=
-16-gbcf2261fa0b0/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sa=
m9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/635e871166f15c1889e7d=
b53
        failing since 1 day (last pass: v4.14.296-16-g2a17f9800d6c6, first =
fail: v4.14.296-16-g74e16cb7c9ad) =

 =



platform                     | arch  | lab          | compiler | defconfig =
         | regressions
-----------------------------+-------+--------------+----------+-----------=
---------+------------
meson-gxl-s905x-khadas-vim   | arm64 | lab-baylibre | gcc-10   | defconfig =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/635e875226cad5e403e7db75

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.296=
-16-gbcf2261fa0b0/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s9=
05x-khadas-vim.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.296=
-16-gbcf2261fa0b0/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s9=
05x-khadas-vim.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/635e875226cad5e403e7d=
b76
        failing since 117 days (last pass: v4.14.285-35-g61a723f50c9f, firs=
t fail: v4.14.285-46-ga87318551bac) =

 =



platform                     | arch  | lab          | compiler | defconfig =
         | regressions
-----------------------------+-------+--------------+----------+-----------=
---------+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-broonie  | gcc-10   | defconfig =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/635e889761e67e6875e7db6d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.296=
-16-gbcf2261fa0b0/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s90=
5x-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.296=
-16-gbcf2261fa0b0/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s90=
5x-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/635e889761e67e6875e7d=
b6e
        failing since 194 days (last pass: v4.14.275-277-gda5c0b6bebbb1, fi=
rst fail: v4.14.275-284-gdf8ec5b4383b9) =

 =



platform                     | arch  | lab          | compiler | defconfig =
         | regressions
-----------------------------+-------+--------------+----------+-----------=
---------+------------
qemu_arm64-virt-gicv2        | arm64 | lab-baylibre | gcc-10   | defconfig =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/635e877cdf362c530ce7db59

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.296=
-16-gbcf2261fa0b0/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.296=
-16-gbcf2261fa0b0/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/635e877cdf362c530ce7d=
b5a
        failing since 173 days (last pass: v4.14.277-54-gfa6de16ffc4e, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab          | compiler | defconfig =
         | regressions
-----------------------------+-------+--------------+----------+-----------=
---------+------------
qemu_arm64-virt-gicv2        | arm64 | lab-broonie  | gcc-10   | defconfig =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/635e8838629f3b1ec3e7db78

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.296=
-16-gbcf2261fa0b0/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.296=
-16-gbcf2261fa0b0/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/635e8838629f3b1ec3e7d=
b79
        failing since 173 days (last pass: v4.14.277-54-gfa6de16ffc4e, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab          | compiler | defconfig =
         | regressions
-----------------------------+-------+--------------+----------+-----------=
---------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-baylibre | gcc-10   | defconfig =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/635e877d793ab43b59e7db4e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.296=
-16-gbcf2261fa0b0/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.296=
-16-gbcf2261fa0b0/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/635e877d793ab43b59e7d=
b4f
        failing since 173 days (last pass: v4.14.277-54-gfa6de16ffc4e, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab          | compiler | defconfig =
         | regressions
-----------------------------+-------+--------------+----------+-----------=
---------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie  | gcc-10   | defconfig =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/635e892899e69d8229e7db69

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.296=
-16-gbcf2261fa0b0/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.296=
-16-gbcf2261fa0b0/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/635e892899e69d8229e7d=
b6a
        failing since 173 days (last pass: v4.14.277-54-gfa6de16ffc4e, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab          | compiler | defconfig =
         | regressions
-----------------------------+-------+--------------+----------+-----------=
---------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-baylibre | gcc-10   | defconfig =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/635e876591f96fd6b4e7db52

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.296=
-16-gbcf2261fa0b0/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.296=
-16-gbcf2261fa0b0/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/635e876591f96fd6b4e7d=
b53
        failing since 173 days (last pass: v4.14.277-54-gfa6de16ffc4e, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab          | compiler | defconfig =
         | regressions
-----------------------------+-------+--------------+----------+-----------=
---------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-broonie  | gcc-10   | defconfig =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/635e87c1a8c0ab2319e7db5b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.296=
-16-gbcf2261fa0b0/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.296=
-16-gbcf2261fa0b0/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/635e87c1a8c0ab2319e7d=
b5c
        failing since 173 days (last pass: v4.14.277-54-gfa6de16ffc4e, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab          | compiler | defconfig =
         | regressions
-----------------------------+-------+--------------+----------+-----------=
---------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-baylibre | gcc-10   | defconfig =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/635e877adf362c530ce7db56

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.296=
-16-gbcf2261fa0b0/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.296=
-16-gbcf2261fa0b0/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/635e877adf362c530ce7d=
b57
        failing since 173 days (last pass: v4.14.277-54-gfa6de16ffc4e, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab          | compiler | defconfig =
         | regressions
-----------------------------+-------+--------------+----------+-----------=
---------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie  | gcc-10   | defconfig =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/635e87e878f34db85be7db52

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.296=
-16-gbcf2261fa0b0/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.296=
-16-gbcf2261fa0b0/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/635e87e878f34db85be7d=
b53
        failing since 173 days (last pass: v4.14.277-54-gfa6de16ffc4e, firs=
t fail: v4.14.277-75-g7a298ff98d4a) =

 =20
