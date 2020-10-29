Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0562329F8CC
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 00:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725769AbgJ2XDH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 19:03:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbgJ2XDG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Oct 2020 19:03:06 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB2BFC0613CF
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 16:01:51 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id y14so3612936pfp.13
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 16:01:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=DiqgfwwU4+Nk6JwvFfw2O3LxFQJRqmlBPawxJU7tgZg=;
        b=utIBo2IGXt1NdGCB8vyohPcPidLhsQwHL+UDrtpUVhHiXnUghftsnhNxhP0zZx4ppM
         2hpzlqpw19+kxWRJJfQ13p+F+VkErjspbmfxP9yBMDiFCOXKSMqbZGnQ4tC5xI/zGMDz
         kD7NL5SMdIrUGVeiG0m7tFOP3OubpH+hsoPUvBeWpAGUG1vJ/teTiuVTdg+leTSiGiR6
         zurb1xvW8Q+XW3dob/WRxHKr4F9JEzSsM8UEtLQL3kbCjMPMrYwZi8KOmtpjfIk8YTfG
         oQpse50f+OtHbRlQT+cpprfi0Whhe9JHlRstkw1rMp/lrytgYGv6hRJeO7Kuyagvt5mI
         ERcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=DiqgfwwU4+Nk6JwvFfw2O3LxFQJRqmlBPawxJU7tgZg=;
        b=n8I7Rh9utMUsurpydDogo9TFdN9QCPCe4slNaCifGMR1poKXBdR/w6eSmrU44hvu+c
         QAUkek9bNyS462gQ+Dmq9Bs/1FsYOc1XwIZwQUZTXOg7g3S+YI2MOPmCfYDlJGYEDR+0
         ThOSf/cj/vjg80CnjhE2f5sE0sSrn1UCT5jNxKuJpCX53xlWEi2d7yp45ZV/j6a7RCVY
         VirsODJrlrLL2N5s2+QxRZFUh6GJI8HiGt/r4xqa24JoSM00T7W191U+dSdIHsYzPtuM
         mKK7qs9jSwvHBjVVhK0JGjAzMJOsifjR9c35GUVnZQPiVzEjYjaCvrD1Mpsn+kidsnR/
         wSZQ==
X-Gm-Message-State: AOAM531o/n7XvdnoCwBB+Ti905wqMMK/vD8UaOZ8NYcU4lMmbfXhWCiN
        UciC2CXcn0dNTSdBP9LToW8vQeS3cJZsYw==
X-Google-Smtp-Source: ABdhPJy6GsL/tK6GSt7T35j5Wl1KKZ6Oh/Gxk/H6SRf++qU0kO6MyKhl4ei0cZO9lDw7rHluKThVYQ==
X-Received: by 2002:a63:5f05:: with SMTP id t5mr5823863pgb.172.1604012510803;
        Thu, 29 Oct 2020 16:01:50 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t11sm874869pjs.8.2020.10.29.16.01.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 16:01:50 -0700 (PDT)
Message-ID: <5f9b49de.1c69fb81.b5f6d.2453@mx.google.com>
Date:   Thu, 29 Oct 2020 16:01:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.203-2-g4eb6bac3af5a
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 167 runs,
 3 regressions (v4.14.203-2-g4eb6bac3af5a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 167 runs, 3 regressions (v4.14.203-2-g4eb6ba=
c3af5a)

Regressions Summary
-------------------

platform         | arch   | lab           | compiler | defconfig           =
| regressions
-----------------+--------+---------------+----------+---------------------=
+------------
panda            | arm    | lab-collabora | gcc-8    | omap2plus_defconfig =
| 1          =

qemu_x86_64      | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig    =
| 1          =

qemu_x86_64-uefi | x86_64 | lab-broonie   | gcc-8    | x86_64_defconfig    =
| 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.203-2-g4eb6bac3af5a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.203-2-g4eb6bac3af5a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4eb6bac3af5a84befa2ffd9bceddfcfaa0bd35b5 =



Test Regressions
---------------- =



platform         | arch   | lab           | compiler | defconfig           =
| regressions
-----------------+--------+---------------+----------+---------------------=
+------------
panda            | arm    | lab-collabora | gcc-8    | omap2plus_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/5f9b13106a0ffdef5e38103b

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.203=
-2-g4eb6bac3af5a/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.203=
-2-g4eb6bac3af5a/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f9b13106a0ffde=
f5e381042
        new failure (last pass: v4.14.202-192-ge89d89c342f6)
        2 lines =

 =



platform         | arch   | lab           | compiler | defconfig           =
| regressions
-----------------+--------+---------------+----------+---------------------=
+------------
qemu_x86_64      | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig    =
| 1          =


  Details:     https://kernelci.org/test/plan/id/5f9b134a9210427dc4381045

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.203=
-2-g4eb6bac3af5a/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x=
86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.203=
-2-g4eb6bac3af5a/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x=
86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9b134a9210427dc4381=
046
        new failure (last pass: v4.14.202-192-ge89d89c342f6) =

 =



platform         | arch   | lab           | compiler | defconfig           =
| regressions
-----------------+--------+---------------+----------+---------------------=
+------------
qemu_x86_64-uefi | x86_64 | lab-broonie   | gcc-8    | x86_64_defconfig    =
| 1          =


  Details:     https://kernelci.org/test/plan/id/5f9b133f9210427dc438103d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.203=
-2-g4eb6bac3af5a/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x8=
6_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.203=
-2-g4eb6bac3af5a/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x8=
6_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9b133f9210427dc4381=
03e
        new failure (last pass: v4.14.202-192-ge89d89c342f6) =

 =20
