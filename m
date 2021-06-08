Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F9C339FDC1
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 19:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232725AbhFHRei (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 13:34:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231652AbhFHReh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 13:34:37 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA0BCC061574
        for <stable@vger.kernel.org>; Tue,  8 Jun 2021 10:32:44 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id n12so17044030pgs.13
        for <stable@vger.kernel.org>; Tue, 08 Jun 2021 10:32:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=d/p+EPKwWEcg+hEYVMmuf/xZqG/8NZm5aHx6P1YlOjs=;
        b=TrElx69xhd11gTnrWn/g+p+Hz4G++6qV6M/xM1/Ta8XpG3ID9hRxpfMq5pal6CUVGa
         7tlneiXjtiGeZRfTdLqvDUlQvJSgALj/3SGQ51AA398TYokNLzSDHQD4kIlg5gnaHQbG
         rV9q7qp7/YK9bVfraG5pLWfxAnu2Y6tuGHuxvf8UeG5mm/C2Wes/P3LTLDZS6KhYy7TW
         V+qhKhrnZE0ly2EhHeA9kGA7WGok9vSbHgCqg8UvgAcRVuNPY6vKDl2UmiNWBQziu3nD
         ht0NV/1EsNj/IpX5u61rGjDaLpSnQX3jsdYNEJkUTGtfQmVKcTGOix2uIWVupkOAfDAw
         SmSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=d/p+EPKwWEcg+hEYVMmuf/xZqG/8NZm5aHx6P1YlOjs=;
        b=AF0iGXlVU8Bt94QHsUaVRS/k/yZr7G415YmTvct6NiN1I415xtb1uipS6ffDzJA4+f
         9BwUQEuKp6kXJi1UmNRsOSIpvaJ/jh9RNeYD9k0gvHsJw+OS2wMAmyBG2+H723khDKMK
         ixHxZx2R2vqNqrDAVZFVwZyz4lyraWBSJX+jzqiYhrZO20N1QkDGivkXijitPYyEdJAv
         qiCLK8Sc/i6X1wrpwLsX0R1ZCAkdY8HOyq1SZ+aQRnwNBbfcDeQs8Gw3cJvaNHthWysE
         k3UoPbDl7rgVznFH2kRG4txOfeQlC5/9mdOZJ9Mk28xmu/Avv1VqM7p5UZZWQayYE229
         bCLg==
X-Gm-Message-State: AOAM5328DCrpMZxObjVbFZ2C+ZbK22qSw9XbtJnT5MnigS4AYP4efLLs
        8l3DyeIuKiARthFUllBwjGRi52lKNEeVcI74
X-Google-Smtp-Source: ABdhPJwS68QCOLCKFxmt4Yqg67e7MWpfYTpR/PSXEmDFgFC3m/xV8zu7hZNTJ0fIzlJuqQQtq7HDQg==
X-Received: by 2002:a63:5f8b:: with SMTP id t133mr23465329pgb.411.1623173564257;
        Tue, 08 Jun 2021 10:32:44 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id bv3sm2591716pjb.1.2021.06.08.10.32.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 10:32:43 -0700 (PDT)
Message-ID: <60bfa9bb.1c69fb81.bf2f9.813d@mx.google.com>
Date:   Tue, 08 Jun 2021 10:32:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.193-31-gaf2147b1b6b5
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 100 runs,
 4 regressions (v4.19.193-31-gaf2147b1b6b5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 100 runs, 4 regressions (v4.19.193-31-gaf214=
7b1b6b5)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.193-31-gaf2147b1b6b5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.193-31-gaf2147b1b6b5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      af2147b1b6b59acb37d0fc676ed0a1406d4e6bb4 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60bf7689b8241c65740c0e13

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.193=
-31-gaf2147b1b6b5/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.193=
-31-gaf2147b1b6b5/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bf7689b8241c65740c0=
e14
        failing since 206 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60bf76eec36d31aff40c0e0d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.193=
-31-gaf2147b1b6b5/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.193=
-31-gaf2147b1b6b5/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bf76eec36d31aff40c0=
e0e
        failing since 206 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60bf767b86d2c93dae0c0e01

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.193=
-31-gaf2147b1b6b5/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.193=
-31-gaf2147b1b6b5/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bf767b86d2c93dae0c0=
e02
        failing since 206 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60bf76dac618fb30300c0e39

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.193=
-31-gaf2147b1b6b5/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.193=
-31-gaf2147b1b6b5/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bf76dac618fb30300c0=
e3a
        failing since 206 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
