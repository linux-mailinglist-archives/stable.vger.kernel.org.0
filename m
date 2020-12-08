Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73EF62D1EB9
	for <lists+stable@lfdr.de>; Tue,  8 Dec 2020 01:01:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726114AbgLHABA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Dec 2020 19:01:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725877AbgLHABA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Dec 2020 19:01:00 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44557C061749
        for <stable@vger.kernel.org>; Mon,  7 Dec 2020 16:00:20 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id c12so4967291pfo.10
        for <stable@vger.kernel.org>; Mon, 07 Dec 2020 16:00:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/wCKdwXTafy7M7EaxcdR2MJN8TMf3JPSWRjCP8Kd9Y8=;
        b=yXOP0PVGWQ9cg/K2CnNNwKeBGQlfq3Mafm/pN2zc0/LnJrMEGRcl0uNcCbsksb0x8a
         SdlR1mGq7+MSvSGrKolusrY9S0ctiOgWF1HGgJO3RuMX0iMoggKmBnospzV2QVHmLRV4
         UIK359zmdgXrx+I1bMBRExA5/9LKyrgdH+Njht/GYZF8dlo7Z2SLQ+HWcHEdaSZ83UtY
         KELVZjD/NEHn+HJZGOGZwVdDqiWCHsGogTTUgL/LN5XduDvK8vFC0M67Ye9OIjnyG1PI
         GQLbxiA1n0/uRycbKHhZdfuD1TFyzBKxxbq5AAFoqMg2qBteKB2ba6fspwGv0Gk7sgG6
         XK/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/wCKdwXTafy7M7EaxcdR2MJN8TMf3JPSWRjCP8Kd9Y8=;
        b=CBEbKmSxLlAtBRBK/LKS0TTQ0zpkuNA6i+tUlduvh0SgzkkO+6l/qyL/RbVaawhbLu
         DX33BBgBDYt6ZCSxxFrfA02jHkLynPB5voSOHk2TwCyL86oE3Phf9rw+e+7bfELwWgdU
         xp8LtTC0US9oZ9LSW3wan1UtNMquYCpz/7NW191bG/XpyIl9bqcpulgw/buchaeiCqgK
         tMYPcRYmEW72AnDW7mW4weOeSjastKkrH8YyCJ9XshsW3kyxiHP+mpkIq2XDLrQm9Lix
         pW+t9kQrv4BWrHjzSWlZ7NFRLcIuDmjmZe5JJIEucQkXPlJWiyNjUIVl5QNXGNQ2ej5Z
         qugg==
X-Gm-Message-State: AOAM531bxiAcXD3T6wCYuw1vUsql4ay9IdeXvWslC2PcK3M38O7B3Wg9
        hI7oTSd8GsmwDKMXILJFKfbl8mqvW3fTgg==
X-Google-Smtp-Source: ABdhPJwkJVFdr35FYBbndxXcEK4zn/DQiyPjKnq4aAK+K5Rx+aH/sfxNbapd0aWdsdb9Li1SVrd6qQ==
X-Received: by 2002:a17:90a:4093:: with SMTP id l19mr1236463pjg.218.1607385619409;
        Mon, 07 Dec 2020 16:00:19 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 5sm11102466pfw.12.2020.12.07.16.00.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 16:00:18 -0800 (PST)
Message-ID: <5fcec212.1c69fb81.c0c71.977f@mx.google.com>
Date:   Mon, 07 Dec 2020 16:00:18 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.247-4-g50539cf53250b
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 41 runs,
 6 regressions (v4.9.247-4-g50539cf53250b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 41 runs, 6 regressions (v4.9.247-4-g50539cf53=
250b)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
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

r8a7795-salvator-x   | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.247-4-g50539cf53250b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.247-4-g50539cf53250b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      50539cf53250bb2ad1022e77689d58d1ac7b72f5 =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc85aae57a6b0abd3c94cbd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
-g50539cf53250b/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
-g50539cf53250b/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc85aae57a6b0abd3c94=
cbe
        failing since 19 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc85aa1f73e9a864ec94cd7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
-g50539cf53250b/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
-g50539cf53250b/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc85aa1f73e9a864ec94=
cd8
        failing since 19 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc85aab2a6d16ccb5c94cbd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
-g50539cf53250b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
-g50539cf53250b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc85aab2a6d16ccb5c94=
cbe
        failing since 19 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc85a93f73e9a864ec94cc2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
-g50539cf53250b/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
-g50539cf53250b/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc85a93f73e9a864ec94=
cc3
        failing since 19 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc85a6935d97ac55dc94cc9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
-g50539cf53250b/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
-g50539cf53250b/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc85a6935d97ac55dc94=
cca
        failing since 19 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
r8a7795-salvator-x   | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc85abb3f2ecff10bc94cc2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
-g50539cf53250b/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvato=
r-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
-g50539cf53250b/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvato=
r-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc85abb3f2ecff10bc94=
cc3
        failing since 15 days (last pass: v4.9.243-24-ga8ede488cf7a, first =
fail: v4.9.243-77-g36ec779d6aa89) =

 =20
