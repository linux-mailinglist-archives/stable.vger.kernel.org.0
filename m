Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF922F539B
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 20:47:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728644AbhAMTqf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jan 2021 14:46:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728451AbhAMTqe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jan 2021 14:46:34 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 989F7C061795
        for <stable@vger.kernel.org>; Wed, 13 Jan 2021 11:45:54 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id a188so1873838pfa.11
        for <stable@vger.kernel.org>; Wed, 13 Jan 2021 11:45:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=c7vszXSuoLh8Kj/pFdM/AQyiTXugSKT/Yjx1sPz7qOM=;
        b=E84U2UcGO+sky75UKqD6JemFNE18bW13vPdiMfwdpDT8b7DoHhVg5o6y5TZRBqQq0d
         UhyaW3lf7PTizHYhZMFaaVhL6XcKEX5C+zhVcuvOcBbk6kX7fwLItR2nLtjiLpeOux+z
         /9gcxhL4l9+5x2vCWBGxs/maCNdANAeu4fyFp2stFWRt/naTAI7LfnaDYN9D/K/I30I4
         Hyu+1EmoxEKvJcntZ8Bq8jsoqqxlNvo5F2O7ME+yolt/+0I1ic9j2gd1Yh5JU93e1o4G
         /c9+SX+FSyFqEeFj98z7TuMbQXgOq5zxQB7ecb3LXxEWtrXnLWEyb33Y6yQ3GzVRnmIX
         CQaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=c7vszXSuoLh8Kj/pFdM/AQyiTXugSKT/Yjx1sPz7qOM=;
        b=K9DiLUdzzVrylKZdvIfe7kFgq1kTUz3mwMdOHLZp+OgNhLqEgy91I0onwiZET4igGF
         DVORXd8AuXtzc2UuCRxGQnGICSbk1sqCiN10kqBayO1UpJ8VH0J5dfeGHTsTv7sr+jyn
         81dwYbcrqyCJjLnhMwyDmmhPZbNiL2Mic9pUJEi5yRiICdVoN4zJqxnyKVGl5sY2MlUM
         qUMDTeEFBX+M/1Je23pukYmgS/Ydl6HOBddyUvo72u79I7tAhPwtHRBTmUtypjQunOou
         uGPiNeaZrIUrcXbmcD4tyCxvOr+zfyqbnsTqZgm3ttd1gGFYbhoLhucKmjT7JDb4yBHq
         xJrQ==
X-Gm-Message-State: AOAM532kpyre/xpLHYpdXkhlMuzT5w5mPTeiOF4QemTikJ+mHgxPJz0/
        PAibBlJqdo6qZ4In4C3lamxf+hrKZ7zWIw==
X-Google-Smtp-Source: ABdhPJwQ+RiKlqnUOHqHjqfrtq+9GpmG4nDScxSBkQFou2XrQurJis9+Wj9tAsCXgquNMwz4FimgAA==
X-Received: by 2002:a05:6a00:795:b029:19e:28de:e92a with SMTP id g21-20020a056a000795b029019e28dee92amr3550286pfu.36.1610567153715;
        Wed, 13 Jan 2021 11:45:53 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c10sm3376816pfj.54.2021.01.13.11.45.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 11:45:52 -0800 (PST)
Message-ID: <5fff4df0.1c69fb81.8fe3f.7d7e@mx.google.com>
Date:   Wed, 13 Jan 2021 11:45:52 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.214-57-g0e50c1f11b4bc
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 120 runs,
 5 regressions (v4.14.214-57-g0e50c1f11b4bc)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 120 runs, 5 regressions (v4.14.214-57-g0e50c=
1f11b4bc)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
meson-gxm-q200       | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.214-57-g0e50c1f11b4bc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.214-57-g0e50c1f11b4bc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0e50c1f11b4bcdb4776cd435e0add7ad67607c02 =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
meson-gxm-q200       | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/5fff4273912058c59dc94cc0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.214=
-57-g0e50c1f11b4bc/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.214=
-57-g0e50c1f11b4bc/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fff4273912058c59dc94=
cc1
        failing since 36 days (last pass: v4.14.210-20-gc32b9f7cbda7, first=
 fail: v4.14.210-20-g5ea7913395d3) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fff190729d039fb12c94cd8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.214=
-57-g0e50c1f11b4bc/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.214=
-57-g0e50c1f11b4bc/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fff190729d039fb12c94=
cd9
        failing since 60 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fff19193cb45ee666c94cc6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.214=
-57-g0e50c1f11b4bc/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.214=
-57-g0e50c1f11b4bc/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fff19193cb45ee666c94=
cc7
        failing since 60 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fff1912d4b1b9d19fc94cf0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.214=
-57-g0e50c1f11b4bc/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.214=
-57-g0e50c1f11b4bc/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fff1912d4b1b9d19fc94=
cf1
        failing since 60 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fff48f51cad5351e2c94cd8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.214=
-57-g0e50c1f11b4bc/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.214=
-57-g0e50c1f11b4bc/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fff48f51cad5351e2c94=
cd9
        failing since 60 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =20
