Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79F80362853
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 21:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242234AbhDPTIy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 15:08:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242215AbhDPTIw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Apr 2021 15:08:52 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61B2CC061756
        for <stable@vger.kernel.org>; Fri, 16 Apr 2021 12:08:27 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id h20so14493822plr.4
        for <stable@vger.kernel.org>; Fri, 16 Apr 2021 12:08:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pENFFD6GKsFJt7NSBBSHqC+uaA6wIV7FbDTi7bCGe8M=;
        b=YTdjNfB47M3KC010/dgXg2mwMWVXhP3sy8iOOsH94lzpRpPqJYC7P2OFXwQZzlskkX
         mxI67MhV4hi5CDFi4eWIOp7xT3CsQsbA/16MCwNysPk+/rH1eAUrkBd+7dd0D/UMop0c
         0wvJq6dR4beO36ZJIHFsrEnuDaUBQuAqmIPdRNGOMx3tV23sI8wM4Awk1HUapcT1p5Zf
         LzZhUpRR1MR4HJ/0+z3RJH+1jz+UmTmIQAUiVMgF8VzvRqy6Vsfg+rfnnZ128n0VIeVr
         a+4fdIpyj6Vy6h/qMGgas+Rkn+hkkcNJy+jmZs04KLpVGJ8VzON1eaIPZioV6P0efSbv
         lKTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pENFFD6GKsFJt7NSBBSHqC+uaA6wIV7FbDTi7bCGe8M=;
        b=RVueRHkWaDg9xcFgCmL5hjYHhszOrV3CLOGMGI8s/Csir7osuv8QLWO8pUfEsWkz17
         4yi0DmT/LkUqvbe4db58Dr3SbDangc210N5cyY5sz/uwwTMTR+LHCFgm8KNTv6zTyyfF
         XZ9YLSHI4tOWu53mJ7SA2zYz/J7WwZcAvoWAwbJ6Oz/FIE1db/9JgyxMjseKDaHk62iG
         k2SadNsbbE4mm9alNMyW9gLxNuHhBXqlrPI4U+TCvI9TEOvpeQYH5nXlr/lN/9FJeAPY
         wAt6UBgQIH+Us88MIJsFRcgQXrqs5HbDzY5rOJg4lttGsCisYSKbOm+chcThBFA0OoRR
         hBMA==
X-Gm-Message-State: AOAM531W0IvE0Lva4BZRT0PpfHtXaWqGKolkR7EHpaLhNSi6Bcrk7xkf
        C5GNRS9XcVtGQLLMEnGXdJxQVzb47lAxCg==
X-Google-Smtp-Source: ABdhPJzYpPifSLtk1kkayaOnLBm44p8Bpwauc/g9ImNuTNl8isZYM5l6mREpGs+5ZzfI14fqpQqbNg==
X-Received: by 2002:a17:902:aa87:b029:e9:8d9e:6808 with SMTP id d7-20020a170902aa87b02900e98d9e6808mr10887011plr.34.1618600106695;
        Fri, 16 Apr 2021 12:08:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y2sm5765960pgp.2.2021.04.16.12.08.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 12:08:26 -0700 (PDT)
Message-ID: <6079e0aa.1c69fb81.c3974.0d17@mx.google.com>
Date:   Fri, 16 Apr 2021 12:08:26 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.231
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.14.y baseline: 105 runs, 5 regressions (v4.14.231)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y baseline: 105 runs, 5 regressions (v4.14.231)

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

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.14.y/kernel=
/v4.14.231/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.14.y
  Describe: v4.14.231
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      cf256fbcbe347b7d0ff58fe2dfa382a156bd3694 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6079a39d0285fb3ff6dac6d2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.231/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.231/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6079a39d0285fb3ff6dac=
6d3
        failing since 148 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6079a3a1b246db6fd4dac6b1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.231/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.231/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6079a3a1b246db6fd4dac=
6b2
        failing since 148 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6079a39c9923f86a38dac6c3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.231/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.231/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6079a39c9923f86a38dac=
6c4
        failing since 148 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6079a342d34a2ae657dac6c9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.231/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.231/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6079a342d34a2ae657dac=
6ca
        failing since 148 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6079a34d575cba05b0dac6d6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.231/=
arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb=
.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.231/=
arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6079a34d575cba05b0dac=
6d7
        failing since 148 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =20
