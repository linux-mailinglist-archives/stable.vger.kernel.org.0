Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF2D677304
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 23:33:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbjAVWdv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 17:33:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230007AbjAVWdt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 17:33:49 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C74F126FB
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 14:33:47 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id o13so10132613pjg.2
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 14:33:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=G9NLkMZrB13ap4MrQitl76K5VUM8QQ8kjpFYRB+pjzM=;
        b=E7MqwHDHwP/Ctw79O5vPDy4TOYZYflyxnHaU5ntCzu5J8USkdxRVXy9w+sBEi/0stG
         MJ2A5cHv7YMMwnHui1zvTReIJhgh7Jxcwyzgr5krQOIw7ITWGWcVjuTvArq7/v+e3qFo
         VdbpdvdiJwgTiT/7xEd2PX8ANIhRvUOeUvDLGVGT4JU2GqrSMslevNCrxCxp9Fpn+NKi
         iUs4qPQk5Qfd+gnm71Z2dK7JirirlGPcFF8Qd1xJAD5P5nxEe5z3hs5/g8yieEnzplA6
         5xNcRQNdtVpbavNbFcBGt9lGxQW9p27rT8QSC6B+szDNF5e47mzy82+kIa8UDjsavwea
         3rkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G9NLkMZrB13ap4MrQitl76K5VUM8QQ8kjpFYRB+pjzM=;
        b=0x01xqiSRwPTx2+c1equ3ovp77JGWIwZEFy9J+fjI5p4rBgMMoE5h12EOejtkVjAru
         TssxkP/M+LI+Zh/CRSSvfG3czWwfKK/9HH317xaihoVBrMNmRMXzjiOGmcvXJReWv2iP
         1dfihopDAFH3iDpjEKZXSH4W9g+QQVYephxhusxTibi168SIO+eS8lVtygRP8FpmXL5C
         RO89INlKt/fcVt/B13RTNFdWh9p3FX139zONQLoI4yw3CWemyZB4yIzgHmKYDKUiT0HM
         61UAjntRxz761jrB/FZtfUnTye33b4Oa5xNoJBPSqPtv54wFx6y7g6fPvZUPdAKm071Q
         cNoQ==
X-Gm-Message-State: AFqh2kpcy4Vhip7KNCKUlrbmwZPM8nkwftpVrbXM/ZULP4g1UYVmFA6z
        sh0Bhg0Kng8P3FWCYluSL+7zeNgTlUp9QRHTBLs=
X-Google-Smtp-Source: AMrXdXvN/6p/t7XkTUlGCd3X8CTvR0jyuCytVx4ceydhS8u+Cv/evf3fih0iMyWkBSpHw5gow+zNCg==
X-Received: by 2002:a17:902:e887:b0:193:e89:f5ff with SMTP id w7-20020a170902e88700b001930e89f5ffmr57733195plg.28.1674426826175;
        Sun, 22 Jan 2023 14:33:46 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z9-20020a170903018900b00189db296776sm30939277plg.17.2023.01.22.14.33.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Jan 2023 14:33:45 -0800 (PST)
Message-ID: <63cdb9c9.170a0220.f7ee6.1dd0@mx.google.com>
Date:   Sun, 22 Jan 2023 14:33:45 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.302-364-ga6d71d85fd0f
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.14.y baseline: 123 runs,
 18 regressions (v4.14.302-364-ga6d71d85fd0f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 123 runs, 18 regressions (v4.14.302-364-ga=
6d71d85fd0f)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre  | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-collabora | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-baylibre  | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.302-364-ga6d71d85fd0f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.302-364-ga6d71d85fd0f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a6d71d85fd0f5c89a0e3aa52de437d22485dfa61 =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre  | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/63cd820314e203bed9915eba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.3=
02-364-ga6d71d85fd0f/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm6=
4-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.3=
02-364-ga6d71d85fd0f/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm6=
4-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cd820314e203bed9915=
ebb
        failing since 152 days (last pass: v4.14.266-45-gce409501ca5f, firs=
t fail: v4.14.290-230-g4d54ef55c38e) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63cd82e24578cd3852915ec1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.3=
02-364-ga6d71d85fd0f/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/b=
aseline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.3=
02-364-ga6d71d85fd0f/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/b=
aseline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cd82e24578cd3852915=
ec2
        failing since 258 days (last pass: v4.14.277-55-gfb8b8dfe0168, firs=
t fail: v4.14.277-71-geacdf1a71409) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/63cd8bb8a46d6e3449915ec0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.3=
02-364-ga6d71d85fd0f/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64=
-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.3=
02-364-ga6d71d85fd0f/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64=
-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cd8bb8a46d6e3449915=
ec1
        failing since 152 days (last pass: v4.14.266-45-gce409501ca5f, firs=
t fail: v4.14.290-230-g4d54ef55c38e) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63cd8f7974aa3d933e915ec6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.3=
02-364-ga6d71d85fd0f/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/ba=
seline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.3=
02-364-ga6d71d85fd0f/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/ba=
seline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cd8f7974aa3d933e915=
ec7
        failing since 258 days (last pass: v4.14.277-55-gfb8b8dfe0168, firs=
t fail: v4.14.277-71-geacdf1a71409) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-collabora | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/63cd81bb92b48c7697915eca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.3=
02-364-ga6d71d85fd0f/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm=
64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.3=
02-364-ga6d71d85fd0f/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm=
64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cd81bb92b48c7697915=
ecb
        failing since 152 days (last pass: v4.14.266-45-gce409501ca5f, firs=
t fail: v4.14.290-230-g4d54ef55c38e) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/63cd820614e203bed9915ec0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.3=
02-364-ga6d71d85fd0f/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm6=
4-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.3=
02-364-ga6d71d85fd0f/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm6=
4-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cd820614e203bed9915=
ec1
        failing since 257 days (last pass: v4.14.277-55-gfb8b8dfe0168, firs=
t fail: v4.14.277-79-ga6b67a30bbcc) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63cd82dee07bca8159915ed2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.3=
02-364-ga6d71d85fd0f/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/b=
aseline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.3=
02-364-ga6d71d85fd0f/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/b=
aseline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cd82dee07bca8159915=
ed3
        failing since 258 days (last pass: v4.14.277-55-gfb8b8dfe0168, firs=
t fail: v4.14.277-71-geacdf1a71409) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/63cd8d0c3bb0483388915ed4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.3=
02-364-ga6d71d85fd0f/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.3=
02-364-ga6d71d85fd0f/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cd8d0c3bb0483388915=
ed5
        failing since 257 days (last pass: v4.14.277-55-gfb8b8dfe0168, firs=
t fail: v4.14.277-79-ga6b67a30bbcc) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63cd8e10302adbacab915ed2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.3=
02-364-ga6d71d85fd0f/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/ba=
seline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.3=
02-364-ga6d71d85fd0f/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/ba=
seline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cd8e10302adbacab915=
ed3
        failing since 258 days (last pass: v4.14.277-55-gfb8b8dfe0168, firs=
t fail: v4.14.277-71-geacdf1a71409) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-baylibre  | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/63cd8202707c6c599c915ed8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.3=
02-364-ga6d71d85fd0f/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm6=
4-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.3=
02-364-ga6d71d85fd0f/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm6=
4-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cd8202707c6c599c915=
ed9
        failing since 257 days (last pass: v4.14.277-55-gfb8b8dfe0168, firs=
t fail: v4.14.277-79-ga6b67a30bbcc) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63cd82e1774c2d4f57915ed3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.3=
02-364-ga6d71d85fd0f/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/b=
aseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.3=
02-364-ga6d71d85fd0f/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/b=
aseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cd82e1774c2d4f57915=
ed4
        failing since 141 days (last pass: v4.14.267-33-g871c9e115feb, firs=
t fail: v4.14.291-43-g3eabc273fb308) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/63cd8ba4a46d6e3449915eb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.3=
02-364-ga6d71d85fd0f/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64=
-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.3=
02-364-ga6d71d85fd0f/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64=
-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cd8ba4a46d6e3449915=
eba
        failing since 257 days (last pass: v4.14.277-55-gfb8b8dfe0168, firs=
t fail: v4.14.277-79-ga6b67a30bbcc) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63cd8e74c3656edb54915eb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.3=
02-364-ga6d71d85fd0f/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/ba=
seline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.3=
02-364-ga6d71d85fd0f/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/ba=
seline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cd8e74c3656edb54915=
eba
        failing since 141 days (last pass: v4.14.267-33-g871c9e115feb, firs=
t fail: v4.14.291-43-g3eabc273fb308) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63cd82bfff94bba605915ee1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.3=
02-364-ga6d71d85fd0f/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.3=
02-364-ga6d71d85fd0f/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cd82bfff94bba605915=
ee2
        failing since 141 days (last pass: v4.14.267-33-g871c9e115feb, firs=
t fail: v4.14.291-43-g3eabc273fb308) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/63cd820414e203bed9915ebd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.3=
02-364-ga6d71d85fd0f/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm6=
4-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.3=
02-364-ga6d71d85fd0f/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm6=
4-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cd820414e203bed9915=
ebe
        failing since 257 days (last pass: v4.14.277-55-gfb8b8dfe0168, firs=
t fail: v4.14.277-79-ga6b67a30bbcc) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63cd82df4578cd3852915eba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.3=
02-364-ga6d71d85fd0f/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/b=
aseline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.3=
02-364-ga6d71d85fd0f/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/b=
aseline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cd82df4578cd3852915=
ebb
        failing since 258 days (last pass: v4.14.277-55-gfb8b8dfe0168, firs=
t fail: v4.14.277-71-geacdf1a71409) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/63cd8ce488476b7dde915ed5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.3=
02-364-ga6d71d85fd0f/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.3=
02-364-ga6d71d85fd0f/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cd8ce488476b7dde915=
ed6
        failing since 257 days (last pass: v4.14.277-55-gfb8b8dfe0168, firs=
t fail: v4.14.277-79-ga6b67a30bbcc) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63cd8e4de04ee57b49915ec6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.3=
02-364-ga6d71d85fd0f/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/ba=
seline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.3=
02-364-ga6d71d85fd0f/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/ba=
seline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cd8e4de04ee57b49915=
ec7
        failing since 258 days (last pass: v4.14.277-55-gfb8b8dfe0168, firs=
t fail: v4.14.277-71-geacdf1a71409) =

 =20
