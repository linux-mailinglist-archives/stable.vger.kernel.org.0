Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 654DD32EF0B
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 16:38:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbhCEPhv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 10:37:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbhCEPho (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Mar 2021 10:37:44 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6573EC061574
        for <stable@vger.kernel.org>; Fri,  5 Mar 2021 07:37:44 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id e6so1630115pgk.5
        for <stable@vger.kernel.org>; Fri, 05 Mar 2021 07:37:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/E3+Vz5fgoVedTrNtQroM0PwH+wuib/qYk27PmHyvxY=;
        b=Vj1RMwPpJ+s5ZOrWhyKmabmqSAEgD5YB9MRp1N4lAqXzCW/LDY74YxB/xeo0U/r8aP
         2U650AhzCzT1/vrXEnQMNtt1zO7tvV68zvqe1YkV3x4opqfFIEH9nxIa3hAfyjCi/YpK
         a90qo/Ztxt+kE4o/bxIH2FhH1lcM4hR5rUiBM/TqWKyfTBYppnmElOzabD8bmij0Gs1i
         1amLUlqU+o2NlWVwgOjlh6iJ0i1ryTTvVgzUExUBWyQ0iVxguw0P/wSjByduWpSGnnHI
         hygTyHdhb7rMXzpNfecRy1mXbZHX8fp+6crphAwZmpjqu/JhPNEJQRjKlCkWIZW2o1Gl
         oeKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/E3+Vz5fgoVedTrNtQroM0PwH+wuib/qYk27PmHyvxY=;
        b=rkV56w/grQw5mM/Oxw3TmKZUGtGTfVWuFx0Kuej7b0PcPgrfsNyMRhyczdQezCBYmC
         dXMrwVZRpZzV0qUWde3lKPOFzdZzpLjlkEHFMthTbZ7Cmp3FYgI+HzB4kxKDnJ1eU2Wy
         1ot0tymOqg9iE3jm3gbw0Asz94+j3F4k8cq19Uh9JXci32kfbKU0+e5Iesi5FQWyi5R8
         8qADnm9lz+gcOXzNcwQ/JtHqpChe1uzxxRYtfeftIrbKKAHXi/OYbE9QzV/M076QhZW8
         /AJlgQ/uObdiP6r5ghomXgCkmbATFc3liraPUzc5tjVq5XppG97htYLB/b8SZImGf7Kc
         +7oQ==
X-Gm-Message-State: AOAM531T0278oxzbuV6niJ25c4dICZWssJCOUqwWGjp58bg8lCTTNsag
        lB26X5vyoIbKB5P8rOSRX+obqmeSn7U/i7ex
X-Google-Smtp-Source: ABdhPJw1vd2OqA24UiFqWQUubXa96te1Qz7Y5zOkm/L40BcMmRowiiW3bCB6anA+yMetRrpYruSEug==
X-Received: by 2002:a63:fa02:: with SMTP id y2mr9061996pgh.412.1614958663752;
        Fri, 05 Mar 2021 07:37:43 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z22sm2946308pfa.41.2021.03.05.07.37.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 07:37:43 -0800 (PST)
Message-ID: <60425047.1c69fb81.e5305.7940@mx.google.com>
Date:   Fri, 05 Mar 2021 07:37:43 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.223-39-ga5085a4288227
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 83 runs,
 3 regressions (v4.14.223-39-ga5085a4288227)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 83 runs, 3 regressions (v4.14.223-39-ga5085a=
4288227)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.223-39-ga5085a4288227/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.223-39-ga5085a4288227
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a5085a4288227cd62f7b93cbf69fb3980496a61c =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60423df5db61038847addcb2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.223=
-39-ga5085a4288227/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.223=
-39-ga5085a4288227/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60423df5db61038847add=
cb3
        failing since 111 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6042316e9b5a14e1c5addcb8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.223=
-39-ga5085a4288227/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.223=
-39-ga5085a4288227/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6042316e9b5a14e1c5add=
cb9
        failing since 111 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/604220b522d1da875daddcbc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.223=
-39-ga5085a4288227/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.223=
-39-ga5085a4288227/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604220b522d1da875dadd=
cbd
        failing since 111 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =20
