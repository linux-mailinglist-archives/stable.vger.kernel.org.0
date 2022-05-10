Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DA24522159
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 18:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347472AbiEJQiW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 12:38:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347461AbiEJQiO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 12:38:14 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B19E6205276
        for <stable@vger.kernel.org>; Tue, 10 May 2022 09:34:15 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id k14so15093894pga.0
        for <stable@vger.kernel.org>; Tue, 10 May 2022 09:34:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+lQpPqDVWKFwvvCleAxLS733KaWl+MKWxr6aY/N+Ku0=;
        b=pFAoklipn8wd7iu8BFlOisHHY2NqlalsfoNE8ghJkyLlRNhPEcKx2Mb3ZQ5wLcczBw
         cdvhNMlAZNUi+tfBr3m0s2NtLlilIdgf/CUzdh1+HZEn7NLAVmyuOdo5PjjfOwEzaXT7
         ngaC1/jt9cBe+Jrcx1xV2Grh9Nj6eTVWQaS2ttzMYwQJbfKOj89sM7fPAaWaL8+vCX2s
         ryaIlvStiodn9FQgzXQ7ea9pIogEzF2Fkgh5Irou/6YnyawrXH4gsJQejSz/vEdchpxk
         EuXVvCSUtDtK+7czAJ4JqIgV7EzKtgvX+t+YpnP8aaL4cG4EzkWnBEnynXftypFHqI3b
         EuXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+lQpPqDVWKFwvvCleAxLS733KaWl+MKWxr6aY/N+Ku0=;
        b=NiHur4ftQOiJEnqjV4Rm4DHsIRY1jRIj2hCzb7X9FnT4LD6g8DHwv5K7R/nkTjvz2Q
         PYp3FNv59kLj6uQBonVkSScDzpNtN44jx+0tPMUGGOhsOeSDkBwguxpkKeWM0M35q/og
         Tc0PwxurZ3gE4nVAjbeZ6VrPKUBvz30AOA1OAOMq/KI6dHjjfl8VZit3W0TGGxeEjWI+
         czaLcyjnMt/rTztwuwyo3j1r71iZGf8QCQshHltSTvMtu1u/0gFu1cXtU6BqF58U8A7f
         3lNxwyflBUR3KaP71ad9FGtYhtmeSpMVM/b50g7dM11z8plP5gvmd3dWF1XMnDMOTwTX
         rdNw==
X-Gm-Message-State: AOAM532g3pW/zsPkpcskwNBEd0quYwI1XbOmx7I22MMxN5aIZvIorxtn
        w0ZCqJ+Lx4VC3d4ngg9MiWY8RFv/JapeNA5VTmA=
X-Google-Smtp-Source: ABdhPJwCFj3YffmjZaSV5f/ArVHyWRX3Q/N/wves2iaDRHHWCm5N2HSoeUuZjzUT7O4FA5R63LJMkg==
X-Received: by 2002:a05:6a00:711:b0:4fa:daf1:94c1 with SMTP id 17-20020a056a00071100b004fadaf194c1mr21233430pfl.52.1652200454978;
        Tue, 10 May 2022 09:34:14 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c13-20020a170902c1cd00b0015ee9bb2a38sm2302319plc.72.2022.05.10.09.34.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 09:34:14 -0700 (PDT)
Message-ID: <627a9406.1c69fb81.fdf61.5a06@mx.google.com>
Date:   Tue, 10 May 2022 09:34:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.277-78-g71dc583ecdb9
Subject: stable-rc/queue/4.14 baseline: 78 runs,
 10 regressions (v4.14.277-78-g71dc583ecdb9)
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

stable-rc/queue/4.14 baseline: 78 runs, 10 regressions (v4.14.277-78-g71dc5=
83ecdb9)

Regressions Summary
-------------------

platform                     | arch  | lab         | compiler | defconfig  =
                | regressions
-----------------------------+-------+-------------+----------+------------=
----------------+------------
fsl-ls2088a-rdb              | arm64 | lab-nxp     | gcc-10   | defconfig  =
                | 1          =

meson-gxl-s905x-libretech-cc | arm64 | lab-broonie | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-broonie | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-broonie | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-broonie | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-broonie | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie | gcc-10   | defconfig  =
                | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.277-78-g71dc583ecdb9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.277-78-g71dc583ecdb9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      71dc583ecdb99268f405cf24bfa60eefdcb726a2 =



Test Regressions
---------------- =



platform                     | arch  | lab         | compiler | defconfig  =
                | regressions
-----------------------------+-------+-------------+----------+------------=
----------------+------------
fsl-ls2088a-rdb              | arm64 | lab-nxp     | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/627a6646eb6b129eb78f5764

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.277=
-78-g71dc583ecdb9/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls2088a-rdb.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.277=
-78-g71dc583ecdb9/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls2088a-rdb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627a6646eb6b129eb78f5=
765
        failing since 0 day (last pass: v4.14.277-54-gfa6de16ffc4e, first f=
ail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab         | compiler | defconfig  =
                | regressions
-----------------------------+-------+-------------+----------+------------=
----------------+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-broonie | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/627a645f3c204478bc8f5757

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.277=
-78-g71dc583ecdb9/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s90=
5x-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.277=
-78-g71dc583ecdb9/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s90=
5x-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627a645f3c204478bc8f5=
758
        failing since 21 days (last pass: v4.14.275-277-gda5c0b6bebbb1, fir=
st fail: v4.14.275-284-gdf8ec5b4383b9) =

 =



platform                     | arch  | lab         | compiler | defconfig  =
                | regressions
-----------------------------+-------+-------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2        | arm64 | lab-broonie | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/627a6f61f5e8941f858f572a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.277=
-78-g71dc583ecdb9/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.277=
-78-g71dc583ecdb9/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627a6f61f5e8941f858f5=
72b
        failing since 0 day (last pass: v4.14.277-54-gf277f09f64f4, first f=
ail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab         | compiler | defconfig  =
                | regressions
-----------------------------+-------+-------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2        | arm64 | lab-broonie | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/627a72d1c4d4f9a7d08f5735

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.277=
-78-g71dc583ecdb9/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.277=
-78-g71dc583ecdb9/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627a72d1c4d4f9a7d08f5=
736
        failing since 0 day (last pass: v4.14.277-54-gfa6de16ffc4e, first f=
ail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab         | compiler | defconfig  =
                | regressions
-----------------------------+-------+-------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/627a6f9d9974fd8f0f8f5717

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.277=
-78-g71dc583ecdb9/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.277=
-78-g71dc583ecdb9/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627a6f9d9974fd8f0f8f5=
718
        failing since 0 day (last pass: v4.14.277-54-gf277f09f64f4, first f=
ail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab         | compiler | defconfig  =
                | regressions
-----------------------------+-------+-------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/627a718138fce99a6e8f575a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.277=
-78-g71dc583ecdb9/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.277=
-78-g71dc583ecdb9/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627a718138fce99a6e8f5=
75b
        failing since 0 day (last pass: v4.14.277-54-gfa6de16ffc4e, first f=
ail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab         | compiler | defconfig  =
                | regressions
-----------------------------+-------+-------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-broonie | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/627a6f7537620149b88f5734

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.277=
-78-g71dc583ecdb9/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.277=
-78-g71dc583ecdb9/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627a6f7537620149b88f5=
735
        failing since 0 day (last pass: v4.14.277-54-gf277f09f64f4, first f=
ail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab         | compiler | defconfig  =
                | regressions
-----------------------------+-------+-------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-broonie | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/627a72d225b54464c28f572d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.277=
-78-g71dc583ecdb9/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.277=
-78-g71dc583ecdb9/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627a72d225b54464c28f5=
72e
        failing since 0 day (last pass: v4.14.277-54-gfa6de16ffc4e, first f=
ail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab         | compiler | defconfig  =
                | regressions
-----------------------------+-------+-------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/627a6f39ebc0e4af9b8f573a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.277=
-78-g71dc583ecdb9/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.277=
-78-g71dc583ecdb9/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627a6f39ebc0e4af9b8f5=
73b
        failing since 0 day (last pass: v4.14.277-54-gf277f09f64f4, first f=
ail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab         | compiler | defconfig  =
                | regressions
-----------------------------+-------+-------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/627a72d425b54464c28f5730

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.277=
-78-g71dc583ecdb9/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.277=
-78-g71dc583ecdb9/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627a72d425b54464c28f5=
731
        failing since 0 day (last pass: v4.14.277-54-gfa6de16ffc4e, first f=
ail: v4.14.277-75-g7a298ff98d4a) =

 =20
