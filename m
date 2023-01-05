Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D87AE65F4B8
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 20:41:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232255AbjAETlh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 14:41:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235947AbjAETlD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 14:41:03 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31FE6247
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 11:40:13 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id 17so40457794pll.0
        for <stable@vger.kernel.org>; Thu, 05 Jan 2023 11:40:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=HcmxJ0T0uUsU1mAHtQu7VP0vyGx/7zaMGv9IKh4hfHA=;
        b=g8weKydU4hOdOjxFv04zD+aOmAw6Zj+pf6wGANc8TuJwMdUjfbXgAEm/Fxs3YmkaGO
         lKdmcS4EnvXYLzYhHN8bS1QM8YUcGVhBojMF/GYgFxBbNwO6GfBoSbrAd0dq2vOCXTg7
         uv/kBOyuiDK2PSC4LJgBnvWJ9rFEpE93YH4NC8vSwB1yhW2HJJ7omFw3ch1I46Z6wY1E
         /Q5wswkqDydDKDryX/q8hVOjX8r1vjAYuEv3TpzdKZLWcRuHkoMB05hdmp01cfbFJzw4
         GvnZnJs7z6HtKH19Cd52VHXOpQPvnA9A8KL/+8PnMGZ/VMt+7k5kdho5t4ofIeOpcLC1
         0NxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HcmxJ0T0uUsU1mAHtQu7VP0vyGx/7zaMGv9IKh4hfHA=;
        b=tkRgawazHrqrnegs32sMpX43TChgXfaWRIEB7KLR3zDIrlt0ET9/hgHCFSg+LFAbpg
         YDnRMaEa86tw40wHwkUZubE/7RzM/65uhTIPkeCuQvYk73JuTy3WT+CvA1i+0YIOq928
         8TamMn4hSAO2fgzazbLIFCARrWLVaU6q6XxXJByBUNFieKaIBHGsncradBOBC0hYCZ0k
         4FdcekTFmOgrO2V5Hag0c+XP6AypBQAWTJAHMH6dr4IsVunTMUSTg7ZgZROZfu9YG/vV
         Lh6xZnNcWAUTyR7/HHIcTdtlwPSzY0IjqVcDAGrcsSRvh80bA7G3zajJMj+QstGbSRi6
         9XEA==
X-Gm-Message-State: AFqh2krwcD32dhB5PHHxJPyB9vJq8LRBDpnoq2UYnjGIEiToC6O7ZNp5
        9erH02qluuE+Kyh6emNZC5aPYYZejnEG6Kk8/mXFAg==
X-Google-Smtp-Source: AMrXdXuFe9ShnWj2mP1U2nyx44OY2WeSfV28gFxJuebd+u6uJF60PY3OdaIVakhEXItuDof6QJmoOQ==
X-Received: by 2002:a17:90a:3ec5:b0:226:d748:b1f9 with SMTP id k63-20020a17090a3ec500b00226d748b1f9mr1444688pjc.23.1672947612500;
        Thu, 05 Jan 2023 11:40:12 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y6-20020a17090a474600b002139459e121sm1649178pjg.27.2023.01.05.11.40.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 11:40:12 -0800 (PST)
Message-ID: <63b7279c.170a0220.bfc77.2d51@mx.google.com>
Date:   Thu, 05 Jan 2023 11:40:12 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.336-251-g07e346aafdaa
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 77 runs,
 4 regressions (v4.9.336-251-g07e346aafdaa)
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

stable-rc/queue/4.9 baseline: 77 runs, 4 regressions (v4.9.336-251-g07e346a=
afdaa)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.336-251-g07e346aafdaa/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.336-251-g07e346aafdaa
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      07e346aafdaad03aea5dd9eadc709cf0e9e3398c =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/63b6f6210f7b561d6f4eee1c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.336-2=
51-g07e346aafdaa/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.336-2=
51-g07e346aafdaa/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221230.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63b6f6210f7b561d6f4ee=
e1d
        failing since 163 days (last pass: v4.9.302-31-gdbb0728e500a, first=
 fail: v4.9.324-19-gbc9f55260bb17) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63b6f7b2c2fd8d02b04eee41

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.336-2=
51-g07e346aafdaa/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.336-2=
51-g07e346aafdaa/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221230.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63b6f7b2c2fd8d02b04ee=
e42
        failing since 163 days (last pass: v4.9.302-28-g96ac67c43b2b, first=
 fail: v4.9.324-19-gbc9f55260bb17) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/63b6f4747fa32e175a4eee2b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.336-2=
51-g07e346aafdaa/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.336-2=
51-g07e346aafdaa/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221230.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63b6f4747fa32e175a4ee=
e2c
        failing since 163 days (last pass: v4.9.302-31-gdbb0728e500a, first=
 fail: v4.9.324-19-gbc9f55260bb17) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63b6f5926c6a88edd74eee2e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.336-2=
51-g07e346aafdaa/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.336-2=
51-g07e346aafdaa/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221230.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63b6f5926c6a88edd74ee=
e2f
        failing since 163 days (last pass: v4.9.302-28-g96ac67c43b2b, first=
 fail: v4.9.324-19-gbc9f55260bb17) =

 =20
