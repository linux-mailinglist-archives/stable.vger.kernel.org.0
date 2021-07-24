Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 888023D4477
	for <lists+stable@lfdr.de>; Sat, 24 Jul 2021 04:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233769AbhGXCRq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Jul 2021 22:17:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233755AbhGXCRq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Jul 2021 22:17:46 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B424FC061575
        for <stable@vger.kernel.org>; Fri, 23 Jul 2021 19:58:17 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id ds11-20020a17090b08cbb0290172f971883bso11620561pjb.1
        for <stable@vger.kernel.org>; Fri, 23 Jul 2021 19:58:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=YPew3vyWxsNuNVRDx4SKncYqx3yJHCaWNzviPHbytfU=;
        b=pjnoZ8yAGnbvkq5jr6mMMdH3PnkixGGHBEgoFHfO+CsCrNup47aSqbaPKjurhB58ZI
         Wa+mSVZ1swFb/NuRwpp7F5qNELNksRy+p0X0kOg/wwwNgXmikTYDtNASCg8o02D/nP2h
         d8jhMkq6zj+ZXoMIazdGuwikU9plBgj7zau11Hm0qyMx6IehvIRvRUgt1EvQ96vrv7JF
         BqJU6wjlQJbVQYfceri1EAEnKre/WGukADnru+7hoijdI+tY1LN1LgUcGVUOb15og14P
         8J2+dX6E2nzHHaXsxjHUjbBxUkcr8JHq2jMZwf4k84gXxj0CqsvmsGoUN1r7im2ydtTi
         ifhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=YPew3vyWxsNuNVRDx4SKncYqx3yJHCaWNzviPHbytfU=;
        b=RJ1jaS5+NwvrRvt5B88FcPvdAltGPD0yG2/QCmOCZIgnfXreB4NaB72GdBFJhQ4Plu
         0yW2RLGd3u9zff51r2JcMMhNZwZ1jZZo8zwwgCGaUI4jc5qv1VdfqM7CRbjV2LE/+VaO
         UXgoyZfc/I4qp8I1hEPmS+YuRkJhfI9Ss9Fa2N4sJ3nSI6k57Ert10xN3DzPJEbBsJZe
         00wHEAcREw0aSc4inGkT/FQLW7DCZXmB/dWaWg9ZRF6A+h+MClbzosNdk8CXK4+rssnC
         SZVwFqMRxZR+rgmKAfuCjD4ubmCzE9z+HWb5jpqX/nq7JDfwxcQMnsbxWkWitHl7Lx2F
         NUnQ==
X-Gm-Message-State: AOAM532BsnlprMyYJbLaGNA+xhPNNWkRrLwg8IWO50D1/kxpL4Wl+C1C
        giYzGJqnMJuSC/4Ak/30WTFjMgWTGnXj1Mbx
X-Google-Smtp-Source: ABdhPJwvjb8ABvrAexNaazI2GeICYo/JCibyqHofNYF+5KrDEwHE+dsB1TE7LHJbKRCqeN0QzxWsFg==
X-Received: by 2002:a17:902:ced2:b029:12b:7c68:8dff with SMTP id d18-20020a170902ced2b029012b7c688dffmr6057027plg.15.1627095496298;
        Fri, 23 Jul 2021 19:58:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c24sm41935489pgj.11.2021.07.23.19.58.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 19:58:15 -0700 (PDT)
Message-ID: <60fb81c7.1c69fb81.c6852.ffb2@mx.google.com>
Date:   Fri, 23 Jul 2021 19:58:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Kernel: v4.9.275-270-gfc2788ccf4e4
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 150 runs,
 5 regressions (v4.9.275-270-gfc2788ccf4e4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 150 runs, 5 regressions (v4.9.275-270-gfc2788=
ccf4e4)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.275-270-gfc2788ccf4e4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.275-270-gfc2788ccf4e4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fc2788ccf4e4ca0ff7b56928e43a828529d6204d =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60fb4894adbf4030913a2f27

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-2=
70-gfc2788ccf4e4/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-2=
70-gfc2788ccf4e4/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60fb4894adbf4030913a2=
f28
        failing since 251 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60fb48b5311c5f348a3a2f2f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-2=
70-gfc2788ccf4e4/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-2=
70-gfc2788ccf4e4/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60fb48b5311c5f348a3a2=
f30
        failing since 251 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60fb487c0819219b8d3a2f2c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-2=
70-gfc2788ccf4e4/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-2=
70-gfc2788ccf4e4/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60fb487c0819219b8d3a2=
f2d
        failing since 251 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60fb68dd450bb1b2b93a2f55

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-2=
70-gfc2788ccf4e4/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-2=
70-gfc2788ccf4e4/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60fb68dd450bb1b2b93a2=
f56
        failing since 251 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60fb484c345461583c3a2f43

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-2=
70-gfc2788ccf4e4/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-2=
70-gfc2788ccf4e4/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60fb484c345461583c3a2=
f44
        failing since 251 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
