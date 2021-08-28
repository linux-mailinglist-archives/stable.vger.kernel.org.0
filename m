Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC1A43FA50B
	for <lists+stable@lfdr.de>; Sat, 28 Aug 2021 12:41:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233741AbhH1KmK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 Aug 2021 06:42:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233732AbhH1KmK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 Aug 2021 06:42:10 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00356C061756
        for <stable@vger.kernel.org>; Sat, 28 Aug 2021 03:41:19 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id mw10-20020a17090b4d0a00b0017b59213831so10707005pjb.0
        for <stable@vger.kernel.org>; Sat, 28 Aug 2021 03:41:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=K5baHtt2X3m+IDsEmvcTw0Pd02oYTyFDZwJVMwlY9xI=;
        b=Min+49IVyvx4JRpKqPZCy3kuVHDHsBwzNp1IN5iu7Kvsqv0yQfFRQiIo9i9DDoeMIL
         bqbH+6EHj36LG3d5LHmYA6EXkY0UJCM7fJkuUcivqUH1nnpypkhQMCStmTbb9ZM98W1v
         obiU0fcLKUBnxeRybe7VfzFGOs+Sy1Ds0OhqL2WbfuzIAGagGAPw23Py6IVAAhOha/9Q
         kQ6p05LiK5A4wvHqPm3Qnrf0mIe1Y/oD83ZSp2Pe3+3O/RAd0vKij2oSPqbLPywdnRHl
         pV8SoZlx6MSi5wfLwJERTYzRVZ1tYOjn+kRoGJWWVMS6o5tTKQgsFOm2oJwqZBEg6OFf
         m4Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=K5baHtt2X3m+IDsEmvcTw0Pd02oYTyFDZwJVMwlY9xI=;
        b=S1RwJgAlwrCQFkA83Aptrlt9wU2Xz1nhd3zd/Z7fRvaoFWSz31nXvE8lJdcZsqtMJs
         X5vzNtIajIvV/03goiywtaNBqVfaFMNAoqZU6QJPiA2k5mfxvxFi8H0k50j7YAaVFy4F
         W9qmw6lfFBtuHapNch+ODYIKmMc9cBNkTRkHluQ/ZKy9y5bsrUY9qLu1TmWGRRKiLgUT
         dglN76t6xQ3c6ZEM/7bIBc1Qt9P2w3OHTo5W/2yeP/F3NG/7WrL31v+I5eZ+cYWai1GD
         2y14HcQI4pLKxRUcTj+bGU/U2zKx4QphN6Mndqquz0KFoKH59RUQIHVrAlWHNH89mlwv
         f4PQ==
X-Gm-Message-State: AOAM5310S4tbAvhtKz4kvZ3atkrG2DDpyrLoWcFv+B9le7ugMF2BG99Y
        wmK1mO+pgshRH3rhEIIyCjg7O5Vf/D8glgYa
X-Google-Smtp-Source: ABdhPJx3fRgH1M9A2O3JVBe+Tu0PsXZ+VYqvbEhr4gMO83xgwwR2BIupXZiQdU8UMd0TLONLbpvmpg==
X-Received: by 2002:a17:902:c9d5:b0:138:9a20:4bd9 with SMTP id q21-20020a170902c9d500b001389a204bd9mr7464351pld.34.1630147279095;
        Sat, 28 Aug 2021 03:41:19 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m18sm9064717pjq.32.2021.08.28.03.41.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Aug 2021 03:41:18 -0700 (PDT)
Message-ID: <612a12ce.1c69fb81.9140.7d30@mx.google.com>
Date:   Sat, 28 Aug 2021 03:41:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.205-7-gdac1f330021c
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 131 runs,
 4 regressions (v4.19.205-7-gdac1f330021c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 131 runs, 4 regressions (v4.19.205-7-gdac1f3=
30021c)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
meson-gxbb-p200      | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.205-7-gdac1f330021c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.205-7-gdac1f330021c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      dac1f330021cf93c8c2210232543a706cf27dec6 =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
meson-gxbb-p200      | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/6129e07dd16a0388e68e2ca6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.205=
-7-gdac1f330021c/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.205=
-7-gdac1f330021c/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6129e07dd16a0388e68e2=
ca7
        new failure (last pass: v4.19.205-7-g0cfdba431276) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6129dbeb2664f7404a8e2cad

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.205=
-7-gdac1f330021c/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.205=
-7-gdac1f330021c/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6129dbeb2664f7404a8e2=
cae
        failing since 287 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6129dc09bb8aa4cb088e2c8d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.205=
-7-gdac1f330021c/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.205=
-7-gdac1f330021c/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6129dc09bb8aa4cb088e2=
c8e
        failing since 287 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6129efb307ca68990e8e2c77

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.205=
-7-gdac1f330021c/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.205=
-7-gdac1f330021c/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6129efb307ca68990e8e2=
c78
        failing since 287 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
