Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0C865DDD1
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 21:47:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235259AbjADUrj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 15:47:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjADUrj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 15:47:39 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72B3413EB1
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 12:47:37 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id b2so37083264pld.7
        for <stable@vger.kernel.org>; Wed, 04 Jan 2023 12:47:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=9UfDDHZ3MPQ5uO/+ZGtUylzuAeBXE3Q5HCl3jycGLu4=;
        b=mtQ84PMcPTiMTw4fgCWTsfapr9+t8Jlg0myA6V0906+MPB2jlmVjI4zXs31MBjHZLi
         jm2tBUyd6okhLSR0z64xZwAitVeBJDP3xOkIa+ZBwWPBpT6Le4U/1C9jCPvz+FVQ8eLO
         BLc4zGviiO9QUSvTYOp44mz5fdvP4M4PsNFxeQRkIlNxw14SAMkwK6bs1zHfTkuVq1Qp
         0VksQPvWunhZW18fd6XVYYnH2YmQi+QM94i/xvhX61eRiKmcJ0OlkLQpnBz0QK9wI/w8
         xi15OvzsNWsQt1I6VBxs74gCRt6szvmRgVjcrl/VRdjPP85SaTs2vZpSwGZGYZSTMx1P
         t5NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9UfDDHZ3MPQ5uO/+ZGtUylzuAeBXE3Q5HCl3jycGLu4=;
        b=UjcGtJqzZ320twGwvWlzNTTpqeexYYjSe2L6UgGXgHmKhrbwrHza1zumzscpQ6s1ga
         ZyZYePNaqjBvvutlMcT3GufNpNHqomN5J9ikco4WhjJcRGqUybmmi8ygR9lcBZyZSM3a
         4xQOwZfNjkoHu9J9Z01HIm+i2EXWysnu4o6BX8EEikzgwpiCJnX6eLf7GLJADBe6Qzk7
         qvQ0yzDH52rTHaPwGyaZobkIKyjvijIvINp7WzidGaydCJxdHZ/Zz+nwPGXBtx6GhPjG
         X9LfILWCVXk63D84AzV3OgJzsTwr1ACiZV92fAWmjC3j5A29pQeFNhacPBqXJKm8sFNE
         qsbw==
X-Gm-Message-State: AFqh2kpSYniOnIO+rbYFaa5gmutK4bzI1WtNBkEyj6xBjw3Vs53kIeVD
        IzV8kc1zQ2lJDOLqtQWv7vDfjqa3OP0ateycMqCF1A==
X-Google-Smtp-Source: AMrXdXsFt1uq0aNnpRmTyP48mDVr1bOgncOXk+rbFkiVELZaltgPDTq3fgO3xaHLVbLQiBJhZiBBlw==
X-Received: by 2002:a17:902:ab1b:b0:191:3f73:bf4e with SMTP id ik27-20020a170902ab1b00b001913f73bf4emr63958370plb.62.1672865256789;
        Wed, 04 Jan 2023 12:47:36 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n8-20020a1709026a8800b00172f6726d8esm24589928plk.277.2023.01.04.12.47.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 12:47:36 -0800 (PST)
Message-ID: <63b5e5e8.170a0220.52e1a.642f@mx.google.com>
Date:   Wed, 04 Jan 2023 12:47:36 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.302-307-g7e3a8fefcea8
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.14.y baseline: 80 runs,
 6 regressions (v4.14.302-307-g7e3a8fefcea8)
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

stable-rc/linux-4.14.y baseline: 80 runs, 6 regressions (v4.14.302-307-g7e3=
a8fefcea8)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.302-307-g7e3a8fefcea8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.302-307-g7e3a8fefcea8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7e3a8fefcea86b7c762ca32f40fa9b4002c049d0 =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63b5b743c236518b8a4eee25

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.3=
02-307-g7e3a8fefcea8/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/ba=
seline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.3=
02-307-g7e3a8fefcea8/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/ba=
seline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221230.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63b5b743c236518b8a4ee=
e26
        failing since 142 days (last pass: v4.14.267-33-g871c9e115feb, firs=
t fail: v4.14.290-154-gc3e4c291190ba) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/63b5b937dd619400ca4eee1b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.3=
02-307-g7e3a8fefcea8/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64=
-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.3=
02-307-g7e3a8fefcea8/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64=
-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221230.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63b5b937dd619400ca4ee=
e1c
        failing since 239 days (last pass: v4.14.277-55-gfb8b8dfe0168, firs=
t fail: v4.14.277-79-ga6b67a30bbcc) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63b5b3c62b6f9c0d644eee2d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.3=
02-307-g7e3a8fefcea8/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.3=
02-307-g7e3a8fefcea8/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221230.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63b5b3c62b6f9c0d644ee=
e2e
        failing since 142 days (last pass: v4.14.267-33-g871c9e115feb, firs=
t fail: v4.14.290-154-gc3e4c291190ba) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63b5b706dc89df64334eee4c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.3=
02-307-g7e3a8fefcea8/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/ba=
seline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.3=
02-307-g7e3a8fefcea8/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/ba=
seline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221230.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63b5b706dc89df64334ee=
e4d
        failing since 240 days (last pass: v4.14.277-55-gfb8b8dfe0168, firs=
t fail: v4.14.277-71-geacdf1a71409) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/63b5b405c0a66c48b54eee21

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.3=
02-307-g7e3a8fefcea8/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm=
64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.3=
02-307-g7e3a8fefcea8/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm=
64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221230.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63b5b405c0a66c48b54ee=
e22
        failing since 134 days (last pass: v4.14.266-45-gce409501ca5f, firs=
t fail: v4.14.290-230-g4d54ef55c38e) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63b5b3c28ae493cb034eee36

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.3=
02-307-g7e3a8fefcea8/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.3=
02-307-g7e3a8fefcea8/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221230.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63b5b3c28ae493cb034ee=
e37
        failing since 141 days (last pass: v4.14.267-33-g871c9e115feb, firs=
t fail: v4.14.290-176-g1ee5c98a9d0bc) =

 =20
