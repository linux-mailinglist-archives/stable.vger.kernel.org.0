Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0594032ED5A
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 15:44:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbhCEOnu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 09:43:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbhCEOnk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Mar 2021 09:43:40 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1326BC061574
        for <stable@vger.kernel.org>; Fri,  5 Mar 2021 06:43:40 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id n10so1514451pgl.10
        for <stable@vger.kernel.org>; Fri, 05 Mar 2021 06:43:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WS6mLlzjGe3uvo8uqtSQDy3p8zlB7Ce1M4PfA4/xEdE=;
        b=r8ehV1twhBqNxU/WCho8cJDOKZrnu5j8myfF4ywAnFugKDJGIcTG8iis47JAgV5C8E
         urr/TGgsmqHVs0vnxtWv+uZCOL8qYC9mkz12HgNdbgif6uMwZpok0vpxUNdetppDTYeT
         dJwa9gweuaRRMNK3yohkjk51qJlM6bvh9Q3mYhX7Mx21Vy2b4v0p3gqeL06ej/k98BuQ
         6YkJQS1qJPRK9dGvXDNHq81V3P/nPBc0Qv7S7P01k/SXNasWU/eZw5BRDxajM5SSMo1c
         l2jVHtv3IOsAlIgsd210zpkukoyOwRR91xzOhM5Q/9k1NbOnoreppHk7tavmeOHO+CkA
         iVyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WS6mLlzjGe3uvo8uqtSQDy3p8zlB7Ce1M4PfA4/xEdE=;
        b=YUjWjzSVTnSH6TCkmfc3Aw6BPrNY1jjfgcFRBZbEdtd4P3BR6dtGSL4kLJPdAaalOy
         pjrRt4Ldj8AZPxqSgnflDgGG2ENS9FOgayiyTGyVNujvJcP63nT44WyCBDAFm1xdiRBb
         /581Q6gXBVY/EV0AbcOrZD58j6ud8lo1u/mJsksEo4x9FoGn+60ugum+Ypnyhoqwr7s/
         U0hmKy2bcd6FEEv96OxysxP4RCL/BbtESxkEcNRuu44EF6LIE+KGPnPcPuLrRtvb1mau
         5LqCJwgAiVINqj3y6bJ3otrczYE9uztxNUOT3jxjCyMtCbeaZgvpNIEPIkLBm3lVddri
         JxXw==
X-Gm-Message-State: AOAM532QSwXM7Dt/qYDDVctR0/iJKGLxY6E0M2Ave7cfurGpyI2wGKLA
        R3cmoiUwA8d3VT0osOdGB0b05sOx+AXlFUiQ
X-Google-Smtp-Source: ABdhPJwnTNRkZk03FkLCvYHq7KebdgqVZcfBAtvrZcLt0yEUmm4Hvkksv1Wk/HCP9yTNhNveo14vGQ==
X-Received: by 2002:a62:1896:0:b029:197:491c:be38 with SMTP id 144-20020a6218960000b0290197491cbe38mr9224013pfy.15.1614955419414;
        Fri, 05 Mar 2021 06:43:39 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p20sm2774764pgb.62.2021.03.05.06.43.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 06:43:39 -0800 (PST)
Message-ID: <6042439b.1c69fb81.fdac.6dfc@mx.google.com>
Date:   Fri, 05 Mar 2021 06:43:39 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.102-68-gba82a09ddb3f4
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 108 runs,
 3 regressions (v5.4.102-68-gba82a09ddb3f4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 108 runs, 3 regressions (v5.4.102-68-gba82a09=
ddb3f4)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.102-68-gba82a09ddb3f4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.102-68-gba82a09ddb3f4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ba82a09ddb3f4a3e0365ca8f63d2a5a4827ae6e1 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6042385ae324adad02addcc0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-6=
8-gba82a09ddb3f4/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-6=
8-gba82a09ddb3f4/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6042385ae324adad02add=
cc1
        failing since 111 days (last pass: v5.4.77-44-gce6b18c3a8969, first=
 fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/604226fbb488af2b77addcbe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-6=
8-gba82a09ddb3f4/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-6=
8-gba82a09ddb3f4/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604226fbb488af2b77add=
cbf
        failing since 111 days (last pass: v5.4.77-44-gce6b18c3a8969, first=
 fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/604219a30b153ed7dfaddcff

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-6=
8-gba82a09ddb3f4/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-6=
8-gba82a09ddb3f4/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604219a30b153ed7dfadd=
d00
        failing since 111 days (last pass: v5.4.77-44-gce6b18c3a8969, first=
 fail: v5.4.77-45-gfd610189f77e1) =

 =20
