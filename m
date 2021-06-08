Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA6323A054F
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 22:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230482AbhFHUxX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 16:53:23 -0400
Received: from mail-pj1-f46.google.com ([209.85.216.46]:34557 "EHLO
        mail-pj1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231220AbhFHUxW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 16:53:22 -0400
Received: by mail-pj1-f46.google.com with SMTP id g6-20020a17090adac6b029015d1a9a6f1aso2410958pjx.1
        for <stable@vger.kernel.org>; Tue, 08 Jun 2021 13:51:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=v5q8t1GjIYxrTN/1EV/m1Kld0TzFO4eCJ+3VCWwGDug=;
        b=wecWWxS1fZZp2I3V1Ha1gpNv8dyKWfAG9y00D24fYdg1e5LDFq0qg+Fu0VNNFEVxnC
         VDDnV3a2TqkyhQNRbE6zH+gzonAxYGfsiqOyTS+xWH96MW2TfgOaHiaL4XGnq7iMBVR5
         UFnMyge1n1/MFn9OcTRBzT2852Dpa3I9a7RmISw0xRQUYsVToSIJrNzGzE+zwvVTFoh2
         22WSMbrKAW98V9IOg1uCj/4h07yO6YQp9w8vKPFF1FD7G+AE21D9wtIqezpqZZA5vlRP
         AbeTjVEllprNRKpsPlwzQwVJAa/INtWsjDGo2O504LnX5Z3QkEromitX+SHb+cYUq+Zi
         OOOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=v5q8t1GjIYxrTN/1EV/m1Kld0TzFO4eCJ+3VCWwGDug=;
        b=LvXsF/sXb8wwtCDQQkA4dHqSM/OY6QzJFtnENX1MPzAEVPDUjUZC5HDqJA8SrNtGSr
         KnMLgsNwoJ57/RigtfDnxaoGWH41g26PGcgqasCYu7w/vBd9v+XwZHXbba5TBr/o3xEz
         xaGtkmIpEe9x/5mxq+Z0RVYXCy1NxYw7XOWERCAdPTLZZ4f8pORcap1wwxJDiSVc5xPM
         7SOcjVtvZeXTKm5AcEQl+LrijifwASrpabuvvu5k8Up5N+BPv3GjIrHWc9Gsk7rYYckk
         UgAoOe3E70vEV0jL0RTMJ26lkse2DQQBplsQwUAk0RcBmhLu/I84kq+2t0oBL0zMNoGx
         Q3mA==
X-Gm-Message-State: AOAM530/FC/h9xtRB8nLBsG1VSoHklM3qRAdlXbKoGEFz8B+OneoqrO/
        eMmYrDFzdrCheehMm1wE8MQPGNPRch1S8nbm
X-Google-Smtp-Source: ABdhPJyIyBfBeInk9H1nUy7fBO1tkECOFwXYBoFeZhCosUL2HfZvioyf7ngWwKCRSiEzxNvjzDCezQ==
X-Received: by 2002:a17:902:9685:b029:ef:70fd:a5a2 with SMTP id n5-20020a1709029685b02900ef70fda5a2mr1974194plp.20.1623185428907;
        Tue, 08 Jun 2021 13:50:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id fw16sm3102296pjb.30.2021.06.08.13.50.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 13:50:28 -0700 (PDT)
Message-ID: <60bfd814.1c69fb81.c8ae4.a288@mx.google.com>
Date:   Tue, 08 Jun 2021 13:50:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.193-51-g95140046b4ea
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 98 runs,
 4 regressions (v4.19.193-51-g95140046b4ea)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 98 runs, 4 regressions (v4.19.193-51-g951400=
46b4ea)

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
nel/v4.19.193-51-g95140046b4ea/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.193-51-g95140046b4ea
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      95140046b4eabb6c746049653c49813eb8dc72b6 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60bfa2f5273fc9bdbb0c0dfb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.193=
-51-g95140046b4ea/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.193=
-51-g95140046b4ea/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bfa2f5273fc9bdbb0c0=
dfc
        failing since 206 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60bfa2f5f7373535fb0c0df7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.193=
-51-g95140046b4ea/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.193=
-51-g95140046b4ea/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bfa2f5f7373535fb0c0=
df8
        failing since 206 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60bfa2f684884db6740c0e02

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.193=
-51-g95140046b4ea/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.193=
-51-g95140046b4ea/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bfa2f684884db6740c0=
e03
        failing since 206 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60bfc4a96b08ce52fc0c0e10

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.193=
-51-g95140046b4ea/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.193=
-51-g95140046b4ea/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bfc4a96b08ce52fc0c0=
e11
        failing since 206 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
