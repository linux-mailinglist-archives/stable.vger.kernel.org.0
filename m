Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45C95639143
	for <lists+stable@lfdr.de>; Fri, 25 Nov 2022 23:04:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbiKYWEt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Nov 2022 17:04:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiKYWEs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Nov 2022 17:04:48 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3EEC23380
        for <stable@vger.kernel.org>; Fri, 25 Nov 2022 14:04:47 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id k7so5028079pll.6
        for <stable@vger.kernel.org>; Fri, 25 Nov 2022 14:04:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=p5O8ISJbf7FNnjq4xzHNt2BgJ/A2ydoinovesD4mc64=;
        b=7OSAE1x654lZGaze2SlMasMSzjpklsvtCgKuu3h2VHCfa8FRmBHzdkUxgb3esxQHI+
         EkcEZVkKW0zOf/+N8a1BRVm4TZwn+33e48f/ViqOGuYCVfxduBW/heJAXWglxWkpaZ68
         s6gxCwK748R5bRGvRvcUyVA4lf3dC0zKcEgitC+rSY9vspx7nuNqT2+JbPhH5kx6M4cx
         plS7LmXaX0KBaUKlK+jx4QmMJDAStU08BhpRqCki2lXIRtsM9//hI+98TCGomjbadk9a
         5/VVNGouzbf5QbGlQNtEWbDZqxkmstfNHkmbTj1MpjtboGg+4s8vWj0+IDXDUi4NxsoD
         op/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p5O8ISJbf7FNnjq4xzHNt2BgJ/A2ydoinovesD4mc64=;
        b=q385ZRnw/vABZCGhkwg5fHEkJXSX2TDeo5kRQfo4/Gkw2Dm0a10QbCo4QuWy8bPgJk
         XN4mPm+Kngcq1PEt55f0r6fP40xIQpFy1sEXZglOqA/CFLmZXyxdAaM5BVF9MC+RfXIj
         MtTVsU8XEIlycXjhClyEje0sF/5xxyvT0+j2DsxiSerCXDsCcoPz+FaFT+/Gx0XMfNpo
         UIr+Qky5dYDz4nS95lm3g1wS5xyFmQPLXkQJnCGit+CLBinjL8qorqrC5Jk4nFEY3y2N
         Ko9LIXnLCiSUbSk5wmKUH+Z4ed4Dfl1RIQ9AeF8hD0K4ckklgx2SNcjtTCzrW9/p0K57
         sz8Q==
X-Gm-Message-State: ANoB5pnj9THszgTroSVMckO0WAj2Tf/MVkffO5wom/ODbh0uFYn4J7qv
        vmGPNeAyKoZhJX7dJBoGG/55QZbqdeWwi1BBeak=
X-Google-Smtp-Source: AA0mqf4pfucPRIh9V4Nv6jTNkvKHBBytE1IGsq9U8E8JPOzeUoCMOHp+DO31Kvtt8UWyZ3dKj7jwDw==
X-Received: by 2002:a17:90a:3d49:b0:213:9458:8a93 with SMTP id o9-20020a17090a3d4900b0021394588a93mr49090145pjf.233.1669413886935;
        Fri, 25 Nov 2022 14:04:46 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id bk16-20020a17090b081000b00218c5bdb983sm3431477pjb.22.2022.11.25.14.04.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Nov 2022 14:04:46 -0800 (PST)
Message-ID: <63813bfe.170a0220.92a2.5019@mx.google.com>
Date:   Fri, 25 Nov 2022 14:04:46 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.224-156-g4d2a309b5c28
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 95 runs,
 6 regressions (v5.4.224-156-g4d2a309b5c28)
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

stable-rc/queue/5.4 baseline: 95 runs, 6 regressions (v5.4.224-156-g4d2a309=
b5c28)

Regressions Summary
-------------------

platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre | gcc-10   | defconfig+ar=
m64-chromebook | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-baylibre | gcc-10   | defconfig   =
               | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre | gcc-10   | defconfig   =
               | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-baylibre | gcc-10   | defconfig   =
               | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre | gcc-10   | defconfig+ar=
m64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre | gcc-10   | defconfig   =
               | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.224-156-g4d2a309b5c28/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.224-156-g4d2a309b5c28
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4d2a309b5c28a2edc0900542d22fec3a5a22243b =



Test Regressions
---------------- =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre | gcc-10   | defconfig+ar=
m64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63812277591f88d60c2abd39

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.224-1=
56-g4d2a309b5c28/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/basel=
ine-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.224-1=
56-g4d2a309b5c28/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/basel=
ine-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63812277591f88d60c2ab=
d3a
        failing since 199 days (last pass: v5.4.191-84-g56ce42d78d96, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre | gcc-10   | defconfig   =
               | 1          =


  Details:     https://kernelci.org/test/plan/id/638123b9010d979fd72abd1e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.224-1=
56-g4d2a309b5c28/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.224-1=
56-g4d2a309b5c28/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/638123b9010d979fd72ab=
d1f
        failing since 199 days (last pass: v5.4.191-77-g1a3b249e415b, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre | gcc-10   | defconfig   =
               | 1          =


  Details:     https://kernelci.org/test/plan/id/638123b64e563572162abd19

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.224-1=
56-g4d2a309b5c28/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.224-1=
56-g4d2a309b5c28/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/638123b64e563572162ab=
d1a
        failing since 199 days (last pass: v5.4.191-77-g1a3b249e415b, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-baylibre | gcc-10   | defconfig   =
               | 1          =


  Details:     https://kernelci.org/test/plan/id/638123e1ee97bb45c02abd03

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.224-1=
56-g4d2a309b5c28/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.224-1=
56-g4d2a309b5c28/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/638123e1ee97bb45c02ab=
d04
        failing since 199 days (last pass: v5.4.191-77-g1a3b249e415b, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre | gcc-10   | defconfig+ar=
m64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6381227a104f9393e02abd79

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.224-1=
56-g4d2a309b5c28/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/basel=
ine-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.224-1=
56-g4d2a309b5c28/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/basel=
ine-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6381227a104f9393e02ab=
d7a
        failing since 199 days (last pass: v5.4.191-84-g56ce42d78d96, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre | gcc-10   | defconfig   =
               | 1          =


  Details:     https://kernelci.org/test/plan/id/638123c835331692492abd37

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.224-1=
56-g4d2a309b5c28/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.224-1=
56-g4d2a309b5c28/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/638123c835331692492ab=
d38
        failing since 199 days (last pass: v5.4.191-77-g1a3b249e415b, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =20
