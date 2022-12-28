Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 387ED658723
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 22:58:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbiL1V62 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 16:58:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbiL1V61 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 16:58:27 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB44A11A2A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 13:58:26 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id n65-20020a17090a2cc700b0021bc5ef7a14so17262890pjd.0
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 13:58:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=dxNsDCaT8kFhfqPfEGZoR6VYrablrjE1Ntgc5m57Rsk=;
        b=f5DbI8lihL6JzGv62DArFVwkcEpGlu63SRm/m1HBwEGbxV2E/v+y5Kqp4zD8lUq2eS
         IqmqRHcxc5ZlaZqmIfcmsysKrt24Ya9PNIxGAy1eubTCZw51dpDm/esiBajcdmiHzsuu
         OBQwjiCdj0ZzRiQn/sia0swUuT9RKfK0FTTuF339m/zASo8/YB/z+3Sh1XIMp4AFUxHi
         fzCWc6ToznbssO6aBmL9OH3KP2m9aHuQ9u6Vuv+1n33JER/mgj6hdmDo4DtOOHROp4eC
         icDgeSs0x87Cgtg1KyleLW9MqxMe3Rdn6pJT+Z/A6xBO+F6UMbkTpteP/zq7nKLEYLTP
         IgUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dxNsDCaT8kFhfqPfEGZoR6VYrablrjE1Ntgc5m57Rsk=;
        b=sErX77fGIXuBQcRL8G1aiAH05twUD/4QdBDVpA0TOTkuMiYTQTP+OUBaWTfGfoqtr1
         w3WprbvgHfsQo5yBrAKOL7lENggMwWfWCWRUjjoY8RuyykSwPLhUQaxvowJOKcLEsAJz
         nFVl4PWvMajEhkP1Xd6XsMgugLK+LIs+TF8cSmYVSY3dxXNfXmxQQwgPMDLjxyawmoeT
         dibV8rVqNHRKqxD+7VmHAK69X54C0N1J9MZdpUiskTUxWwcSyjtdrknG2BvZ3+1bDPgo
         AGtC0i1gIWE/aPZ7zqAXpgPHlse71x194V0LMsxkyZAgfhXT5nZQi5X7BeFvUvFl8Eti
         4yng==
X-Gm-Message-State: AFqh2koPq8Oef9xduWBaF687dSw+pEqanu4AAadUByRNz7bGgdJsMyc/
        zVWUygM8Wgheu7Pa53Zu4Llwp+EWlrKcBTYnhu0=
X-Google-Smtp-Source: AMrXdXvyuTAtBRGivY6jxTwRE4kD6jpvZr3mkshEEqcNjXOhfA3CIesJpI2dw6YMBFYjEDs5q/pyyw==
X-Received: by 2002:a17:902:d3c9:b0:190:eec0:9fe3 with SMTP id w9-20020a170902d3c900b00190eec09fe3mr32440531plb.48.1672264706072;
        Wed, 28 Dec 2022 13:58:26 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ij27-20020a170902ab5b00b00189529ed580sm6257065plb.60.2022.12.28.13.58.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Dec 2022 13:58:25 -0800 (PST)
Message-ID: <63acbc01.170a0220.91c38.a4ac@mx.google.com>
Date:   Wed, 28 Dec 2022 13:58:25 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.228-455-g11507d2e8f603
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 118 runs,
 4 regressions (v5.4.228-455-g11507d2e8f603)
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

stable-rc/queue/5.4 baseline: 118 runs, 4 regressions (v5.4.228-455-g11507d=
2e8f603)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig  =
                | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.228-455-g11507d2e8f603/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.228-455-g11507d2e8f603
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      11507d2e8f60310ce65cfdfab1def1ffae4ff958 =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63ac8b11cc228dc72b4eee46

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-4=
55-g11507d2e8f603/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-4=
55-g11507d2e8f603/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221216.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ac8b11cc228dc72b4ee=
e47
        failing since 155 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63ac8ab6b7e6c6be854eee21

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-4=
55-g11507d2e8f603/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-4=
55-g11507d2e8f603/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221216.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ac8ab6b7e6c6be854ee=
e22
        failing since 155 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/63ac8c0126e07d8fb14eee4d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-4=
55-g11507d2e8f603/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-4=
55-g11507d2e8f603/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221216.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ac8c0126e07d8fb14ee=
e4e
        failing since 155 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/63ac8bf426e07d8fb14eee3a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-4=
55-g11507d2e8f603/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-=
virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-4=
55-g11507d2e8f603/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-=
virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221216.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ac8bf426e07d8fb14ee=
e3b
        failing since 155 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =20
