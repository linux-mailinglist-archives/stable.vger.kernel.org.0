Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B17869FBE9
	for <lists+stable@lfdr.de>; Wed, 22 Feb 2023 20:20:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232238AbjBVTUl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Feb 2023 14:20:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjBVTUk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Feb 2023 14:20:40 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 511903D935
        for <stable@vger.kernel.org>; Wed, 22 Feb 2023 11:20:10 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id na9-20020a17090b4c0900b0023058bbd7b2so9369155pjb.0
        for <stable@vger.kernel.org>; Wed, 22 Feb 2023 11:20:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=R2zCj3jBOBysPhMFE1K//x2jJIi3jLY+SwPQx0RJ12w=;
        b=QIsz08lC9wr+FRmmVJNkliBUhBBoPunRVQHuZnI7UNo7ingQYkjkWG/75kC+0g5x+o
         uQT7GScbB7q3FXFDb3MJliBfTunFIQCfFSjM8bKEOU8iQpduN2NjhRGbj643CvlYv1j3
         SCOObkYGZLIatMufYLrr07CfpFNhO4MZ+OKc9O45YcX4TOG8XApPVMWVVAQDohyzTbc9
         Zl7C8HPOl0NI+K/YhF2yk34uJvOUjoV7pbGOG8ErQi6t+SOwff4BpZSAITOMAvUnlk8D
         rOkWPzO0QbwCWHZEFWkl9gAUmDefCEWrAjcjBGhlOv/SwcbnSJJ+iaqdfx5j7Cu7VBRl
         7mFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R2zCj3jBOBysPhMFE1K//x2jJIi3jLY+SwPQx0RJ12w=;
        b=pU5/T7zMr/ZuWdYHq6apLhTaiRkSTfSLpBg9Rx04Rkz0IhTwYuBSOiB/m8iX2otDX0
         48qDrYeN530Hz2G0bXyRpnZlyahJ+fvY0oCJFMzkmLpWy10DPZ+SpVPrqTgTAh+96Yxy
         xHEldgaZPQ/zM395yCT+8NWK9fhV1tFEBn1rbyBLYeLxt0btffccsgm1z5+rfU9S7V69
         6rEez8OFp8nfdKyJiMcWcRaP1+TfeMa/hmv5+4N9W6AORaA6obiS8bdQAUCGG5wtophS
         aJdNZ/RD2rdBzDdmGUaumEVkesiy8+WY9zpqmxX9y8P+mixyzKdLJvUwlLvLCzzquhuV
         arSg==
X-Gm-Message-State: AO0yUKVdCqd3D94vX9zOj23V9uNeyE7jYTdB8WLcSI+whU7ktFEW1uhI
        Oo0kMqlPBXWXXlFRgOGkjbI5H6bvnzDlXtAOgy8XvQ==
X-Google-Smtp-Source: AK7set/SlWYrMIWGR9MW41dy2WdfNZJux55rQ4mCbMf4BwrE8CCyP6O8rZhUUTBwcBS5zgv0Ofs7IA==
X-Received: by 2002:a05:6a20:3d8d:b0:c7:40a1:ac1b with SMTP id s13-20020a056a203d8d00b000c740a1ac1bmr12528190pzi.50.1677093609427;
        Wed, 22 Feb 2023 11:20:09 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l64-20020a638843000000b004784cdc196dsm5105149pgd.24.2023.02.22.11.20.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Feb 2023 11:20:09 -0800 (PST)
Message-ID: <63f66ae9.630a0220.9c6fd.9b36@mx.google.com>
Date:   Wed, 22 Feb 2023 11:20:09 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.272-89-g1b36e402a6da
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 119 runs,
 13 regressions (v4.19.272-89-g1b36e402a6da)
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

stable-rc/queue/4.19 baseline: 119 runs, 13 regressions (v4.19.272-89-g1b36=
e402a6da)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
at91sam9g20ek              | arm   | lab-broonie   | gcc-10   | multi_v5_de=
fconfig  | 1          =

beaglebone-black           | arm   | lab-broonie   | gcc-10   | omap2plus_d=
efconfig | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-baylibre  | gcc-10   | defconfig  =
         | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig  =
         | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-collabora | gcc-10   | defconfig  =
         | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig  =
         | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig  =
         | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-baylibre  | gcc-10   | defconfig  =
         | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig  =
         | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig  =
         | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig  =
         | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig  =
         | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig  =
         | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.272-89-g1b36e402a6da/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.272-89-g1b36e402a6da
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1b36e402a6da4975211756da2ab35d29ad6d32c7 =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
at91sam9g20ek              | arm   | lab-broonie   | gcc-10   | multi_v5_de=
fconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/63f6317a8fde48ff348c866a

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.272=
-89-g1b36e402a6da/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sa=
m9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.272=
-89-g1b36e402a6da/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sa=
m9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63f6317a8fde48ff348c8673
        new failure (last pass: v4.19.272-89-ge538c4751892)

    2023-02-22T15:14:46.533220  + set +x
    2023-02-22T15:14:46.538287  <8><LAVA_SIGNAL_ENDRUN 0_dmesg 55347_1.5.2.=
4.1>
    2023-02-22T15:14:46.651724  / # #
    2023-02-22T15:14:46.754540  export SHELL=3D/bin/sh
    2023-02-22T15:14:46.755316  #
    2023-02-22T15:14:46.857198  / # export SHELL=3D/bin/sh. /lava-55347/env=
ironment
    2023-02-22T15:14:46.858043  =

    2023-02-22T15:14:46.960038  / # . /lava-55347/environment/lava-55347/bi=
n/lava-test-runner /lava-55347/1
    2023-02-22T15:14:46.961297  =

    2023-02-22T15:14:46.967688  / # /lava-55347/bin/lava-test-runner /lava-=
55347/1 =

    ... (12 line(s) more)  =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
beaglebone-black           | arm   | lab-broonie   | gcc-10   | omap2plus_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/63f630e85cb7a529a38c8648

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.272=
-89-g1b36e402a6da/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beagl=
ebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.272=
-89-g1b36e402a6da/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beagl=
ebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63f630e85cb7a529a38c8651
        failing since 1 day (last pass: v4.19.272-89-gffd5d7f695f9, first f=
ail: v4.19.272-89-ge538c4751892)

    2023-02-22T15:12:22.276396  + set +x<8>[   23.123832] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 55355_1.5.2.4.1>
    2023-02-22T15:12:22.277015  =

    2023-02-22T15:12:22.388818  / # #
    2023-02-22T15:12:22.491602  export SHELL=3D/bin/sh
    2023-02-22T15:12:22.492340  #
    2023-02-22T15:12:22.594741  / # export SHELL=3D/bin/sh. /lava-55355/env=
ironment
    2023-02-22T15:12:22.595474  =

    2023-02-22T15:12:22.697840  / # . /lava-55355/environment/lava-55355/bi=
n/lava-test-runner /lava-55355/1
    2023-02-22T15:12:22.699000  =

    2023-02-22T15:12:22.703799  / # /lava-55355/bin/lava-test-runner /lava-=
55355/1 =

    ... (12 line(s) more)  =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre  | gcc-10   | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/63f62f4cc0af581bc38c8634

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.272=
-89-g1b36e402a6da/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.272=
-89-g1b36e402a6da/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f62f4cc0af581bc38c8=
635
        failing since 211 days (last pass: v4.19.230-58-gbd840138c177, firs=
t fail: v4.19.253-43-g91137b502cfbd) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/63f62f5a2a16dfc16e8c8664

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.272=
-89-g1b36e402a6da/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.272=
-89-g1b36e402a6da/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f62f5a2a16dfc16e8c8=
665
        failing since 211 days (last pass: v4.19.230-58-gbd840138c177, firs=
t fail: v4.19.253-43-g91137b502cfbd) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-collabora | gcc-10   | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/63f62f018cfbf133ac8c8640

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.272=
-89-g1b36e402a6da/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-=
virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.272=
-89-g1b36e402a6da/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-=
virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f62f018cfbf133ac8c8=
641
        failing since 211 days (last pass: v4.19.230-58-gbd840138c177, firs=
t fail: v4.19.253-43-g91137b502cfbd) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/63f62f4f7ee3694e168c8643

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.272=
-89-g1b36e402a6da/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.272=
-89-g1b36e402a6da/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f62f4f7ee3694e168c8=
644
        failing since 288 days (last pass: v4.19.241-58-g5e77acf6dbb6, firs=
t fail: v4.19.241-83-g0ec5709aa1da) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/63f62f973054ee1b4e8c8652

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.272=
-89-g1b36e402a6da/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.272=
-89-g1b36e402a6da/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f62f973054ee1b4e8c8=
653
        failing since 288 days (last pass: v4.19.241-58-g5e77acf6dbb6, firs=
t fail: v4.19.241-83-g0ec5709aa1da) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-baylibre  | gcc-10   | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/63f62f512a16dfc16e8c862f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.272=
-89-g1b36e402a6da/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.272=
-89-g1b36e402a6da/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f62f512a16dfc16e8c8=
630
        failing since 211 days (last pass: v4.19.230-58-gbd840138c177, firs=
t fail: v4.19.253-43-g91137b502cfbd) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/63f62f993054ee1b4e8c8655

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.272=
-89-g1b36e402a6da/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.272=
-89-g1b36e402a6da/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f62f993054ee1b4e8c8=
656
        failing since 211 days (last pass: v4.19.230-58-gbd840138c177, firs=
t fail: v4.19.253-43-g91137b502cfbd) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/63f62f048cfbf133ac8c864a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.272=
-89-g1b36e402a6da/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-=
virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.272=
-89-g1b36e402a6da/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-=
virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f62f048cfbf133ac8c8=
64b
        failing since 211 days (last pass: v4.19.230-58-gbd840138c177, firs=
t fail: v4.19.253-43-g91137b502cfbd) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/63f62f4e7ee3694e168c863d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.272=
-89-g1b36e402a6da/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.272=
-89-g1b36e402a6da/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f62f4e7ee3694e168c8=
63e
        failing since 211 days (last pass: v4.19.230-58-gbd840138c177, firs=
t fail: v4.19.253-43-g91137b502cfbd) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/63f62f963054ee1b4e8c864e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.272=
-89-g1b36e402a6da/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.272=
-89-g1b36e402a6da/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f62f963054ee1b4e8c8=
64f
        failing since 211 days (last pass: v4.19.230-58-gbd840138c177, firs=
t fail: v4.19.253-43-g91137b502cfbd) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/63f62f028cfbf133ac8c8644

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.272=
-89-g1b36e402a6da/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-=
virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.272=
-89-g1b36e402a6da/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-=
virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f62f028cfbf133ac8c8=
645
        failing since 211 days (last pass: v4.19.230-58-gbd840138c177, firs=
t fail: v4.19.253-43-g91137b502cfbd) =

 =20
