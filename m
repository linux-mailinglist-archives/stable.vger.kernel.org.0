Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 901D9639138
	for <lists+stable@lfdr.de>; Fri, 25 Nov 2022 22:49:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbiKYVtA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Nov 2022 16:49:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiKYVs7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Nov 2022 16:48:59 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A63748740
        for <stable@vger.kernel.org>; Fri, 25 Nov 2022 13:48:57 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id q12so1069939pfn.10
        for <stable@vger.kernel.org>; Fri, 25 Nov 2022 13:48:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=oPjQE7wInJ2ROGIHrq8dEUEmtXmL9trJsNTvt9Wm8LU=;
        b=KqIk2njxN/VOvTMOmgOM2a3XoAZgtWVW9cq3eLXaVCUCd/cVrVlJ27FVOeVlqk35Rf
         XnzZW3qUGTA+yfBYdDlEWYBAVpQFa6hBhiQUajMb5u90rVsXEqlTbCElusmLf9kgQb2N
         3lk+pUEcWWW6NuozzcUpM4ru+xOxiejB4JegKeM0yueO+2pS0iQg+q2d46eMdtGuZL57
         l+elDHvQZgcxgV+lw/vckiEOZivd/iO7GYiwtm/tJrMAP1m/Kp3MRptgTLQDkjmt5ohF
         S1NTESZIEOinx8kD3RQSbEos0a22SKRhUw2rKrS1zMJQzR72SYuLIMfg5mujujNJoZ+R
         9lKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oPjQE7wInJ2ROGIHrq8dEUEmtXmL9trJsNTvt9Wm8LU=;
        b=AsMxxW+CZ6zJYqDppBFsb5AyvEkLP8FwbjfSN+FcAn6zZ657K5q8NMSvyyAGp0bHe6
         7yAnSqcHGw/QOHnO9vsece8v0yzqYCJ0EoyF34Ncyk+TJKpwCaN4TcV1FkQg95zYjPK+
         r1PiQ4Ez31ld4ffIX+5FC1oqtz1nndHabaOb3nhR6s9air0hOlYNAQ3uVmyWt0Y3W5H2
         CXOYFIgJ5yoWssBySQBZOOE1DpMWCX4fj8qC0eSExXAuUzaLAINq1Fs4nb1zg0F1J+29
         h82XpCLsiy7YaMhkZ5C3xURFlucIqzvGIQS6BllS4/daQKAx0bEDfzh8vhn3U5telp0v
         JBWQ==
X-Gm-Message-State: ANoB5pk/Cxv96+wYMVMEVB/gsgpLpX00XyiltgO57r4ntVvml5xPOpD/
        qzzrTmwDyxLKHawXHECy2AhwOfoJ6GT0qdOD9Fs=
X-Google-Smtp-Source: AA0mqf4l/JLTC9PomMzSOrxKmARRxEta5j85YScm1An+K+GgUJTaUGuT75Uy5bk70JvHotV71TD1uQ==
X-Received: by 2002:a63:883:0:b0:476:9983:b4b5 with SMTP id 125-20020a630883000000b004769983b4b5mr17507136pgi.516.1669412936577;
        Fri, 25 Nov 2022 13:48:56 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c6-20020a621c06000000b005748aca80fesm3546876pfc.32.2022.11.25.13.48.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Nov 2022 13:48:55 -0800 (PST)
Message-ID: <63813847.620a0220.c0b88.4cae@mx.google.com>
Date:   Fri, 25 Nov 2022 13:48:55 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.267
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
Subject: stable/linux-4.19.y baseline: 84 runs, 7 regressions (v4.19.267)
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

stable/linux-4.19.y baseline: 84 runs, 7 regressions (v4.19.267)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-baylibre  | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-baylibre  | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig  =
                | 1          =

r8a7743-iwg20d-q7          | arm   | lab-cip       | gcc-10   | shmobile_de=
fconfig         | 1          =

rk3399-gru-kevin           | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

sun8i-h3-orangepi-pc       | arm   | lab-clabbe    | gcc-10   | sunxi_defco=
nfig            | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.267/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.267
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      c1ccef20f08e192228a2056808113b453d18c094 =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/638120559312a1be122abd07

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.267/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.267/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/638120559312a1be122ab=
d08
        failing since 197 days (last pass: v4.19.239, first fail: v4.19.242=
) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre  | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/638121bc371f6e7d7a2abcfb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.267/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.267/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/638121bc371f6e7d7a2ab=
cfc
        failing since 197 days (last pass: v4.19.239, first fail: v4.19.242=
) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-baylibre  | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/638121a75acbdbda182abd04

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.267/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.267/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/638121a75acbdbda182ab=
d05
        failing since 197 days (last pass: v4.19.239, first fail: v4.19.242=
) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/638121a45acbdbda182abcfe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.267/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.267/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/638121a45acbdbda182ab=
cff
        failing since 197 days (last pass: v4.19.239, first fail: v4.19.242=
) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
r8a7743-iwg20d-q7          | arm   | lab-cip       | gcc-10   | shmobile_de=
fconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/638106f688a542f34a2abcff

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.267/=
arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.267/=
arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/638106f788a542f34a2ab=
d00
        new failure (last pass: v4.19.266) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
rk3399-gru-kevin           | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63810ef02e1c887aaf2abcfa

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.267/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.267/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/63810ef02e1c887aaf2abd1c
        failing since 254 days (last pass: v4.19.231, first fail: v4.19.235)

    2022-11-25T18:52:23.719925  /lava-8128979/1/../bin/lava-test-case
    2022-11-25T18:52:23.728190  <8>[   36.914107] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
sun8i-h3-orangepi-pc       | arm   | lab-clabbe    | gcc-10   | sunxi_defco=
nfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/638109f544638492d22abd10

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.267/=
arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-orangepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.267/=
arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-orangepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/638109f544638492d22ab=
d11
        new failure (last pass: v4.19.266) =

 =20
