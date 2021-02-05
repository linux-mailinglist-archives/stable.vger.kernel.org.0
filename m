Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAD61310AA3
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 12:52:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231318AbhBELuv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 06:50:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbhBELsm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Feb 2021 06:48:42 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BAE8C06178B
        for <stable@vger.kernel.org>; Fri,  5 Feb 2021 03:48:02 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id z9so3632544pjl.5
        for <stable@vger.kernel.org>; Fri, 05 Feb 2021 03:48:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zVu2+5WswYit9UUgrr8Hz7GCB8T0W0PXkd6H/uP9KYM=;
        b=ExVVrhDjLBbmIAqsmQfKpl+Yn7z5DbwRlPNkSjh4cRaNvm4I6/5vn5aZ/u11BpCk/O
         myNHY8xh+tm1tCMn0nefzy4opFQOco8V4iWB46lKGpT1XeMWRi64e61KJPjONf4g+GGR
         9mipTmOvyzNw4308jPat7/SelWyatT3HIC1HEuZST7p2beOHcazI3uDStq6nRRf95m6m
         drnpsbygirbCExoxd5BaVH4Kvy0GX16DyZCb1FXPys89uCA5sX1HwO+AAR7THdIaXaPN
         ebs98CqpUSsmSClwWGVje0HHZipz31sSLhRIfeRjrjcWkZi2i9/Y4rCFediptY0gxaoj
         SwIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zVu2+5WswYit9UUgrr8Hz7GCB8T0W0PXkd6H/uP9KYM=;
        b=HUWyr9Nb3mNCHuOBdmh4mHH2bHhX+HGlMmJDoSD6G+WCmU8qYNQWVoIXhgNhJiHqQx
         kGUZuTCCYnOUoPxeF0uGZ9dWnUgdmUzqPWDOtkZ8T4Q4k9YziD1ReNjgmNSj7Lxe+qoo
         kOO7asZ/gfTnQGR2/h4DoZUm9WEykzYTVNSeKmoyvqAr43wi79rLV1AT9rNC1F42y0KT
         1BftGI1Td5y0BRUiNpN9JPTLdNrJZ1zzkii2GnnYdcqOtrU7CowFefYNgUTMLDcTyGUJ
         3jTXsguL+rcj2CSQs9WTmsRB+g9DmsxTJmNTyg/Ennqsda6fX7ZImadbOmtMESz3kKQY
         SD0g==
X-Gm-Message-State: AOAM531uqgOMfs2V1zzsujbKO+AqSlu8bS1QuB7jveJg8Upk2UjOHmNj
        +/0iHnue0gtQfaWQJ/BDn6Pbe+VJGzj6cFLO
X-Google-Smtp-Source: ABdhPJzw5spq4dtN4HLK6eJXIZZMq6AVlKmjW05nKMwDXeHqk5DiaZUslJXmtu5gF3qlJSt4eNCJHQ==
X-Received: by 2002:a17:902:c24b:b029:e1:8c46:f876 with SMTP id 11-20020a170902c24bb02900e18c46f876mr3777521plg.15.1612525681114;
        Fri, 05 Feb 2021 03:48:01 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s21sm9818944pga.12.2021.02.05.03.48.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 03:48:00 -0800 (PST)
Message-ID: <601d3070.1c69fb81.b8485.4f8f@mx.google.com>
Date:   Fri, 05 Feb 2021 03:48:00 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.95-8-g0a2f09bafabe0
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 172 runs,
 5 regressions (v5.4.95-8-g0a2f09bafabe0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 172 runs, 5 regressions (v5.4.95-8-g0a2f09baf=
abe0)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.95-8-g0a2f09bafabe0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.95-8-g0a2f09bafabe0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0a2f09bafabe0e92df1117854c23dc83e915fb1e =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/601cfde88e2f6be77d3abe95

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.95-8-=
g0a2f09bafabe0/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.95-8-=
g0a2f09bafabe0/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601cfde88e2f6be77d3ab=
e96
        failing since 83 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/601d00a5cb756488b43abe87

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.95-8-=
g0a2f09bafabe0/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.95-8-=
g0a2f09bafabe0/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d00a5cb756488b43ab=
e88
        failing since 83 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/601cfdf38b476be8ca3abe76

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.95-8-=
g0a2f09bafabe0/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.95-8-=
g0a2f09bafabe0/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601cfdf38b476be8ca3ab=
e77
        failing since 83 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/601d054aa8805315e33abe86

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.95-8-=
g0a2f09bafabe0/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.95-8-=
g0a2f09bafabe0/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d054aa8805315e33ab=
e87
        failing since 83 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/601cfdb35cd6bcb1be3abe77

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.95-8-=
g0a2f09bafabe0/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.95-8-=
g0a2f09bafabe0/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601cfdb35cd6bcb1be3ab=
e78
        failing since 83 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =20
