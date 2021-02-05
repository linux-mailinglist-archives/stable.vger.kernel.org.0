Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9F731193F
	for <lists+stable@lfdr.de>; Sat,  6 Feb 2021 04:00:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232129AbhBFC7u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 21:59:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230392AbhBFCrg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Feb 2021 21:47:36 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4B3DC08ECB2
        for <stable@vger.kernel.org>; Fri,  5 Feb 2021 14:50:35 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id l18so4640538pji.3
        for <stable@vger.kernel.org>; Fri, 05 Feb 2021 14:50:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6G3+YfPCOC3ZadGv5/4/yTlNru6JlAhweW839jUQMts=;
        b=zJxckRvWdHukFMod3Fg69Gv2o/wY33vSCPZ54mWWW2THm2bUo41mL17vFoJ5HYf8Jd
         2wt79SywUuCryIC4ugqSFOiAiHmIJK3oic0cIQyjVtZpkBnuX3mJwxVKdFep8YHIGgl8
         bdZRaDdFks+GzqJoBZS9IcIdArsIjpruyiOgeiTJ98DV57l2ZVoH0jR252uh+J4d7QD/
         RRenEFqPFl4szJuo3UJcqqQ4jTzX1vrWDW55+PYLyxnZSQIx/+e0o0yHcbGl22FSwPFc
         dg5cCK3ZSuRzFdtkq/uf08xpc0zhzmOJ/skPJ2yotf+ka7yL57NUC28p0R5PiF0s3cwS
         cj2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6G3+YfPCOC3ZadGv5/4/yTlNru6JlAhweW839jUQMts=;
        b=uRMTk4tJMXW1amvPkWYg6HOLKgaako/lCUmafuCQc9VVDHkC9Yf6r7WSG7uNee3I36
         SZgMdzOXATLSvIsyVuZnfk9fwJi8FTK0r9taPD9ZtBKj7LF6jE2YxQYvQwI/5QqhvJsn
         oJXc1tEmud19nsgcWrSlZ4K7PyaYRDVxTcBhHvURD6T9rqIQ/D8+gH6VZJrw4wW6KkXk
         qwXGmvjCzU+uxbU/HR/BaXQveuB6fUgdS3nVOZHiT+iyQJVTGY69w73D7jpp9f5/K8hy
         KVaIxvn2wIRXset34uOwzeVyBNYQJ2xYlZG1XMQwdo5DSI6XdzPmcPk0nVIZ3AY+7sID
         hueg==
X-Gm-Message-State: AOAM533oKVc5FUTpqiVoC7aknE6E087MYRPr+II4o3Lxcbe+7SNwNNqG
        vCWrwVSf4EEnYMx8VPrWuxXTRlQTZU4aIw==
X-Google-Smtp-Source: ABdhPJwduvkicgX0SabW1Ajw1uHH0I1mw03rdcC4DrrT5MvR8QxZjNEqzXdFdomYrZMffByMiKwVow==
X-Received: by 2002:a17:902:ed84:b029:e1:1058:d7ca with SMTP id e4-20020a170902ed84b02900e11058d7camr6054710plj.85.1612565434842;
        Fri, 05 Feb 2021 14:50:34 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a8sm5549978pjs.40.2021.02.05.14.50.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 14:50:33 -0800 (PST)
Message-ID: <601dcbb9.1c69fb81.570d7.b1d0@mx.google.com>
Date:   Fri, 05 Feb 2021 14:50:33 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.173-17-gb05333213586d
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 120 runs,
 5 regressions (v4.19.173-17-gb05333213586d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 120 runs, 5 regressions (v4.19.173-17-gb0533=
3213586d)

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

qemu_i386            | i386 | lab-baylibre  | gcc-8    | i386_defconfig    =
  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.173-17-gb05333213586d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.173-17-gb05333213586d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b05333213586dda1661ff8a8c12f91b8b22584db =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/601d9928fa9641f1853abe6b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.173=
-17-gb05333213586d/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.173=
-17-gb05333213586d/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d9928fa9641f1853ab=
e6c
        failing since 83 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/601d992af7e362db533abe78

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.173=
-17-gb05333213586d/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.173=
-17-gb05333213586d/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d992af7e362db533ab=
e79
        failing since 83 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/601d992b1587e2c9403abe6b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.173=
-17-gb05333213586d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.173=
-17-gb05333213586d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d992b1587e2c9403ab=
e6c
        failing since 83 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/601d98d5dc8726c9083abe66

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.173=
-17-gb05333213586d/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.173=
-17-gb05333213586d/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d98d5dc8726c9083ab=
e67
        failing since 83 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_i386            | i386 | lab-baylibre  | gcc-8    | i386_defconfig    =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/601d98054688cfd2cb3abe65

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.173=
-17-gb05333213586d/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i38=
6.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.173=
-17-gb05333213586d/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i38=
6.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d98054688cfd2cb3ab=
e66
        new failure (last pass: v4.19.173-5-g9a0b47b184f3) =

 =20
