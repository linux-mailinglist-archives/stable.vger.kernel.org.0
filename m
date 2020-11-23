Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56A992C11A0
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 18:08:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390331AbgKWRHe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 12:07:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390349AbgKWRHe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Nov 2020 12:07:34 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7145C0613CF
        for <stable@vger.kernel.org>; Mon, 23 Nov 2020 09:07:34 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id b6so5034474pfp.7
        for <stable@vger.kernel.org>; Mon, 23 Nov 2020 09:07:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BsYkTSFowt1YeWiWmCPRBtlpJA80yx4ZoiN8BUKPNcQ=;
        b=lu0QPt2UYlzohJe9tZHuyUbUz9L1Eqnj3HLiMYiDAMhGvwnmOkuANH4SyMQTBZQdWh
         +G4HkZyKfLNq2F3Uld7/CU+I2r09SuqGb0slCS0IOpafqC/LURAzlWZJevMy2cwPObl5
         /LRmnTMHW/JEYTvG1fXZY5brHHSc3cgGY20OVmrbbkVKV0Cr3HqcRBOU6UAcV+dj2sef
         Nf9nhPOlhcvClDmFvG3wsQzpdVdbRKdYyJw4r6Bh+VxI7hzlq1RtsIWC/ha8O7UH2CpC
         /JVspbePbxG/l4b4P50Gk3gbvf6Eq5/L0omB1KJFygoeMaAO7yphUM0VWNVFUooQBDKt
         j7zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BsYkTSFowt1YeWiWmCPRBtlpJA80yx4ZoiN8BUKPNcQ=;
        b=EG4jB6PmCIqv7jPwmKO58z49Eynuw2fPItDz4+lF6MiVJZ8cDO77kJyh6Wcfx5jUrq
         bcqZQUtxyfpPC/RLJ7Jb85uYy8ujkn1NRJ0YxBYE0f739Wq5mDNHt+fL9b+18FKQQIWI
         pSGNeETY0QtrqAdAnpgRwUYkdQeGaOYjNEnl1fIr8CPSDwgx8j0e5W7YRyxrEV4tAJW2
         J80j2Fn8urIIxKMitcAwk8blQ1ZrBnCt6IviJMxcPSZ+u1TN10Ip/xpXmTjtkKBnxSBd
         A5y1tq5CQ7PnpLbGPveDuPyc4WErkzm4rs9+J67DZDP6cDl2c5Q1/qZbJLQPdVyFpPtV
         nfdA==
X-Gm-Message-State: AOAM533ANktDXK3xjQAwPfeSXUiS2aXx7kxLEoiumBzIJa6E/mbCXnPs
        zr3jl7BLJFXaJrY682pPk9heHXW6riNulg==
X-Google-Smtp-Source: ABdhPJw4sYsTgSvDxXMAMfEiHGT0DwV/XE0k60QXRVB7mu2WSD5IUF6od5m32fSYy0jHigwQTxmECA==
X-Received: by 2002:a17:90a:d195:: with SMTP id fu21mr723991pjb.157.1606151253789;
        Mon, 23 Nov 2020 09:07:33 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q12sm10983792pgv.91.2020.11.23.09.07.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2020 09:07:32 -0800 (PST)
Message-ID: <5fbbec54.1c69fb81.bef5.8244@mx.google.com>
Date:   Mon, 23 Nov 2020 09:07:32 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.159-91-ga6373fa1634b
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 162 runs,
 5 regressions (v4.19.159-91-ga6373fa1634b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 162 runs, 5 regressions (v4.19.159-91-ga6373=
fa1634b)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.159-91-ga6373fa1634b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.159-91-ga6373fa1634b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a6373fa1634bf97c7118cd5a3e70d8903234cab9 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbbb9746b9024d96bd8d921

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.159=
-91-ga6373fa1634b/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.159=
-91-ga6373fa1634b/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fbbb9746b9024d=
96bd8d926
        failing since 0 day (last pass: v4.19.159-26-g0e1af0d881d4, first f=
ail: v4.19.159-32-g9230dcfcb9bbb)
        2 lines

    2020-11-23 13:30:23.937000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbbbad75c59bd310fd8d913

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.159=
-91-ga6373fa1634b/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.159=
-91-ga6373fa1634b/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbbbad75c59bd310fd8d=
914
        failing since 9 days (last pass: v4.19.157-26-gd59f3161b3a0, first =
fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbbbacb5c59bd310fd8d8fd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.159=
-91-ga6373fa1634b/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.159=
-91-ga6373fa1634b/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbbbacb5c59bd310fd8d=
8fe
        failing since 9 days (last pass: v4.19.157-26-gd59f3161b3a0, first =
fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbbbadca004ea52ffd8d928

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.159=
-91-ga6373fa1634b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.159=
-91-ga6373fa1634b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbbbadda004ea52ffd8d=
929
        failing since 9 days (last pass: v4.19.157-26-gd59f3161b3a0, first =
fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbbba786090736fddd8d933

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.159=
-91-ga6373fa1634b/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.159=
-91-ga6373fa1634b/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbbba786090736fddd8d=
934
        failing since 9 days (last pass: v4.19.157-26-gd59f3161b3a0, first =
fail: v4.19.157-27-g5543cc2c41d55) =

 =20
