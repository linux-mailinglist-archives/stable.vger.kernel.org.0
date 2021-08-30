Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 206003FB115
	for <lists+stable@lfdr.de>; Mon, 30 Aug 2021 08:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233036AbhH3GNk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Aug 2021 02:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232313AbhH3GNk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Aug 2021 02:13:40 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 654EDC061575
        for <stable@vger.kernel.org>; Sun, 29 Aug 2021 23:12:47 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id 18so11336210pfh.9
        for <stable@vger.kernel.org>; Sun, 29 Aug 2021 23:12:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=I3iKNJETfbMnkdU3r3Kt7CTRSYz8NKRPnH3NgdJBFPg=;
        b=gO0Fhm85RuH3ISUQiX95gnXSlD0JpkQ6LvBVxh4oLanYcWmajumCgWM2KJwBPpaDyT
         M6KzniE6hA3cAOsR7lIQKmsZwJ3XFeP9JuKXNxrxgstz84/z6y2Hd5h8xuwTrLaP7yXu
         wkZ92d9LuOk5WbVRb40Uey2ZN5ax5bxzwTAUPGhaVNBe50GlszLOQKt1h1VonuN7QeFG
         w5GLxDM15QTrhzR61hFSzNUg7QnWBJ32CVROONzH3TTEsjaAC2hvDcowxKSlLpTevV94
         wcJJmN8fNHoUOrh0QCASB2TV4VC77yCJPYC+RajQeKBEIolSxBA9NsRyl9yC/pG4NGEl
         11Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=I3iKNJETfbMnkdU3r3Kt7CTRSYz8NKRPnH3NgdJBFPg=;
        b=X2BbkBDIrmp9r0F3d35B5Ff30MZIfzuZ+YswST3ejTpWUzd8+iTWyE2tBX9rnmdNos
         7tLb7Ly8hLAikZVuCZq6lTN3OcnLKKUGNJzeGRTDmc5ol+ZCt7njSYNCb0BY5HRZm3GH
         ir+/4ntuIxtghmFp2+lCEzRA3BcAT050EQIh0YAY+miGGPja9YrM/DWMD02WiCiEN2T3
         DXYTStP9uwFEYqZUrqzmv9UaGqPFYf0kXB5smW5n5HpzZ27rD5DNbe5JWAOzqwDhjrIR
         sygN/FV4Ri0RpspygOQ403IHU3L9I98IlDSB1B2hlK3DRS0yU2nlWDStTsM597zztAK0
         yPqA==
X-Gm-Message-State: AOAM531NSEbx9OhoWOUdAmrwLBePYQu4slmzRWq3YOOMReE6B/OF5KM6
        xgpWSw6dJVRdl2s7taSW/pLFhq9WkIbFNuvk
X-Google-Smtp-Source: ABdhPJzjf3BxfFV7u6xO6MXAcnd20CTKys2Zz93BeW+YJt4mIK4yL02+rxmpBw/YBuW+RCDFCBYowQ==
X-Received: by 2002:a62:5846:0:b0:3f2:805b:50b1 with SMTP id m67-20020a625846000000b003f2805b50b1mr16795764pfb.74.1630303966635;
        Sun, 29 Aug 2021 23:12:46 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b190sm15753297pgc.91.2021.08.29.23.12.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Aug 2021 23:12:46 -0700 (PDT)
Message-ID: <612c76de.1c69fb81.fa950.8539@mx.google.com>
Date:   Sun, 29 Aug 2021 23:12:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.205-19-g4eecbf2ca97e
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 137 runs,
 4 regressions (v4.19.205-19-g4eecbf2ca97e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 137 runs, 4 regressions (v4.19.205-19-g4eecb=
f2ca97e)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.205-19-g4eecbf2ca97e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.205-19-g4eecbf2ca97e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4eecbf2ca97e8edc426051aa806a8bf2abcc151b =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/612c3c82303aa959118e2c77

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.205=
-19-g4eecbf2ca97e/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.205=
-19-g4eecbf2ca97e/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612c3c82303aa959118e2=
c78
        failing since 289 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/612c4ad05a826c94558e2c8a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.205=
-19-g4eecbf2ca97e/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.205=
-19-g4eecbf2ca97e/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612c4ad05a826c94558e2=
c8b
        failing since 289 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/612c3df773db36ae648e2c9a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.205=
-19-g4eecbf2ca97e/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.205=
-19-g4eecbf2ca97e/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612c3df773db36ae648e2=
c9b
        failing since 289 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/612c428057023dcc848e2c78

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.205=
-19-g4eecbf2ca97e/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.205=
-19-g4eecbf2ca97e/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612c428057023dcc848e2=
c79
        failing since 289 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
