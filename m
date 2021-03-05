Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A24E32E091
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 05:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbhCEEU1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 23:20:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbhCEEU1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Mar 2021 23:20:27 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B03F6C061574
        for <stable@vger.kernel.org>; Thu,  4 Mar 2021 20:20:26 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id a24so713245plm.11
        for <stable@vger.kernel.org>; Thu, 04 Mar 2021 20:20:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ngBy0ZWs/5r0/84/zUBZGOmqMr2mrl6AHch/To71wX0=;
        b=pcaZ/lo0M2V6CO3lHzssGJcMV7m9X/yrztIuB4sNFBvPt6/Ho39fTPL8EyXeGATD/y
         F/ngYm4gSSa4Itzo+jncYIqGJXaOf/sBFsneGFnB4ZBwDQsQ19FViIaFKUAZbedsgoVN
         WRyZurldk5+ZReLlm0x/bVOkuNWi1599yFVO+LWcaSu6iG/JVGJhQrzJ0d+qYHbol/X7
         qAA3SCprdLwm48ydzz6vwvm6KGXOHkyPxwK7dSgl4MRLhGP05gWGcOJCAKHz79z+Wq8f
         ZuHJ0fJTgBF8+OegEWYNx+URoCnm7di9368Ggir5RlgX630eeM9tshq8XPAsTvlU9ELA
         b6Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ngBy0ZWs/5r0/84/zUBZGOmqMr2mrl6AHch/To71wX0=;
        b=nBBRPSgpbKJjeoJm+6lshun4u4BS3pnYjv5Utkkh7xAvAoclVQ6pGpg9EXWQy/7PO2
         1+3OZ/ac4SmnjZuVmlL6WxWKcBC5AoxcI9ZtWaUG8e34ukj2Bl65zjxM4/BjQRepOvsl
         qSh//VfWmdflrQT0IPrs+0bCmDFeapTPKnsDdeV5pqZJ9NHClid3g12DeSNdEV+XbDh9
         5p6adchxjscChenAUN83UrA4hPudFhfJ1zO8vvOShs1WmhkHZXz8qHNEpvSiSyG/XT3U
         7q0RxuQExRDmSzn+LsDh3XCFxP+CLpi9Jb05qN5uTounsYIdT902ALbD8YIVAGExvXaY
         ac/Q==
X-Gm-Message-State: AOAM530ulEf+Czd43cbVKDU+nEMrjifrUCEJ+2lYB4EEXlZ4P91bl59J
        dDHt/mi8SMktDJC3NsQxeBUbvH6m3R+Rs8DQ
X-Google-Smtp-Source: ABdhPJw4lAwk9srIe5mNxVAIKCaTJ6VytIVompV+qrd8W1ARlbC0njsf6QoeYJkjOSEuKL+Im+VqoQ==
X-Received: by 2002:a17:902:e78e:b029:e4:84c1:51ce with SMTP id cp14-20020a170902e78eb02900e484c151cemr6921271plb.25.1614918025971;
        Thu, 04 Mar 2021 20:20:25 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s1sm679640pjo.36.2021.03.04.20.20.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 20:20:25 -0800 (PST)
Message-ID: <6041b189.1c69fb81.11aec.32e1@mx.google.com>
Date:   Thu, 04 Mar 2021 20:20:25 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.259-22-g6ba0ea81d1fd
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 92 runs,
 5 regressions (v4.9.259-22-g6ba0ea81d1fd)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 92 runs, 5 regressions (v4.9.259-22-g6ba0ea81=
d1fd)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.259-22-g6ba0ea81d1fd/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.259-22-g6ba0ea81d1fd
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6ba0ea81d1fd270d4f1c7575113b4faf3310e5e8 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60417f21466a4a0706addcbb

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.259-2=
2-g6ba0ea81d1fd/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.259-2=
2-g6ba0ea81d1fd/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60417f21466a4a0=
706addcc0
        failing since 0 day (last pass: v4.9.259-22-gef981795155f, first fa=
il: v4.9.259-22-g60dc3d39f4a2)
        2 lines

    2021-03-05 00:45:15.749000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/127
    2021-03-05 00:45:15.759000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6041abdbbb5a98b539addcb3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.259-2=
2-g6ba0ea81d1fd/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.259-2=
2-g6ba0ea81d1fd/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6041abdbbb5a98b539add=
cb4
        failing since 111 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604181f128e8ed70c5addcbe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.259-2=
2-g6ba0ea81d1fd/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.259-2=
2-g6ba0ea81d1fd/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604181f128e8ed70c5add=
cbf
        failing since 111 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60417e72678bae2807addcc6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.259-2=
2-g6ba0ea81d1fd/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.259-2=
2-g6ba0ea81d1fd/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60417e72678bae2807add=
cc7
        failing since 111 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6041846972be5236f5addcc2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.259-2=
2-g6ba0ea81d1fd/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.259-2=
2-g6ba0ea81d1fd/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6041846972be5236f5add=
cc3
        failing since 111 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
