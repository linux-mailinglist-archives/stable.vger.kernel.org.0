Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E317A3112CF
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 21:53:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232984AbhBETJB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 14:09:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233489AbhBETIw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Feb 2021 14:08:52 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E0E8C061794
        for <stable@vger.kernel.org>; Fri,  5 Feb 2021 12:49:55 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id cl8so4293651pjb.0
        for <stable@vger.kernel.org>; Fri, 05 Feb 2021 12:49:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BZa3x2D+BqLs69ptCLtc0iXTq35NydrhOqGkEosW3GE=;
        b=odgHuSAQeRjnRaN3tOAbBB9G9Q+M9Av5WRn1XT5hujOmxMWwKbfYDlt/NUearhi6C+
         4li9eqxdE82IJgPZ0Pog57Ssi6UgTpCma9EIJKvwCGrNjs2g/vnzXSUx/wPCLfmUoxKm
         5+/NfdEBFFY/Sa+A/9F7gMGUo7mtvVGjrYXdMEpNjdT8Aia4CxEPfG6uPWC0jZ/5zXmh
         swkh5rBQnYqJpyRz1+G2x1iPjvsMq/0jdWPvKAB+xjJtasn0vicUyL/Hgz3AxDsxvZy1
         Zd24u6DOOITnBAl5h04cPo8Qckddo6A4FYGn+5C+hXYWlzoFTveh8Jzbllw1ZP6I+JDI
         JIUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BZa3x2D+BqLs69ptCLtc0iXTq35NydrhOqGkEosW3GE=;
        b=eOR0Agh+lRqph+XSbM03ZwRplDlUrZjCXzxL9pLsM9Sjaw5HYdmvs5w21z8BkysluC
         kyRYwjQh08s4ufreZ9Rh1a9sug73PK8owio33sW2t6Z0PRS23qACsNGOpehMvNAf6LB/
         xbVlnO5jNEXl7RGi3W2lXNd+h6rL9o6w2sKupOWrb8CZ4Bi66m8za+vlqBSFMY4h8U7R
         wNX2x+E4SKuCk/F8yfJAhdR2EgJdg5yBNDaENUNGTluyibMqjE0/GEOQAh5vsi2iR/hy
         XKXeUjWwg/tCJ92MPIYJ94ChL5G46DxLqn3H/PPayNe1hgT9hoQdymzSk6n46rz6uuMG
         Cc3Q==
X-Gm-Message-State: AOAM5324vWiBEEzW9JVtekmhdx/loPZ/NHmGqtEbY8uctXl/FCnkOnQ4
        qyA8TSU7Ty32tihf+QJnhcAnKp1c0Mk+oQ==
X-Google-Smtp-Source: ABdhPJzTW72GiMiH4Q39GF/fRsT3QIrGINx47KP1EP5osQXBWH7hYO8YXZSWSKlak/Rb9xxMePQxiQ==
X-Received: by 2002:a17:903:228a:b029:da:d645:ab58 with SMTP id b10-20020a170903228ab02900dad645ab58mr5816416plh.25.1612558194305;
        Fri, 05 Feb 2021 12:49:54 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e3sm10705767pgs.60.2021.02.05.12.49.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 12:49:53 -0800 (PST)
Message-ID: <601daf71.1c69fb81.71551.7649@mx.google.com>
Date:   Fri, 05 Feb 2021 12:49:53 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.256-17-g135b2ff75c04
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 98 runs,
 5 regressions (v4.9.256-17-g135b2ff75c04)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 98 runs, 5 regressions (v4.9.256-17-g135b2ff7=
5c04)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.256-17-g135b2ff75c04/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.256-17-g135b2ff75c04
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      135b2ff75c046c9f2fb5b40b0b8277bf757ae6b2 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/601d7e7397a48463023abebd

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.256-1=
7-g135b2ff75c04/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.256-1=
7-g135b2ff75c04/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/601d7e7397a4846=
3023abec4
        new failure (last pass: v4.9.255-17-gd2af09dda691)
        2 lines

    2021-02-05 17:20:47.688000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/116
    2021-02-05 17:20:47.698000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-02-05 17:20:47.713000+00:00  [   20.626098] <LAVA_SIGNAL_TESTCASE =
TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/601d7b8c6f304266863abe67

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.256-1=
7-g135b2ff75c04/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.256-1=
7-g135b2ff75c04/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d7b8c6f304266863ab=
e68
        failing since 83 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/601d7dfd3b13b6934c3abe7b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.256-1=
7-g135b2ff75c04/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.256-1=
7-g135b2ff75c04/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d7dfd3b13b6934c3ab=
e7c
        failing since 83 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/601d7b9f364c6da5423abe7b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.256-1=
7-g135b2ff75c04/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.256-1=
7-g135b2ff75c04/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d7b9f364c6da5423ab=
e7c
        failing since 83 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/601d7b324ec4bf829e3abe71

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.256-1=
7-g135b2ff75c04/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.256-1=
7-g135b2ff75c04/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d7b324ec4bf829e3ab=
e72
        failing since 83 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =20
