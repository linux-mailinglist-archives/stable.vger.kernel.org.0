Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB9B1526A99
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 21:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350745AbiEMTj6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 15:39:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383897AbiEMTjz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 15:39:55 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D1FE4C410
        for <stable@vger.kernel.org>; Fri, 13 May 2022 12:39:52 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id x52so8503299pfu.11
        for <stable@vger.kernel.org>; Fri, 13 May 2022 12:39:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4wb5CRV2r7BZFb6Kr+tp1pEX+9DJs8zs/dhzKSqvdJs=;
        b=Ve5Gx8nVt2aCWUgAjfdIEUtNR13FMLdbn8s72Y4jKMkfRARvWA/DK2Z9jvF+GJi+vX
         4O1vHG3PFbq99Lc8xIfejD9XU12Ojw5CEqSGKOxnw8+o97X40T+S0ANxVqu4F8+fWuEK
         WnM9fTOzs/bRQNu5RljUSi0RX7if5u7jBlpQ0n1hV4H2UNcM7v4oIFEJ2oxTl9lpLzQK
         IegdGlsE/a9V+Xb3ADmTCJTFmChECt1S1jC3LVnGh3IoNJqz7DxmAqjYDONSqAupAjRz
         HPIMedgUkx0HVKiq6l+X44D/Fo3aMqZvXxCc6u4JwmsrmF6LDKvqFbnQ5Hh4PXqecEug
         dHOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4wb5CRV2r7BZFb6Kr+tp1pEX+9DJs8zs/dhzKSqvdJs=;
        b=mEQJhn4LgRSyavIHyw2yCz7uvQdLlnAQ9NHRt9f2nju1eU+vsNgJoHlstll+b8tEzm
         rLijVWedgVr8/iLWOrO6zYHSLuzNkHU6dgQ9ftWTXxjsn5IejVknWnOQkjzBNlph+gVJ
         61xSgOUMiKSfnbYdkGLmuouygoeGKP5wxabf+MLNqNah4VcFehramIxiU/2SlIgatIDn
         LTFOnCFV1KU1AzbWPbwkmkcw2IVkL0ax5Cow/iSDGGT/AtNCKeNMyjS70J3ZvsvqRYx4
         6MegMXPpPVk0LTzddnzpWkKVoi2NKCnTq0UJmaIFdedRrTsH9v0Neww1cOwP1bgfcNmq
         3otw==
X-Gm-Message-State: AOAM533h6WBG4Kvpcdl3+6Dx0El2dzuOfVhKtoBuDapjpPUlm0fEhWGd
        ZUeyCV3WpQUjzy2wJ5XOMSCxbydlC9+WR61rnXE=
X-Google-Smtp-Source: ABdhPJxmyFhukK4QG0sF0ofDCN27gdmJxj8mRdSQ5JK8+7pc54tKx+1pidY0p5BcF++63i1CVtcXEQ==
X-Received: by 2002:a63:8b49:0:b0:3c6:1ec9:a018 with SMTP id j70-20020a638b49000000b003c61ec9a018mr5327522pge.451.1652470791839;
        Fri, 13 May 2022 12:39:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u14-20020aa7848e000000b005106b52a823sm2167868pfn.145.2022.05.13.12.39.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 12:39:51 -0700 (PDT)
Message-ID: <627eb407.1c69fb81.c5d6c.58e5@mx.google.com>
Date:   Fri, 13 May 2022 12:39:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.278-4-g95c4f04a529a
Subject: stable-rc/queue/4.14 baseline: 101 runs,
 10 regressions (v4.14.278-4-g95c4f04a529a)
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

stable-rc/queue/4.14 baseline: 101 runs, 10 regressions (v4.14.278-4-g95c4f=
04a529a)

Regressions Summary
-------------------

platform                     | arch  | lab          | compiler | defconfig =
         | regressions
-----------------------------+-------+--------------+----------+-----------=
---------+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-broonie  | gcc-10   | defconfig =
         | 1          =

meson8b-odroidc1             | arm   | lab-baylibre | gcc-10   | multi_v7_d=
efconfig | 1          =

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
nel/v4.14.278-4-g95c4f04a529a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.278-4-g95c4f04a529a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      95c4f04a529a0aa5dcb2b24cedcc6c67c8e22bb3 =



Test Regressions
---------------- =



platform                     | arch  | lab          | compiler | defconfig =
         | regressions
-----------------------------+-------+--------------+----------+-----------=
---------+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-broonie  | gcc-10   | defconfig =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/627d7065a43517f9b88f572a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.278=
-4-g95c4f04a529a/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s905=
x-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.278=
-4-g95c4f04a529a/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s905=
x-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627d7065a43517f9b88f5=
72b
        failing since 24 days (last pass: v4.14.275-277-gda5c0b6bebbb1, fir=
st fail: v4.14.275-284-gdf8ec5b4383b9) =

 =



platform                     | arch  | lab          | compiler | defconfig =
         | regressions
-----------------------------+-------+--------------+----------+-----------=
---------+------------
meson8b-odroidc1             | arm   | lab-baylibre | gcc-10   | multi_v7_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/627d70c0e765ecee248f572e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.278=
-4-g95c4f04a529a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson8=
b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.278=
-4-g95c4f04a529a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson8=
b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627d70c0e765ecee248f5=
72f
        failing since 88 days (last pass: v4.14.266-18-g18b83990eba9, first=
 fail: v4.14.266-28-g7d44cfe0255d) =

 =



platform                     | arch  | lab          | compiler | defconfig =
         | regressions
-----------------------------+-------+--------------+----------+-----------=
---------+------------
qemu_arm64-virt-gicv2        | arm64 | lab-baylibre | gcc-10   | defconfig =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/627d7025deb0a3c26e8f572d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.278=
-4-g95c4f04a529a/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.278=
-4-g95c4f04a529a/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627d7025deb0a3c26e8f5=
72e
        failing since 2 days (last pass: v4.14.277-54-gfa6de16ffc4e, first =
fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab          | compiler | defconfig =
         | regressions
-----------------------------+-------+--------------+----------+-----------=
---------+------------
qemu_arm64-virt-gicv2        | arm64 | lab-broonie  | gcc-10   | defconfig =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/627d7071a43517f9b88f5730

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.278=
-4-g95c4f04a529a/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.278=
-4-g95c4f04a529a/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627d7071a43517f9b88f5=
731
        failing since 2 days (last pass: v4.14.277-54-gfa6de16ffc4e, first =
fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab          | compiler | defconfig =
         | regressions
-----------------------------+-------+--------------+----------+-----------=
---------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-baylibre | gcc-10   | defconfig =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/627d702210a497a3328f5736

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.278=
-4-g95c4f04a529a/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.278=
-4-g95c4f04a529a/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627d702210a497a3328f5=
737
        failing since 2 days (last pass: v4.14.277-54-gfa6de16ffc4e, first =
fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab          | compiler | defconfig =
         | regressions
-----------------------------+-------+--------------+----------+-----------=
---------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie  | gcc-10   | defconfig =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/627d704930aa52e2fa8f5726

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.278=
-4-g95c4f04a529a/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.278=
-4-g95c4f04a529a/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627d704930aa52e2fa8f5=
727
        failing since 2 days (last pass: v4.14.277-54-gfa6de16ffc4e, first =
fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab          | compiler | defconfig =
         | regressions
-----------------------------+-------+--------------+----------+-----------=
---------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-baylibre | gcc-10   | defconfig =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/627d7026deb0a3c26e8f5733

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.278=
-4-g95c4f04a529a/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.278=
-4-g95c4f04a529a/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627d7026deb0a3c26e8f5=
734
        failing since 2 days (last pass: v4.14.277-54-gfa6de16ffc4e, first =
fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab          | compiler | defconfig =
         | regressions
-----------------------------+-------+--------------+----------+-----------=
---------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-broonie  | gcc-10   | defconfig =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/627d7085e5740615558f5725

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.278=
-4-g95c4f04a529a/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.278=
-4-g95c4f04a529a/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627d7085e5740615558f5=
726
        failing since 2 days (last pass: v4.14.277-54-gfa6de16ffc4e, first =
fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab          | compiler | defconfig =
         | regressions
-----------------------------+-------+--------------+----------+-----------=
---------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-baylibre | gcc-10   | defconfig =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/627d70212f8dd3355c8f5756

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.278=
-4-g95c4f04a529a/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.278=
-4-g95c4f04a529a/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627d70212f8dd3355c8f5=
757
        failing since 2 days (last pass: v4.14.277-54-gfa6de16ffc4e, first =
fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab          | compiler | defconfig =
         | regressions
-----------------------------+-------+--------------+----------+-----------=
---------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie  | gcc-10   | defconfig =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/627d70359ac250f7f78f572e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.278=
-4-g95c4f04a529a/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.278=
-4-g95c4f04a529a/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627d70359ac250f7f78f5=
72f
        failing since 2 days (last pass: v4.14.277-54-gfa6de16ffc4e, first =
fail: v4.14.277-75-g7a298ff98d4a) =

 =20
