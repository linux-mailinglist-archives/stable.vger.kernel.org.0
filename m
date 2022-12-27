Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13921656FE3
	for <lists+stable@lfdr.de>; Tue, 27 Dec 2022 22:15:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230240AbiL0VOt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Dec 2022 16:14:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230302AbiL0VOT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Dec 2022 16:14:19 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C80F194
        for <stable@vger.kernel.org>; Tue, 27 Dec 2022 13:14:17 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id jl4so8007462plb.8
        for <stable@vger.kernel.org>; Tue, 27 Dec 2022 13:14:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=0/wJH2h6RnUjkiNkSqv6JEcvnLmfK69j4/chRmc6Lbg=;
        b=tS3Ps0GdP0qJZfnR5W588akBkPMjZLOfVwbbpd6P9wE8eL2QDkzhawmoEmmaBwF/5v
         dcA1u1HklIxHqql1IIg7PZky3OAZy+LgwPjH/WHCwnqDNixVzdauBnHN3Y9ii1rUl/i6
         EijC81eAWjdGL1dSLdPjOSvRabRtk2SSO0BoLwXvV90vsOuwjWPWs+obl2NTzG6zTu/J
         sfThpc8/8ogZ8TJb7rNSsD3lWottk5+UkaIgy1CpZMBrY9U/0c1DZrlCapY7iJA6KUSQ
         t3SpD3Mtrf5XrxinYPwm5jzj2kYY2CleI3u9iih14ieZmSwWli1gEAM/0vxEStT/075k
         KThg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0/wJH2h6RnUjkiNkSqv6JEcvnLmfK69j4/chRmc6Lbg=;
        b=XpODbJbREpCI/bX3SYBnIDMFwGxbVPsNecnj0tBomLK7vhsvtgRE4jBUQ2Di6y1WhF
         qNqGNZIZ5Z2SNxpS6Wa58v5Tcqxv5r93ikd30b+GEkcsMoMh87V2eVI6xwaoZizhf2nL
         Gq6IORVEiMgJSjHeVt/UZhf1DNYn9SUj+B0n6T8dWV/OvIRO6ZTwcDcGe+vZztnprczW
         1tH1Un7mlBYvmaE5dHpXOGXqe8GwK/aYUBohel00xDW6w9iF4r966ACRJErcAiC8KXuK
         ReRTRzvfq3Nbqxwh5y+dB4QCeZhjl+3hRymm/LCl1d7lnIU2cHr/DI59Hsw3xgTECvSO
         86oA==
X-Gm-Message-State: AFqh2kq73P5ju/D3E459RFCgwuzIWu84rEqjusaJUXzsbzCbYPg7umO/
        PQ+ZCBDy+p+E2Bm/qUODilB1ak7IIYGvbiPHtcE=
X-Google-Smtp-Source: AMrXdXt3DI0U/tocRbcdp3MkvrzZiaKDBFT7iu0ga9Vlb+O8t2n441aTGQWxz00+OZHWV7zPoSEaOg==
X-Received: by 2002:a17:90a:1955:b0:21b:c9b3:e94b with SMTP id 21-20020a17090a195500b0021bc9b3e94bmr26079911pjh.16.1672175656603;
        Tue, 27 Dec 2022 13:14:16 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a9-20020a17090a854900b002135de3013fsm8450839pjw.32.2022.12.27.13.14.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Dec 2022 13:14:16 -0800 (PST)
Message-ID: <63ab6028.170a0220.22ef1.eb9d@mx.google.com>
Date:   Tue, 27 Dec 2022 13:14:16 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.336-215-g1bb9fe8160014
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 77 runs,
 6 regressions (v4.9.336-215-g1bb9fe8160014)
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

stable-rc/queue/4.9 baseline: 77 runs, 6 regressions (v4.9.336-215-g1bb9fe8=
160014)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig  =
                | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.336-215-g1bb9fe8160014/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.336-215-g1bb9fe8160014
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1bb9fe816001495358052a41fde2ba48a0e1419e =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/63ab2e0762c260e2b94eee61

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.336-2=
15-g1bb9fe8160014/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.336-2=
15-g1bb9fe8160014/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221216.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ab2e0762c260e2b94ee=
e62
        failing since 154 days (last pass: v4.9.302-31-gdbb0728e500a, first=
 fail: v4.9.324-19-gbc9f55260bb17) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/63ab26c55da14995824eee42

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.336-2=
15-g1bb9fe8160014/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-=
virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.336-2=
15-g1bb9fe8160014/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-=
virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221216.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ab26c55da14995824ee=
e43
        failing since 154 days (last pass: v4.9.302-31-gdbb0728e500a, first=
 fail: v4.9.324-19-gbc9f55260bb17) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63ab2be9c3b246d3df4eee68

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.336-2=
15-g1bb9fe8160014/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.336-2=
15-g1bb9fe8160014/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221216.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ab2be9c3b246d3df4ee=
e69
        failing since 154 days (last pass: v4.9.302-28-g96ac67c43b2b, first=
 fail: v4.9.324-19-gbc9f55260bb17) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63ab254a2aca090e1c4eee52

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.336-2=
15-g1bb9fe8160014/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.336-2=
15-g1bb9fe8160014/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221216.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ab254a2aca090e1c4ee=
e53
        failing since 154 days (last pass: v4.9.302-28-g96ac67c43b2b, first=
 fail: v4.9.324-19-gbc9f55260bb17) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/63ab2df24e4fedec824eee1f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.336-2=
15-g1bb9fe8160014/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.336-2=
15-g1bb9fe8160014/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221216.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ab2df24e4fedec824ee=
e20
        failing since 154 days (last pass: v4.9.302-31-gdbb0728e500a, first=
 fail: v4.9.324-19-gbc9f55260bb17) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/63ab26c4c46db55fa34eee1e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.336-2=
15-g1bb9fe8160014/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-=
virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.336-2=
15-g1bb9fe8160014/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-=
virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221216.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ab26c4c46db55fa34ee=
e1f
        failing since 154 days (last pass: v4.9.302-31-gdbb0728e500a, first=
 fail: v4.9.324-19-gbc9f55260bb17) =

 =20
