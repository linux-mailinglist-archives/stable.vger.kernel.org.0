Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8FA96189E3
	for <lists+stable@lfdr.de>; Thu,  3 Nov 2022 21:48:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbiKCUsf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Nov 2022 16:48:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiKCUse (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Nov 2022 16:48:34 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4B6D1EAFF
        for <stable@vger.kernel.org>; Thu,  3 Nov 2022 13:48:32 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id io19so3051307plb.8
        for <stable@vger.kernel.org>; Thu, 03 Nov 2022 13:48:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=KEfRorRZBQq985sIU/mdGxM4/bupyynn3XgqY9ntr1g=;
        b=KwUdRnakD7fnsq2yhsiQpIX+oxtYo2tw9rrGjDJOiQiPlTp/bXwGv9znVRjZdza3jw
         TiZ6/x+FBMUKpNlQ5e7P7eN+q5fQiJYPFl+gFAXvxu00ytto1xjsbaGcYUlw32MATYkB
         FXtH8rgeD+rUiaJ2ihSIYgex+RRrpgY/ZrFInzCfP+dhzdC2siYIu0nokkm9ERkK/Oz0
         VQLnqtUevxX5nOpJCYCPS0ZiW1iNKObbToAQGmRIqnJHohSgqNar93Ol950pD4fqV49W
         ngoVkrq8yLeqW7NVO71f9pGarst8aVhVi+pUUka15NwxWACN3w6Dfb2QOP2RAs01h11E
         saxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KEfRorRZBQq985sIU/mdGxM4/bupyynn3XgqY9ntr1g=;
        b=tQUcKvFyzYU8j5Hplm6zkacHu9bwx+mxVDamGYIjE2IIxCJj4HLdgl6q7m+HUU6dji
         QSmLgYemDXWzM+qmjCHbm/Q1rT0uucvtTgYi1DLyOASObMZuPztHl4ztQmIzeIDnzWPu
         IZacjo0Blo7NreKivPzf4CrcZXpo76KSlq8N2V7mfacuX9WcArqEmp2LzFP4UiY8ORVg
         czItAVISSgjbW6W75HpJWDUqi3JjRoMgK+kksg+akYxxGjlxYCe86biF05jbDf1s/cQi
         mJSOBLHUqhddHm5IUWQGVrIGXemtJqQubGs/UtUoTdF7/M9rgCbnP8OC92YpcV9lMwns
         kM5g==
X-Gm-Message-State: ACrzQf3/KXpGoQa3v4LBID+sq0svgc/ZUtHQDSZIEj26JEISDBTEE8tQ
        vFOD/gQpb+L05a9WQDNph+XaUD1uwXlb8Y6V
X-Google-Smtp-Source: AMsMyM6yBfQ+OmkS0qLlu1UjGIFXSwSn3w6zaz12obS3NSglyXcPoPd5JhpBswqMSwtH6qSDqTyENw==
X-Received: by 2002:a17:902:7b91:b0:185:4548:3a96 with SMTP id w17-20020a1709027b9100b0018545483a96mr31621135pll.130.1667508512005;
        Thu, 03 Nov 2022 13:48:32 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n6-20020a170902e54600b00186afd756edsm1036281plf.283.2022.11.03.13.48.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 13:48:31 -0700 (PDT)
Message-ID: <6364291f.170a0220.21b3e.252f@mx.google.com>
Date:   Thu, 03 Nov 2022 13:48:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.223
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.4.y baseline: 87 runs, 12 regressions (v5.4.223)
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

stable/linux-5.4.y baseline: 87 runs, 12 regressions (v5.4.223)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
hifive-unleashed-a00       | riscv | lab-baylibre  | gcc-10   | defconfig  =
                | 2          =

qemu_arm64-virt-gicv2      | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

rk3399-gru-kevin           | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.223/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.223
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      a0d9384967214783a92973c920092b7251c03e57 =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
hifive-unleashed-a00       | riscv | lab-baylibre  | gcc-10   | defconfig  =
                | 2          =


  Details:     https://kernelci.org/test/plan/id/6363ebf29a6d69cfa2e7db56

  Results:     3 PASS, 2 FAIL, 2 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.223/ri=
scv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.223/ri=
scv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/riscv/rootfs.cpio.gz =



  * baseline.bootrr.all-cpus-are-online: https://kernelci.org/test/case/id/=
6363ebf29a6d69cfa2e7db5a
        failing since 7 days (last pass: v5.4.219, first fail: v5.4.220)

    2022-11-03T16:27:05.349078  sbin:/bin:/usr/bin'
    2022-11-03T16:27:05.349287  + cd /opt/bootrr
    2022-11-03T16:27:05.349438  + sh helpers/bootrr-auto
    2022-11-03T16:27:05.349600  /lava-2802836/1/../bin/lava-test-case
    2022-11-03T16:27:06.336132  /lava-2802836/1/../bin/lava-test-case
    2022-11-03T16:27:06.388550  <8>[   26.439348] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dall-cpus-are-online RESULT=3Dfail>   =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/6363ebf29a6d69cf=
a2e7db5f
        failing since 7 days (last pass: v5.4.219, first fail: v5.4.220)
        3 lines

    2022-11-03T16:26:52.089094  / # =

    2022-11-03T16:26:52.089981  =

    2022-11-03T16:26:54.154700  / # #
    2022-11-03T16:26:54.155375  #
    2022-11-03T16:26:56.168663  / # export SHELL=3D/bin/sh
    2022-11-03T16:26:56.169107  export SHELL=3D/bin/sh
    2022-11-03T16:26:58.184479  / # . /lava-2802836/environment
    2022-11-03T16:26:58.184863  . /lava-2802836/environment
    2022-11-03T16:27:00.200527  / # /lava-2802836/bin/lava-test-runner /lav=
a-2802836/0
    2022-11-03T16:27:00.201751  /lava-2802836/bin/lava-test-runner /lava-28=
02836/0 =

    ... (11 line(s) more)  =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6363efd18cc65c5230e7db55

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.223/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-virt=
-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.223/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-virt=
-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6363efd18cc65c5230e7d=
b56
        failing since 178 days (last pass: v5.4.190, first fail: v5.4.192) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6363f2f3380c588ed8e7db62

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.223/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-virt-=
gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.223/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-virt-=
gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6363f2f3380c588ed8e7d=
b63
        failing since 178 days (last pass: v5.4.190, first fail: v5.4.192) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6363efcf38f55329fde7db6e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.223/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-virt=
-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.223/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-virt=
-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6363efcf38f55329fde7d=
b6f
        failing since 36 days (last pass: v5.4.180, first fail: v5.4.215) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6363f19f28bab3e0a0e7db4f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.223/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-virt-=
gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.223/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-virt-=
gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6363f19f28bab3e0a0e7d=
b50
        failing since 36 days (last pass: v5.4.180, first fail: v5.4.215) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6363efc9535109f282e7db7c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.223/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-vir=
t-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.223/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-vir=
t-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6363efc9535109f282e7d=
b7d
        failing since 36 days (last pass: v5.4.180, first fail: v5.4.215) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6363efd207333404f7e7db4e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.223/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-virt=
-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.223/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-virt=
-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6363efd207333404f7e7d=
b4f
        failing since 178 days (last pass: v5.4.190, first fail: v5.4.192) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6363f307e6961fe3a2e7db56

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.223/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-virt-=
gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.223/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-virt-=
gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6363f307e6961fe3a2e7d=
b57
        failing since 178 days (last pass: v5.4.190, first fail: v5.4.192) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6363efd08cc65c5230e7db4f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.223/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-virt=
-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.223/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-virt=
-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6363efd08cc65c5230e7d=
b50
        failing since 178 days (last pass: v5.4.190, first fail: v5.4.192) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6363f1b363e4698337e7db53

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.223/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-virt-=
gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.223/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-virt-=
gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6363f1b363e4698337e7d=
b54
        failing since 178 days (last pass: v5.4.190, first fail: v5.4.192) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
rk3399-gru-kevin           | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6363ef6a41e17e4e59e7db7b

  Results:     88 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.223/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-kev=
in.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.223/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-kev=
in.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6363ef6a41e17e4e59e7db9d
        failing since 239 days (last pass: v5.4.181, first fail: v5.4.183)

    2022-11-03T16:41:54.866341  /lava-7835126/1/../bin/lava-test-case
    2022-11-03T16:41:54.874580  <8>[   32.720132] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
