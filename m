Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF2D422B9F
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 16:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbhJEPBJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 11:01:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231226AbhJEPBI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Oct 2021 11:01:08 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03F29C061749
        for <stable@vger.kernel.org>; Tue,  5 Oct 2021 07:59:18 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id 145so17641590pfz.11
        for <stable@vger.kernel.org>; Tue, 05 Oct 2021 07:59:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kVKwA39FEm4VoHXtYrG+f7lgLhyLeY8HWejcSvabr18=;
        b=Si/asqN9GooiyFCho+RJVI2pWpm4F5FyDiCEyyC5a4IjaFqcY1TGpGS10blroAZrh1
         9vWuucEzQ83gBHkIheaw0TiX54x3ETOukqIXbe9IveT7Gdq7VjJ5HCMaIh0wArk8J0jg
         ens6sM04+I3gia7r0d1F85hats8UXaM/IxBZfJNvNI8Xsc4AinN0OcfeT+86x+4iKEMD
         xSXFI1SQ5EmyjCpsY06q1ZO1RbrU9CXIpwexoGWfwCnaw/ial5OkjKN2btqcmQvuF9Jd
         A9TQ+wii+Qcl60Gtwy2lLLC4Z/N0dhySZZ7pSWUcNyMSCbJ3zA2+2ZrhFzmtQHk7FdKa
         DpuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kVKwA39FEm4VoHXtYrG+f7lgLhyLeY8HWejcSvabr18=;
        b=0yF7zh7ubP9j4YzxAlZhG+KAOV7b/Bl8eWS2T8CEFjF+EIIlg3Kah610rmIfGk3gZc
         Sm6QYp9mJv0HxXKguj/1VfUZfhPQrWeZ6R5xTijrw1IY9TS4pOcfbUoYvTlsvlxHAn+c
         52dXHYeuBDDu+LGBzhSJfZKMYCx2zdmhtL1u4Df0U9SipYG+pVUHNKUTZa2kxjxbQVCk
         cM34GwdOLdq6qJfBiV8S5HOsPHDARRYzzxujXBMRpSGLvPpLgt21sg5zQvLat3FIsLEb
         7hebQQfivtFdrSzbAGXdI1xhAF1cl2vQepjQ0teix4Kst4QUzzQS+sFgRGVHIrJFggXI
         LfQA==
X-Gm-Message-State: AOAM532zNZo0ZFlqnZ0FLLpTjqG7E6dryO2kn9xfcER07batutHL7+9j
        lFZ3zVr2JARbDlIOANhfebSI2+Rda101qgtF
X-Google-Smtp-Source: ABdhPJzVd1FgvLREuxg6H+J44PXCiG3vsx4irefOug9UV9KvEqmK9kfsR1F4aaGuHCmqe/m3EjGl+g==
X-Received: by 2002:a05:6a00:2146:b0:44c:2922:8abf with SMTP id o6-20020a056a00214600b0044c29228abfmr18848570pfk.27.1633445957294;
        Tue, 05 Oct 2021 07:59:17 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w13sm2603771pjc.29.2021.10.05.07.59.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 07:59:17 -0700 (PDT)
Message-ID: <615c6845.1c69fb81.14a6d.82d5@mx.google.com>
Date:   Tue, 05 Oct 2021 07:59:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.150-54-gf7188f3f8d71
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 148 runs,
 4 regressions (v5.4.150-54-gf7188f3f8d71)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 148 runs, 4 regressions (v5.4.150-54-gf7188=
f3f8d71)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig         =
  | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.150-54-gf7188f3f8d71/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.150-54-gf7188f3f8d71
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f7188f3f8d712443cf29de94ef1b644d2cfc5692 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig         =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/615c35c9f98f81166399a320

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.150=
-54-gf7188f3f8d71/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleas=
hed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.150=
-54-gf7188f3f8d71/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleas=
hed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615c35c9f98f81166399a=
321
        failing since 319 days (last pass: v5.4.77-152-ga3746663c3479, firs=
t fail: v5.4.78) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/615c32665ddc62344599a2e5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.150=
-54-gf7188f3f8d71/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.150=
-54-gf7188f3f8d71/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615c32665ddc62344599a=
2e6
        failing since 324 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/615c4b5cae5af3ae0599a2dd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.150=
-54-gf7188f3f8d71/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.150=
-54-gf7188f3f8d71/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615c4b5cae5af3ae0599a=
2de
        failing since 324 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/615c3307a31afc2e8a99a2e6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.150=
-54-gf7188f3f8d71/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.150=
-54-gf7188f3f8d71/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615c3307a31afc2e8a99a=
2e7
        failing since 324 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =20
