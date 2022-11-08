Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E15FF621EB2
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 22:45:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbiKHVpo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 16:45:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbiKHVpn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 16:45:43 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27986222B1
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:45:41 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id q1-20020a17090a750100b002139ec1e999so96363pjk.1
        for <stable@vger.kernel.org>; Tue, 08 Nov 2022 13:45:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=qNwUaiHDVuZi3Il49fI3vYh0b/f2UAEql/TstCyF8Hw=;
        b=lWhNDbCmec5SasaNYqeD+V7CLclYt5ZrYNHOwmmP9pQ9ZJj3be2gCWf5Pr4Sh6Odvs
         wMWFD0rjL9ZhszXQLLX0/EwDkZ0mgY7imOZ+3QY4PwanuQ8nUjCvsnZx27b7wfriehFk
         kxqh/BAXBixcmkmLaK8F8PCsB6hIScPk/fh0obdCGFXZA7LKTYuB72aJGE2ugW0b+bAf
         V5Wi/avXRrNl4kdZ6TeWno1jxVA+NL5BBQXisXeE6u254gRPPoIXQAoJLH4Gv6HrOho/
         iZ6L4aQLHhWLnpPNOqel/iKu/gl4PuOPv903uySlMtrZrTshWXSYx8N0FfN05X0ZAMpA
         G+rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qNwUaiHDVuZi3Il49fI3vYh0b/f2UAEql/TstCyF8Hw=;
        b=eQ8a48J1D8uhwBZRTNBza1R1bJqlRmIlVFFaK0kwSv3hOOAbTlEI8QOQShIt6cWpDj
         1oCdhWo9hTeDwFzvLs0civbaQ4zJqiw7jYnfmK3fAZZkK43nFY3gktlR6QmrNx0qJ8uM
         R8mLfd8e+/2lpoW8tF4D+m2/Cg3nCSgtfMQ8es8tZGpk4IlZ+BFvQ4fTMT1AB5HGt+Dg
         sRn1I/c41jm8DgG3j1CcVX7Qa96zxyrtfq+XInCOtJQMqz89I/xLkEjOses1E5cv5bt8
         B9L19rFapMtWchviSJR298RxTLAhCcsZrTKyqdMN8akv2kHzVKxFD+C0qtQ7nAgOC3Wv
         55PQ==
X-Gm-Message-State: ACrzQf0SL3rrWJIfDTiW7oF9uHvDQGm+gyIEfGKsDU2bSTyGUTl6rHnZ
        qD98bL/0d5gpCnWvmKn0mj4tmmOp1s59qwf1
X-Google-Smtp-Source: AMsMyM52e5XyKjEg+0VyTrgMYceqvgi8bF8/qOiF5TX/Ipm1YuQxT2BuxN+h7dtAg7fqKoR0dWWgUg==
X-Received: by 2002:a17:902:b581:b0:186:fb90:1151 with SMTP id a1-20020a170902b58100b00186fb901151mr57869973pls.43.1667943940299;
        Tue, 08 Nov 2022 13:45:40 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b30-20020a62a11e000000b0056dde9895e2sm6825260pff.30.2022.11.08.13.45.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 13:45:39 -0800 (PST)
Message-ID: <636ace03.620a0220.cdf36.adbf@mx.google.com>
Date:   Tue, 08 Nov 2022 13:45:39 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.223-75-gdc8d80bb822a
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.4.y baseline: 134 runs,
 12 regressions (v5.4.223-75-gdc8d80bb822a)
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

stable-rc/linux-5.4.y baseline: 134 runs, 12 regressions (v5.4.223-75-gdc8d=
80bb822a)

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

qemu_arm64-virt-gicv2      | arm64 | lab-baylibre  | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-baylibre  | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig  =
                | 1          =

rk3399-gru-kevin           | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.223-75-gdc8d80bb822a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.223-75-gdc8d80bb822a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      dc8d80bb822aa0a393ccaa810d63be127d1bd864 =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
hifive-unleashed-a00       | riscv | lab-baylibre  | gcc-10   | defconfig  =
                | 2          =


  Details:     https://kernelci.org/test/plan/id/636a99432cb6e08cfae7db4e

  Results:     3 PASS, 2 FAIL, 2 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.223=
-75-gdc8d80bb822a/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unlea=
shed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.223=
-75-gdc8d80bb822a/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unlea=
shed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/riscv/rootfs.cpio.gz =



  * baseline.bootrr.all-cpus-are-online: https://kernelci.org/test/case/id/=
636a99432cb6e08cfae7db52
        failing since 20 days (last pass: v5.4.219, first fail: v5.4.219-26=
7-g4a976f825745)

    2022-11-08T18:00:19.602472  + sh helpers/bootrr-auto
    2022-11-08T18:00:19.603400  /lava-2824686/1/../bin/lava-test-case
    2022-11-08T18:00:20.607411  /lava-2824686/1/../bin/lava-test-case
    2022-11-08T18:00:20.608692  <8>[   11.848689] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dall-cpus-are-online RESULT=3Dfail>   =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/636a99432cb6e08c=
fae7db57
        failing since 20 days (last pass: v5.4.219, first fail: v5.4.219-26=
7-g4a976f825745)
        3 lines

    2022-11-08T18:00:18.508317  / # =

    2022-11-08T18:00:18.514219  =

    2022-11-08T18:00:18.621624  / # #
    2022-11-08T18:00:18.642490  #
    2022-11-08T18:00:18.745682  / # export SHELL=3D/bin/sh
    2022-11-08T18:00:18.754663  export SHELL=3D/bin/sh
    2022-11-08T18:00:18.857309  / # . /lava-2824686/environment
    2022-11-08T18:00:18.866497  . /lava-2824686/environment
    2022-11-08T18:00:18.969280  / # /lava-2824686/bin/lava-test-runner /lav=
a-2824686/0
    2022-11-08T18:00:18.978739  /lava-2824686/bin/lava-test-runner /lava-28=
24686/0 =

    ... (10 line(s) more)  =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/636a9bcbb1bde2ccc8e7db93

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.223=
-75-gdc8d80bb822a/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.223=
-75-gdc8d80bb822a/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/636a9bcbb1bde2ccc8e7d=
b94
        failing since 182 days (last pass: v5.4.191-85-ga4a4cbb41380, first=
 fail: v5.4.191-118-g7dae5fe9ddc0) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre  | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/636a9c2d05b31d142de7db6b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.223=
-75-gdc8d80bb822a/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.223=
-75-gdc8d80bb822a/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/636a9c2d05b31d142de7d=
b6c
        failing since 182 days (last pass: v5.4.191-85-ga4a4cbb41380, first=
 fail: v5.4.191-118-g7dae5fe9ddc0) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/636a9bc88ca0e8fe1fe7db83

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.223=
-75-gdc8d80bb822a/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.223=
-75-gdc8d80bb822a/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/636a9bc88ca0e8fe1fe7d=
b84
        failing since 182 days (last pass: v5.4.191-84-gbea55d0a1d975, firs=
t fail: v5.4.191-118-g7dae5fe9ddc0) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/636a9c308cfa523ad4e7db51

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.223=
-75-gdc8d80bb822a/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.223=
-75-gdc8d80bb822a/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/636a9c308cfa523ad4e7d=
b52
        failing since 98 days (last pass: v5.4.180-59-g4f62141869c8, first =
fail: v5.4.207-123-gb48a8f43dce6) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/636a9c2e9b68cd1c6be7dba7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.223=
-75-gdc8d80bb822a/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-=
virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.223=
-75-gdc8d80bb822a/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-=
virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/636a9c2e9b68cd1c6be7d=
ba8
        failing since 98 days (last pass: v5.4.180-59-g4f62141869c8, first =
fail: v5.4.207-123-gb48a8f43dce6) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/636a9bcc4e5b40b787e7db5c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.223=
-75-gdc8d80bb822a/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.223=
-75-gdc8d80bb822a/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/636a9bcc4e5b40b787e7d=
b5d
        failing since 182 days (last pass: v5.4.191-84-gbea55d0a1d975, firs=
t fail: v5.4.191-118-g7dae5fe9ddc0) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-baylibre  | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/636a9c2ebed4f8244be7db4f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.223=
-75-gdc8d80bb822a/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.223=
-75-gdc8d80bb822a/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/636a9c2ebed4f8244be7d=
b50
        failing since 182 days (last pass: v5.4.191-85-ga4a4cbb41380, first=
 fail: v5.4.191-118-g7dae5fe9ddc0) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/636a9bc98ca0e8fe1fe7db86

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.223=
-75-gdc8d80bb822a/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.223=
-75-gdc8d80bb822a/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/636a9bc98ca0e8fe1fe7d=
b87
        failing since 182 days (last pass: v5.4.191-84-gbea55d0a1d975, firs=
t fail: v5.4.191-118-g7dae5fe9ddc0) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/636a9c328cfa523ad4e7db55

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.223=
-75-gdc8d80bb822a/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.223=
-75-gdc8d80bb822a/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/636a9c328cfa523ad4e7d=
b56
        failing since 182 days (last pass: v5.4.191-85-ga4a4cbb41380, first=
 fail: v5.4.191-118-g7dae5fe9ddc0) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
rk3399-gru-kevin           | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/636a9b67fcfa1d14f2e7db63

  Results:     88 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.223=
-75-gdc8d80bb822a/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.223=
-75-gdc8d80bb822a/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/636a9b67fcfa1d14f2e7db85
        failing since 247 days (last pass: v5.4.181-51-gb77a12b8d613, first=
 fail: v5.4.182-54-gf27af6bf3c32)

    2022-11-08T18:09:32.926733  /lava-7900840/1/../bin/lava-test-case
    2022-11-08T18:09:32.934845  <8>[   32.752829] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
