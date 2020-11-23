Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 558D42C0CA3
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 15:14:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730032AbgKWN6x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:58:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729111AbgKWN6x (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Nov 2020 08:58:53 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1714C0613CF
        for <stable@vger.kernel.org>; Mon, 23 Nov 2020 05:58:52 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id f17so5798613pge.6
        for <stable@vger.kernel.org>; Mon, 23 Nov 2020 05:58:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=iR9+afcb3+j0rBQBzRYXuQHaz1updDTZMzwIwCHIqjQ=;
        b=dvJbdhHdw/Lj0LCIrp4xxniVanQuh4iVgMBfxdsfQTjVKgKzrY3REEESIYib2f5pJG
         wBzg+6z607ZLoP39yrpF+vJmBh1AYYQ3P9XEP1rWewewmGU/40qNWvPHC33ZVi0VVh9b
         CSlmMldfprQQtqumYCrR2wFCaQecSPYMmBdQXPiZIdlh1wbLyrC7CwZmHSCq3BxDCCH0
         i7ZsZWQxeIyq3eM+xmCBBb4NzBNnbW3HNAoQtxU5lOlX+NN4XARRKnFM4xo10T4+DoNT
         +NwQpmb4Z64HoiZFHxusBdpLxsCP8O0TEbvGmzuwO6rFvICvW5P9KrtrZhMDXWeUGigu
         oi6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=iR9+afcb3+j0rBQBzRYXuQHaz1updDTZMzwIwCHIqjQ=;
        b=d2IdBfM3dJnNnCQOoHJ/8S60AxCogD0UK16F4wCPtUtIFzRkAd6YaxUGgkZQpTLVw6
         scuAUfbuQAfQoXaXBljolmZbxYm0SBowU8ise7qoc+xyI2GO/nLmO9psMR9iXvjJlh7D
         2mlOK/WeqToEVuoyL4wUI0CYfK4PZ1NdHcxy2KDpweeg4HCrvKaGC8pLOk0UkzJzFRuW
         tmPSTqYI84yqT/vlonl0vxvc98FIfsub2LmoFIwPQsv6VPgRgsnCHMNvyXlGlYWsQMgY
         hdMzS1/vpRjgQ4rO1yHQB/G2fo9CPqvn4NEJJ+WrTPL9LilRuGYlAnSaDsVL8Y+tpZnJ
         IdiQ==
X-Gm-Message-State: AOAM530BzK+QkbRBJfbsp95DG4UniIdHk/J1VWTu6BAodEEJDGTVrnW/
        qpd4dD2f+iDIowftVmdxf43LcaAWensClw==
X-Google-Smtp-Source: ABdhPJxJGu+3CGNSmp9FrNnfEWww8o+KnpFyQC55EZ/iU7MEmwXw+orVNHQLbHDg73NdEmE0Dj0i3Q==
X-Received: by 2002:a63:d1b:: with SMTP id c27mr28147341pgl.25.1606139932035;
        Mon, 23 Nov 2020 05:58:52 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v191sm11968300pfc.19.2020.11.23.05.58.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2020 05:58:51 -0800 (PST)
Message-ID: <5fbbc01b.1c69fb81.ffe12.9f92@mx.google.com>
Date:   Mon, 23 Nov 2020 05:58:51 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.208-53-g7564ff33f2d0
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 111 runs,
 3 regressions (v4.14.208-53-g7564ff33f2d0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 111 runs, 3 regressions (v4.14.208-53-g7564f=
f33f2d0)

Regressions Summary
-------------------

platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.208-53-g7564ff33f2d0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.208-53-g7564ff33f2d0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7564ff33f2d01e45b95ab21c7c5e2efc4d1880c1 =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbb8a9fdbea4d55d1d8d919

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.208=
-53-g7564ff33f2d0/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.208=
-53-g7564ff33f2d0/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbb8a9fdbea4d55d1d8d=
91a
        failing since 9 days (last pass: v4.14.206-21-g787a7a3ca16c, first =
fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbb8aab164e8e6c24d8d924

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.208=
-53-g7564ff33f2d0/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.208=
-53-g7564ff33f2d0/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbb8aab164e8e6c24d8d=
925
        failing since 9 days (last pass: v4.14.206-21-g787a7a3ca16c, first =
fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbb8aa12cc11aec2dd8d924

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.208=
-53-g7564ff33f2d0/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.208=
-53-g7564ff33f2d0/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbb8aa12cc11aec2dd8d=
925
        failing since 9 days (last pass: v4.14.206-21-g787a7a3ca16c, first =
fail: v4.14.206-22-ga949bf40fb01) =

 =20
