Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3962569FAC3
	for <lists+stable@lfdr.de>; Wed, 22 Feb 2023 19:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbjBVSIZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Feb 2023 13:08:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbjBVSIY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Feb 2023 13:08:24 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8705C1A679
        for <stable@vger.kernel.org>; Wed, 22 Feb 2023 10:08:22 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id ko13so10391140plb.13
        for <stable@vger.kernel.org>; Wed, 22 Feb 2023 10:08:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=ayVMXY/lokx3rVbjpQ3hrlBdqgk0lc1vVfqG2+5Vsag=;
        b=d5/YP0hqadzXJco3kUocxhO+r4wNNmYdvZXLdQeY8mLFSb02CbLnFO2u8qvjJ1gXHA
         SjMwbkFi4/Ag7gHstO8pwLAs1YfcgjQyMx4bBm4XZJ8S/Fw520BF1pzOaOi5ZKXCSMAz
         ny3ylR/ww9tUvSEPL9JvXHbMIV/FhGNyq2X4JeCt4qxp8an8GGDcUnVpwEZo8wJ8itW2
         YRG3lQh6NaIQ09dsgBla7BIEx+n3Lj3i1rItHhCYbtb4Oy78lp1sN6v1vJ/Dhup5n7BK
         eh4qGC6KMhoBKXEj4+NL65GT0Cova5hu2M1MDrpknE+x7MWbMKzPe2pFdSf+RYork1Id
         kabg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ayVMXY/lokx3rVbjpQ3hrlBdqgk0lc1vVfqG2+5Vsag=;
        b=42MV8WQrVbZ0e4a96e95RRXzqFoCFKEkItnae5SYEFzdSkw8PqmoZ0RFs7PkrVVv3w
         D36pwveP84jOCzlO3QSD6KaJbxZV4jTacva/bpqUT1V6aiukv5FnTrT4JuLMIL91UX1a
         y7bfCq1LYHgFSAISFeR4rctajJHV8Z5Tf6wXuPTahYUCuRPgKs4+dcYWvhD8EkfPaWbL
         TpQBGRm3UEdhrlCrX3LMNNHJgItX5GOI/6ip7Yat2lDs3dh50+2T9nr4jdygptuj1Zfh
         gEo4wfH76R+Bu6oXZBBEq95azpgpOg8bGIaBQfZC8HjICUpEj0VmGJVWrt+67CJ29llc
         Jkww==
X-Gm-Message-State: AO0yUKVEzllJN6bTbKGU4LEx+45BBBn+Hf7+/K9Rw/mB3/nf2q9nhyb2
        SPIcjr4YFgmeRi3uVjpdSUxAyNYEi1mEfyna/BDDgw==
X-Google-Smtp-Source: AK7set/1fXkc1esJIDr0Al+ATT1tHKsQpHpmcnzahsRs5RXnNBTBviovL4kH7JdY3KpxVx9NpxeDcg==
X-Received: by 2002:a17:902:d489:b0:196:40b1:3319 with SMTP id c9-20020a170902d48900b0019640b13319mr11828599plg.5.1677089301478;
        Wed, 22 Feb 2023 10:08:21 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p23-20020a170902a41700b0018099c9618esm7089439plq.231.2023.02.22.10.08.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Feb 2023 10:08:21 -0800 (PST)
Message-ID: <63f65a15.170a0220.c2946.cbc5@mx.google.com>
Date:   Wed, 22 Feb 2023 10:08:21 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.10.169
X-Kernelci-Report-Type: test
Subject: stable/linux-5.10.y baseline: 147 runs, 14 regressions (v5.10.169)
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

stable/linux-5.10.y baseline: 147 runs, 14 regressions (v5.10.169)

Regressions Summary
-------------------

platform                | arch   | lab           | compiler | defconfig    =
                | regressions
------------------------+--------+---------------+----------+--------------=
----------------+------------
cubietruck              | arm    | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig           | 1          =

qemu_i386-uefi          | i386   | lab-baylibre  | gcc-10   | i386_defconfi=
g               | 1          =

qemu_i386-uefi          | i386   | lab-broonie   | gcc-10   | i386_defconfi=
g               | 1          =

qemu_i386-uefi          | i386   | lab-collabora | gcc-10   | i386_defconfi=
g               | 1          =

qemu_x86_64-uefi        | x86_64 | lab-baylibre  | gcc-10   | x86_64_defcon=
...6-chromebook | 1          =

qemu_x86_64-uefi        | x86_64 | lab-baylibre  | gcc-10   | x86_64_defcon=
fig             | 1          =

qemu_x86_64-uefi        | x86_64 | lab-broonie   | gcc-10   | x86_64_defcon=
...6-chromebook | 1          =

qemu_x86_64-uefi        | x86_64 | lab-broonie   | gcc-10   | x86_64_defcon=
fig             | 1          =

qemu_x86_64-uefi-mixed  | x86_64 | lab-baylibre  | gcc-10   | x86_64_defcon=
...6-chromebook | 1          =

qemu_x86_64-uefi-mixed  | x86_64 | lab-baylibre  | gcc-10   | x86_64_defcon=
fig             | 1          =

qemu_x86_64-uefi-mixed  | x86_64 | lab-broonie   | gcc-10   | x86_64_defcon=
...6-chromebook | 1          =

qemu_x86_64-uefi-mixed  | x86_64 | lab-broonie   | gcc-10   | x86_64_defcon=
fig             | 1          =

r8a7743-iwg20d-q7       | arm    | lab-cip       | gcc-10   | shmobile_defc=
onfig           | 1          =

sun50i-a64-bananapi-m64 | arm64  | lab-clabbe    | gcc-10   | defconfig    =
                | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.169/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.169
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      2ae73796985b582b79711dfed2941d190b571fb5 =



Test Regressions
---------------- =



platform                | arch   | lab           | compiler | defconfig    =
                | regressions
------------------------+--------+---------------+----------+--------------=
----------------+------------
cubietruck              | arm    | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63f62398a83f0cd89a8c8639

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.169/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.169/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63f62398a83f0cd89a8c8642
        failing since 34 days (last pass: v5.10.158, first fail: v5.10.164)

    2023-02-22T14:15:37.493851  <8>[   10.994771] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3365124_1.5.2.4.1>
    2023-02-22T14:15:37.601214  / # #
    2023-02-22T14:15:37.702864  export SHELL=3D/bin/sh
    2023-02-22T14:15:37.703292  #
    2023-02-22T14:15:37.804597  / # export SHELL=3D/bin/sh. /lava-3365124/e=
nvironment
    2023-02-22T14:15:37.804972  =

    2023-02-22T14:15:37.906131  / # . /lava-3365124/environment/lava-336512=
4/bin/lava-test-runner /lava-3365124/1
    2023-02-22T14:15:37.906700  =

    2023-02-22T14:15:37.906845  / # /lava<3>[   11.370993] Bluetooth: hci0:=
 command 0x0c03 tx timeout
    2023-02-22T14:15:37.911473  -3365124/bin/lava-test-runner /lava-3365124=
/1 =

    ... (12 line(s) more)  =

 =



platform                | arch   | lab           | compiler | defconfig    =
                | regressions
------------------------+--------+---------------+----------+--------------=
----------------+------------
qemu_i386-uefi          | i386   | lab-baylibre  | gcc-10   | i386_defconfi=
g               | 1          =


  Details:     https://kernelci.org/test/plan/id/63f625c24febec454a8c8660

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.169/=
i386/i386_defconfig/gcc-10/lab-baylibre/baseline-qemu_i386-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.169/=
i386/i386_defconfig/gcc-10/lab-baylibre/baseline-qemu_i386-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f625c24febec454a8c8=
661
        new failure (last pass: v5.10.167) =

 =



platform                | arch   | lab           | compiler | defconfig    =
                | regressions
------------------------+--------+---------------+----------+--------------=
----------------+------------
qemu_i386-uefi          | i386   | lab-broonie   | gcc-10   | i386_defconfi=
g               | 1          =


  Details:     https://kernelci.org/test/plan/id/63f62775cd8427d6178c863a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.169/=
i386/i386_defconfig/gcc-10/lab-broonie/baseline-qemu_i386-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.169/=
i386/i386_defconfig/gcc-10/lab-broonie/baseline-qemu_i386-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f62775cd8427d6178c8=
63b
        new failure (last pass: v5.10.167) =

 =



platform                | arch   | lab           | compiler | defconfig    =
                | regressions
------------------------+--------+---------------+----------+--------------=
----------------+------------
qemu_i386-uefi          | i386   | lab-collabora | gcc-10   | i386_defconfi=
g               | 1          =


  Details:     https://kernelci.org/test/plan/id/63f625a1c5aa9439588c8661

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.169/=
i386/i386_defconfig/gcc-10/lab-collabora/baseline-qemu_i386-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.169/=
i386/i386_defconfig/gcc-10/lab-collabora/baseline-qemu_i386-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f625a1c5aa9439588c8=
662
        new failure (last pass: v5.10.167) =

 =



platform                | arch   | lab           | compiler | defconfig    =
                | regressions
------------------------+--------+---------------+----------+--------------=
----------------+------------
qemu_x86_64-uefi        | x86_64 | lab-baylibre  | gcc-10   | x86_64_defcon=
...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63f624d6328769b13f8c8651

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.169/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre/baseline-qemu_x8=
6_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.169/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre/baseline-qemu_x8=
6_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f624d6328769b13f8c8=
652
        new failure (last pass: v5.10.167) =

 =



platform                | arch   | lab           | compiler | defconfig    =
                | regressions
------------------------+--------+---------------+----------+--------------=
----------------+------------
qemu_x86_64-uefi        | x86_64 | lab-baylibre  | gcc-10   | x86_64_defcon=
fig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63f626631c3c5abfa38c8658

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.169/=
x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.169/=
x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f626631c3c5abfa38c8=
659
        new failure (last pass: v5.10.167) =

 =



platform                | arch   | lab           | compiler | defconfig    =
                | regressions
------------------------+--------+---------------+----------+--------------=
----------------+------------
qemu_x86_64-uefi        | x86_64 | lab-broonie   | gcc-10   | x86_64_defcon=
...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63f6263518e0f1878b8c8646

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.169/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/baseline-qemu_x86=
_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.169/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/baseline-qemu_x86=
_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f6263518e0f1878b8c8=
647
        new failure (last pass: v5.10.167) =

 =



platform                | arch   | lab           | compiler | defconfig    =
                | regressions
------------------------+--------+---------------+----------+--------------=
----------------+------------
qemu_x86_64-uefi        | x86_64 | lab-broonie   | gcc-10   | x86_64_defcon=
fig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63f627b2f9928ba4ee8c8637

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.169/=
x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.169/=
x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f627b2f9928ba4ee8c8=
638
        new failure (last pass: v5.10.167) =

 =



platform                | arch   | lab           | compiler | defconfig    =
                | regressions
------------------------+--------+---------------+----------+--------------=
----------------+------------
qemu_x86_64-uefi-mixed  | x86_64 | lab-baylibre  | gcc-10   | x86_64_defcon=
...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63f624d4a613f91f1b8c8644

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.169/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre/baseline-qemu_x8=
6_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.169/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre/baseline-qemu_x8=
6_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f624d4a613f91f1b8c8=
645
        new failure (last pass: v5.10.167) =

 =



platform                | arch   | lab           | compiler | defconfig    =
                | regressions
------------------------+--------+---------------+----------+--------------=
----------------+------------
qemu_x86_64-uefi-mixed  | x86_64 | lab-baylibre  | gcc-10   | x86_64_defcon=
fig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63f62664dd0247a4258c8632

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.169/=
x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_x86_64-uefi-mixed=
.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.169/=
x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_x86_64-uefi-mixed=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f62664dd0247a4258c8=
633
        new failure (last pass: v5.10.167) =

 =



platform                | arch   | lab           | compiler | defconfig    =
                | regressions
------------------------+--------+---------------+----------+--------------=
----------------+------------
qemu_x86_64-uefi-mixed  | x86_64 | lab-broonie   | gcc-10   | x86_64_defcon=
...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63f6262418e0f1878b8c8640

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.169/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/baseline-qemu_x86=
_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.169/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/baseline-qemu_x86=
_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f6262418e0f1878b8c8=
641
        new failure (last pass: v5.10.167) =

 =



platform                | arch   | lab           | compiler | defconfig    =
                | regressions
------------------------+--------+---------------+----------+--------------=
----------------+------------
qemu_x86_64-uefi-mixed  | x86_64 | lab-broonie   | gcc-10   | x86_64_defcon=
fig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63f627d9f9928ba4ee8c8643

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.169/=
x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x86_64-uefi-mixed.=
txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.169/=
x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x86_64-uefi-mixed.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f627d9f9928ba4ee8c8=
644
        new failure (last pass: v5.10.167) =

 =



platform                | arch   | lab           | compiler | defconfig    =
                | regressions
------------------------+--------+---------------+----------+--------------=
----------------+------------
r8a7743-iwg20d-q7       | arm    | lab-cip       | gcc-10   | shmobile_defc=
onfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63f645ee4ff39e86968c8634

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.169/=
arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.169/=
arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f645ee4ff39e86968c8=
635
        failing since 16 days (last pass: v5.10.166, first fail: v5.10.167) =

 =



platform                | arch   | lab           | compiler | defconfig    =
                | regressions
------------------------+--------+---------------+----------+--------------=
----------------+------------
sun50i-a64-bananapi-m64 | arm64  | lab-clabbe    | gcc-10   | defconfig    =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/63f629d9f933d15dc38c8636

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.169/=
arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bananapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.169/=
arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bananapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f629d9f933d15dc38c8=
637
        new failure (last pass: v5.10.167) =

 =20
