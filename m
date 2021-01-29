Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC033083EA
	for <lists+stable@lfdr.de>; Fri, 29 Jan 2021 03:51:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231450AbhA2CvF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 21:51:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231376AbhA2Cu5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jan 2021 21:50:57 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BD65C061573
        for <stable@vger.kernel.org>; Thu, 28 Jan 2021 18:50:17 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id m6so5315420pfk.1
        for <stable@vger.kernel.org>; Thu, 28 Jan 2021 18:50:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=MVEvphZbvrdcUWazVOgowiyCMs9OXiEYaeJ28I/aBqk=;
        b=hKuJFEYBPzT3oohaVi3UJ0x1Tt//fHPPgXQ74XKdjz+eM3CdLfWh+MBuJHdQbTDLlW
         /5nXK0YJbvveJ9A9JTcuMzOKA1fJ6rfLO713uqPmZQzixCSOEb9NvQWURfOnEaFRWfC8
         8lhxWASo5Ajwfs0Zvx0xOsuya/fkGd8ipjNv3C6P7wWX8ixJN4VsYd1Fj8B/wsIerZ2o
         VSRWDcUVex1j86AgpAlTHeRWmvqc7wrszxqZ7AAoXDlTxaYBbCS71Frsp7biWNgwF5Si
         kXC2OWJdFKyIdG6JF47WPQ7lDgO/XCWrqW7S9DGGKFqOwaVlw7zd81tJUvuRqkWSw/hs
         5DJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=MVEvphZbvrdcUWazVOgowiyCMs9OXiEYaeJ28I/aBqk=;
        b=iV2vPHEpf5OcKgW3zzjGp9CEAKfE3Vni7Aln+FBHGb07WS9SwZwFXSczNjC7r79WZZ
         xXhjqEXjQV4XY1WS+fE1UkehPFUWIAYvGggWK/jakRPumQgNcR2HlI1uF1Wm+WlQWayB
         H9YvM42CR18G+5ZHAZN+ldfXK94OnkGJ16qVOiX6uPv2hXhLfrvZD9uNqk0DRgj80Ly8
         hGoWJylNlMROAK1amgPIlBtXnloNBZkV41qJ/e0nP0Qhz+/P983K0//N101ZAl6+gi0P
         4w9PnCTS6hUZJpX5MX767RfvINk9+T/7lBJQd1FM2wuqsfmihAVRDCJ1z2dpEqMoYhjd
         Lp4Q==
X-Gm-Message-State: AOAM532iOvULojgwcKFlbZtKeMPBWZkb2BOE6u0DP1WXTbvq30u8QlQu
        WP/kluebKJoaiyyhJB+sDMzGKXILeJAHQw==
X-Google-Smtp-Source: ABdhPJxLXeqGJXAy8PVRanVDN5EQpZt9TbtVtfADVa5jxiAb5LqnIMSfzexj37w2i5K6AASmdn7Rkw==
X-Received: by 2002:a63:1426:: with SMTP id u38mr2491502pgl.149.1611888616707;
        Thu, 28 Jan 2021 18:50:16 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e7sm620615pjt.21.2021.01.28.18.50.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 18:50:16 -0800 (PST)
Message-ID: <601377e8.1c69fb81.4d4a2.29f0@mx.google.com>
Date:   Thu, 28 Jan 2021 18:50:16 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.93-2-gebe5a4ff71d7
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 185 runs,
 6 regressions (v5.4.93-2-gebe5a4ff71d7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 185 runs, 6 regressions (v5.4.93-2-gebe5a4ff7=
1d7)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
hifive-unleashed-a00 | riscv | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.93-2-gebe5a4ff71d7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.93-2-gebe5a4ff71d7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ebe5a4ff71d7e01605c719adf499a54b19e97c67 =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
hifive-unleashed-a00 | riscv | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/6013438183282c39e2d3dffa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.93-2-=
gebe5a4ff71d7/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-=
a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.93-2-=
gebe5a4ff71d7/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-=
a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6013438183282c39e2d3d=
ffb
        failing since 69 days (last pass: v5.4.78-5-g843222460ebea, first f=
ail: v5.4.78-13-g81acf0f7c6ec) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60134550633fda6772d3dff8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.93-2-=
gebe5a4ff71d7/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.93-2-=
gebe5a4ff71d7/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60134550633fda6772d3d=
ff9
        failing since 76 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60134bd8e11628c7b5d3dfe8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.93-2-=
gebe5a4ff71d7/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.93-2-=
gebe5a4ff71d7/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60134bd8e11628c7b5d3d=
fe9
        failing since 76 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/601345385d53b4378ad3dfeb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.93-2-=
gebe5a4ff71d7/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versa=
tilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.93-2-=
gebe5a4ff71d7/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versa=
tilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601345385d53b4378ad3d=
fec
        failing since 76 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/601345038ef2155027d3dfc9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.93-2-=
gebe5a4ff71d7/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.93-2-=
gebe5a4ff71d7/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601345038ef2155027d3d=
fca
        failing since 76 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60134505fe5730ce8dd3dff1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.93-2-=
gebe5a4ff71d7/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.93-2-=
gebe5a4ff71d7/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60134505fe5730ce8dd3d=
ff2
        failing since 76 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =20
