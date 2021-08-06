Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E2FD3E21EC
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 04:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbhHFC4L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Aug 2021 22:56:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbhHFC4L (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Aug 2021 22:56:11 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74D00C061798
        for <stable@vger.kernel.org>; Thu,  5 Aug 2021 19:55:56 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id a8so13791785pjk.4
        for <stable@vger.kernel.org>; Thu, 05 Aug 2021 19:55:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RnUon7cwiSujPzfpJzQSavbL2mBmUTVm3wsABU1YsHw=;
        b=cyhuSNf502ifN5dc9IyTWLwg/7Irv5Ke2O46DvPgYbqE0PRlohiGXNu11rHcnUK5Y6
         DSsF1HDUQsLs4TVPfD2ovTp3cQrYqfhPuNCV42nB3IGfRr1gE2vH4mr9Wq0BmEO57Bzu
         cjtHDJJf9jS8KMWQiSb/joRlObakZ+FWVN0L57dnvbkK2V5e4xf3KmTxriydSd/oZGo9
         20KoWvLNkRexbfIj4U2PPcY4e7WgSGePgM/rlW3adfqnGismBbchKu75hU/VeqBV0Ta/
         X1091l7WXBEWSBNoUUaJBe/TRcNzfhPDWHw6nSd80odDG10Ys7PLi4yYR10ftEQkYKdM
         AHAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RnUon7cwiSujPzfpJzQSavbL2mBmUTVm3wsABU1YsHw=;
        b=owDmT6icOFSdoiaGx+noaJ0rQiLjGLglIF7nYwv5/Hst3L46IudK47K9nfjBguzfRJ
         lXHEc8QvBrNB1JXgiDUlw1xrUrJb3XhX4OJk5B3d1b19qdKv/sKz6283VIb5/nuv9B95
         0K/6CtVf6mLpRKcvDdP5eD0FDypBBumgKA7wv3johkC+28zs0ksPwgBjjbGJy7/DXEJP
         IjBsDJ6mgemFAf7QXOD3mDSh6nGasmwfC3WFoTvTddR37bbATc2COapYp5O+8DwsWuS/
         TYqsNhEPnLg7KZlSljmAhfTHW0zowPmEwE4BlPN/4ZlTLDGlmwIzzLZ+hxOnGiOp25T5
         tSmQ==
X-Gm-Message-State: AOAM530ptxE2d4Gf/EjkXi53SR0RFz7mHbCwukUwpUwnw7FL0uDu10R2
        EsWHsUpDSG6Yj3cvDE6VYnRaFnvvFcwDXwf4
X-Google-Smtp-Source: ABdhPJzcST7G4ymN0gOBjEMDh7zAsoNK5G0WG0vrDuunm6wUFUxmvQz2MjCgOpmuve7dhqjtN4d6NA==
X-Received: by 2002:a17:902:76cc:b029:12b:ecc5:c176 with SMTP id j12-20020a17090276ccb029012becc5c176mr6747854plt.42.1628218555569;
        Thu, 05 Aug 2021 19:55:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q21sm9282124pgk.71.2021.08.05.19.55.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 19:55:54 -0700 (PDT)
Message-ID: <610ca4ba.1c69fb81.600bf.d870@mx.google.com>
Date:   Thu, 05 Aug 2021 19:55:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.201-9-gca95c1892f35
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 126 runs,
 3 regressions (v4.19.201-9-gca95c1892f35)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 126 runs, 3 regressions (v4.19.201-9-gca95c1=
892f35)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.201-9-gca95c1892f35/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.201-9-gca95c1892f35
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ca95c1892f355c5103c5acbe40dc1e46639cf081 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/610c68ba518f492c06b1367e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.201=
-9-gca95c1892f35/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.201=
-9-gca95c1892f35/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610c68ba518f492c06b13=
67f
        failing since 265 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/610c68d9fdd1b592c1b1367a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.201=
-9-gca95c1892f35/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.201=
-9-gca95c1892f35/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610c68d9fdd1b592c1b13=
67b
        failing since 265 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/610c6874fcfb8b2f26b1368d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.201=
-9-gca95c1892f35/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.201=
-9-gca95c1892f35/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610c6874fcfb8b2f26b13=
68e
        failing since 265 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
