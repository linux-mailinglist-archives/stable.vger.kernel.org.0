Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1322F332F53
	for <lists+stable@lfdr.de>; Tue,  9 Mar 2021 20:53:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbhCITw4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Mar 2021 14:52:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230431AbhCITwg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Mar 2021 14:52:36 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6B00C06174A
        for <stable@vger.kernel.org>; Tue,  9 Mar 2021 11:52:35 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id w34so8456017pga.8
        for <stable@vger.kernel.org>; Tue, 09 Mar 2021 11:52:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QBF7BTxKvJWwnvrxjtKuuIXbP3RCVoqgUdojskbBY+0=;
        b=FO0WO1QyYkZyHF1YAcL/M2jjgJ3XzYlzpTQlADKv2fUXIghfytX026MgP5kEgr9JyD
         nRhDYP8GYL0hS48/TgRJdQ6e4e+h4cSJ1+lEPLEz1I4hcaUOe/gta0ZkNWnEcHoMBXFG
         11o2xvGxMq4TM1HyzLkenqanNUfbRxZgAD4fzeDJ6vTmyPQkI64L1U2CdQlEbK0/V7zI
         6TigS8WAAb4e+vKluodLaU8aUdcMogvBHgDt2FSpfT8FLfN7vjAfujZYqmyYOU1u4tcj
         BZfoRIzHvXDCUIymq6E94E+L0mHXO7GmOiLrmusCMOiqcwIK8kkcxJyg6xDHV99UL7OZ
         W1ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QBF7BTxKvJWwnvrxjtKuuIXbP3RCVoqgUdojskbBY+0=;
        b=GE28V0UguQdIint8Z5wKwz7vJXJ99k/LsEAOkmpzJlbBsx92iTbsCVlNTScIhmMz0c
         n4F/yqH9aktNu7v81u2017NtjAAyC01TFhWVG4ovkbsEcihY5bIjMe8TfoouJUJdPFTI
         1AdQINLo9QDhigRcFEqdNqXU3Pwqnkp3dsUpM2xK5hxZGfKYHG3XCR0/5iAl7b01x28g
         Ea1pY5ouLgJDaxy5mY+vhDUjRN/7Pwfr6PLnIILgoextk5xQo8VFVjCFNzWHywqVsf38
         6Tjy13os6Lb5ASgdQesxXs/g3d3x0O0NRqT7L0Eh1V/z6L6dC5uNC7I6tZcZHl/7Fvgb
         a8SQ==
X-Gm-Message-State: AOAM531p5w5RUbLWTnDLl28lQEwNgViL89NrXnS2d39rNW2NtH4eT/zX
        IlUn5kU0IB3z14J4iw0tG4XMQrKeH4PI3Xp8
X-Google-Smtp-Source: ABdhPJwPtrt+BsPgYpJc+t8zuc4GUb0g6efCECX9wcx8Wg4zG3JNGOJ4bsSeoKSXvWmjl51caBiWQw==
X-Received: by 2002:a65:5843:: with SMTP id s3mr26695338pgr.425.1615319555193;
        Tue, 09 Mar 2021 11:52:35 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j125sm14873297pfd.27.2021.03.09.11.52.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Mar 2021 11:52:34 -0800 (PST)
Message-ID: <6047d202.1c69fb81.d8d0.4e68@mx.google.com>
Date:   Tue, 09 Mar 2021 11:52:34 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.224-6-g893f1fb0db77b
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 97 runs,
 4 regressions (v4.14.224-6-g893f1fb0db77b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 97 runs, 4 regressions (v4.14.224-6-g893f1fb=
0db77b)

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
nel/v4.14.224-6-g893f1fb0db77b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.224-6-g893f1fb0db77b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      893f1fb0db77bcd9812f755951c252b85f126e6c =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60479e7c9ad430720aaddcba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.224=
-6-g893f1fb0db77b/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.224=
-6-g893f1fb0db77b/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60479e7c9ad430720aadd=
cbb
        failing since 115 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60479e7bbf5b36a34eaddcbe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.224=
-6-g893f1fb0db77b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.224=
-6-g893f1fb0db77b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60479e7bbf5b36a34eadd=
cbf
        failing since 115 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60479e15fd3761415eaddd1c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.224=
-6-g893f1fb0db77b/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.224=
-6-g893f1fb0db77b/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60479e15fd3761415eadd=
d1d
        failing since 115 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6047a56f6a47c9b28daddcc5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.224=
-6-g893f1fb0db77b/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.224=
-6-g893f1fb0db77b/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6047a56f6a47c9b28dadd=
cc6
        failing since 115 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =20
