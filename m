Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 587FB5F316A
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 15:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbiJCNlb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 09:41:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbiJCNl0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 09:41:26 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11A254663B
        for <stable@vger.kernel.org>; Mon,  3 Oct 2022 06:41:16 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id z20so3185671plb.10
        for <stable@vger.kernel.org>; Mon, 03 Oct 2022 06:41:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=hV/yJyThsgoXYU3PpI0gsJ3H390iODdvlleqLjncx6E=;
        b=dvYFN59QV41foLo2I5MTktVO0LWGNUXjaRbxvmw1kT4ZHMKc15R9eySDQI4RfxVqI4
         q2jIHtvWH1Q44E+iQU/8ZL3P0ZG2qDOwWFNYBT59MfXudtHUGWy2/zoE3ZLMzJeVk5L0
         1gXBfZksANiVXLdE9ZdzXmj1TwtwmIqhS3zsGLM21VzIGiY1Jmi5RrYCclVPKt6sQwOY
         e95rfDIAZMXLAP0sn6cMw6heuRL1ZahiOBDjSpcE5rwZDtW5K6uDkSQ5Zm+eVjppKzMi
         76+Io0Pu1sXCAoqfWdrPQQDC5l5Yfnpqb8DU3kg8yaMSpxRB5SIs1Tch7IuMfMUDXxcb
         uTvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=hV/yJyThsgoXYU3PpI0gsJ3H390iODdvlleqLjncx6E=;
        b=nqFm/6jLvRmnHWywzaX0BuUaRYQ6KfUCZB9h2MZU1GePlTfDWYbHKSe6MvXkpyWOcc
         FoY/oFsnC9Sxg8CKL6XFUDkIuw1jfQY2rWeDjmYlgKuIe3bSsPR0IIpbtYUCr64npyLg
         U8SC9NQnSZoW1FwLUi9vdILzfuF1cV7iCJLbXOStYhmzUxDgrlQcXSZ5CTc4/+q9Y5ra
         PKVWe7wOAqhJZrVJdY/UOvkC7dVG8T4xRqbGy1qGOdGg5fZLAZ5aUd3DZxg/cGCt8dOi
         f87KqnYJhPgWLe9lPKCyFKglrchVKVJ15S0xqCTMVqWGzBFmFnIMOaWeHTkbZUEelZRw
         7EWg==
X-Gm-Message-State: ACrzQf3rtpN7o4y2TZ6QWqZZVKIYmCCoF2+8AMKkbMq2J4FJ0OOBO+r2
        P1j7IXq0qgXhUid/cfAXP2IH5DAJu5yPU4s9VZw=
X-Google-Smtp-Source: AMsMyM74c9jD/ZT1gh4AwPlZyXuBVtLYzO1op0Jn3EbQJjAFq2na3k3F1oaUZRD8WC9xKBGK4055KA==
X-Received: by 2002:a17:90b:3ec1:b0:202:f490:e508 with SMTP id rm1-20020a17090b3ec100b00202f490e508mr12386372pjb.156.1664804475910;
        Mon, 03 Oct 2022 06:41:15 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g7-20020a625207000000b0055fe9a6075bsm625252pfb.155.2022.10.03.06.41.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Oct 2022 06:41:15 -0700 (PDT)
Message-ID: <633ae67b.620a0220.ac900.0e96@mx.google.com>
Date:   Mon, 03 Oct 2022 06:41:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.215-30-gd0b5ac17eb55
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 134 runs,
 5 regressions (v5.4.215-30-gd0b5ac17eb55)
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

stable-rc/queue/5.4 baseline: 134 runs, 5 regressions (v5.4.215-30-gd0b5ac1=
7eb55)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.215-30-gd0b5ac17eb55/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.215-30-gd0b5ac17eb55
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d0b5ac17eb55b2fe3e2ff71c3e73b9a7c767427f =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/633ad00638fa54307dec4ea7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.215-3=
0-gd0b5ac17eb55/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.215-3=
0-gd0b5ac17eb55/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633ad00638fa54307dec4=
ea8
        failing since 146 days (last pass: v5.4.191-77-g1a3b249e415b, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/633aceda62123bec12ec4eb8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.215-3=
0-gd0b5ac17eb55/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.215-3=
0-gd0b5ac17eb55/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633aceda62123bec12ec4=
eb9
        failing since 146 days (last pass: v5.4.191-77-g1a3b249e415b, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/633ace9d9d93a3fb82ec4eb7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.215-3=
0-gd0b5ac17eb55/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.215-3=
0-gd0b5ac17eb55/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633ace9d9d93a3fb82ec4=
eb8
        failing since 69 days (last pass: v5.4.180-77-g7de29e82b9db, first =
fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/633aba39303f22f549ec4eb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.215-3=
0-gd0b5ac17eb55/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vi=
rt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.215-3=
0-gd0b5ac17eb55/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vi=
rt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633aba39303f22f549ec4=
eba
        failing since 69 days (last pass: v5.4.180-77-g7de29e82b9db, first =
fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/633acec501abf25310ec4ead

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.215-3=
0-gd0b5ac17eb55/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.215-3=
0-gd0b5ac17eb55/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633acec501abf25310ec4=
eae
        failing since 146 days (last pass: v5.4.191-77-g1a3b249e415b, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =20
