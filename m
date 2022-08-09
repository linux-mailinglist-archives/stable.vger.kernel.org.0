Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C059658E320
	for <lists+stable@lfdr.de>; Wed, 10 Aug 2022 00:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbiHIWUT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 18:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbiHIWT6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 18:19:58 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0398331938
        for <stable@vger.kernel.org>; Tue,  9 Aug 2022 15:19:51 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id t22-20020a17090a449600b001f617f2bf3eso2278446pjg.0
        for <stable@vger.kernel.org>; Tue, 09 Aug 2022 15:19:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=DGMi4jO1DuE63xhju+B23/OrEDdvU0c6eXETNebBpew=;
        b=qZAbCohKGkCmxj7s2w9ctu634vZlk/CgXCtxbNwDfPL+Xfb9W6JDEZSpZpBDK6Bhky
         B0Flgk+MHjxe51lNCtTfo5FIa1G/Mo7mrV+y+BykOVc/pv9SzsX5ivm/BWRE+14TUN8g
         gG9Vx6X69+Yg7yfDLxa6xyw+fz0pZaakjTIgboLx8Xau9Hpdvx50nxhGX1LRJ4MCRFBq
         xmL+h5HM+klma4LmD3j7dxLcIqZ+fiL+q0FBbtnfLrOI8m7iJ08oBFMQ0mEuepdx/vpR
         AFeMv40m5jIbwlUV5XMM0k5Vi98RbQYiG+PenEbzcfwj4wMNAHcXzMSs8ooyjpU584ui
         54TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=DGMi4jO1DuE63xhju+B23/OrEDdvU0c6eXETNebBpew=;
        b=L+1qOy/qU6Bw42fGYno6ANBnz1L4HqrUAybnlgLQ7H++opUB7SObrR6ERSE8ZIGNvN
         6njOy2ib9OuQqYBKnSRNMyS3zFxOeNqHlTVb5xGojSpNk+2t0b+GYMVj24B+AmjLQoYj
         5YCbDKsU+mEz6Scup6xH9C01nAFiYFL5u+PR4IF+1xYy3xhBwmQIMFtVSvcOkOmd2CIT
         6K+tzJpijUbeRtGzm2nnXuz1JIGb6ydm5eauhpBHeIR7u/rZ9urRUlH7jZs0Q83r1Llx
         tluUpxTPU5As6w4n/nvPG1zsn/zRucAi7qcHIPpPnHS9QLmREr7pTrduHKfUiq18QHym
         srKQ==
X-Gm-Message-State: ACgBeo3aP4k62uRahNyl6fIiBrXmmIbjek+wEc3VnfZGq86xJWrOM5v8
        4HmDJHnHYfAqUfh66/qea9Dz0bBOjyAcimZ+ctw=
X-Google-Smtp-Source: AA6agR7IcUS56DNLym6AGWiW0E21uVG1ODg22kYtLnM3gYengNo9N4zWoPmLWyG3CN+Nv+9ohOB3hQ==
X-Received: by 2002:a17:902:e947:b0:170:d739:8cbe with SMTP id b7-20020a170902e94700b00170d7398cbemr6171413pll.141.1660083590049;
        Tue, 09 Aug 2022 15:19:50 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p18-20020a170902ead200b001677d4a9654sm11161376pld.265.2022.08.09.15.19.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Aug 2022 15:19:49 -0700 (PDT)
Message-ID: <62f2dd85.170a0220.fe525.3199@mx.google.com>
Date:   Tue, 09 Aug 2022 15:19:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.135-23-g2a486aef142c6
Subject: stable-rc/queue/5.10 baseline: 112 runs,
 5 regressions (v5.10.135-23-g2a486aef142c6)
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

stable-rc/queue/5.10 baseline: 112 runs, 5 regressions (v5.10.135-23-g2a486=
aef142c6)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

rk3399-gru-kevin           | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.135-23-g2a486aef142c6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.135-23-g2a486aef142c6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2a486aef142c6dab07f550261f1c3c1aeaa85052 =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62f2ae1e3dcdd88083daf08a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.135=
-23-g2a486aef142c6/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.135=
-23-g2a486aef142c6/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f2ae1e3dcdd88083daf=
08b
        failing since 91 days (last pass: v5.10.113-129-g2a88b987a070, firs=
t fail: v5.10.113-199-g20397cd2a67b) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62f2ade5fc45ace3abdaf060

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.135=
-23-g2a486aef142c6/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.135=
-23-g2a486aef142c6/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f2ade5fc45ace3abdaf=
061
        failing since 91 days (last pass: v5.10.113-129-g2a88b987a070, firs=
t fail: v5.10.113-199-g20397cd2a67b) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62f2ade477a5113a4fdaf067

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.135=
-23-g2a486aef142c6/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.135=
-23-g2a486aef142c6/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f2ade477a5113a4fdaf=
068
        failing since 91 days (last pass: v5.10.113-129-g2a88b987a070, firs=
t fail: v5.10.113-199-g20397cd2a67b) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62f2ade2be4f2112eddaf08e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.135=
-23-g2a486aef142c6/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.135=
-23-g2a486aef142c6/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f2ade2be4f2112eddaf=
08f
        failing since 91 days (last pass: v5.10.113-129-g2a88b987a070, firs=
t fail: v5.10.113-199-g20397cd2a67b) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
rk3399-gru-kevin           | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62f2ad8c0f129e80c5daf0bc

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.135=
-23-g2a486aef142c6/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.135=
-23-g2a486aef142c6/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62f2ad8c0f129e80c5daf0e0
        failing since 154 days (last pass: v5.10.103-56-ge5a40f18f4ce, firs=
t fail: v5.10.103-105-gf074cce6ae0d)

    2022-08-09T18:54:47.473145  /lava-7001974/1/../bin/lava-test-case
    2022-08-09T18:54:47.483997  <8>[   34.441899] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
