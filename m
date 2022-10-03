Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BFDC5F3067
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 14:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbiJCMoy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 08:44:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiJCMow (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 08:44:52 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69013DF5D
        for <stable@vger.kernel.org>; Mon,  3 Oct 2022 05:44:49 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id bh13so9589472pgb.4
        for <stable@vger.kernel.org>; Mon, 03 Oct 2022 05:44:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=rvU7lO7vHcDKlCHnxBTyxtfWkpLmYbVWMDbDkNtyzE8=;
        b=Ez8C6DvJL/079xl9T4ng7uBgtHLUFvGnwQkHVaSWMvprFtJWEAU9C1g8jfx1et/spW
         Pka3Fo3i/eKXQUYcjjtVAv4H7muW5hRKTxLz+1DwTKN4+74dTiFTNkoWm5YsPodOe58E
         0e2dZP0NeXw0WHd0lkDaaC9eEJjaj2LNpPGqetm1qIyuyVVs4st3OBNNXM+7Vgd5gOHy
         +YBXOrCGdXPZExwrTROyS6nsTFpCqggEndl2n6HJh/ftXnmd4cqKKls5FEME3dm1KpaL
         i8flIKyxCHQyjSa4ujx4/KcfycaSFS/LfD7LZqKuQ3DYzFjqdIsfEEjIWXMp3YksHcGs
         YETg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=rvU7lO7vHcDKlCHnxBTyxtfWkpLmYbVWMDbDkNtyzE8=;
        b=32z48rHdZV5uq1Xq7wMp50sJtIeOi71PmvucOkzbYp4sW3XukwnSVBnYxsYfsro5/A
         XbRa1Ti/rADAOOP0IkYBomuuPPS1fZoBDlHdMC82v0gOuLdBf1Sav1jAy83FkPh6/qfa
         qCnkORsU4lUgNiIkV+EBRlMjLrul/A7V3GqFSV166GgAiMUe0KEWz9ye5euxz+/kDx2W
         Zlm2q/8w4w8IgQU1VY3E0tlYV0uq3YPQgBUehr2uEjqGlK4i4HaBT6+POocdrcHoEkuS
         qb/0IkSJyngnUOWACe1glgDaDVy5cMnSReNa9e2G5CnBmHa0rzHMxVVM6gNb/WBoLBC/
         KBVw==
X-Gm-Message-State: ACrzQf3nMHdLpmDChnouE2dGyDyBePwgkAWRFIs/KQUsTsEb0+WWj2uu
        vIJ9kv1Auq0zjMX44B2/PJrFIKQ3IOe8GLpn4nU=
X-Google-Smtp-Source: AMsMyM5Hmy6HMjU/GkC3DSvaLtLwH34XkN8EvX10CyOZoc7YL1TCfoAzx/szoHrIvbGJwEsM+fcx9g==
X-Received: by 2002:a65:4d46:0:b0:43b:e00f:8663 with SMTP id j6-20020a654d46000000b0043be00f8663mr18530525pgt.147.1664801088529;
        Mon, 03 Oct 2022 05:44:48 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w129-20020a623087000000b00541c68a0689sm7337911pfw.7.2022.10.03.05.44.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Oct 2022 05:44:48 -0700 (PDT)
Message-ID: <633ad940.620a0220.d178b.c235@mx.google.com>
Date:   Mon, 03 Oct 2022 05:44:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.330-4-gdbbc88e8dcfec
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 39 runs,
 8 regressions (v4.9.330-4-gdbbc88e8dcfec)
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

stable-rc/queue/4.9 baseline: 39 runs, 8 regressions (v4.9.330-4-gdbbc88e8d=
cfec)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.330-4-gdbbc88e8dcfec/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.330-4-gdbbc88e8dcfec
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      dbbc88e8dcfec7b6a387a8619485c7e98a6cbb68 =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6338e75d6bfab88e3bec4eab

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.330-4=
-gdbbc88e8dcfec/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.330-4=
-gdbbc88e8dcfec/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6338e75d6bfab88e3bec4=
eac
        failing since 68 days (last pass: v4.9.302-31-gdbb0728e500a, first =
fail: v4.9.324-19-gbc9f55260bb17) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2      | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6338e48b46a57c144dec4ee8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.330-4=
-gdbbc88e8dcfec/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vi=
rt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.330-4=
-gdbbc88e8dcfec/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vi=
rt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6338e48b46a57c144dec4=
ee9
        failing since 68 days (last pass: v4.9.302-31-gdbb0728e500a, first =
fail: v4.9.324-19-gbc9f55260bb17) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6338e7fc560f9daab9ec4ebd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.330-4=
-gdbbc88e8dcfec/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.330-4=
-gdbbc88e8dcfec/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6338e7fc560f9daab9ec4=
ebe
        failing since 68 days (last pass: v4.9.302-31-gdbb0728e500a, first =
fail: v4.9.324-19-gbc9f55260bb17) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6338e48c46a57c144dec4eee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.330-4=
-gdbbc88e8dcfec/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vi=
rt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.330-4=
-gdbbc88e8dcfec/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vi=
rt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6338e48c46a57c144dec4=
eef
        failing since 68 days (last pass: v4.9.302-31-gdbb0728e500a, first =
fail: v4.9.324-19-gbc9f55260bb17) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6338e694f08c008f68ec4ea6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.330-4=
-gdbbc88e8dcfec/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.330-4=
-gdbbc88e8dcfec/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6338e694f08c008f68ec4=
ea7
        failing since 68 days (last pass: v4.9.302-31-gdbb0728e500a, first =
fail: v4.9.324-19-gbc9f55260bb17) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6338e49a8f1ab4ccf6ec4ea6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.330-4=
-gdbbc88e8dcfec/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vi=
rt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.330-4=
-gdbbc88e8dcfec/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vi=
rt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6338e49a8f1ab4ccf6ec4=
ea7
        failing since 68 days (last pass: v4.9.302-31-gdbb0728e500a, first =
fail: v4.9.324-19-gbc9f55260bb17) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6338e7716bfab88e3bec4eb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.330-4=
-gdbbc88e8dcfec/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.330-4=
-gdbbc88e8dcfec/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6338e7716bfab88e3bec4=
eb2
        failing since 68 days (last pass: v4.9.302-31-gdbb0728e500a, first =
fail: v4.9.324-19-gbc9f55260bb17) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6338e4aee2b96cf6e1ec4ea9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.330-4=
-gdbbc88e8dcfec/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vi=
rt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.330-4=
-gdbbc88e8dcfec/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vi=
rt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6338e4aee2b96cf6e1ec4=
eaa
        failing since 68 days (last pass: v4.9.302-31-gdbb0728e500a, first =
fail: v4.9.324-19-gbc9f55260bb17) =

 =20
