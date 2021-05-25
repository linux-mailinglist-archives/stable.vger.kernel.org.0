Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D35639082C
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 19:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231784AbhEYRzk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 13:55:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231659AbhEYRzj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 May 2021 13:55:39 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A502EC061574
        for <stable@vger.kernel.org>; Tue, 25 May 2021 10:54:08 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id e15so10126322plh.1
        for <stable@vger.kernel.org>; Tue, 25 May 2021 10:54:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=SHtsEkMlDWwVMD439wqUaIZb7IGkYXsw9VNe07WsGIo=;
        b=LRs7GvDPb7Kn0rR/qTy3av3LgHtJSncY1WJrChxlmEsO5yIFonHz5ukuV3gg1I7+o8
         ZEKU9Ys/G/oO//gCBCmaIgCuJLOtxuTMTtGXgzPM1KTm3hSaJmjKCmvYtVf94Ty+0FkV
         sqmykTLsCgrc25s8WmU5Bi15oOLRdn2141wjGm8JFhjErVDlNIcwsvgOiocw7fOZDqGn
         6ZbxP+eDAlF+Reled7s0hJ2L452ESH9QibJylT5a0H+nLJGwAD4KQ1FxW7u4yp84Pfvz
         lWzpRxk9AsOsMoqRVGBL6ykSxm0SARkGDUCuMHrNR+6VMaLhPy+OvoGXpe0YsVVAwV8/
         ckWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=SHtsEkMlDWwVMD439wqUaIZb7IGkYXsw9VNe07WsGIo=;
        b=bC86ErdSvqh1LgvUDUhYCUawAtadfs4+NbhBVBQgbZbjdrpa2Eif7J5IZfcDyyzH7g
         UbduSJQ6+zHjFbBX9ZwFdm10zr1vuxiHRn9o3E06uRW4ulPwnTBlORFotHUuOmqG1qKt
         xdaUmCbf00l++67B2Bxd9QaVJgYKuEQj6iyPmGItkaWjtx68ch1ckCevWeBGD/sUScZz
         +WFnK80I7qdf5KcNKzjmGxi2AV/PfVWKJ6EH0md2F1dRE9BwTHDCTXBMB7nDu7nJn8ia
         yuv2DJCSqpxjEuUnuHhyY3H5B+jXwXsLAd/ratXjEGkoFzpU6kJgB66LQwySq6a5M4Gu
         UEbA==
X-Gm-Message-State: AOAM530SMmoUUT8ra6YF75D4szPnQ9FBpkK6pQMHsOAXdf9xTxER6Rk+
        AsWNlb4iYywj+Y/mc6kxQrp3dqIKBtzNswLe
X-Google-Smtp-Source: ABdhPJwbvLnk5y/O3mKjBBKrb/PeB1hEKLVKG3+XT8azT/iZBf9B/uangHItj/yoyfQt4vh68m0E9Q==
X-Received: by 2002:a17:90a:f87:: with SMTP id 7mr31993096pjz.38.1621965247806;
        Tue, 25 May 2021 10:54:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b21sm10901754pfo.47.2021.05.25.10.54.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 10:54:07 -0700 (PDT)
Message-ID: <60ad39bf.1c69fb81.82562.227c@mx.google.com>
Date:   Tue, 25 May 2021 10:54:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.191-47-g149010c16dae
X-Kernelci-Branch: queue/4.19
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 116 runs,
 4 regressions (v4.19.191-47-g149010c16dae)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 116 runs, 4 regressions (v4.19.191-47-g14901=
0c16dae)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.191-47-g149010c16dae/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.191-47-g149010c16dae
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      149010c16daec6c20c0177af3b1e76f54428b4a5 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ad070f91b4821d74b3afbc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.191=
-47-g149010c16dae/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.191=
-47-g149010c16dae/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ad070f91b4821d74b3a=
fbd
        failing since 192 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ad05a7fbb155501ab3afb6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.191=
-47-g149010c16dae/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.191=
-47-g149010c16dae/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ad05a7fbb155501ab3a=
fb7
        failing since 192 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ad08624aaebfda32b3afd7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.191=
-47-g149010c16dae/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.191=
-47-g149010c16dae/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ad08624aaebfda32b3a=
fd8
        failing since 192 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ad052c54ca4c0283b3af9f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.191=
-47-g149010c16dae/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.191=
-47-g149010c16dae/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ad052c54ca4c0283b3a=
fa0
        failing since 192 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
