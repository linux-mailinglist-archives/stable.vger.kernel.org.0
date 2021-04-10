Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB00935AF98
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 20:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234768AbhDJSau (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Apr 2021 14:30:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234513AbhDJSap (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Apr 2021 14:30:45 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6A7FC06138A
        for <stable@vger.kernel.org>; Sat, 10 Apr 2021 11:30:29 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id b26so1298645pfr.3
        for <stable@vger.kernel.org>; Sat, 10 Apr 2021 11:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=edzKm7xclpadjl2yqMcxqSlb1umdJkpe3x5uVSefUWw=;
        b=frSE+n0Jl0tsnBj05bhFWMhnK935XLpHRTvBIhYi4gaQ+TuZZlmCjrAcs/WpbrUGTD
         oQmRLlbZtlawKvoZT7iTWEPqf1KHLfS3N9weaz8cQdEiZ1+BAxfUgM7uJbtOA15MsuZZ
         k/lKXXeK5Osnesv/969G2jpTWaBSkZ16O1secDXUPhAspeJCKrZCQRnRid2RUGFtsYhu
         FwixzeOxl9334mooiUAfJa5DoHESykjqlBNIZgJxtyAQ81/nljpvYpsbdsNjPpfbU9NQ
         lbScBxXk4s+lAKEEPgkMS/LVBK8eGqlFf59I3LKp0DzBz9h0c/V4++egbuYk8WbLo4ao
         8vSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=edzKm7xclpadjl2yqMcxqSlb1umdJkpe3x5uVSefUWw=;
        b=OLh2e9q5/X92EixZNIdaA95nedI/EETU+IhEa0KXSvk0wximz7fs1lRzkEZ6LdyeZW
         pfL6zWDVgv6f1HtBr92bJfyRclUlZpQjCCb1V79Kea3cv3+kSWeBKzz73EI4v7MHA/2t
         jhQap8wOUO22QxdGysLZi3dpe+NP26DwYMCQvcSAHn862v4sEEbdrVAJOOdTxRViU6Kk
         U3dyUdNFv7K693UBIJSvTRqKKvo4EAiV7I7JfVcP8fcgSTLAygHbJzS9j7Fy2GODcsVp
         fFz2cX4MArNpDdsF8436ZWR14PK8q8RhT4ti35auQNlTPG0m9LQHeeCHU8s1Qg22gY0N
         NXXw==
X-Gm-Message-State: AOAM532xgvYYIzF6uqsykHknbIPVFmoKNYsG5TdmZi2wuJRlZQ7+6c1r
        JABn2ElUHABaVqhMAs2cLGOti3GXmNoJDxat
X-Google-Smtp-Source: ABdhPJz+NBVWf5B3KzWswMgOudeAT8XAVbxjQGQmbvxCC7rBZn1jUEisryq7AK/dIa0paWiz+MU8Iw==
X-Received: by 2002:a65:6415:: with SMTP id a21mr18907701pgv.417.1618079429192;
        Sat, 10 Apr 2021 11:30:29 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m4sm5808890pgu.4.2021.04.10.11.30.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Apr 2021 11:30:28 -0700 (PDT)
Message-ID: <6071eec4.1c69fb81.a0258.ea0b@mx.google.com>
Date:   Sat, 10 Apr 2021 11:30:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.230-14-g6c412903bfb3c
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 121 runs,
 4 regressions (v4.14.230-14-g6c412903bfb3c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 121 runs, 4 regressions (v4.14.230-14-g6c412=
903bfb3c)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.230-14-g6c412903bfb3c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.230-14-g6c412903bfb3c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6c412903bfb3c1ba7dda45c481445d9da85b71b7 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6071ba364636966f1ddac6c8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-14-g6c412903bfb3c/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-14-g6c412903bfb3c/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6071ba364636966f1ddac=
6c9
        failing since 147 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6071ba442c40c378eddac6ce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-14-g6c412903bfb3c/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-14-g6c412903bfb3c/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6071ba442c40c378eddac=
6cf
        failing since 147 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6071ba42f34b8c0931dac6eb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-14-g6c412903bfb3c/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-14-g6c412903bfb3c/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6071ba42f34b8c0931dac=
6ec
        failing since 147 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6071b9e5008dcc9ae1dac6b1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-14-g6c412903bfb3c/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-14-g6c412903bfb3c/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6071b9e5008dcc9ae1dac=
6b2
        failing since 147 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =20
