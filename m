Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F23B24BBC32
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 16:29:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236415AbiBRP3e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 10:29:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232013AbiBRP3b (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 10:29:31 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6762C2B2C65
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 07:29:14 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id v5-20020a17090a4ec500b001b8b702df57so12681930pjl.2
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 07:29:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=oglHpLzr+FtdrISo4riVmeQUmJSTCuU5/ds8dEQZScc=;
        b=coRx3dfyWX6n+Vt/DMt6n58+qhEMHOsX83DlYRrw2PBHApx3qssO72Xe8ACNkfNmAh
         eNrdUFNIyYLjvHfEj4+9nbokiVMhG3cEOMLTKJ/8X0Kmjxu68ww5w7SbnrJ/RGpSGx3Z
         65EdPDA8WBVlVPkQJxDCU5F1aPtpMtKQGPAAeKYVGncjfVgMU3KPcYUyR79jEKj2+M+e
         Knz7bWgAKu3csPG+CtlQX6FEP+xNNlUphYYzU0+E/5ll8q0/02mHgkRhFjn3iIS3/N0v
         4B8tPEuOmgugQ38mrxkhAGR1KPg5lS/cZM15y1ydhG0eP+Nizg9/WfNHuqUn5mT8cwYH
         mUcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=oglHpLzr+FtdrISo4riVmeQUmJSTCuU5/ds8dEQZScc=;
        b=gDyP/VSh2OrDCUgZ1+PiihooZjaZApIzsen+0temz0/NhWQWNQMEkfElAyj4GC80gK
         QfznxP5VWhNxZLXhBACTCKR3JqSzJIxDZstUhUZyY49QXC/dpw/7L1Rb2CKmAL1/fzPc
         8J3mM3hidkrxKSO31YkuB6e7sVhSmm+1UTu6ZAQNsvms3BfPq0R94LEfE4jbVTX5fFnj
         0/ovU/2GPG8j2UOumwOiO6sAaVTVU8eKW32zBWU42KsE2g0FnK9qPivTrlCQNceT+FFm
         ccDhjHOTTobOiG5pPqeOpBJETdraGe81Nr4RLrIEQqN4KmMZWL7qsYCOhdDac3bakWKh
         Z5bQ==
X-Gm-Message-State: AOAM532tJ5rjbzVZ812FW2JQM7t86y+l9YcdG4F63XZ8RnFaTETGt+rU
        2z4254Xl3tVhwRJZvf1fKtSdIXBAkzDvfjzl
X-Google-Smtp-Source: ABdhPJyWe5MJG3YpSQN1wXdGwDFk0jwZKUYV7TChvXkte0SSQlrfknZN5Xs9PjK/Wy7sDMySrF59Uw==
X-Received: by 2002:a17:902:7298:b0:14e:f6c2:8b64 with SMTP id d24-20020a170902729800b0014ef6c28b64mr8016760pll.75.1645198153440;
        Fri, 18 Feb 2022 07:29:13 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m21sm11318194pgh.69.2022.02.18.07.29.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 07:29:13 -0800 (PST)
Message-ID: <620fbb49.1c69fb81.f1d12.e32f@mx.google.com>
Date:   Fri, 18 Feb 2022 07:29:13 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.230-20-g549cd99b49a8
Subject: stable-rc/queue/4.19 baseline: 100 runs,
 9 regressions (v4.19.230-20-g549cd99b49a8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 100 runs, 9 regressions (v4.19.230-20-g549cd=
99b49a8)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
panda                      | arm   | lab-collabora | gcc-10   | omap2plus_d=
efconfig | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-baylibre  | gcc-10   | defconfig  =
         | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig  =
         | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig  =
         | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig  =
         | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-baylibre  | gcc-10   | defconfig  =
         | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig  =
         | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig  =
         | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig  =
         | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.230-20-g549cd99b49a8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.230-20-g549cd99b49a8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      549cd99b49a8257d8112a157ed03c6c5ed4610b5 =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
panda                      | arm   | lab-collabora | gcc-10   | omap2plus_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/620f9d39d7bffb10a1c62969

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.230=
-20-g549cd99b49a8/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.230=
-20-g549cd99b49a8/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/620f9d39d7bffb1=
0a1c6296c
        new failure (last pass: v4.19.230-16-g06418b3894b9)
        2 lines

    2022-02-18T13:20:39.842307  <8>[   21.582427] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-02-18T13:20:39.888347  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/101
    2022-02-18T13:20:39.897781  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2022-02-18T13:20:39.912548  <8>[   21.654876] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre  | gcc-10   | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/620f8133f6fe5b6534c62996

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.230=
-20-g549cd99b49a8/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.230=
-20-g549cd99b49a8/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/620f8133f6fe5b6534c62=
997
        failing since 9 days (last pass: v4.19.227-86-g4a26c86a185c, first =
fail: v4.19.227-86-g59fd6eade0cc) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/620f81197ada448366c6298f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.230=
-20-g549cd99b49a8/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.230=
-20-g549cd99b49a8/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/620f81197ada448366c62=
990
        failing since 9 days (last pass: v4.19.227-86-g4a26c86a185c, first =
fail: v4.19.227-86-g59fd6eade0cc) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/620f8134f6fe5b6534c62999

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.230=
-20-g549cd99b49a8/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.230=
-20-g549cd99b49a8/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/620f8134f6fe5b6534c62=
99a
        failing since 9 days (last pass: v4.19.227-86-g4a26c86a185c, first =
fail: v4.19.227-86-g59fd6eade0cc) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/620f8141f6fe5b6534c629b0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.230=
-20-g549cd99b49a8/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.230=
-20-g549cd99b49a8/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/620f8141f6fe5b6534c62=
9b1
        failing since 9 days (last pass: v4.19.227-86-g4a26c86a185c, first =
fail: v4.19.227-86-g59fd6eade0cc) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-baylibre  | gcc-10   | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/620f8136f6fe5b6534c629ad

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.230=
-20-g549cd99b49a8/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.230=
-20-g549cd99b49a8/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/620f8136f6fe5b6534c62=
9ae
        failing since 9 days (last pass: v4.19.227-86-g4a26c86a185c, first =
fail: v4.19.227-86-g59fd6eade0cc) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/620f815495ecf77b0ac62990

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.230=
-20-g549cd99b49a8/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.230=
-20-g549cd99b49a8/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/620f815495ecf77b0ac62=
991
        failing since 9 days (last pass: v4.19.227-86-g4a26c86a185c, first =
fail: v4.19.227-86-g59fd6eade0cc) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/620f815c330360bacec62968

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.230=
-20-g549cd99b49a8/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.230=
-20-g549cd99b49a8/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/620f815c330360bacec62=
969
        failing since 9 days (last pass: v4.19.227-86-g4a26c86a185c, first =
fail: v4.19.227-86-g59fd6eade0cc) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/620f81578c16fded5dc629a0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.230=
-20-g549cd99b49a8/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.230=
-20-g549cd99b49a8/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/620f81578c16fded5dc62=
9a1
        failing since 9 days (last pass: v4.19.227-86-g4a26c86a185c, first =
fail: v4.19.227-86-g59fd6eade0cc) =

 =20
