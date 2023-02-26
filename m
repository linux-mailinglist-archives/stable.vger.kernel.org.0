Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9696A3423
	for <lists+stable@lfdr.de>; Sun, 26 Feb 2023 21:55:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbjBZUzi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 15:55:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjBZUzi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 15:55:38 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7336D12F10
        for <stable@vger.kernel.org>; Sun, 26 Feb 2023 12:55:33 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id kb15so4150109pjb.1
        for <stable@vger.kernel.org>; Sun, 26 Feb 2023 12:55:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=4qFC0DH15E1dOBJpDeREVqVJAsdJVkiWcoHzOTE5IFE=;
        b=c6aYJZiUpc6onSvvLX17UwJYidyPhXe2zrYqE5y5bYj8HmEnZGeiUJhT9obZ1znH/B
         GFD0Op6SZqTNBbTD5sTM8tM/lziEASgqd6KPyJn4X8Bw1wYnGo2P0Vhwgh8QCbdMpMPl
         B6lBmYJgVpiXEbjHLBpNKo+i7RFRiQqUAC79fxfARrqqQ6tbQGG/0qFG8timdpqIVr5Y
         W9F5J2b6gKuNhiUTtUFfKFgdBxJCtEtY/BvvoRr2C3jwByIDjN27jrxzAgpvO7YAlC93
         wPELNBDLGqXEGSajZ9T3EiMrPTcaMr/3m5Ea4P2MRV1V41+jna9V121j7eAAu7T1BJ2D
         wBhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4qFC0DH15E1dOBJpDeREVqVJAsdJVkiWcoHzOTE5IFE=;
        b=yHsFytw0TmBA1zffCbtNg+IHldPEYnCCeXqJut/vjcx90UK+g7Nmk2Scu7lPfqD5nb
         RcRoyGD/oI9wr2duon6BNAJvKl9+wLqnRhqsUt9MEcXgUXNbNvUZne5VaMRenM5NhseE
         rIzY3A08OrQoYZ/oSIY5WMaXFTQob5IFiZfuHuHwvnUebsNUFn0ms5qSi0TDf3nVhvYi
         Oog+FaCQhjzteMZPeRhIjKv4koHOwjnVd6J+vujNa00mJgkM9IjJH9+bpwCzLJzFOcin
         HaXVFrKgNbyphy/HF4SaaxIohC6cD8eXpTWlNXJ+53aMZ/RUasr3lzi0tuL1+Gui0b/i
         FSFw==
X-Gm-Message-State: AO0yUKVKKGWO1lDapSVXQDq3Tz02ywZLi4jJRiz6YU0Bro5mLUi8yrqr
        2XE+FZCanGS8S3idDc0WyAT0VnsxibIr9cKo
X-Google-Smtp-Source: AK7set+PH9ENSL5CJGbAh/q8uEu7u2+XFoM0130uQ0f3g3JQOa0euGWgKIaD+BTKobz+Y1axNANrcA==
X-Received: by 2002:a17:90b:4a03:b0:236:6dea:87b4 with SMTP id kk3-20020a17090b4a0300b002366dea87b4mr24142663pjb.39.1677444932286;
        Sun, 26 Feb 2023 12:55:32 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b192-20020a6334c9000000b00502f86b2069sm2638341pga.65.2023.02.26.12.55.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Feb 2023 12:55:31 -0800 (PST)
Message-ID: <63fbc743.630a0220.38206.3c20@mx.google.com>
Date:   Sun, 26 Feb 2023 12:55:31 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.233-7-ga09023f5d060
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 161 runs,
 41 regressions (v5.4.233-7-ga09023f5d060)
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

stable-rc/queue/5.4 baseline: 161 runs, 41 regressions (v5.4.233-7-ga09023f=
5d060)

Regressions Summary
-------------------

platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hifive-unleashed-a00         | riscv  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =

qemu_arm64-virt-gicv2        | arm64  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =

qemu_arm64-virt-gicv2        | arm64  | lab-baylibre  | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv2        | arm64  | lab-broonie   | gcc-10   | defconfi=
g                    | 1          =

qemu_arm64-virt-gicv2        | arm64  | lab-broonie   | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv2        | arm64  | lab-collabora | gcc-10   | defconfi=
g                    | 1          =

qemu_arm64-virt-gicv2        | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64  | lab-baylibre  | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64  | lab-broonie   | gcc-10   | defconfi=
g                    | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64  | lab-broonie   | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64  | lab-collabora | gcc-10   | defconfi=
g                    | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv3        | arm64  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =

qemu_arm64-virt-gicv3        | arm64  | lab-baylibre  | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv3        | arm64  | lab-broonie   | gcc-10   | defconfi=
g                    | 1          =

qemu_arm64-virt-gicv3        | arm64  | lab-broonie   | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv3        | arm64  | lab-collabora | gcc-10   | defconfi=
g                    | 1          =

qemu_arm64-virt-gicv3        | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64  | lab-baylibre  | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64  | lab-broonie   | gcc-10   | defconfi=
g                    | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64  | lab-broonie   | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64  | lab-collabora | gcc-10   | defconfi=
g                    | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =

qemu_i386-uefi               | i386   | lab-baylibre  | gcc-10   | i386_def=
config               | 1          =

qemu_i386-uefi               | i386   | lab-broonie   | gcc-10   | i386_def=
config               | 1          =

qemu_i386-uefi               | i386   | lab-collabora | gcc-10   | i386_def=
config               | 1          =

qemu_x86_64-uefi             | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efconfig             | 1          =

qemu_x86_64-uefi             | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

qemu_x86_64-uefi             | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efconfig             | 1          =

qemu_x86_64-uefi             | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

qemu_x86_64-uefi             | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efconfig             | 1          =

qemu_x86_64-uefi             | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

qemu_x86_64-uefi-mixed       | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efconfig             | 1          =

qemu_x86_64-uefi-mixed       | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

qemu_x86_64-uefi-mixed       | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efconfig             | 1          =

qemu_x86_64-uefi-mixed       | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

qemu_x86_64-uefi-mixed       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efconfig             | 1          =

qemu_x86_64-uefi-mixed       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.233-7-ga09023f5d060/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.233-7-ga09023f5d060
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a09023f5d060f4b02616ec8774670af029e81edd =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hifive-unleashed-a00         | riscv  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63fb8f0255f8da3bb78c8635

  Results:     3 PASS, 2 FAIL, 2 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleashe=
d-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleashe=
d-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/riscv/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/63fb8f0255f8da3b=
b78c863a
        failing since 130 days (last pass: v5.4.219-270-gde284a6cd1e4, firs=
t fail: v5.4.219-266-g5eb28a6c7901)
        3 lines

    2023-02-26T16:55:09.562198  / # =

    2023-02-26T16:55:09.563158  =

    2023-02-26T16:55:11.623703  / # #
    2023-02-26T16:55:11.624596  #
    2023-02-26T16:55:13.637972  / # export SHELL=3D/bin/sh
    2023-02-26T16:55:13.638332  export SHELL=3D/bin/sh
    2023-02-26T16:55:15.654145  / # . /lava-3376464/environment
    2023-02-26T16:55:15.654594  . /lava-3376464/environment
    2023-02-26T16:55:17.670142  / # /lava-3376464/bin/lava-test-runner /lav=
a-3376464/0
    2023-02-26T16:55:17.671576  /lava-3376464/bin/lava-test-runner /lava-33=
76464/0 =

    ... (9 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63fb91ec79b44b862a8c866c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt=
-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt=
-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fb91ec79b44b862a8c8=
66d
        failing since 215 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-baylibre  | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63fb9218a525d2cabf8c867b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baselin=
e-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baselin=
e-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fb9218a525d2cabf8c8=
67c
        failing since 215 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-broonie   | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63fb91da450e2d7efc8c8668

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-=
gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-=
gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fb91da450e2d7efc8c8=
669
        failing since 215 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-broonie   | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63fb941f30caad9dca8c8635

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline=
-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline=
-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fb941f30caad9dca8c8=
636
        failing since 215 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-collabora | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63fb91bb2b427c7bb48c8689

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vir=
t-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vir=
t-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fb91bb2b427c7bb48c8=
68a
        failing since 215 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63fb91d4450e2d7efc8c864c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseli=
ne-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseli=
ne-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fb91d4450e2d7efc8c8=
64d
        failing since 215 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-baylibre  | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63fb91d9450e2d7efc8c8665

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baselin=
e-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baselin=
e-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fb91d9450e2d7efc8c8=
666
        failing since 215 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63fb91ee79b44b862a8c8672

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt=
-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt=
-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fb91ee79b44b862a8c8=
673
        failing since 215 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-broonie   | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63fb9343a648267a898c864e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-=
gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-=
gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fb9343a648267a898c8=
64f
        failing since 215 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-broonie   | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63fb936caf1e7695198c863d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline=
-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline=
-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fb936caf1e7695198c8=
63e
        failing since 215 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-collabora | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63fb91bf2b427c7bb48c86b7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vir=
t-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vir=
t-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fb91bf2b427c7bb48c8=
6b8
        failing since 215 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63fb91d0eba0834cb98c8792

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseli=
ne-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseli=
ne-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fb91d0eba0834cb98c8=
793
        failing since 215 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63fb91ed79b44b862a8c866f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt=
-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt=
-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fb91ed79b44b862a8c8=
670
        failing since 215 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-baylibre  | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63fb9216a525d2cabf8c8678

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baselin=
e-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baselin=
e-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fb9216a525d2cabf8c8=
679
        failing since 215 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-broonie   | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63fb9204c08df7ae128c867e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-=
gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-=
gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fb9204c08df7ae128c8=
67f
        failing since 215 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-broonie   | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63fb936bdbfb806ced8c8639

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline=
-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline=
-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fb936bdbfb806ced8c8=
63a
        failing since 215 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-collabora | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63fb91bc2b427c7bb48c86a6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vir=
t-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vir=
t-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fb91bc2b427c7bb48c8=
6a7
        failing since 215 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63fb91c09e91ba94178c8653

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseli=
ne-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseli=
ne-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fb91c09e91ba94178c8=
654
        failing since 215 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-baylibre  | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63fb91da450e2d7efc8c866b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baselin=
e-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baselin=
e-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fb91da450e2d7efc8c8=
66c
        failing since 215 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63fb9215a525d2cabf8c8675

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt=
-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt=
-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fb9215a525d2cabf8c8=
676
        failing since 215 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-broonie   | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63fb92b69624de5b198c8630

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-=
gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-=
gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fb92b69624de5b198c8=
631
        failing since 215 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-broonie   | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63fb94abb4777462978c863b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline=
-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline=
-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fb94abb4777462978c8=
63c
        failing since 215 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-collabora | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63fb91bd9e91ba94178c8640

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vir=
t-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vir=
t-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fb91bd9e91ba94178c8=
641
        failing since 215 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63fb91c1885c7915ed8c864b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseli=
ne-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseli=
ne-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fb91c1885c7915ed8c8=
64c
        failing since 215 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_i386-uefi               | i386   | lab-baylibre  | gcc-10   | i386_def=
config               | 1          =


  Details:     https://kernelci.org/test/plan/id/63fb932c2526c0df0a8c866f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/i386/i386_defconfig/gcc-10/lab-baylibre/baseline-qemu_i386-u=
efi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/i386/i386_defconfig/gcc-10/lab-baylibre/baseline-qemu_i386-u=
efi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fb932c2526c0df0a8c8=
670
        failing since 12 days (last pass: v5.4.231-79-gef392a6e97bb, first =
fail: v5.4.231-87-g1c61c99ed18f) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_i386-uefi               | i386   | lab-broonie   | gcc-10   | i386_def=
config               | 1          =


  Details:     https://kernelci.org/test/plan/id/63fb953775531fe66d8c862f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/i386/i386_defconfig/gcc-10/lab-broonie/baseline-qemu_i386-ue=
fi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/i386/i386_defconfig/gcc-10/lab-broonie/baseline-qemu_i386-ue=
fi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fb953775531fe66d8c8=
630
        failing since 12 days (last pass: v5.4.231-79-gef392a6e97bb, first =
fail: v5.4.231-87-g1c61c99ed18f) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_i386-uefi               | i386   | lab-collabora | gcc-10   | i386_def=
config               | 1          =


  Details:     https://kernelci.org/test/plan/id/63fb930f52277e136d8c863a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/i386/i386_defconfig/gcc-10/lab-collabora/baseline-qemu_i386-=
uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/i386/i386_defconfig/gcc-10/lab-collabora/baseline-qemu_i386-=
uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fb930f52277e136d8c8=
63b
        failing since 12 days (last pass: v5.4.231-79-gef392a6e97bb, first =
fail: v5.4.231-87-g1c61c99ed18f) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63fb903547be610e678c8650

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_x8=
6_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_x8=
6_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fb903547be610e678c8=
651
        failing since 12 days (last pass: v5.4.231-76-g24eb5d727a7b, first =
fail: v5.4.231-90-g401a6c72b195) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63fb9390be38de3d2d8c8651

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre/b=
aseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre/b=
aseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fb9390be38de3d2d8c8=
652
        failing since 12 days (last pass: v5.4.231-76-g24eb5d727a7b, first =
fail: v5.4.231-87-g1c61c99ed18f) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63fb9036f55d78825a8c8662

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x86=
_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x86=
_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fb9036f55d78825a8c8=
663
        failing since 12 days (last pass: v5.4.231-76-g24eb5d727a7b, first =
fail: v5.4.231-90-g401a6c72b195) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63fb95af0b6e7ca2df8c8671

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/ba=
seline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/ba=
seline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fb95af0b6e7ca2df8c8=
672
        failing since 12 days (last pass: v5.4.231-76-g24eb5d727a7b, first =
fail: v5.4.231-87-g1c61c99ed18f) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63fb90028b1edea53e8c863d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-qemu_x=
86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-qemu_x=
86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fb90028b1edea53e8c8=
63e
        failing since 12 days (last pass: v5.4.231-76-g24eb5d727a7b, first =
fail: v5.4.231-90-g401a6c72b195) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63fb9387dbfb806ced8c8664

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/=
baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/=
baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fb9387dbfb806ced8c8=
665
        failing since 12 days (last pass: v5.4.231-76-g24eb5d727a7b, first =
fail: v5.4.231-87-g1c61c99ed18f) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63fb9034f55d78825a8c865c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_x8=
6_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_x8=
6_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fb9034f55d78825a8c8=
65d
        failing since 12 days (last pass: v5.4.231-76-g24eb5d727a7b, first =
fail: v5.4.231-87-g1c61c99ed18f) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63fb939210c94b8ef18c862f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre/b=
aseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre/b=
aseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fb939210c94b8ef18c8=
630
        failing since 12 days (last pass: v5.4.231-79-gef392a6e97bb, first =
fail: v5.4.231-87-g1c61c99ed18f) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63fb902247be610e678c8642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x86=
_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x86=
_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fb902247be610e678c8=
643
        failing since 12 days (last pass: v5.4.231-76-g24eb5d727a7b, first =
fail: v5.4.231-87-g1c61c99ed18f) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63fb95c4dddd048b848c8645

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/ba=
seline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/ba=
seline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fb95c4dddd048b848c8=
646
        failing since 12 days (last pass: v5.4.231-79-gef392a6e97bb, first =
fail: v5.4.231-87-g1c61c99ed18f) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63fb9008cca2da9abe8c865c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-qemu_x=
86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-qemu_x=
86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fb9008cca2da9abe8c8=
65d
        failing since 12 days (last pass: v5.4.231-76-g24eb5d727a7b, first =
fail: v5.4.231-87-g1c61c99ed18f) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63fb939be329c1301e8c863a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/=
baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/=
baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fb939be329c1301e8c8=
63b
        failing since 12 days (last pass: v5.4.231-79-gef392a6e97bb, first =
fail: v5.4.231-87-g1c61c99ed18f) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63fb927b109320adfc8c8632

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h3=
-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.233-7=
-ga09023f5d060/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h3=
-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63fb927b109320adfc8c863b
        failing since 25 days (last pass: v5.4.230-108-g761a8268d868, first=
 fail: v5.4.230-109-g0a6085bff265)

    2023-02-26T17:09:52.800856  / # #
    2023-02-26T17:09:52.903420  export SHELL=3D/bin/sh
    2023-02-26T17:09:52.904191  #
    2023-02-26T17:09:53.005907  / # export SHELL=3D/bin/sh. /lava-3376527/e=
nvironment
    2023-02-26T17:09:53.006722  =

    2023-02-26T17:09:53.108417  / # . /lava-3376527/environment/lava-337652=
7/bin/lava-test-runner /lava-3376527/1
    2023-02-26T17:09:53.109252  =

    2023-02-26T17:09:53.124980  / # /lava-3376527/bin/lava-test-runner /lav=
a-3376527/1
    2023-02-26T17:09:53.214843  + export 'TESTRUN_ID=3D1_bootrr'
    2023-02-26T17:09:53.215264  + cd /lava-3376527/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
