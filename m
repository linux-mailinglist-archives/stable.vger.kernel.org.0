Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E12823958B7
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 12:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230518AbhEaKGy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 06:06:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230521AbhEaKGw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 06:06:52 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD15DC061574
        for <stable@vger.kernel.org>; Mon, 31 May 2021 03:05:09 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id e22so7978078pgv.10
        for <stable@vger.kernel.org>; Mon, 31 May 2021 03:05:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wnAGt45xKtcPPid1Y7rpn/aPhpV9Dta1bR6zRtbHijk=;
        b=UPNLWrwYjlJ9R5t+SWbJe/CmeGGs3fz/bWXcZrv/KRhH02GwC+gpCFTXya/A9vOM96
         1UU9sjFUGHZUKQ/TIL9WndEKA5HOKWXHhQj/gtxLGccOAcNMrQrYwU/N7oVia3TAE9dR
         7D/oAlwHWHzi97xB+iSY9bxJR1nuAfa5oUI+nhdJWQdEqPfnocU2sDVyUCcfKxtQqbFH
         XLlPMOgAWzlA6FNMZ2/Jz7Hd5u6CdXNvOBSilIQ7bzA9lm9+pzFLXBmZlVlUl+uNnS8i
         5rMG6qMlMcnt/QuRmqejY950+vpS3/Jmc7i7y14aiRoNqVP6VjRey4FZruPJW7R1AGBT
         tSgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wnAGt45xKtcPPid1Y7rpn/aPhpV9Dta1bR6zRtbHijk=;
        b=sgrBrkb3Nbgz692pf5wHjHmfeoVZH7ovUvkWCcAUwu8zH1/E2i7pCI1sJ7xRE+ficB
         CMVIsDyFY9Z6wLiXG3NXBE42fjPmVnc4fjuooFojaiu7cwC6+5ZgR9J+OYukqm7vLdJU
         BfOvzZ5chAYXpmywd5OPse2hoxx7MkXzTnvgmbcMKYvogAK98kUC7r4hCFO6ppHRgE/p
         BD5M5vieAPbxUhBihyBf0WPQ+RV2ldwAKn74oXQEOMUtw4H7Yskf242j4H/qx7QmAi5P
         DYX369fnvauYCY0AIhIixFkOanidSfYORYvQOMV4ksfS1JGBIbz3PYqTk0HXPhoe6jcj
         rbvA==
X-Gm-Message-State: AOAM531n8gcBvePUX7QM2xXUPhi7RefHDoF9bjFCuzrOYmitx8TTJ77m
        lRYRPopVsDI5ETWdpOgwkdlc232V+peWms1l
X-Google-Smtp-Source: ABdhPJxmIWWmpqVg09oCN3Zh0iA7OlU66okkpkJrY+guO9R2PXWdxuTIfqB7VqoDag5dUf+RwVZz1w==
X-Received: by 2002:a05:6a00:10c2:b029:2de:7333:1343 with SMTP id d2-20020a056a0010c2b02902de73331343mr16283525pfu.42.1622455509101;
        Mon, 31 May 2021 03:05:09 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z5sm8950259pfb.114.2021.05.31.03.05.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 03:05:08 -0700 (PDT)
Message-ID: <60b4b4d4.1c69fb81.989e4.bcff@mx.google.com>
Date:   Mon, 31 May 2021 03:05:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.192-114-g533e4285f10d
X-Kernelci-Branch: queue/4.19
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 118 runs,
 6 regressions (v4.19.192-114-g533e4285f10d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 118 runs, 6 regressions (v4.19.192-114-g533e=
4285f10d)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
beaglebone-black     | arm  | lab-cip         | gcc-8    | multi_v7_defconf=
ig  | 1          =

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.192-114-g533e4285f10d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.192-114-g533e4285f10d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      533e4285f10d17d5ec998419572378f5d72c3130 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
beaglebone-black     | arm  | lab-cip         | gcc-8    | multi_v7_defconf=
ig  | 1          =


  Details:     https://kernelci.org/test/plan/id/60b47d05fb9027ed25b3afa1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-114-g533e4285f10d/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-beaglebone=
-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-114-g533e4285f10d/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-beaglebone=
-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b47d05fb9027ed25b3a=
fa2
        new failure (last pass: v4.19.192-97-gbcb6e5399a5d) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60b47718c09ee8f49db3afaf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-114-g533e4285f10d/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-114-g533e4285f10d/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b47718c09ee8f49db3a=
fb0
        failing since 198 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60b4770ffa247ee442b3afa9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-114-g533e4285f10d/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-114-g533e4285f10d/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b4770ffa247ee442b3a=
faa
        failing since 198 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60b4771ac09ee8f49db3afbf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-114-g533e4285f10d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-114-g533e4285f10d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b4771ac09ee8f49db3a=
fc0
        failing since 198 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60b48b41f5d53000f7b3afa6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-114-g533e4285f10d/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-114-g533e4285f10d/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b48b41f5d53000f7b3a=
fa7
        failing since 198 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60b476d00202ff0522b3afaf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-114-g533e4285f10d/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-114-g533e4285f10d/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b476d00202ff0522b3a=
fb0
        failing since 198 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
