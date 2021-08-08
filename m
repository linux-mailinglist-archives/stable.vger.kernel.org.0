Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A50553E3C45
	for <lists+stable@lfdr.de>; Sun,  8 Aug 2021 20:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbhHHSuO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Aug 2021 14:50:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbhHHSuO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Aug 2021 14:50:14 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01551C061760
        for <stable@vger.kernel.org>; Sun,  8 Aug 2021 11:49:55 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id u5-20020a17090ae005b029017842fe8f82so17204158pjy.0
        for <stable@vger.kernel.org>; Sun, 08 Aug 2021 11:49:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BJcW8KkQj52B1Str+YnIq6X8C5qBeoe6s5+SVtDaObk=;
        b=S5qwd/H1RyuXEgYNcFH+fefpOoZOHEX2v79aO8MPyYLLtyMjLzwqDcIkkNCnfYv6RY
         Y+a8CcIeeCofhT2snSoY+EjzY0auYHvx+YxP/hUSDx+B+Ikri8MgXh5jbuEtpfcQUAoQ
         6ftxQmGgIlDanCX0UEqfq7btgIRla/3CdbZIeVZi5WzonareyV9oJ3z1AmijgBxoSNcJ
         p9OvYs7gB+crdKwXwhGyhORVksjTfXGUiX6lA31dQ+blVyzuqFvRfBXEslZnS3YSsbCG
         mVHeWaTsGdO+Du1NtRQL55vfVAWW4XhGAjsS9bUryiul4aGzXAWTyyGBAENuXe9iKVbw
         ip+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BJcW8KkQj52B1Str+YnIq6X8C5qBeoe6s5+SVtDaObk=;
        b=MuJdENJevuZWfthSNKH9i+f56Isl78BVmaG/HHl+1bcPxrzmSz6K4aryfE5R4ORfYN
         uZ8ws88vlJJNUd1lVOKhSybStxlHPRwD29Z3pj1QZGXkydpF1d8w/6aTrOMB+bs0S31L
         RhWyDO3ZjNrb5vMY4ywKE8W/e2FUhQgFV2FHPfYxgU6vyFphI3XPpzVcHn0Gj5FJfQaF
         L5ofXEPX20nYVdrm1ooQecF92ykaDlm3lRnFBB0rQbMpJiLv1344mQY8mFVR0BK8KBjW
         XbszWb3JBsgvXPPot/Q0n0Mq1M8Fz4Zykv7oIjBJLT9pH1LT2mQRvBKGudFejrBZgQUQ
         X5bA==
X-Gm-Message-State: AOAM530CLWxcjVRxen3ADAj7bQmsjX2Vm6yzan3kA1L232ScAEH9ufTd
        C4jVr72M0/Lh1ddDAVdTL/tjC8y4dPX/Sxtz
X-Google-Smtp-Source: ABdhPJwz+NKSO/ryF20HQD0gVxY4Gs4bpq8LoiRE1oRUqfAlgvqn0zsSqPCrHSjn6zCdj13/4TUwCw==
X-Received: by 2002:aa7:90d4:0:b029:3b3:2746:5449 with SMTP id k20-20020aa790d40000b02903b327465449mr20691069pfk.81.1628448594360;
        Sun, 08 Aug 2021 11:49:54 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c13sm17293046pfi.71.2021.08.08.11.49.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Aug 2021 11:49:54 -0700 (PDT)
Message-ID: <61102752.1c69fb81.8a0b8.2782@mx.google.com>
Date:   Sun, 08 Aug 2021 11:49:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.201-16-gce588829808f
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 119 runs,
 4 regressions (v4.19.201-16-gce588829808f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 119 runs, 4 regressions (v4.19.201-16-gce588=
829808f)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
imx6ull-14x14-evk    | arm  | lab-nxp         | gcc-8    | imx_v6_v7_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.201-16-gce588829808f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.201-16-gce588829808f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ce588829808fbc421be6a6f864762d2e0f920002 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
imx6ull-14x14-evk    | arm  | lab-nxp         | gcc-8    | imx_v6_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/610ff82d7e9f82452ab1369b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.201=
-16-gce588829808f/arm/imx_v6_v7_defconfig/gcc-8/lab-nxp/baseline-imx6ull-14=
x14-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.201=
-16-gce588829808f/arm/imx_v6_v7_defconfig/gcc-8/lab-nxp/baseline-imx6ull-14=
x14-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610ff82d7e9f82452ab13=
69c
        new failure (last pass: v4.19.201-12-g0bdb8864dde6) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/610fea94fda4efe90ab13695

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.201=
-16-gce588829808f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.201=
-16-gce588829808f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610fea94fda4efe90ab13=
696
        failing since 267 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61100b2050ce6aa345b13661

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.201=
-16-gce588829808f/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.201=
-16-gce588829808f/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61100b2050ce6aa345b13=
662
        failing since 267 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/610fef224cef73be6db13662

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.201=
-16-gce588829808f/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.201=
-16-gce588829808f/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610fef224cef73be6db13=
663
        failing since 267 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
