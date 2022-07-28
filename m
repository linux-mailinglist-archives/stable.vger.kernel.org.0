Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F61458478D
	for <lists+stable@lfdr.de>; Thu, 28 Jul 2022 23:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbiG1VJP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 17:09:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbiG1VJO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 17:09:14 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C0966C10D
        for <stable@vger.kernel.org>; Thu, 28 Jul 2022 14:09:12 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id v18so2832425plo.8
        for <stable@vger.kernel.org>; Thu, 28 Jul 2022 14:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JXXTft5fjUYMYlrFlQNtNmDrU8z8lEyaaP9l35a3Cns=;
        b=eOOpmUPPLLgPALZ8G3Ydt/CDQ+fXI5qk9TMqHspVh8O4kxpvWnJVwRWK3L+U9EvV4T
         rz0ug756YxGYEmSF1xGHWHiaXT5H3lthT0Cq/aWIr3Lm0glaUXBalESVj4rkhaY55n7M
         Jl2RrYSgX9pLbdgNlOf0hCTNOpFEqLoxpuhyErJc882MoIf25MEdcpJgaMq4lSFK0i+t
         krXw3jKKxWlksoD3w9jylwKrm4Rm+L7AsdsgRlLcow4IKXPdWYpwSS/FmxyyOMY6nGvh
         dp2ne81Rra++SjWwaIZ/GXM8bOKICS8tJ4BAN/bwv0Fvc2rntNKbAZPmNNDm8IO9cQsb
         nslg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JXXTft5fjUYMYlrFlQNtNmDrU8z8lEyaaP9l35a3Cns=;
        b=pFT6GWP/ZjxMQ15kcD3Wzz4oO38K75F/jKa5oXh6PKQdLOoVCEX5OKkcKe0x7YvjSW
         61iJaFgXK5CRvxi59Jj+RfHOvAHf1s3U8639kQh/y3hv8JR4SV+b0rTtFUIwlFo4/30f
         3OoQ96fpMx9cHUOyekeC+e7+KCwHFFVthDX5JNRyV3RGn7IrFtGhicxd3LmGZzLvbs2c
         +sF10LB4NFpwkXy4mm90AZeOYPlkd/QwZ/RiabKjGxmhqsVeYfCO9kOB34bD2GLCeyie
         jCAb8mZf2imD98BYmlbVuYqPmhbAaB5VjWaGrxxlfuc+S0qTVlL8ppILFJjtvGqfbiiq
         Gssw==
X-Gm-Message-State: ACgBeo1DTDUPPcJBAqUUA3omRf3+eJ1Kg75nUHwygX0UjFv3ERimqdP3
        IYamFIANseBrS34f8fCXy4/m6cJGAE2B1xcz
X-Google-Smtp-Source: AA6agR4bM08q24kXzeBO0D7sarT+5hXKvAlzb1BUh91phTKde4iKgNj2nFOgwybHy+WNQldg6ooBDw==
X-Received: by 2002:a17:902:db12:b0:16d:7c86:914c with SMTP id m18-20020a170902db1200b0016d7c86914cmr769783plx.82.1659042551501;
        Thu, 28 Jul 2022 14:09:11 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k14-20020a170902c40e00b0016a17da4ad4sm1846634plk.39.2022.07.28.14.09.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 14:09:11 -0700 (PDT)
Message-ID: <62e2faf7.170a0220.a031b.2e87@mx.google.com>
Date:   Thu, 28 Jul 2022 14:09:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.207-87-g69c0cc3f8efe
Subject: stable-rc/queue/5.4 baseline: 99 runs,
 8 regressions (v5.4.207-87-g69c0cc3f8efe)
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

stable-rc/queue/5.4 baseline: 99 runs, 8 regressions (v5.4.207-87-g69c0cc3f=
8efe)

Regressions Summary
-------------------

platform                   | arch  | lab         | compiler | defconfig    =
              | regressions
---------------------------+-------+-------------+----------+--------------=
--------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie | gcc-10   | defconfig    =
              | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-broonie | gcc-10   | defconfig+arm=
64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie | gcc-10   | defconfig    =
              | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie | gcc-10   | defconfig+arm=
64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie | gcc-10   | defconfig    =
              | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie | gcc-10   | defconfig+arm=
64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie | gcc-10   | defconfig    =
              | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.207-87-g69c0cc3f8efe/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.207-87-g69c0cc3f8efe
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      69c0cc3f8efed7951535fb58fcf3ae8f51e966b4 =



Test Regressions
---------------- =



platform                   | arch  | lab         | compiler | defconfig    =
              | regressions
---------------------------+-------+-------------+----------+--------------=
--------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie | gcc-10   | defconfig    =
              | 1          =


  Details:     https://kernelci.org/test/plan/id/62e2c39dc54214b58bdaf056

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-8=
7-g69c0cc3f8efe/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-8=
7-g69c0cc3f8efe/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e2c39dc54214b58bdaf=
057
        failing since 79 days (last pass: v5.4.191-77-g1a3b249e415b, first =
fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                   | arch  | lab         | compiler | defconfig    =
              | regressions
---------------------------+-------+-------------+----------+--------------=
--------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62e2c56ae252237fbcdaf09c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-8=
7-g69c0cc3f8efe/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-8=
7-g69c0cc3f8efe/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e2c56ae252237fbcdaf=
09d
        failing since 79 days (last pass: v5.4.191-84-g56ce42d78d96, first =
fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                   | arch  | lab         | compiler | defconfig    =
              | regressions
---------------------------+-------+-------------+----------+--------------=
--------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie | gcc-10   | defconfig    =
              | 1          =


  Details:     https://kernelci.org/test/plan/id/62e2c3a0d68e0e249ddaf0bd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-8=
7-g69c0cc3f8efe/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-8=
7-g69c0cc3f8efe/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e2c3a0d68e0e249ddaf=
0be
        failing since 79 days (last pass: v5.4.191-77-g1a3b249e415b, first =
fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                   | arch  | lab         | compiler | defconfig    =
              | regressions
---------------------------+-------+-------------+----------+--------------=
--------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62e2c5925d9ef758b9daf083

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-8=
7-g69c0cc3f8efe/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-8=
7-g69c0cc3f8efe/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e2c5925d9ef758b9daf=
084
        failing since 79 days (last pass: v5.4.191-84-g56ce42d78d96, first =
fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                   | arch  | lab         | compiler | defconfig    =
              | regressions
---------------------------+-------+-------------+----------+--------------=
--------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie | gcc-10   | defconfig    =
              | 1          =


  Details:     https://kernelci.org/test/plan/id/62e2c3a1ee47cbb684daf077

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-8=
7-g69c0cc3f8efe/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-8=
7-g69c0cc3f8efe/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e2c3a1ee47cbb684daf=
078
        failing since 79 days (last pass: v5.4.191-77-g1a3b249e415b, first =
fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                   | arch  | lab         | compiler | defconfig    =
              | regressions
---------------------------+-------+-------------+----------+--------------=
--------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62e2c57d5d9ef758b9daf065

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-8=
7-g69c0cc3f8efe/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-8=
7-g69c0cc3f8efe/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e2c57d5d9ef758b9daf=
066
        failing since 79 days (last pass: v5.4.191-84-g56ce42d78d96, first =
fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                   | arch  | lab         | compiler | defconfig    =
              | regressions
---------------------------+-------+-------------+----------+--------------=
--------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie | gcc-10   | defconfig    =
              | 1          =


  Details:     https://kernelci.org/test/plan/id/62e2c39eee47cbb684daf06f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-8=
7-g69c0cc3f8efe/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-8=
7-g69c0cc3f8efe/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e2c39eee47cbb684daf=
070
        failing since 79 days (last pass: v5.4.191-77-g1a3b249e415b, first =
fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                   | arch  | lab         | compiler | defconfig    =
              | regressions
---------------------------+-------+-------------+----------+--------------=
--------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62e2c5ce7559f32b4ddaf08a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-8=
7-g69c0cc3f8efe/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-8=
7-g69c0cc3f8efe/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e2c5ce7559f32b4ddaf=
08b
        failing since 79 days (last pass: v5.4.191-84-g56ce42d78d96, first =
fail: v5.4.191-125-g5917d1547e6e) =

 =20
