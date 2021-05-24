Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AEEB38E1E2
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 09:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232276AbhEXHmZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 03:42:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232266AbhEXHmZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 May 2021 03:42:25 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA847C061574
        for <stable@vger.kernel.org>; Mon, 24 May 2021 00:40:56 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id g18so18489220pfr.2
        for <stable@vger.kernel.org>; Mon, 24 May 2021 00:40:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4iz7gOI6ynS8nXYDlB8wtiz99k3qKoea0SbXIu8XpVo=;
        b=QHySbfVgPIJTabi0w9CEjWQgc/LkxDFTXufjjkoiUEbDJVTseWzaeYBqkBPOSiiq/7
         1Xl8DPYDdFXbIWHZW/aYMWi5Wdifhc9o2fIdb45q9va43v3BDsBN4oBIVedfyqKFsSLL
         z4WXqb5s37rNqzqDroFvJydAOrTF8NrGdu0Jw9ZH67U6AEhWZrgKOx2MOfXaEmi4I8Kx
         57TjLgnbeEHZsAqFrLlP5JekvufyN3U+SMfOM4uXCziG7+qMF0tFXTkYEC1UQ0Ki757u
         hk4uEIcZj02gNoxxHyj+1LPPniGqrMdH+RPYyi5Y6IxBcr3K0+Myr8QvnP0QxDtrwmaf
         fx9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4iz7gOI6ynS8nXYDlB8wtiz99k3qKoea0SbXIu8XpVo=;
        b=NsDtbvIifOrhaQpcOQ5Dq8j9F8YNaXbn6Se//dJRj3i9RoDKeeiU2cO6PYhVjk5U8P
         83zoXb6+Zl0j5QNa67sCRC2sRz/vsWZ1OWUtKq8Mi+fJiu1+yd6hJI2pzn4ucAY8/Yf5
         U7/4ub/xaUZNqnW0beWKJ/wMOYb/q4Y/jzq20dDgH3Zje1QQGMi+USCXd/gXrBQwPLKR
         WbOINFu2nIaWnuvZqlK0JkG3ugYOVlcX/MWoU2pZumtyM2NEwSqklXJUWaNuJYB0ofiZ
         zZ4N+BgsNRfcuyrGv7ZKIGw8HzFYOOCWMA0iC+nPTT1bYMiUNeIT2nrr6Z/YXHFw0jsD
         NH7A==
X-Gm-Message-State: AOAM532Yc7+iQdTkuLpZfT9FKds1TBQEOExPCx4D3GCVlaA3BBSwZonq
        F/uTJl4H02ppm+zs6IgKm2/65nzu6otkEdAD
X-Google-Smtp-Source: ABdhPJyYiHlqPhdOF+Q+wvRC7rPMO2Wljoci2SaoheH9coM1Tt380Q5Fmx4fL2pqe6bhzs3YUZbieA==
X-Received: by 2002:a62:1c0c:0:b029:2b7:6dd2:adb3 with SMTP id c12-20020a621c0c0000b02902b76dd2adb3mr23139142pfc.44.1621842056074;
        Mon, 24 May 2021 00:40:56 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a9sm10292435pfl.57.2021.05.24.00.40.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 00:40:55 -0700 (PDT)
Message-ID: <60ab5887.1c69fb81.b40f0.1e40@mx.google.com>
Date:   Mon, 24 May 2021 00:40:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.232-327-g2fbe9738ee01
X-Kernelci-Branch: queue/4.14
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 101 runs,
 4 regressions (v4.14.232-327-g2fbe9738ee01)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 101 runs, 4 regressions (v4.14.232-327-g2fbe=
9738ee01)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.232-327-g2fbe9738ee01/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.232-327-g2fbe9738ee01
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2fbe9738ee015a69aaace080d7c2946a6ff1bdbb =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ab258acda7c6cd85b3af97

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-327-g2fbe9738ee01/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-327-g2fbe9738ee01/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ab258acda7c6cd85b3a=
f98
        failing since 191 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ab25862406b3c139b3afb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-327-g2fbe9738ee01/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-327-g2fbe9738ee01/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ab25862406b3c139b3a=
fba
        failing since 191 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ab2ab4a3bfc858e8b3af98

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-327-g2fbe9738ee01/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-327-g2fbe9738ee01/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ab2ab4a3bfc858e8b3a=
f99
        failing since 191 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ab2536b84a900c91b3afb8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-327-g2fbe9738ee01/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-327-g2fbe9738ee01/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ab2536b84a900c91b3a=
fb9
        failing since 191 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =20
