Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 074055F9F25
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 15:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbiJJNI5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 09:08:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiJJNI4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 09:08:56 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3AE65A2D7
        for <stable@vger.kernel.org>; Mon, 10 Oct 2022 06:08:54 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id z20so10320328plb.10
        for <stable@vger.kernel.org>; Mon, 10 Oct 2022 06:08:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=dadO4epTkYZ/0M4iu14nyGriXlx1WgwSEplqV5KfRek=;
        b=UjL7wPzIOmoToZXJGCKedBX5YWAIthuDDdyTB5yhXtVQeuiN0GeCLeJIpD6doowZgI
         WVdtMeFydq9W4BfUTeLI39GR8koiJTpn9PDefADpVbT3Qcnzg8Q0WGsexxydMy+RfusY
         S+EJz2YxAQRT6YrAX6v+1Fjp+DVM8LI3vhFZp7S5biIoTRA0L5tO3RL7mGaN4408LX82
         D7nzlDiOznQiCkHHAFI8UsMdyAGN1Oj2e9iX4zJvMjgnuif+kUB2xl+z2EAR1HBa/mOK
         S5oCPDr3Sm0HJKe08awSDhXc0g/rPA1NzV4VsBx1wPAFZalfqlPgOVzZYgEzQtetP6sq
         Z37g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dadO4epTkYZ/0M4iu14nyGriXlx1WgwSEplqV5KfRek=;
        b=Hji+RjaTGluTihqIc5AWORw1Md8IDDBlVsQEL+weECrM7GXyLEAPCFClDGRnnntgi/
         EDXeh6VByfAayNKR7bfPo5Gu9sgW4di90wH5uuPTgjzzHQfFyuR+j0zp9WY+Zg6OlI+0
         15fsHh07Wods4Bey6GUxP/OKESgh/XMWjaQnOEemBq+em4FnqzYOzUuRr07EFmmCrWZr
         ru+/LBAMpVEd8oPMQndMh9Ot2DGNj6nZulwNKCTkCMEo+ri2MRA0B0G9vpLZfQmtbY5U
         CbiNG1lFQMgwWl6o0VpiZcPItM3BczZgLw/9pGDyiTrGqNv/jd8CLO5nPZ+1dnx+Ui3r
         lA6g==
X-Gm-Message-State: ACrzQf2aMIwd4/ZASyq8g3XBA13NCTthsc2Bta3l28DB5MFKo9WeIuNa
        GaY94jNo5ICS6UnIpoz15YjgI/fsUH2YtXzC2ZY=
X-Google-Smtp-Source: AMsMyM7NDAuwuWYVXKWUwkichsRjc3wBfrwUkN5Y58OOLhf8z1EQiRLONwP5dwzSvaXET6vPp3P2xg==
X-Received: by 2002:a17:902:d484:b0:17f:7437:565d with SMTP id c4-20020a170902d48400b0017f7437565dmr18796863plg.154.1665407334208;
        Mon, 10 Oct 2022 06:08:54 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u10-20020a170902714a00b0017f92d7fe2csm6557601plm.288.2022.10.10.06.08.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Oct 2022 06:08:53 -0700 (PDT)
Message-ID: <63441965.170a0220.30b07.ad16@mx.google.com>
Date:   Mon, 10 Oct 2022 06:08:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.261-20-g5644b22533b36
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.19.y baseline: 87 runs,
 8 regressions (v4.19.261-20-g5644b22533b36)
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

stable-rc/linux-4.19.y baseline: 87 runs, 8 regressions (v4.19.261-20-g5644=
b22533b36)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.261-20-g5644b22533b36/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.261-20-g5644b22533b36
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5644b22533b36dc1a95ab1db4ae83381514b2908 =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6343f976ffa66e4fd6cab62b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
61-20-g5644b22533b36/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64=
-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
61-20-g5644b22533b36/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64=
-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6343f976ffa66e4fd6cab=
62c
        failing since 55 days (last pass: v4.19.230-41-g73351b9c55d9, first=
 fail: v4.19.255-191-gab9c8d4442969) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2      | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6343e963494d4e2a26cab5ec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
61-20-g5644b22533b36/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm=
64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
61-20-g5644b22533b36/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm=
64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6343e963494d4e2a26cab=
5ed
        failing since 55 days (last pass: v4.19.230-41-g73351b9c55d9, first=
 fail: v4.19.255-191-gab9c8d4442969) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6343f98abdb7954f42cab602

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
61-20-g5644b22533b36/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
61-20-g5644b22533b36/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6343f98abdb7954f42cab=
603
        failing since 41 days (last pass: v4.19.230-41-g73351b9c55d9, first=
 fail: v4.19.256-37-g34c3cf0160a8) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6343e978494d4e2a26cab604

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
61-20-g5644b22533b36/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm=
64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
61-20-g5644b22533b36/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm=
64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6343e978494d4e2a26cab=
605
        failing since 41 days (last pass: v4.19.230-41-g73351b9c55d9, first=
 fail: v4.19.256-37-g34c3cf0160a8) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6343fadea58695f6a7cab5fb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
61-20-g5644b22533b36/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64=
-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
61-20-g5644b22533b36/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64=
-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6343fadea58695f6a7cab=
5fc
        failing since 67 days (last pass: v4.19.230-41-g73351b9c55d9, first=
 fail: v4.19.254) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6343e964494d4e2a26cab5f0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
61-20-g5644b22533b36/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm=
64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
61-20-g5644b22533b36/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm=
64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6343e964494d4e2a26cab=
5f1
        failing since 67 days (last pass: v4.19.230-41-g73351b9c55d9, first=
 fail: v4.19.254) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6343f9b2121d40fd0ccab5ec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
61-20-g5644b22533b36/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
61-20-g5644b22533b36/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6343f9b2121d40fd0ccab=
5ed
        failing since 53 days (last pass: v4.19.230-41-g73351b9c55d9, first=
 fail: v4.19.255) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6343e974e2a64feb42cab5fc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
61-20-g5644b22533b36/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm=
64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
61-20-g5644b22533b36/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm=
64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6343e974e2a64feb42cab=
5fd
        failing since 53 days (last pass: v4.19.230-41-g73351b9c55d9, first=
 fail: v4.19.255) =

 =20
