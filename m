Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86F5C5E914E
	for <lists+stable@lfdr.de>; Sun, 25 Sep 2022 08:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbiIYG7u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Sep 2022 02:59:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiIYG7t (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 25 Sep 2022 02:59:49 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4388AE002
        for <stable@vger.kernel.org>; Sat, 24 Sep 2022 23:59:43 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id b5so3906351pgb.6
        for <stable@vger.kernel.org>; Sat, 24 Sep 2022 23:59:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=OjzhoYlvoOj7ElNV5386ysrO+pMEThEWCskH426OBuA=;
        b=58qjoNiWgjT4pPTQYldPyYaa8LYzaW0sLEdcwyaxHGCxWfyyWtMVXFj7xCT/pHSbO5
         /FIZRcnGbGAl66C2gB6aHnjOijMDTnpI6VGYsRSJhKOeM4Xw+5hLvhfmAuEafWoO9fSI
         P1lizS7ztnTBURVBVU7NDKKZr0zlpVywvFiSfgfxzHp+hBy9POUy7imAuH1xivJbLjsR
         Y6b3Y+krQCfyuOyegKcuiMEGAEIj8sbJ2Jr+jX1JXbfyu/3JfAxB9oXjMqhRjCB567tP
         /FW58HenMIhZfjdHNM/liR4muRhipxOvnkfJrrNJvEI/iXK8za3+akHuuXYCpMMGsF8n
         3vHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=OjzhoYlvoOj7ElNV5386ysrO+pMEThEWCskH426OBuA=;
        b=tzYoJit/phsFoLeoBUzksXD3sNR6TdWihLp1g4AlRx/20rAuGPDvgEruVJXCEZsVmk
         apaM72mIidBggV6Iq6JsnQNG8UVP0u6dZlnlIgrDuixZHRORW2C21EOwEbj5W9Nhj3i5
         jdnQSoJ9A6TTA5R5M2L1C4uwXIjuF2A0oXFSVjmchDpKEnNqU1TqeO3ovWGWkrg0XNA6
         4Swfxb2wyw6C5x2Zqu/eL5WbNEqRT4Na1xg1MdV/1SDUCsd1crmg8ibKD7H8eZAl04+q
         T9iBAdu2hPNPgIUpT6DxQGx1xtm6obiN60OnApyqxrCCnLY1pt4Gy664KAlnWZa1Oyig
         +Q6g==
X-Gm-Message-State: ACrzQf0b8FisKMru1a809UWJgZjUuI75ukHXwtp4WCaT07tStmfL4/4k
        xZrk79fzbJwbvpraDJrILI6g7rRr3UN41CgRy4g=
X-Google-Smtp-Source: AMsMyM5Ssfp9QjUa+1XJtignkxeKzc8Hy+xKPUU9DBV/yIr+O1DczxxyndGChTseXvDe0jjt8s+2ig==
X-Received: by 2002:a63:120b:0:b0:43c:771b:4c52 with SMTP id h11-20020a63120b000000b0043c771b4c52mr6026312pgl.370.1664089182192;
        Sat, 24 Sep 2022 23:59:42 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b13-20020aa7950d000000b005546fe4b127sm7143673pfp.78.2022.09.24.23.59.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Sep 2022 23:59:41 -0700 (PDT)
Message-ID: <632ffc5d.a70a0220.dae73.e481@mx.google.com>
Date:   Sat, 24 Sep 2022 23:59:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.145-119-g0ed01873ed141
Subject: stable-rc/queue/5.10 baseline: 176 runs,
 20 regressions (v5.10.145-119-g0ed01873ed141)
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

stable-rc/queue/5.10 baseline: 176 runs, 20 regressions (v5.10.145-119-g0ed=
01873ed141)

Regressions Summary
-------------------

platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
am57xx-beagle-x15          | arm   | lab-linaro-lkft | gcc-10   | multi_v7_=
defconfig         | 2          =

panda                      | arm   | lab-baylibre    | gcc-10   | multi_v7_=
defconfig         | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-broonie     | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-broonie     | gcc-10   | defconfig=
                  | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-collabora   | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-collabora   | gcc-10   | defconfig=
                  | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie     | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie     | gcc-10   | defconfig=
                  | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora   | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora   | gcc-10   | defconfig=
                  | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie     | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie     | gcc-10   | defconfig=
                  | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-collabora   | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-collabora   | gcc-10   | defconfig=
                  | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie     | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie     | gcc-10   | defconfig=
                  | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora   | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora   | gcc-10   | defconfig=
                  | 1          =

rk3399-gru-kevin           | arm64 | lab-collabora   | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.145-119-g0ed01873ed141/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.145-119-g0ed01873ed141
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0ed01873ed141e2095cc1e0545ab5a54a55c99a6 =



Test Regressions
---------------- =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
am57xx-beagle-x15          | arm   | lab-linaro-lkft | gcc-10   | multi_v7_=
defconfig         | 2          =


  Details:     https://kernelci.org/test/plan/id/632fc9683345f4712635566c

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-119-g0ed01873ed141/arm/multi_v7_defconfig/gcc-10/lab-linaro-lkft/baseline-=
am57xx-beagle-x15.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-119-g0ed01873ed141/arm/multi_v7_defconfig/gcc-10/lab-linaro-lkft/baseline-=
am57xx-beagle-x15.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.all-cpus-are-online: https://kernelci.org/test/case/id/=
632fc9683345f47126355670
        new failure (last pass: v5.10.145-61-gab7e1784ec88)

    2022-09-25T03:22:09.845485  /lava-5581436/1/../bin/lava-test-case
    2022-09-25T03:22:09.903975  <8>[   29.401580] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dall-cpus-are-online RESULT=3Dfail>
    2022-09-25T03:22:09.904284  /lava-5581436/1/../bin/lava-test-case   =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/632fc9683345f471=
26355673
        new failure (last pass: v5.10.145-61-gab7e1784ec88)
        1 lines

    2022-09-25T03:22:06.740174  / # =

    2022-09-25T03:22:06.747607  =

    2022-09-25T03:22:06.852099  / # #
    2022-09-25T03:22:06.859453  #
    2022-09-25T03:22:06.961098  / # export SHELL=3D/bin/sh
    2022-09-25T03:22:06.971392  export SHELL=3D/bin/sh
    2022-09-25T03:22:07.072857  / # . /lava-5581436/environment
    2022-09-25T03:22:07.083286  . /lava-5581436/environment
    2022-09-25T03:22:07.184745  / # /lava-5581436/bin/lava-test-runner /lav=
a-5581436/0
    2022-09-25T03:22:07.195216  /lava-5581436/bin/lava-test-runner /lava-55=
81436/0 =

    ... (8 line(s) more)  =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
panda                      | arm   | lab-baylibre    | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/632fcf708e9963d4dc355651

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-119-g0ed01873ed141/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-119-g0ed01873ed141/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632fcf708e9963d4dc355=
652
        failing since 33 days (last pass: v5.10.136-539-g2b0d128e38cdb, fir=
st fail: v5.10.137-150-g8b56d7183e67) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie     | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/632fca859a35cbb5fc355657

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-119-g0ed01873ed141/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-119-g0ed01873ed141/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632fca859a35cbb5fc355=
658
        failing since 137 days (last pass: v5.10.113-129-g2a88b987a070, fir=
st fail: v5.10.113-199-g20397cd2a67b) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie     | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/632fd07674e8f5d273355656

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-119-g0ed01873ed141/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-119-g0ed01873ed141/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632fd07674e8f5d273355=
657
        failing since 137 days (last pass: v5.10.113-129-g2a88b987a070, fir=
st fail: v5.10.113-195-g7c30a988fd24) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-collabora   | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/632fd58cd64e2f6278355646

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-119-g0ed01873ed141/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-119-g0ed01873ed141/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632fd58cd64e2f6278355=
647
        failing since 137 days (last pass: v5.10.113-129-g2a88b987a070, fir=
st fail: v5.10.113-199-g20397cd2a67b) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-collabora   | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/632feb218818f96f69355659

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-119-g0ed01873ed141/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm6=
4-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-119-g0ed01873ed141/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm6=
4-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632feb218818f96f69355=
65a
        failing since 137 days (last pass: v5.10.113-129-g2a88b987a070, fir=
st fail: v5.10.113-195-g7c30a988fd24) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie     | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/632fca8797d3f019df355675

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-119-g0ed01873ed141/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-119-g0ed01873ed141/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632fca8797d3f019df355=
676
        failing since 137 days (last pass: v5.10.113-129-g2a88b987a070, fir=
st fail: v5.10.113-199-g20397cd2a67b) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie     | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/632fd13ef57f5300b3355645

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-119-g0ed01873ed141/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-119-g0ed01873ed141/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632fd13ff57f5300b3355=
646
        failing since 137 days (last pass: v5.10.113-129-g2a88b987a070, fir=
st fail: v5.10.113-195-g7c30a988fd24) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora   | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/632fd630cfaa1a460d355677

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-119-g0ed01873ed141/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-119-g0ed01873ed141/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632fd630cfaa1a460d355=
678
        failing since 137 days (last pass: v5.10.113-129-g2a88b987a070, fir=
st fail: v5.10.113-199-g20397cd2a67b) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora   | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/632febd4671d6a8452355656

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-119-g0ed01873ed141/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm6=
4-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-119-g0ed01873ed141/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm6=
4-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632febd4671d6a8452355=
657
        failing since 137 days (last pass: v5.10.113-129-g2a88b987a070, fir=
st fail: v5.10.113-195-g7c30a988fd24) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie     | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/632fcb9e83ff1496b435565e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-119-g0ed01873ed141/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-119-g0ed01873ed141/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632fcb9e83ff1496b4355=
65f
        failing since 137 days (last pass: v5.10.113-129-g2a88b987a070, fir=
st fail: v5.10.113-199-g20397cd2a67b) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie     | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/632fd03c465aa6d852355646

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-119-g0ed01873ed141/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-119-g0ed01873ed141/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632fd03c465aa6d852355=
647
        failing since 137 days (last pass: v5.10.113-129-g2a88b987a070, fir=
st fail: v5.10.113-195-g7c30a988fd24) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-collabora   | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/632fd7e8481a998be3355679

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-119-g0ed01873ed141/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-119-g0ed01873ed141/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632fd7e8481a998be3355=
67a
        failing since 137 days (last pass: v5.10.113-129-g2a88b987a070, fir=
st fail: v5.10.113-199-g20397cd2a67b) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-collabora   | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/632fead352477444d135565f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-119-g0ed01873ed141/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm6=
4-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-119-g0ed01873ed141/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm6=
4-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632fead352477444d1355=
660
        failing since 137 days (last pass: v5.10.113-129-g2a88b987a070, fir=
st fail: v5.10.113-195-g7c30a988fd24) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie     | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/632fcaad8a4250272b355657

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-119-g0ed01873ed141/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-119-g0ed01873ed141/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632fcaad8a4250272b355=
658
        failing since 137 days (last pass: v5.10.113-129-g2a88b987a070, fir=
st fail: v5.10.113-199-g20397cd2a67b) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie     | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/632fd03a32dec55f7e35565c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-119-g0ed01873ed141/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-119-g0ed01873ed141/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632fd03a32dec55f7e355=
65d
        failing since 137 days (last pass: v5.10.113-129-g2a88b987a070, fir=
st fail: v5.10.113-195-g7c30a988fd24) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora   | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/632fd6e1fd2c92e460355660

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-119-g0ed01873ed141/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-119-g0ed01873ed141/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632fd6e1fd2c92e460355=
661
        failing since 137 days (last pass: v5.10.113-129-g2a88b987a070, fir=
st fail: v5.10.113-199-g20397cd2a67b) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora   | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/632feaa87def26e3b4355643

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-119-g0ed01873ed141/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm6=
4-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-119-g0ed01873ed141/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm6=
4-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632feaa87def26e3b4355=
644
        failing since 137 days (last pass: v5.10.113-129-g2a88b987a070, fir=
st fail: v5.10.113-195-g7c30a988fd24) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
rk3399-gru-kevin           | arm64 | lab-collabora   | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/632fcc8142e38c3477355693

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-119-g0ed01873ed141/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-119-g0ed01873ed141/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/632fcc8142e38c34773556b9
        failing since 201 days (last pass: v5.10.103-56-ge5a40f18f4ce, firs=
t fail: v5.10.103-105-gf074cce6ae0d)

    2022-09-25T03:35:05.951456  /lava-7384333/1/../bin/lava-test-case
    2022-09-25T03:35:05.962135  <8>[   34.509114] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
