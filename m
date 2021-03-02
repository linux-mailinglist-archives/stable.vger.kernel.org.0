Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62DAE32B0A9
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:44:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344974AbhCCAy1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:54:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232067AbhCBXtI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 18:49:08 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4F66C06178A
        for <stable@vger.kernel.org>; Tue,  2 Mar 2021 15:47:58 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id t26so15011103pgv.3
        for <stable@vger.kernel.org>; Tue, 02 Mar 2021 15:47:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KhqMtUK25Ixh826mVr2+FFq08yP7859EPoR23K8h1p8=;
        b=GpkXfQnSEVDXV5o5MZo/TCYnu6fkTt87vqX+v7g6byzppBkfedPpjHnSOavt0WSGUu
         e88IYJ10vO+LfjQzxeal5Pu2aSdLdn1Un/PTnbA2UD6t/UTEEX5rknVYWNs6VXpuZPvr
         J/VjsG1boCA1h2/vd9k6k/kL2/JG9J9KhvMjg8HcYKHFr9PY4RnYL7JbLp5zO1+Jf/Qc
         w+KJNVByG3wBVlNwTXepLj16XRpyb7XbZQWXvFjxwjczPbNqfne+knsyj2cJSu/XFDhT
         giFcMle7eRxN/dNMGncDZE0U3hWhzUB3lS6yfuVkFIcL/iZygdWqzszN2doeIuBMV+iq
         0rnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KhqMtUK25Ixh826mVr2+FFq08yP7859EPoR23K8h1p8=;
        b=EFRyh12TylJ0qBGVOFlLZuw1+eiXfbfV5XrOsPJtlyY0TTmvOVQEnEZfi0dQ6C1L1F
         L7mEsLEjP/Ql1RmZhZqS45BkRQ+pypDDI1OoKJycD80YKxrrZ3KtZsQDEmfuwIsmwKlc
         j+HA516mIXBSZRpLerEffrRTReM2dvi20THiALVPtW772DKs7vzHHm2bwB795QRMBLzE
         ys+WUR98EZqwr/QVm8s3x4INdN4GfnUPID8P5WuEQcH5sQhOQ9Z2y7W05wwbyrN7DoQ5
         zUafB7qb3qQkVusE0vn22zxpc7SSc4uK2757s5X7wUFgKyz/KuOwqRexcwvggTFbFAmb
         SXow==
X-Gm-Message-State: AOAM530nVuqniEfrzzCzKudAeWHRq1ucxmpznwBVWIRszk13/VvlsAS+
        g87iQwgQHaRWw5wJA8isK0tJ+/TqRnZNNQ==
X-Google-Smtp-Source: ABdhPJwU2z6vdxWY8ma4LTL3+X0LrIouB7YEzgSBG/myRccJMAYS6MkYfh/Y53eBvuj7Uor/67JMdA==
X-Received: by 2002:a65:6290:: with SMTP id f16mr20326684pgv.69.1614728878303;
        Tue, 02 Mar 2021 15:47:58 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id js16sm4731982pjb.21.2021.03.02.15.47.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Mar 2021 15:47:58 -0800 (PST)
Message-ID: <603eceae.1c69fb81.9907e.aba2@mx.google.com>
Date:   Tue, 02 Mar 2021 15:47:58 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.177-246-g84c6db07880a
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 93 runs,
 3 regressions (v4.19.177-246-g84c6db07880a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 93 runs, 3 regressions (v4.19.177-246-g84c6d=
b07880a)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.177-246-g84c6db07880a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.177-246-g84c6db07880a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      84c6db07880a2a570c85986170398fb6bff6083a =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/603e9961ab3e97cdb7addcd1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.177=
-246-g84c6db07880a/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.177=
-246-g84c6db07880a/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603e9961ab3e97cdb7add=
cd2
        failing since 108 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/603e995ecfa24904d0addcc6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.177=
-246-g84c6db07880a/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.177=
-246-g84c6db07880a/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603e995ecfa24904d0add=
cc7
        failing since 108 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/603e98fd238cd75107addcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.177=
-246-g84c6db07880a/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.177=
-246-g84c6db07880a/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603e98fd238cd75107add=
cb2
        failing since 108 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
