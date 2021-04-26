Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A432F36B2DA
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 14:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233277AbhDZMQ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 08:16:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233279AbhDZMQy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Apr 2021 08:16:54 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AEB8C061574
        for <stable@vger.kernel.org>; Mon, 26 Apr 2021 05:16:12 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id lt13so18027705pjb.1
        for <stable@vger.kernel.org>; Mon, 26 Apr 2021 05:16:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=T0jFY87GB5EIl0bxLkyAieQj4vp+5wBbTYlStCYXXWI=;
        b=V7llFYQdC6aVXqEr0L0trjyH6bte3PIJ/fMZbWTZC7srwf9h5k+DxmUzyvbFOn1kBw
         kEmnndQotkdi1kLAg6h4CoJvccETVRqtgVCe5/9a9lPqH+ofa923il6Dv4BNbvqDQOJQ
         jOhl5U5erCJ+awxdPvvFYiZEV3wv6ErWID/q1gJUg+OMIMALc/pP9z/BplFKEW7gttzU
         C54ao0eB/JngFUYTqHnvtgKHRJGXfMqHdPeg712n8y0/QG8+00sMjBVD56komxzo2DEO
         ODTjPwqbvekzjbK96Sk1cUYxPvcQorki7e+91zOALxYhwKcomgm/TPVsfAsw/QOVCXCp
         2RKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=T0jFY87GB5EIl0bxLkyAieQj4vp+5wBbTYlStCYXXWI=;
        b=mWbAOHbikCYTF5LGaIG4mGiHWcqgJUWmd4yshxobEfC2TEnkBq/DKbnElNsUXCj877
         Fo6lDEHzopfb0vkcnb/LArKYR9HXLTZoO59R4i/rTnq4WY5xiiweiQrtS4g02t7Vdpbd
         BUraQM1szdeuf2Lwz3kEyJxHeWm1wafVIuSyltaWl9dFxutqK4bKvvLS3wYuQPpid4p7
         eQZMCzhm0OsN6noqR9gLYjcySfmOvTlF9iwLNnwabrSAyoy6Fa4nB164C9AkB3Z7XruP
         xACCdVSBnf9o4jwbcZyjp7BmT+lqJGJxO9c0T182EnrIlng8DrNrwTtGkV3t2uRZd7L3
         wa2g==
X-Gm-Message-State: AOAM533IKmL8i6n7i0a+qy2vCjapEDDOHcGcftFGu5DlxnKvcoT/F9Qu
        6t67cBolBmnUmOK7d7vUHm/72xePnmhNn6Dl
X-Google-Smtp-Source: ABdhPJz5MGgBEmtKLd+y9lzVaqltqnfqXygWqYYpVTbdPPFALK60jiBi0gVNeD2eWs/n4deiS03P0Q==
X-Received: by 2002:a17:90a:9509:: with SMTP id t9mr22920611pjo.3.1619439371887;
        Mon, 26 Apr 2021 05:16:11 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w124sm10908867pfb.73.2021.04.26.05.16.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 05:16:11 -0700 (PDT)
Message-ID: <6086af0b.1c69fb81.d5ec0.f789@mx.google.com>
Date:   Mon, 26 Apr 2021 05:16:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.231-49-g6cf323809c5a
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 108 runs,
 4 regressions (v4.14.231-49-g6cf323809c5a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 108 runs, 4 regressions (v4.14.231-49-g6cf32=
3809c5a)

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
nel/v4.14.231-49-g6cf323809c5a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.231-49-g6cf323809c5a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6cf323809c5a2b68bfeb5f8a766f1581060c40ed =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60867a6e2344851ce29b77b1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-49-g6cf323809c5a/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-49-g6cf323809c5a/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60867a6e2344851ce29b7=
7b2
        failing since 163 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60867a566caaafedd69b779d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-49-g6cf323809c5a/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-49-g6cf323809c5a/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60867a566caaafedd69b7=
79e
        failing since 163 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60867a9cf5a46c82ad9b77ad

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-49-g6cf323809c5a/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-49-g6cf323809c5a/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60867a9cf5a46c82ad9b7=
7ae
        failing since 163 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60868ef8b80b9ffdda9b779c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-49-g6cf323809c5a/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-49-g6cf323809c5a/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60868ef8b80b9ffdda9b7=
79d
        failing since 163 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =20
