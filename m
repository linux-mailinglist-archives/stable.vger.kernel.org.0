Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92E5266A51F
	for <lists+stable@lfdr.de>; Fri, 13 Jan 2023 22:30:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbjAMVaI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Jan 2023 16:30:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbjAMVaH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Jan 2023 16:30:07 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 553C57A397
        for <stable@vger.kernel.org>; Fri, 13 Jan 2023 13:30:01 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id bj3so20444538pjb.0
        for <stable@vger.kernel.org>; Fri, 13 Jan 2023 13:30:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=FUtNotmz7apjri/FnupdDyciEo8UAxbYw8f81qVNfjY=;
        b=uXOfdmIO/F30UDueK60wP8t2Io2bMGiJ8i5yy8TKGM/cu00YiUw7UmG+hkjkegHaJ8
         GNBJjKX5p5Zgb2Ju0Djmuvz+H9ZhyZPUCoCM/YPvB/dkWaAIFA4IYSLIKpkGPaHxB1s8
         OEwrJLToAWA+N3n6TFRKOCzyElyAAhi9YICuF5hlnyjCBP1GWFHXmjw0bhUjI2g8veTT
         GOXeaoT290y/Z1wRk7sAyfdk5Utv798HVcW0/0FfvHKTvG8ckVFcS9vaZYVGZX8HIWwZ
         LX8i+kb1Q15mgqXUqwELKqZoWNTRBvdujNpLfGF4VNw2wjqCaEjzYb8htj98xTlbXIsJ
         3r8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FUtNotmz7apjri/FnupdDyciEo8UAxbYw8f81qVNfjY=;
        b=VDe3Sn8g5VcMrMzka1lGeXJykSTV/DmorENKv2TsNPm2SBkevtiZBZAjPZvuO6m1mi
         JoLz2Wiw4FMgr4KT9J+ibBmrHtQ3oFL5nBY3soszKakntAoh7+nbXjoG4KyK5gyg3dQB
         lgTOmmFR6SjeOTPcfoyS/9MzyV/jvVQ2530W/nKj2wDzyfcuwnQJGELm6JJVx3+E25Lt
         ySVUA9qbiK1d5Raa/3nOE07OApEbFv8fwpfhduPPwh1OaJ8SNEvXwX2oMOXCMUk0JtDH
         zRoWRPBRLw6DeGoj74GYl0zZd57cvihNO1bacpmzvDUli6x9aE3HPmhxVYYlLlYDyT0d
         uu0w==
X-Gm-Message-State: AFqh2kq/d3aQX25gDSLF8XSC0WrIPWTsYiEXNG+XryDh27kU49SRvYu6
        oYw8zJsqkgReEOgsmG2Qlq6/F7zjW/CwxX206PbG2w==
X-Google-Smtp-Source: AMrXdXvgR8YZP4S8Wj0X6HARP/347pS7iWpHk7cIx3Ys8lshHatY0rdPuJWWmqs6FDpISqvWOmUl2w==
X-Received: by 2002:a05:6a20:4e09:b0:b6:9b11:ff79 with SMTP id gk9-20020a056a204e0900b000b69b11ff79mr5308613pzb.34.1673645400460;
        Fri, 13 Jan 2023 13:30:00 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r33-20020a635161000000b0046f56534d9fsm11958533pgl.21.2023.01.13.13.29.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 13:30:00 -0800 (PST)
Message-ID: <63c1cd58.630a0220.6dae6.3042@mx.google.com>
Date:   Fri, 13 Jan 2023 13:30:00 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.228-605-g10948214f145
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 94 runs,
 10 regressions (v5.4.228-605-g10948214f145)
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

stable-rc/queue/5.4 baseline: 94 runs, 10 regressions (v5.4.228-605-g109482=
14f145)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
bcm2835-rpi-b-rev2         | arm   | lab-broonie   | gcc-10   | bcm2835_def=
config          | 1          =

odroid-xu3                 | arm   | lab-collabora | gcc-10   | multi_v7_de=
fconfig         | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.228-605-g10948214f145/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.228-605-g10948214f145
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      10948214f145bb719c3bb562c8776464f5315c98 =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
bcm2835-rpi-b-rev2         | arm   | lab-broonie   | gcc-10   | bcm2835_def=
config          | 1          =


  Details:     https://kernelci.org/test/plan/id/63c19800c75af031e11d39c9

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-6=
05-g10948214f145/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-=
rpi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-6=
05-g10948214f145/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-=
rpi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230109.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63c19800c75af031e11d39ce
        failing since 3 days (last pass: v5.4.228-542-gef9f34da2ed1f, first=
 fail: v5.4.228-590-g9476d91a56e1)

    2023-01-13T17:42:04.263597  + set +x
    2023-01-13T17:42:04.266955  <8>[   16.936718] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 108289_1.5.2.4.1>
    2023-01-13T17:42:04.384467  / # #
    2023-01-13T17:42:04.485924  export SHELL=3D/bin/sh
    2023-01-13T17:42:04.486269  #
    2023-01-13T17:42:04.587378  / # export SHELL=3D/bin/sh. /lava-108289/en=
vironment
    2023-01-13T17:42:04.587820  =

    2023-01-13T17:42:04.688988  / # . /lava-108289/environment/lava-108289/=
bin/lava-test-runner /lava-108289/1
    2023-01-13T17:42:04.689486  =

    2023-01-13T17:42:04.695900  / # /lava-108289/bin/lava-test-runner /lava=
-108289/1 =

    ... (13 line(s) more)  =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
odroid-xu3                 | arm   | lab-collabora | gcc-10   | multi_v7_de=
fconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63c1998c86f65821051d39c7

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-6=
05-g10948214f145/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-odroi=
d-xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-6=
05-g10948214f145/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-odroi=
d-xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230109.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63c1998c86f65821051d39cc
        failing since 3 days (last pass: v5.4.228-542-gef9f34da2ed1f, first=
 fail: v5.4.228-590-g9476d91a56e1)

    2023-01-13T17:48:22.380593  / # #
    2023-01-13T17:48:22.482419  export SHELL=3D/bin/sh
    2023-01-13T17:48:22.482998  #
    2023-01-13T17:48:22.584365  / # export SHELL=3D/bin/sh. /lava-8709567/e=
nvironment
    2023-01-13T17:48:22.585010  =

    2023-01-13T17:48:22.686417  / # . /lava-8709567/environment/lava-870956=
7/bin/lava-test-runner /lava-8709567/1
    2023-01-13T17:48:22.687196  =

    2023-01-13T17:48:22.690508  / # /lava-8709567/bin/lava-test-runner /lav=
a-8709567/1
    2023-01-13T17:48:22.779943  + export 'TESTRUN_ID=3D1_bootrr'
    2023-01-13T17:48:22.780260  + cd /lava-8709567/1/tests/1_bootrr =

    ... (15 line(s) more)  =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63c19d7603bcec0c7c1d39f4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-6=
05-g10948214f145/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-6=
05-g10948214f145/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230109.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63c19d7603bcec0c7c1d3=
9f5
        failing since 171 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63c19b290c2be40e191d39c3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-6=
05-g10948214f145/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-6=
05-g10948214f145/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230109.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63c19b290c2be40e191d3=
9c4
        failing since 171 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63c19d6003bcec0c7c1d39cd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-6=
05-g10948214f145/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-6=
05-g10948214f145/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230109.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63c19d6003bcec0c7c1d3=
9ce
        failing since 171 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63c19b2612961cba0d1d39c2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-6=
05-g10948214f145/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-6=
05-g10948214f145/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230109.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63c19b2612961cba0d1d3=
9c3
        failing since 171 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63c19d7403bcec0c7c1d39f1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-6=
05-g10948214f145/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-6=
05-g10948214f145/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230109.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63c19d7403bcec0c7c1d3=
9f2
        failing since 171 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63c19b28d72d7d98491d39fa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-6=
05-g10948214f145/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-6=
05-g10948214f145/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230109.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63c19b28d72d7d98491d3=
9fb
        failing since 171 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63c19d6103bcec0c7c1d39d0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-6=
05-g10948214f145/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-6=
05-g10948214f145/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230109.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63c19d6103bcec0c7c1d3=
9d1
        failing since 171 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63c19b3ac65d3beb831d39c3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-6=
05-g10948214f145/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-6=
05-g10948214f145/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230109.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63c19b3ac65d3beb831d3=
9c4
        failing since 171 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =20
