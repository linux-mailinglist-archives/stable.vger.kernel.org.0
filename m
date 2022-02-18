Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A268C4BC132
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 21:30:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239480AbiBRUax (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 15:30:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235855AbiBRUaw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 15:30:52 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F86C27F2B8
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 12:30:34 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id m11so4478774pls.5
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 12:30:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=sAKRHVWaTceVQlaFHZlcaTW5SvlpM8fuGG1Ifeq6uqM=;
        b=NphPF3i5jDsEAleMLmvaQ/nk7HwGp6O3H36FgfLec5/dGZYEUOnY4jEm8ezvkhmrS7
         toCJlO+DZfzCOlKeVWhYeZpW0cTqDxZQfJRHmZPJsgcJocPSeOHVkGsVSUkCk3c4AaYO
         goNosiojs/EEJbOfObpfY1QDPoTl9oPfS4tL6enisZiOODrKJ9GAOw/qo6GDtVnRhJhF
         xMCFB3zRVa2YYYng3GUTctHY11etL0LA3WvCnNTYRxRY1brZPizF3vgXF6AyO+LDVyiV
         AObog82c/IWwJkWyLkcoE45x6+awkNUHDo8nrcohsZA1E4SPNjUeMuwcmLpAP23uve2V
         PcSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=sAKRHVWaTceVQlaFHZlcaTW5SvlpM8fuGG1Ifeq6uqM=;
        b=ut1qCUuqBHoZeY76qbSyyRtqvf6YU6xaTloA4pC14gIVsBBNVODhYpjD4icFOPYtbQ
         WUz+UUg8fj8n/i2QMUV1jiWio6dDo+PMMMJ73gkYPRDSokMma5ltkvvc2FlR5hQpE827
         CO7dFBB1egtj2ftYHXUaW7+S7fn8b50rqwKtrE8f/Z4pYHrhDVIOtARi7ySA5xIlZSDh
         vvpy8gg9e+MbrgiN+rg7pGhROPfZmoa9sI1FNQM9Lq+mSMJHwYw0/JkVwhtEtqhsM15+
         wKR3cxAFwpLPhQOCom36Gy9ls09iJLInvyUyG2JXiFbV/Gwpyij1w2JIJ1i/reAphhx8
         y/JA==
X-Gm-Message-State: AOAM533mbd3HYS52O1bqVA8AJAIvhALqqSTBB5kGHxBiFqPF35vFk0Bk
        70X9Lm2LHnckM4vOO4e7Sr0jx1iIz/QD1Fqr
X-Google-Smtp-Source: ABdhPJwFwSTbL0VNInIs3EVA9iaEWKCK5Ss7ZDZTcsTT/QAqTMsW1DJ2W7irarqRXI/AqkQs8eS2ng==
X-Received: by 2002:a17:90a:2f81:b0:1b9:75fc:6e25 with SMTP id t1-20020a17090a2f8100b001b975fc6e25mr9938741pjd.61.1645216233457;
        Fri, 18 Feb 2022 12:30:33 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d13-20020a17090ae28d00b001bbb040d038sm191925pjz.40.2022.02.18.12.30.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 12:30:33 -0800 (PST)
Message-ID: <621001e9.1c69fb81.424ce.0e25@mx.google.com>
Date:   Fri, 18 Feb 2022 12:30:33 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.230-30-g704d460002f5
Subject: stable-rc/queue/4.19 baseline: 102 runs,
 9 regressions (v4.19.230-30-g704d460002f5)
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

stable-rc/queue/4.19 baseline: 102 runs, 9 regressions (v4.19.230-30-g704d4=
60002f5)

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
nel/v4.19.230-30-g704d460002f5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.230-30-g704d460002f5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      704d460002f53ec4012d3d0d9d60fc16e08c4088 =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
panda                      | arm   | lab-collabora | gcc-10   | omap2plus_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/620fceec8a88e0e3e2c6296f

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.230=
-30-g704d460002f5/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.230=
-30-g704d460002f5/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/620fceec8a88e0e=
3e2c62972
        failing since 0 day (last pass: v4.19.230-16-g06418b3894b9, first f=
ail: v4.19.230-20-g549cd99b49a8)
        2 lines

    2022-02-18T16:52:37.934591  <8>[   21.481781] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-02-18T16:52:37.982786  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/110
    2022-02-18T16:52:37.989266  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre  | gcc-10   | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/620fc99bf836adb168c6296b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.230=
-30-g704d460002f5/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.230=
-30-g704d460002f5/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/620fc99bf836adb168c62=
96c
        failing since 9 days (last pass: v4.19.227-86-g4a26c86a185c, first =
fail: v4.19.227-86-g59fd6eade0cc) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/620fc9310c70477712c6296a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.230=
-30-g704d460002f5/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.230=
-30-g704d460002f5/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/620fc9310c70477712c62=
96b
        failing since 9 days (last pass: v4.19.227-86-g4a26c86a185c, first =
fail: v4.19.227-86-g59fd6eade0cc) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/620fc937a2fcfec104c6298e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.230=
-30-g704d460002f5/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.230=
-30-g704d460002f5/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/620fc937a2fcfec104c62=
98f
        failing since 9 days (last pass: v4.19.227-86-g4a26c86a185c, first =
fail: v4.19.227-86-g59fd6eade0cc) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/620fc8f5f131a16e7cc6296a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.230=
-30-g704d460002f5/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.230=
-30-g704d460002f5/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/620fc8f5f131a16e7cc62=
96b
        failing since 9 days (last pass: v4.19.227-86-g4a26c86a185c, first =
fail: v4.19.227-86-g59fd6eade0cc) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-baylibre  | gcc-10   | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/620fc99cf0c1d10862c629d3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.230=
-30-g704d460002f5/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.230=
-30-g704d460002f5/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/620fc99cf0c1d10862c62=
9d4
        failing since 9 days (last pass: v4.19.227-86-g4a26c86a185c, first =
fail: v4.19.227-86-g59fd6eade0cc) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/620fc944a2fcfec104c629a6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.230=
-30-g704d460002f5/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.230=
-30-g704d460002f5/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/620fc944a2fcfec104c62=
9a7
        failing since 9 days (last pass: v4.19.227-86-g4a26c86a185c, first =
fail: v4.19.227-86-g59fd6eade0cc) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/620fc94ba2fcfec104c629ae

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.230=
-30-g704d460002f5/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.230=
-30-g704d460002f5/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/620fc94ba2fcfec104c62=
9af
        failing since 9 days (last pass: v4.19.227-86-g4a26c86a185c, first =
fail: v4.19.227-86-g59fd6eade0cc) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/620fc90bbdcf7eaee0c62983

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.230=
-30-g704d460002f5/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.230=
-30-g704d460002f5/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/620fc90bbdcf7eaee0c62=
984
        failing since 9 days (last pass: v4.19.227-86-g4a26c86a185c, first =
fail: v4.19.227-86-g59fd6eade0cc) =

 =20
