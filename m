Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FBC76A0B8E
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 15:10:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233411AbjBWOKH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 09:10:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbjBWOKG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 09:10:06 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20CE14FCAE
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 06:10:02 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id k21-20020a17090aaa1500b002376652e160so1875077pjq.0
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 06:10:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=A8419mFey2X1YYxQpGOE5fKMXPe5sX1xa3XKykRwBgE=;
        b=0oKcP9gy16zFpkQoDnz0F4h+R8StyDnOEl8G30QS67WvVe+gz8Mk2PVt0xaZ4T+e7X
         RGIzno7YgB0M34jDMzsMsodl5BSPF+AD3o9ztq3Rqs70eNBRc59EEhc4ZPA4e1iErbo8
         TPpwVEHAO49cMgXrpdt/jD1c5ARmFoVvMIuiA1uuFyyqM2SBarc3kb5Cs6govj5KPUka
         8npkRtOtw00Hbq4b9h70NcYXL5gyUNqfCBPaUciw0PTlf6kQ3LTKNCT260iiHO5MROH4
         HpAMHrzs3WigjrrjfgbldnXFTxfJq72j4nX2BM3GnuvQzUu5abgRifEIubVuPuWvFbTO
         Q20A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A8419mFey2X1YYxQpGOE5fKMXPe5sX1xa3XKykRwBgE=;
        b=vwebgZPLVpAHEb3S7bCLCGQzB5CUcNhnFka/Fohy84xJdJ71eS/48lT2+gq0L55kTb
         Nb/PUBJGgy4qsZ3RGerFPDGoeyUKZrkDy4X4JpvMGDjRisdUkD68/EPgvnuS7gSeKcjQ
         CgjHWgR7Wr0ywMwWpMFd6hr4+fmgZeASjPf+wKQwc79mReY/P4Xe3PM49IGcmLmnuCin
         SPtoWjcbmOy+anXh2rnddKa9v0+95PjFMHx5jywielHmGZEot5zMQGAZ/DaktK4fYx04
         QqWCRX3niQN3f7n9V5bcWs314IG2mhC7Xyc6jDeXkMGi2p7bpHVmA1SI8C3KvSQeAIim
         hdNw==
X-Gm-Message-State: AO0yUKWQjpPxAI3ixK/tZUtq89nLFI9LWGolsi5i7dchllXTpmljF9mx
        TwdZHnT0i+eiwIs9qXn+5uH5tAiX4Okg2ZOcySgMNg==
X-Google-Smtp-Source: AK7set8ADKTeZXKVHmPTguM1jja3Eie+pvXqGdMPjow2U2OZjnShIRpT8poOap7UV8MbdZ6OEunNNA==
X-Received: by 2002:a17:902:b94c:b0:19c:a8e8:507d with SMTP id h12-20020a170902b94c00b0019ca8e8507dmr4804580pls.47.1677161400634;
        Thu, 23 Feb 2023 06:10:00 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ev5-20020a17090aeac500b00230ffcb2e24sm6191388pjb.13.2023.02.23.06.10.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Feb 2023 06:10:00 -0800 (PST)
Message-ID: <63f773b8.170a0220.89d13.b741@mx.google.com>
Date:   Thu, 23 Feb 2023 06:10:00 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.232-14-g01ff97dca966
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 121 runs,
 35 regressions (v5.4.232-14-g01ff97dca966)
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

stable-rc/queue/5.4 baseline: 121 runs, 35 regressions (v5.4.232-14-g01ff97=
dca966)

Regressions Summary
-------------------

platform                     | arch   | lab           | compiler | defconfi=
g                  | regressions
-----------------------------+--------+---------------+----------+---------=
-------------------+------------
hifive-unleashed-a00         | riscv  | lab-baylibre  | gcc-10   | defconfi=
g                  | 1          =

qemu_arm64-virt-gicv2        | arm64  | lab-baylibre  | gcc-10   | defconfi=
g+arm64-chromebook | 1          =

qemu_arm64-virt-gicv2        | arm64  | lab-baylibre  | gcc-10   | defconfi=
g                  | 1          =

qemu_arm64-virt-gicv2        | arm64  | lab-broonie   | gcc-10   | defconfi=
g+arm64-chromebook | 1          =

qemu_arm64-virt-gicv2        | arm64  | lab-broonie   | gcc-10   | defconfi=
g                  | 1          =

qemu_arm64-virt-gicv2        | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook | 1          =

qemu_arm64-virt-gicv2        | arm64  | lab-collabora | gcc-10   | defconfi=
g                  | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64  | lab-baylibre  | gcc-10   | defconfi=
g+arm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64  | lab-baylibre  | gcc-10   | defconfi=
g                  | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64  | lab-broonie   | gcc-10   | defconfi=
g+arm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64  | lab-broonie   | gcc-10   | defconfi=
g                  | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64  | lab-collabora | gcc-10   | defconfi=
g                  | 1          =

qemu_arm64-virt-gicv3        | arm64  | lab-baylibre  | gcc-10   | defconfi=
g+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3        | arm64  | lab-baylibre  | gcc-10   | defconfi=
g                  | 1          =

qemu_arm64-virt-gicv3        | arm64  | lab-broonie   | gcc-10   | defconfi=
g+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3        | arm64  | lab-broonie   | gcc-10   | defconfi=
g                  | 1          =

qemu_arm64-virt-gicv3        | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3        | arm64  | lab-collabora | gcc-10   | defconfi=
g                  | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64  | lab-baylibre  | gcc-10   | defconfi=
g+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64  | lab-baylibre  | gcc-10   | defconfi=
g                  | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64  | lab-broonie   | gcc-10   | defconfi=
g+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64  | lab-broonie   | gcc-10   | defconfi=
g                  | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64  | lab-collabora | gcc-10   | defconfi=
g                  | 1          =

qemu_i386-uefi               | i386   | lab-baylibre  | gcc-10   | i386_def=
config             | 1          =

qemu_i386-uefi               | i386   | lab-broonie   | gcc-10   | i386_def=
config             | 1          =

qemu_i386-uefi               | i386   | lab-collabora | gcc-10   | i386_def=
config             | 1          =

qemu_x86_64-uefi             | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efconfig           | 1          =

qemu_x86_64-uefi             | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efconfig           | 1          =

qemu_x86_64-uefi             | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efconfig           | 1          =

qemu_x86_64-uefi-mixed       | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efconfig           | 1          =

qemu_x86_64-uefi-mixed       | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efconfig           | 1          =

qemu_x86_64-uefi-mixed       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efconfig           | 1          =

sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig         | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.232-14-g01ff97dca966/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.232-14-g01ff97dca966
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      01ff97dca9660afcb6374cfc4bf46f2731fe91d4 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                  | regressions
-----------------------------+--------+---------------+----------+---------=
-------------------+------------
hifive-unleashed-a00         | riscv  | lab-baylibre  | gcc-10   | defconfi=
g                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63f73e5d7456c954e58c864d

  Results:     3 PASS, 2 FAIL, 2 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
4-g01ff97dca966/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleash=
ed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
4-g01ff97dca966/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleash=
ed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/riscv/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/63f73e5d7456c954=
e58c8652
        failing since 127 days (last pass: v5.4.219-270-gde284a6cd1e4, firs=
t fail: v5.4.219-266-g5eb28a6c7901)
        3 lines

    2023-02-23T10:22:02.210146  / # =

    2023-02-23T10:22:02.211045  =

    2023-02-23T10:22:04.275941  / # #
    2023-02-23T10:22:04.276517  #
    2023-02-23T10:22:06.287812  / # export SHELL=3D/bin/sh
    2023-02-23T10:22:06.288164  export SHELL=3D/bin/sh
    2023-02-23T10:22:08.304288  / # . /lava-3368269/environment
    2023-02-23T10:22:08.304701  . /lava-3368269/environment
    2023-02-23T10:22:10.320318  / # /lava-3368269/bin/lava-test-runner /lav=
a-3368269/0
    2023-02-23T10:22:10.322380  /lava-3368269/bin/lava-test-runner /lava-33=
68269/0 =

    ... (9 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                  | regressions
-----------------------------+--------+---------------+----------+---------=
-------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-baylibre  | gcc-10   | defconfi=
g+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63f740aebe685a71cd8c8640

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
4-g01ff97dca966/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseli=
ne-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
4-g01ff97dca966/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseli=
ne-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f740aebe685a71cd8c8=
641
        failing since 212 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                  | regressions
-----------------------------+--------+---------------+----------+---------=
-------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-baylibre  | gcc-10   | defconfi=
g                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63f741524f63ef71da8c8630

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
4-g01ff97dca966/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
4-g01ff97dca966/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f741524f63ef71da8c8=
631
        failing since 289 days (last pass: v5.4.191-77-g1a3b249e415b, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                  | regressions
-----------------------------+--------+---------------+----------+---------=
-------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-broonie   | gcc-10   | defconfi=
g+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63f740f58d4b7e4b998c8632

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
4-g01ff97dca966/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
4-g01ff97dca966/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f740f58d4b7e4b998c8=
633
        failing since 212 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                  | regressions
-----------------------------+--------+---------------+----------+---------=
-------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-broonie   | gcc-10   | defconfi=
g                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63f7429ae7e62d8c6a8c8638

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
4-g01ff97dca966/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
4-g01ff97dca966/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f7429ae7e62d8c6a8c8=
639
        failing since 289 days (last pass: v5.4.191-77-g1a3b249e415b, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                  | regressions
-----------------------------+--------+---------------+----------+---------=
-------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63f740a731cae2c1748c8646

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
4-g01ff97dca966/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
4-g01ff97dca966/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f740a731cae2c1748c8=
647
        failing since 212 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                  | regressions
-----------------------------+--------+---------------+----------+---------=
-------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-collabora | gcc-10   | defconfi=
g                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63f7420fbe7635e5ad8c864d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
4-g01ff97dca966/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vi=
rt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
4-g01ff97dca966/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vi=
rt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f7420fbe7635e5ad8c8=
64e
        failing since 289 days (last pass: v5.4.191-77-g1a3b249e415b, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                  | regressions
-----------------------------+--------+---------------+----------+---------=
-------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-baylibre  | gcc-10   | defconfi=
g+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63f740b1be685a71cd8c8645

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
4-g01ff97dca966/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseli=
ne-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
4-g01ff97dca966/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseli=
ne-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f740b1be685a71cd8c8=
646
        failing since 289 days (last pass: v5.4.191-84-g56ce42d78d96, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                  | regressions
-----------------------------+--------+---------------+----------+---------=
-------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-baylibre  | gcc-10   | defconfi=
g                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63f741504fa793ad128c862f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
4-g01ff97dca966/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
4-g01ff97dca966/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f741504fa793ad128c8=
630
        failing since 289 days (last pass: v5.4.191-77-g1a3b249e415b, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                  | regressions
-----------------------------+--------+---------------+----------+---------=
-------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-broonie   | gcc-10   | defconfi=
g+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63f7411d7e0abbf5968c864a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
4-g01ff97dca966/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
4-g01ff97dca966/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f7411d7e0abbf5968c8=
64b
        failing since 289 days (last pass: v5.4.191-84-g56ce42d78d96, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                  | regressions
-----------------------------+--------+---------------+----------+---------=
-------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-broonie   | gcc-10   | defconfi=
g                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63f742736394b946418c865a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
4-g01ff97dca966/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
4-g01ff97dca966/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f742736394b946418c8=
65b
        failing since 289 days (last pass: v5.4.191-77-g1a3b249e415b, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                  | regressions
-----------------------------+--------+---------------+----------+---------=
-------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63f740d053dc6aac3b8c8646

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
4-g01ff97dca966/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
4-g01ff97dca966/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f740d053dc6aac3b8c8=
647
        failing since 289 days (last pass: v5.4.191-84-g56ce42d78d96, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                  | regressions
-----------------------------+--------+---------------+----------+---------=
-------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-collabora | gcc-10   | defconfi=
g                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63f741bf4900bde76e8c863f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
4-g01ff97dca966/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vi=
rt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
4-g01ff97dca966/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vi=
rt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f741bf4900bde76e8c8=
640
        failing since 289 days (last pass: v5.4.191-77-g1a3b249e415b, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                  | regressions
-----------------------------+--------+---------------+----------+---------=
-------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-baylibre  | gcc-10   | defconfi=
g+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63f740b053dc6aac3b8c8634

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
4-g01ff97dca966/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseli=
ne-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
4-g01ff97dca966/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseli=
ne-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f740b053dc6aac3b8c8=
635
        failing since 289 days (last pass: v5.4.191-84-g56ce42d78d96, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                  | regressions
-----------------------------+--------+---------------+----------+---------=
-------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-baylibre  | gcc-10   | defconfi=
g                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63f74151ba2ffe09a18c8639

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
4-g01ff97dca966/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
4-g01ff97dca966/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f74151ba2ffe09a18c8=
63a
        failing since 289 days (last pass: v5.4.191-77-g1a3b249e415b, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                  | regressions
-----------------------------+--------+---------------+----------+---------=
-------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-broonie   | gcc-10   | defconfi=
g+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63f740f89da5b5ade78c8632

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
4-g01ff97dca966/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
4-g01ff97dca966/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f740f89da5b5ade78c8=
633
        failing since 289 days (last pass: v5.4.191-84-g56ce42d78d96, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                  | regressions
-----------------------------+--------+---------------+----------+---------=
-------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-broonie   | gcc-10   | defconfi=
g                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63f742746394b946418c865f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
4-g01ff97dca966/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
4-g01ff97dca966/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f742746394b946418c8=
660
        failing since 289 days (last pass: v5.4.191-77-g1a3b249e415b, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                  | regressions
-----------------------------+--------+---------------+----------+---------=
-------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63f740cec5d59098c78c864c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
4-g01ff97dca966/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
4-g01ff97dca966/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f740cec5d59098c78c8=
64d
        failing since 289 days (last pass: v5.4.191-84-g56ce42d78d96, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                  | regressions
-----------------------------+--------+---------------+----------+---------=
-------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-collabora | gcc-10   | defconfi=
g                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63f741fa1a46d97aae8c86ae

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
4-g01ff97dca966/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vi=
rt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
4-g01ff97dca966/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vi=
rt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f741fa1a46d97aae8c8=
6af
        failing since 289 days (last pass: v5.4.191-77-g1a3b249e415b, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                  | regressions
-----------------------------+--------+---------------+----------+---------=
-------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-baylibre  | gcc-10   | defconfi=
g+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63f740af1b5fae8b918c8634

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
4-g01ff97dca966/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseli=
ne-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
4-g01ff97dca966/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseli=
ne-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f740af1b5fae8b918c8=
635
        failing since 212 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                  | regressions
-----------------------------+--------+---------------+----------+---------=
-------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-baylibre  | gcc-10   | defconfi=
g                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63f7414ff2dd78977f8c862f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
4-g01ff97dca966/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
4-g01ff97dca966/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f7414ff2dd78977f8c8=
630
        failing since 289 days (last pass: v5.4.191-77-g1a3b249e415b, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                  | regressions
-----------------------------+--------+---------------+----------+---------=
-------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-broonie   | gcc-10   | defconfi=
g+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63f740f650a3987b038c8634

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
4-g01ff97dca966/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
4-g01ff97dca966/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f740f650a3987b038c8=
635
        failing since 212 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                  | regressions
-----------------------------+--------+---------------+----------+---------=
-------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-broonie   | gcc-10   | defconfi=
g                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63f7427197a76fa34a8c863a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
4-g01ff97dca966/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
4-g01ff97dca966/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f7427197a76fa34a8c8=
63b
        failing since 289 days (last pass: v5.4.191-77-g1a3b249e415b, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                  | regressions
-----------------------------+--------+---------------+----------+---------=
-------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63f740a653dc6aac3b8c862f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
4-g01ff97dca966/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
4-g01ff97dca966/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f740a653dc6aac3b8c8=
630
        failing since 212 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                  | regressions
-----------------------------+--------+---------------+----------+---------=
-------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-collabora | gcc-10   | defconfi=
g                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63f741aa4900bde76e8c8639

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
4-g01ff97dca966/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vi=
rt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
4-g01ff97dca966/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vi=
rt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f741aa4900bde76e8c8=
63a
        failing since 289 days (last pass: v5.4.191-77-g1a3b249e415b, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                  | regressions
-----------------------------+--------+---------------+----------+---------=
-------------------+------------
qemu_i386-uefi               | i386   | lab-baylibre  | gcc-10   | i386_def=
config             | 1          =


  Details:     https://kernelci.org/test/plan/id/63f7414e63ecb2af028c8667

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
4-g01ff97dca966/i386/i386_defconfig/gcc-10/lab-baylibre/baseline-qemu_i386-=
uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
4-g01ff97dca966/i386/i386_defconfig/gcc-10/lab-baylibre/baseline-qemu_i386-=
uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f7414e63ecb2af028c8=
668
        failing since 9 days (last pass: v5.4.231-79-gef392a6e97bb, first f=
ail: v5.4.231-87-g1c61c99ed18f) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                  | regressions
-----------------------------+--------+---------------+----------+---------=
-------------------+------------
qemu_i386-uefi               | i386   | lab-broonie   | gcc-10   | i386_def=
config             | 1          =


  Details:     https://kernelci.org/test/plan/id/63f74235f55bc378588c863e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
4-g01ff97dca966/i386/i386_defconfig/gcc-10/lab-broonie/baseline-qemu_i386-u=
efi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
4-g01ff97dca966/i386/i386_defconfig/gcc-10/lab-broonie/baseline-qemu_i386-u=
efi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f74235f55bc378588c8=
63f
        failing since 9 days (last pass: v5.4.231-79-gef392a6e97bb, first f=
ail: v5.4.231-87-g1c61c99ed18f) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                  | regressions
-----------------------------+--------+---------------+----------+---------=
-------------------+------------
qemu_i386-uefi               | i386   | lab-collabora | gcc-10   | i386_def=
config             | 1          =


  Details:     https://kernelci.org/test/plan/id/63f741704f63ef71da8c8644

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
4-g01ff97dca966/i386/i386_defconfig/gcc-10/lab-collabora/baseline-qemu_i386=
-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
4-g01ff97dca966/i386/i386_defconfig/gcc-10/lab-collabora/baseline-qemu_i386=
-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f741704f63ef71da8c8=
645
        failing since 9 days (last pass: v5.4.231-79-gef392a6e97bb, first f=
ail: v5.4.231-87-g1c61c99ed18f) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                  | regressions
-----------------------------+--------+---------------+----------+---------=
-------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63f73f9600776917d38c863a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
4-g01ff97dca966/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_x=
86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
4-g01ff97dca966/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_x=
86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f73f9600776917d38c8=
63b
        failing since 8 days (last pass: v5.4.231-76-g24eb5d727a7b, first f=
ail: v5.4.231-90-g401a6c72b195) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                  | regressions
-----------------------------+--------+---------------+----------+---------=
-------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63f74091660d4001868c864f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
4-g01ff97dca966/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x8=
6_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
4-g01ff97dca966/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x8=
6_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f74091660d4001868c8=
650
        failing since 8 days (last pass: v5.4.231-76-g24eb5d727a7b, first f=
ail: v5.4.231-90-g401a6c72b195) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                  | regressions
-----------------------------+--------+---------------+----------+---------=
-------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63f73f67556bc53dfa8c8641

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
4-g01ff97dca966/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-qemu_=
x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
4-g01ff97dca966/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-qemu_=
x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f73f67556bc53dfa8c8=
642
        failing since 8 days (last pass: v5.4.231-76-g24eb5d727a7b, first f=
ail: v5.4.231-90-g401a6c72b195) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                  | regressions
-----------------------------+--------+---------------+----------+---------=
-------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63f73f9700776917d38c863d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
4-g01ff97dca966/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_x=
86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
4-g01ff97dca966/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_x=
86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f73f9700776917d38c8=
63e
        failing since 9 days (last pass: v5.4.231-76-g24eb5d727a7b, first f=
ail: v5.4.231-87-g1c61c99ed18f) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                  | regressions
-----------------------------+--------+---------------+----------+---------=
-------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63f740b9e0497b8c688c8637

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
4-g01ff97dca966/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x8=
6_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
4-g01ff97dca966/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x8=
6_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f740b9e0497b8c688c8=
638
        failing since 9 days (last pass: v5.4.231-76-g24eb5d727a7b, first f=
ail: v5.4.231-87-g1c61c99ed18f) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                  | regressions
-----------------------------+--------+---------------+----------+---------=
-------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63f73f66d8b044fc168c866d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
4-g01ff97dca966/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-qemu_=
x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
4-g01ff97dca966/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-qemu_=
x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f73f66d8b044fc168c8=
66e
        failing since 9 days (last pass: v5.4.231-76-g24eb5d727a7b, first f=
ail: v5.4.231-87-g1c61c99ed18f) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                  | regressions
-----------------------------+--------+---------------+----------+---------=
-------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63f7403891f83490fc8c8670

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
4-g01ff97dca966/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h=
3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.232-1=
4-g01ff97dca966/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h=
3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63f7403891f83490fc8c8679
        failing since 22 days (last pass: v5.4.230-108-g761a8268d868, first=
 fail: v5.4.230-109-g0a6085bff265)

    2023-02-23T10:30:05.567020  / # #
    2023-02-23T10:30:05.668836  export SHELL=3D/bin/sh
    2023-02-23T10:30:05.669368  #
    2023-02-23T10:30:05.770876  / # export SHELL=3D/bin/sh. /lava-3368340/e=
nvironment
    2023-02-23T10:30:05.771496  =

    2023-02-23T10:30:05.872942  / # . /lava-3368340/environment/lava-336834=
0/bin/lava-test-runner /lava-3368340/1
    2023-02-23T10:30:05.873829  =

    2023-02-23T10:30:05.879049  / # /lava-3368340/bin/lava-test-runner /lav=
a-3368340/1
    2023-02-23T10:30:05.981870  + export 'TESTRUN_ID=3D1_bootrr'
    2023-02-23T10:30:05.982279  + cd /lava-3368340/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
