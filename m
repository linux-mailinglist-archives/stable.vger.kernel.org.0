Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF1B6B631E
	for <lists+stable@lfdr.de>; Sun, 12 Mar 2023 05:15:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbjCLEPw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 23:15:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCLEPv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 23:15:51 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE5D84C6EC
        for <stable@vger.kernel.org>; Sat, 11 Mar 2023 20:15:48 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id i5so9654859pla.2
        for <stable@vger.kernel.org>; Sat, 11 Mar 2023 20:15:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1678594548;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Jllfg6Psnw71uKWkZkO2+HR61hsHZMG1GqhoZq4Vwzc=;
        b=Dz7lfA9hJw7+ufee87h0LuroM9YW0Rk0xq7WuWZ8KZfV/UmCDKk5JZ2kVFAHbDQ7Os
         Ei2uLYz6/oai5n5Z3YW3Wa4+Mb8rkrLrZtQsZ1ix4zSUbYNMHcYLd2rAERvewcZ7HrZV
         DRRpEMPOh0T8t9fr2swxTc7UTeQqdRF86FJk0V7Bo8hRVofFDbo8zJnqSjQ3H51ZJPLl
         GMcCPzvrFDWS/3O057Jqe+o0ReDCy89pxfl5zrvtdWQpl7RrF9Dct2nlwyzMcGmFghjQ
         y56neu3fWWQuffXjK1JBXm2eLWvQwv5z1CnHkOjmFQFzmHXbOuq4fnuxz2cVI8aN1L7J
         VCUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678594548;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Jllfg6Psnw71uKWkZkO2+HR61hsHZMG1GqhoZq4Vwzc=;
        b=YU+XVZ54Gsw64FQICZ6HdapWrI8nnvCJvpQFVpPWsnhyZtKiWdhXc8CBBH9iy9i0Fq
         NIi+SztMfvKVmm8zwFxE2P4HeD7F6ZImRkaQLwbtk3b42Igr0Pj828/u9taxFm+pmXVf
         6bfH7HmiFYFoHzQg+JjjXpg2mcTyn6sVoTE3Kk1hlNorkpVAvFx5zjMXMN1WAguhRixi
         T9UFDxWY23qtZog8+bUv4CA2A31aZ9f8QXBnpnpU68ZrBK6pzez7r5sYoT8/A0OeBCcn
         9ti+t6chsnBqUWQpanRRLHSak8snRspXYVtiMkEjNE44R/rt1xmt2s4pLiX7I8BDtCYB
         g9+w==
X-Gm-Message-State: AO0yUKWB1HhRyX+fvJ2k1cXRKvNw4rAOyrwaNP59OEHuG4cgdoavkG7T
        bfgKW2eAYqYPwBz6+Tiu4qNBW6dRDgOj6c7a5Vk=
X-Google-Smtp-Source: AK7set/gumuiF5eyiJ7HO5pL11bGmYDG6ys0/AeUNeGlYQtCnjQO38elnM3ZgKknbUIfxwqRiMMIGw==
X-Received: by 2002:a17:902:cecb:b0:19f:27fd:7cb5 with SMTP id d11-20020a170902cecb00b0019f27fd7cb5mr3775553plg.10.1678594547859;
        Sat, 11 Mar 2023 20:15:47 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e12-20020a17090301cc00b00196047fc25dsm2201268plh.42.2023.03.11.20.15.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Mar 2023 20:15:47 -0800 (PST)
Message-ID: <640d51f3.170a0220.b2251.3cbe@mx.google.com>
Date:   Sat, 11 Mar 2023 20:15:47 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.10.173
X-Kernelci-Report-Type: test
Subject: stable/linux-5.10.y baseline: 183 runs, 15 regressions (v5.10.173)
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

stable/linux-5.10.y baseline: 183 runs, 15 regressions (v5.10.173)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
cubietruck               | arm    | lab-baylibre  | gcc-10   | multi_v7_def=
config           | 1          =

qemu_i386-uefi           | i386   | lab-baylibre  | gcc-10   | i386_defconf=
ig               | 1          =

qemu_i386-uefi           | i386   | lab-broonie   | gcc-10   | i386_defconf=
ig               | 1          =

qemu_x86_64-uefi         | x86_64 | lab-baylibre  | gcc-10   | x86_64_defco=
nfig             | 1          =

qemu_x86_64-uefi         | x86_64 | lab-baylibre  | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

qemu_x86_64-uefi         | x86_64 | lab-broonie   | gcc-10   | x86_64_defco=
nfig             | 1          =

qemu_x86_64-uefi         | x86_64 | lab-broonie   | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

qemu_x86_64-uefi-mixed   | x86_64 | lab-baylibre  | gcc-10   | x86_64_defco=
nfig             | 1          =

qemu_x86_64-uefi-mixed   | x86_64 | lab-baylibre  | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

qemu_x86_64-uefi-mixed   | x86_64 | lab-broonie   | gcc-10   | x86_64_defco=
nfig             | 1          =

qemu_x86_64-uefi-mixed   | x86_64 | lab-broonie   | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

qemu_x86_64-uefi-mixed   | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig             | 1          =

qemu_x86_64-uefi-mixed   | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

r8a7743-iwg20d-q7        | arm    | lab-cip       | gcc-10   | shmobile_def=
config           | 1          =

r8a774a1-hihope-rzg2m-ex | arm64  | lab-cip       | gcc-10   | defconfig+ar=
m64-chromebook   | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.173/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.173
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      e5f315b55f8e09ac17c968da42f9345f64efcdd2 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
cubietruck               | arm    | lab-baylibre  | gcc-10   | multi_v7_def=
config           | 1          =


  Details:     https://kernelci.org/test/plan/id/640d19ce49afb4723e8c8703

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.173/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.173/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640d19ce49afb4723e8c870c
        failing since 52 days (last pass: v5.10.158, first fail: v5.10.164)

    2023-03-12T00:15:56.262383  <8>[   10.983983] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3405766_1.5.2.4.1>
    2023-03-12T00:15:56.368759  / # #
    2023-03-12T00:15:56.470170  export SHELL=3D/bin/sh
    2023-03-12T00:15:56.470548  #
    2023-03-12T00:15:56.571731  / # export SHELL=3D/bin/sh. /lava-3405766/e=
nvironment
    2023-03-12T00:15:56.572368  =

    2023-03-12T00:15:56.572607  / # <3>[   11.211427] Bluetooth: hci0: comm=
and 0x0c03 tx timeout
    2023-03-12T00:15:56.674872  . /lava-3405766/environment/lava-3405766/bi=
n/lava-test-runner /lava-3405766/1
    2023-03-12T00:15:56.675406  =

    2023-03-12T00:15:56.681058  / # /lava-3405766/bin/lava-test-runner /lav=
a-3405766/1 =

    ... (12 line(s) more)  =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
qemu_i386-uefi           | i386   | lab-baylibre  | gcc-10   | i386_defconf=
ig               | 1          =


  Details:     https://kernelci.org/test/plan/id/640d18818e3a241ee58c8638

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.173/=
i386/i386_defconfig/gcc-10/lab-baylibre/baseline-qemu_i386-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.173/=
i386/i386_defconfig/gcc-10/lab-baylibre/baseline-qemu_i386-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640d18818e3a241ee58c8=
639
        failing since 17 days (last pass: v5.10.167, first fail: v5.10.169) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
qemu_i386-uefi           | i386   | lab-broonie   | gcc-10   | i386_defconf=
ig               | 1          =


  Details:     https://kernelci.org/test/plan/id/640d187a450ef432ad8c863b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.173/=
i386/i386_defconfig/gcc-10/lab-broonie/baseline-qemu_i386-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.173/=
i386/i386_defconfig/gcc-10/lab-broonie/baseline-qemu_i386-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640d187a450ef432ad8c8=
63c
        failing since 17 days (last pass: v5.10.167, first fail: v5.10.169) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi         | x86_64 | lab-baylibre  | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/640d19c1e071caa7b08c863c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.173/=
x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.173/=
x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640d19c1e071caa7b08c8=
63d
        failing since 17 days (last pass: v5.10.167, first fail: v5.10.169) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi         | x86_64 | lab-baylibre  | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640d1a4e0ef3aa302e8c8637

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.173/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre/baseline-qemu_x8=
6_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.173/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre/baseline-qemu_x8=
6_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640d1a4e0ef3aa302e8c8=
638
        failing since 17 days (last pass: v5.10.167, first fail: v5.10.169) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi         | x86_64 | lab-broonie   | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/640d1a9723b65b88178c872a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.173/=
x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.173/=
x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640d1a9723b65b88178c8=
72b
        failing since 17 days (last pass: v5.10.167, first fail: v5.10.169) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi         | x86_64 | lab-broonie   | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640d1b4b78fddb04658c86cc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.173/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/baseline-qemu_x86=
_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.173/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/baseline-qemu_x86=
_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640d1b4b78fddb04658c8=
6cd
        failing since 17 days (last pass: v5.10.167, first fail: v5.10.169) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi-mixed   | x86_64 | lab-baylibre  | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/640d19c27a361874c58c868f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.173/=
x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_x86_64-uefi-mixed=
.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.173/=
x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_x86_64-uefi-mixed=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640d19c27a361874c58c8=
690
        failing since 8 days (last pass: v5.10.165, first fail: v5.10.172) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi-mixed   | x86_64 | lab-baylibre  | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640d1a4dfc3a83aad98c865c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.173/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre/baseline-qemu_x8=
6_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.173/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre/baseline-qemu_x8=
6_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640d1a4dfc3a83aad98c8=
65d
        failing since 14 days (last pass: v5.10.167, first fail: v5.10.170) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi-mixed   | x86_64 | lab-broonie   | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/640d1afbf13c419b8b8c8636

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.173/=
x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x86_64-uefi-mixed.=
txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.173/=
x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x86_64-uefi-mixed.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640d1afbf13c419b8b8c8=
637
        failing since 8 days (last pass: v5.10.165, first fail: v5.10.172) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi-mixed   | x86_64 | lab-broonie   | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640d1b24285b59c7968c8672

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.173/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/baseline-qemu_x86=
_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.173/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/baseline-qemu_x86=
_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640d1b24285b59c7968c8=
673
        failing since 14 days (last pass: v5.10.167, first fail: v5.10.170) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi-mixed   | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/640d19ba49afb4723e8c86e5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.173/=
x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-qemu_x86_64-uefi-mixe=
d.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.173/=
x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-qemu_x86_64-uefi-mixe=
d.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640d19ba49afb4723e8c8=
6e6
        failing since 8 days (last pass: v5.10.165, first fail: v5.10.172) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi-mixed   | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640d1a460ef3aa302e8c8631

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.173/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-qemu_x=
86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.173/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-qemu_x=
86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640d1a460ef3aa302e8c8=
632
        failing since 14 days (last pass: v5.10.167, first fail: v5.10.170) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
r8a7743-iwg20d-q7        | arm    | lab-cip       | gcc-10   | shmobile_def=
config           | 1          =


  Details:     https://kernelci.org/test/plan/id/640d171e606dce2d248c8630

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.173/=
arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.173/=
arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640d171e606dce2d248c8=
631
        failing since 8 days (last pass: v5.10.171, first fail: v5.10.172) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
r8a774a1-hihope-rzg2m-ex | arm64  | lab-cip       | gcc-10   | defconfig+ar=
m64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/640d1ff5f5be7cdd258c862f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.173/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-cip/baseline-r8a774a1-hihope-rz=
g2m-ex.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.173/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-cip/baseline-r8a774a1-hihope-rz=
g2m-ex.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640d1ff5f5be7cdd258c8=
630
        new failure (last pass: v5.10.172) =

 =20
