Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B26B14B4F5C
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 12:52:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245465AbiBNLvo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 06:51:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351798AbiBNLvo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 06:51:44 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7283CC3A
        for <stable@vger.kernel.org>; Mon, 14 Feb 2022 03:51:35 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id om7so14280002pjb.5
        for <stable@vger.kernel.org>; Mon, 14 Feb 2022 03:51:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=XSygvbgvlrcXI2GkSXpUegmm0TheCzFX0t60faNKyq0=;
        b=r9T5djYzZs9mfM2x/zuDZ9wwKLVCUjH5v18QydovDMMSVuzvH0vdJDYoORCLoPNdhP
         ugFVTf/VWiVQvSdWfiwFvbSwktY3ivTHMxjFXfqoACU/S8s8f8/1auSnTh61TSvSdJLQ
         2Fb7dizN/dqtvvSxIUVdv+bpXrr4hcPPwIgtQramYdXZirKMur2r+ZL8xpuWl1YsQcHI
         8lhEdh95lTaMsEIu33nDJJTV4u85Q0YrOeC0zeglacVoaL7sb1N0sucUyBt473kvnM2D
         UlPKJMnF1LUGhKdHu4SqYNvtIg/+NS0/IYrcKn6ltO7aC/zIb3aaHd0yErhPuINPcTyH
         HZzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=XSygvbgvlrcXI2GkSXpUegmm0TheCzFX0t60faNKyq0=;
        b=ZzJV5NLyqQjxuNLBfaXMOmm4BvDc46ysa63gsqoZVtCefBrRWWtone90d8O06itLhd
         scMldDLo4YvKPNs11XYJUNqrm6cvwQRFR5kOh2YTm2bNiT9PDzZ/qjdIGBkb8Qw9LJxB
         4BluWFX1FfnBCkqiX5D6ULle6hBncs1QYz1DYfCT/gw1nRuB4Ng1+TWNce0g/U9bR7ZP
         5IwDdU4BwQENjozNSCupSBgt5dKSUo4PstXe+hwu9yhYUCxj9FXtk+Hw19mr5424kbos
         UvbdZAk+e5v2egTjSPDnc87V9/Vv3//vJUKyN4+Gou7h3xFIwNLysJb62yW/5DpnUJxB
         G6YQ==
X-Gm-Message-State: AOAM5335fNYnb/nW+UfRmoMSj28ux6KvXglErkQJWRZL/lhAn9DdRXAk
        WqZd/JnyikGQ0vM4wNrQHXKUcPKa4QrmlCc0
X-Google-Smtp-Source: ABdhPJzyw9ANGjfZKtJGa+SRkPgfDt+Xl+jGb76tesC2xfqK3+HIcZFs0OqC05xc6ZTuPwAE/g2v7g==
X-Received: by 2002:a17:90b:3148:: with SMTP id ip8mr10755468pjb.191.1644839494821;
        Mon, 14 Feb 2022 03:51:34 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g4sm36195353pfv.63.2022.02.14.03.51.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Feb 2022 03:51:34 -0800 (PST)
Message-ID: <620a4246.1c69fb81.97542.8d4e@mx.google.com>
Date:   Mon, 14 Feb 2022 03:51:34 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.229-48-g3b6b79c0b2c0
Subject: stable-rc/queue/4.19 baseline: 111 runs,
 8 regressions (v4.19.229-48-g3b6b79c0b2c0)
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

stable-rc/queue/4.19 baseline: 111 runs, 8 regressions (v4.19.229-48-g3b6b7=
9c0b2c0)

Regressions Summary
-------------------

platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv2      | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv3      | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.229-48-g3b6b79c0b2c0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.229-48-g3b6b79c0b2c0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3b6b79c0b2c0f86b2a5ec7776a215fb3c45560f0 =



Test Regressions
---------------- =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/620a0b61d99946a3e8c6298a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.229=
-48-g3b6b79c0b2c0/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.229=
-48-g3b6b79c0b2c0/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/620a0b61d99946a3e8c62=
98b
        failing since 5 days (last pass: v4.19.227-86-g4a26c86a185c, first =
fail: v4.19.227-86-g59fd6eade0cc) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/620a0b51e4d1400bb1c62981

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.229=
-48-g3b6b79c0b2c0/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.229=
-48-g3b6b79c0b2c0/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/620a0b51e4d1400bb1c62=
982
        failing since 5 days (last pass: v4.19.227-86-g4a26c86a185c, first =
fail: v4.19.227-86-g59fd6eade0cc) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/620a0b9cf8d685a290c62973

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.229=
-48-g3b6b79c0b2c0/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.229=
-48-g3b6b79c0b2c0/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/620a0b9cf8d685a290c62=
974
        failing since 5 days (last pass: v4.19.227-86-g4a26c86a185c, first =
fail: v4.19.227-86-g59fd6eade0cc) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/620a0b75cbb85f2297c6296d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.229=
-48-g3b6b79c0b2c0/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.229=
-48-g3b6b79c0b2c0/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/620a0b75cbb85f2297c62=
96e
        failing since 5 days (last pass: v4.19.227-86-g4a26c86a185c, first =
fail: v4.19.227-86-g59fd6eade0cc) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv3      | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/620a0b777bc222a069c6297a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.229=
-48-g3b6b79c0b2c0/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.229=
-48-g3b6b79c0b2c0/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/620a0b777bc222a069c62=
97b
        failing since 5 days (last pass: v4.19.227-86-g4a26c86a185c, first =
fail: v4.19.227-86-g59fd6eade0cc) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/620a0b62d99946a3e8c6298d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.229=
-48-g3b6b79c0b2c0/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.229=
-48-g3b6b79c0b2c0/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/620a0b62d99946a3e8c62=
98e
        failing since 5 days (last pass: v4.19.227-86-g4a26c86a185c, first =
fail: v4.19.227-86-g59fd6eade0cc) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/620a0bb0c75b92c16bc62973

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.229=
-48-g3b6b79c0b2c0/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.229=
-48-g3b6b79c0b2c0/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/620a0bb0c75b92c16bc62=
974
        failing since 5 days (last pass: v4.19.227-86-g4a26c86a185c, first =
fail: v4.19.227-86-g59fd6eade0cc) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/620a0bb1c75b92c16bc62976

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.229=
-48-g3b6b79c0b2c0/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.229=
-48-g3b6b79c0b2c0/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/620a0bb1c75b92c16bc62=
977
        failing since 5 days (last pass: v4.19.227-86-g4a26c86a185c, first =
fail: v4.19.227-86-g59fd6eade0cc) =

 =20
