Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C58D96E6F44
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 00:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbjDRWQU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 18:16:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232455AbjDRWQT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 18:16:19 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 564074C22
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 15:15:50 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-63b4bf2d74aso2231388b3a.2
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 15:15:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1681856149; x=1684448149;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=4PtV0vp+KR51hhTLgoc49SH7X+u9wvOHB44f8ZYA2EY=;
        b=FCV9MQHeRUR8vhq0/N7IYauLFySc+/PCexHdH0hrSq6BTP5O/QXamQXX8DNRJ6dI0l
         ktQnkDvJb2K2daiJBdGC7wQPNdzym8klSrNvle1w3GLns7gpruryZRhPbDkxURHNz0S7
         v7aLfzcJMtvYgznu4mUDYcVZWBbQa3hrHO3FzYcYiTcdBPlhQJ9jxGdufR5ztLfRbKj3
         DdmrwAc67ZpU2NyJbsgfRvxcQgu0MMkW3KHXD3dhrkNY52+whXrAQWihBJdsoWWcJ1IL
         LzFdtX8NrSjF+gdvI7gxGYjFSZpK5NYw1wTQvENKxzdwXAMpYG6zXrK1w9dEkZoA0AHX
         rvuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681856149; x=1684448149;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4PtV0vp+KR51hhTLgoc49SH7X+u9wvOHB44f8ZYA2EY=;
        b=My04BD8Bk7vu6FmDTUnx3f7uHDsvTkcjVvEVOvcryjzf3KSaRO3MuMc9D8GOkUTkGg
         8YR1FZzkbc5th6A71Lzp9UT/aaPn3IudOOTA7i+gwr7uaW3LUwjtAyMx1Snuq0napl15
         syXDFXAIA8BD6kRujvZtPPf33ArlqQAb7RIZl6XnwGX0upjQd1wEdFnxUqD32SXCxx+r
         qRpVzkMC6ecKOaZ7VRvKjKdeeit7Tj4fdAJid8bJfoZAacUMhfNqHz+HKpF6+rEbISoU
         6zfZCCXxEBwJ9rtaNnHgCODuU8CQ3pNZWgLZIqABQrA0THYb7lyU6jTZi8LNKcYDnnpb
         WLXw==
X-Gm-Message-State: AAQBX9exWYDnodLgvyP8aGJI1DEDR2wR/u/X93z/7/KdcMDSwdPhdYPu
        Y56OAr62LIh7SPwzbnGaqalo4BZeGsaNkLXDGuRsLzUA
X-Google-Smtp-Source: AKy350aQ7HV506nGPEADVlDL40ns/3BugCK1bJ14PzYsxWr6tMlLmImgxl8RFmIqdqeAmC2QAKRP8A==
X-Received: by 2002:a05:6a00:1409:b0:626:2ce1:263c with SMTP id l9-20020a056a00140900b006262ce1263cmr1313774pfu.5.1681856149047;
        Tue, 18 Apr 2023 15:15:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p15-20020aa7860f000000b005810c4286d6sm9804741pfn.0.2023.04.18.15.15.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 15:15:48 -0700 (PDT)
Message-ID: <643f1694.a70a0220.b1b96.6905@mx.google.com>
Date:   Tue, 18 Apr 2023 15:15:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.105-280-g0b6a5617247c
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.15.y baseline: 77 runs,
 10 regressions (v5.15.105-280-g0b6a5617247c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.15.y baseline: 77 runs, 10 regressions (v5.15.105-280-g0b=
6a5617247c)

Regressions Summary
-------------------

platform                  | arch  | lab             | compiler | defconfig =
         | regressions
--------------------------+-------+-----------------+----------+-----------=
---------+------------
cubietruck                | arm   | lab-baylibre    | gcc-10   | multi_v7_d=
efconfig | 1          =

hifive-unleashed-a00      | riscv | lab-baylibre    | gcc-10   | defconfig =
         | 1          =

imx53-qsrb                | arm   | lab-pengutronix | gcc-10   | multi_v7_d=
efconfig | 1          =

qemu_riscv64              | riscv | lab-baylibre    | gcc-10   | defconfig =
         | 1          =

qemu_riscv64              | riscv | lab-broonie     | gcc-10   | defconfig =
         | 1          =

qemu_riscv64              | riscv | lab-collabora   | gcc-10   | defconfig =
         | 1          =

qemu_smp8_riscv64         | riscv | lab-baylibre    | gcc-10   | defconfig =
         | 1          =

qemu_smp8_riscv64         | riscv | lab-broonie     | gcc-10   | defconfig =
         | 1          =

qemu_smp8_riscv64         | riscv | lab-collabora   | gcc-10   | defconfig =
         | 1          =

sun8i-h2-plus-orangepi-r1 | arm   | lab-baylibre    | gcc-10   | sunxi_defc=
onfig    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.105-280-g0b6a5617247c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.105-280-g0b6a5617247c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0b6a5617247cb685e4efb226d56074068ad8d0ce =



Test Regressions
---------------- =



platform                  | arch  | lab             | compiler | defconfig =
         | regressions
--------------------------+-------+-----------------+----------+-----------=
---------+------------
cubietruck                | arm   | lab-baylibre    | gcc-10   | multi_v7_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/643ee5e2fd4fb2b8e72e861e

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-280-g0b6a5617247c/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cu=
bietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-280-g0b6a5617247c/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cu=
bietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ee5e2fd4fb2b8e72e8623
        failing since 91 days (last pass: v5.15.82-124-gd731c63c25d1, first=
 fail: v5.15.87-101-g5bcc318cb4cd)

    2023-04-18T18:47:38.818173  + set +x<8>[    9.975529] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3508948_1.5.2.4.1>
    2023-04-18T18:47:38.818884  =

    2023-04-18T18:47:38.928180  / # #
    2023-04-18T18:47:39.031414  export SHELL=3D/bin/sh
    2023-04-18T18:47:39.032282  #
    2023-04-18T18:47:39.134297  / # export SHELL=3D/bin/sh. /lava-3508948/e=
nvironment
    2023-04-18T18:47:39.135353  =

    2023-04-18T18:47:39.237540  / # . /lava-3508948/environment/lava-350894=
8/bin/lava-test-runner /lava-3508948/1
    2023-04-18T18:47:39.239404  =

    2023-04-18T18:47:39.243970  / # /lava-3508948/bin/lava-test-runner /lav=
a-3508948/1 =

    ... (13 line(s) more)  =

 =



platform                  | arch  | lab             | compiler | defconfig =
         | regressions
--------------------------+-------+-----------------+----------+-----------=
---------+------------
hifive-unleashed-a00      | riscv | lab-baylibre    | gcc-10   | defconfig =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/643ee2e20c0dc09c632e85fa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-280-g0b6a5617247c/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-un=
leashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-280-g0b6a5617247c/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-un=
leashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643ee2e20c0dc09c632e8=
5fb
        new failure (last pass: v5.15.105-194-g415a9d81c640) =

 =



platform                  | arch  | lab             | compiler | defconfig =
         | regressions
--------------------------+-------+-----------------+----------+-----------=
---------+------------
imx53-qsrb                | arm   | lab-pengutronix | gcc-10   | multi_v7_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/643ee59da1303041382e8600

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-280-g0b6a5617247c/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline=
-imx53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-280-g0b6a5617247c/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline=
-imx53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ee59da1303041382e8605
        failing since 78 days (last pass: v5.15.81-122-gc5f8d4a5d3c8, first=
 fail: v5.15.90-205-g5605d15db022)

    2023-04-18T18:46:28.070315  + set +x
    2023-04-18T18:46:28.070500  [    9.352125] <LAVA_SIGNAL_ENDRUN 0_dmesg =
929860_1.5.2.3.1>
    2023-04-18T18:46:28.178012  / # #
    2023-04-18T18:46:28.279484  export SHELL=3D/bin/sh
    2023-04-18T18:46:28.279803  #
    2023-04-18T18:46:28.380964  / # export SHELL=3D/bin/sh. /lava-929860/en=
vironment
    2023-04-18T18:46:28.381405  =

    2023-04-18T18:46:28.482677  / # . /lava-929860/environment/lava-929860/=
bin/lava-test-runner /lava-929860/1
    2023-04-18T18:46:28.483261  =

    2023-04-18T18:46:28.486139  / # /lava-929860/bin/lava-test-runner /lava=
-929860/1 =

    ... (12 line(s) more)  =

 =



platform                  | arch  | lab             | compiler | defconfig =
         | regressions
--------------------------+-------+-----------------+----------+-----------=
---------+------------
qemu_riscv64              | riscv | lab-baylibre    | gcc-10   | defconfig =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/643ee23065dcaa43cb2e8623

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-280-g0b6a5617247c/riscv/defconfig/gcc-10/lab-baylibre/baseline-qemu_risc=
v64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-280-g0b6a5617247c/riscv/defconfig/gcc-10/lab-baylibre/baseline-qemu_risc=
v64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643ee23065dcaa43cb2e8=
624
        new failure (last pass: v5.15.105-194-g415a9d81c640) =

 =



platform                  | arch  | lab             | compiler | defconfig =
         | regressions
--------------------------+-------+-----------------+----------+-----------=
---------+------------
qemu_riscv64              | riscv | lab-broonie     | gcc-10   | defconfig =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/643f016681d39b46532e85fa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-280-g0b6a5617247c/riscv/defconfig/gcc-10/lab-broonie/baseline-qemu_riscv=
64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-280-g0b6a5617247c/riscv/defconfig/gcc-10/lab-broonie/baseline-qemu_riscv=
64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643f016681d39b46532e8=
5fb
        new failure (last pass: v5.15.105-194-g415a9d81c640) =

 =



platform                  | arch  | lab             | compiler | defconfig =
         | regressions
--------------------------+-------+-----------------+----------+-----------=
---------+------------
qemu_riscv64              | riscv | lab-collabora   | gcc-10   | defconfig =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/643ee1fe56558f9d292e85ff

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-280-g0b6a5617247c/riscv/defconfig/gcc-10/lab-collabora/baseline-qemu_ris=
cv64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-280-g0b6a5617247c/riscv/defconfig/gcc-10/lab-collabora/baseline-qemu_ris=
cv64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643ee1fe56558f9d292e8=
600
        new failure (last pass: v5.15.105-194-g415a9d81c640) =

 =



platform                  | arch  | lab             | compiler | defconfig =
         | regressions
--------------------------+-------+-----------------+----------+-----------=
---------+------------
qemu_smp8_riscv64         | riscv | lab-baylibre    | gcc-10   | defconfig =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/643ee22fd765cbda022e85f5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-280-g0b6a5617247c/riscv/defconfig/gcc-10/lab-baylibre/baseline-qemu_smp8=
_riscv64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-280-g0b6a5617247c/riscv/defconfig/gcc-10/lab-baylibre/baseline-qemu_smp8=
_riscv64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643ee22fd765cbda022e8=
5f6
        new failure (last pass: v5.15.105-194-g415a9d81c640) =

 =



platform                  | arch  | lab             | compiler | defconfig =
         | regressions
--------------------------+-------+-----------------+----------+-----------=
---------+------------
qemu_smp8_riscv64         | riscv | lab-broonie     | gcc-10   | defconfig =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/643f0152aaa6be72972e85ef

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-280-g0b6a5617247c/riscv/defconfig/gcc-10/lab-broonie/baseline-qemu_smp8_=
riscv64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-280-g0b6a5617247c/riscv/defconfig/gcc-10/lab-broonie/baseline-qemu_smp8_=
riscv64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643f0152aaa6be72972e8=
5f0
        new failure (last pass: v5.15.105-194-g415a9d81c640) =

 =



platform                  | arch  | lab             | compiler | defconfig =
         | regressions
--------------------------+-------+-----------------+----------+-----------=
---------+------------
qemu_smp8_riscv64         | riscv | lab-collabora   | gcc-10   | defconfig =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/643ee1ff8c98a5a4ae2e85f3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-280-g0b6a5617247c/riscv/defconfig/gcc-10/lab-collabora/baseline-qemu_smp=
8_riscv64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-280-g0b6a5617247c/riscv/defconfig/gcc-10/lab-collabora/baseline-qemu_smp=
8_riscv64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643ee1ff8c98a5a4ae2e8=
5f4
        new failure (last pass: v5.15.105-194-g415a9d81c640) =

 =



platform                  | arch  | lab             | compiler | defconfig =
         | regressions
--------------------------+-------+-----------------+----------+-----------=
---------+------------
sun8i-h2-plus-orangepi-r1 | arm   | lab-baylibre    | gcc-10   | sunxi_defc=
onfig    | 1          =


  Details:     https://kernelci.org/test/plan/id/643ee2cc6e7dd8ed202e85f9

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-280-g0b6a5617247c/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i=
-h2-plus-orangepi-r1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
05-280-g0b6a5617247c/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i=
-h2-plus-orangepi-r1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ee2cc6e7dd8ed202e85fe
        failing since 6 days (last pass: v5.15.82-124-g2b8b2c150867, first =
fail: v5.15.105-194-g415a9d81c640)

    2023-04-18T18:34:40.609835  <8>[    5.791359] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3508893_1.5.2.4.1>
    2023-04-18T18:34:40.729231  / # #
    2023-04-18T18:34:40.834830  export SHELL=3D/bin/sh
    2023-04-18T18:34:40.836369  #
    2023-04-18T18:34:40.939703  / # export SHELL=3D/bin/sh. /lava-3508893/e=
nvironment
    2023-04-18T18:34:40.941229  =

    2023-04-18T18:34:41.044650  / # . /lava-3508893/environment/lava-350889=
3/bin/lava-test-runner /lava-3508893/1
    2023-04-18T18:34:41.047433  =

    2023-04-18T18:34:41.054385  / # /lava-3508893/bin/lava-test-runner /lav=
a-3508893/1
    2023-04-18T18:34:41.174142  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =20
