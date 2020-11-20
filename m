Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBC772BA950
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 12:39:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727878AbgKTLij (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 06:38:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727870AbgKTLii (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Nov 2020 06:38:38 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A2EAC0613CF
        for <stable@vger.kernel.org>; Fri, 20 Nov 2020 03:38:38 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id 18so4700755pli.13
        for <stable@vger.kernel.org>; Fri, 20 Nov 2020 03:38:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qoIFEFcWhIEaD3SvwZj+ir/YlklE/YMo5V33iGtCp2o=;
        b=0rkviNvMn17QQGA0aQPb6J0C0CKolr7k/gxGx7J9aISzidUr2v6zUKnB+a7gqE3V9b
         DOoA3VZNY61s8Mw+TmOeqk6N5VTjTcOPgl2SCt3WxhUqazdc2fNxkXFFK3zJAR/N5nxp
         JSwiph6Md+bgvgLJF2TrEfIyhrC4e4/wRZaghzA7xb5NLvMKiA8Myv5PThVOcn8tyPN7
         YLNPC0f8Bfk6c/MRGa8k67Wx7cBZWEk92STPyCHGKxCfjIavZhi9K8IvaA7aDkaA53lH
         YlnDkonCxxKI5CSzyIKwBM1JOjeH6GTnZ7tOaZ+H3ru5KRxdOsInsfn6ZcB+3ZZPJhfd
         r1Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qoIFEFcWhIEaD3SvwZj+ir/YlklE/YMo5V33iGtCp2o=;
        b=kSAXwh1THLTrSrxRRe8ikpxk5UQhFZZEsH6OLJQAnTvDUKhRH0wMA5YX3nEsQweLNW
         8bixDqsdoQ8OsSEHjZqHlmU1IXJRPUkn0BnTwr4+PB667HztgKQeR5g3+LlqzVGlZCkR
         zO7EsTXwS6S3fS67BHfEt+KNCVZMdMDgMYADwP/4FuvMNGZNNKAc1/LDb/f4hAXgvTdB
         ERK1YB18M5OvB5O3NwM4Pv0IsQ/UgKuS4mMnq8ZeN/QBF0bNljOejVwQPbBPjettg/8c
         V7+C4acSWE0YX7tBQoqZ20RmasCFzS7K3VeDsKkjLAK98nzj1CWFA6mGMcrh86hiuz4/
         W5sA==
X-Gm-Message-State: AOAM533ixE2xzaShns+Xwmuj8jodFIPl+lNp93uGKugYIzN5KdZuxoOv
        vbs/HydV67pNRyqCD43x+FoGUt6OrMYsig==
X-Google-Smtp-Source: ABdhPJx6tHrGxEq1fY9JGlb1AzghjBLh6hzdds/OTDksqd3TiXW/jZeSZ7hNORdSysQrvJFL6LTTDQ==
X-Received: by 2002:a17:902:b410:b029:d6:b42c:7af9 with SMTP id x16-20020a170902b410b02900d6b42c7af9mr13293973plr.21.1605872317748;
        Fri, 20 Nov 2020 03:38:37 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id mn21sm3477037pjb.28.2020.11.20.03.38.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 03:38:36 -0800 (PST)
Message-ID: <5fb7aabc.1c69fb81.c5f4a.69aa@mx.google.com>
Date:   Fri, 20 Nov 2020 03:38:36 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.158-7-geea4baa48b58
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 155 runs,
 7 regressions (v4.19.158-7-geea4baa48b58)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 155 runs, 7 regressions (v4.19.158-7-geea4ba=
a48b58)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
beagle-xm            | arm   | lab-baylibre  | gcc-8    | multi_v7_defconfi=
g  | 1          =

meson-gxm-q200       | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 2          =

panda                | arm   | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.158-7-geea4baa48b58/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.158-7-geea4baa48b58
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      eea4baa48b58a7c844f45f0a65b7bbcb0a4d10c6 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
beagle-xm            | arm   | lab-baylibre  | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb77abeb9c71cf412d8d91d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.158=
-7-geea4baa48b58/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.158=
-7-geea4baa48b58/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb77abeb9c71cf412d8d=
91e
        new failure (last pass: v4.19.157-99-g8e0758d3e7f1) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxm-q200       | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 2          =


  Details:     https://kernelci.org/test/plan/id/5fb7758090300b297dd8d909

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.158=
-7-geea4baa48b58/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.158=
-7-geea4baa48b58/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/5fb7758090300b2=
97dd8d90d
        new failure (last pass: v4.19.157-99-g8e0758d3e7f1)
        7 lines

    2020-11-20 07:51:23.386000+00:00  kern  :alert : Mem abort info:
    2020-11-20 07:51:23.386000+00:00  kern  :alert :   ESR =3D 0x86000004
    2020-11-20 07:51:23.427000+00:00  kern  :alert :   Exception class =3D =
IABT (current EL), IL =3D 32 bits
    2020-11-20 07:51:23.428000+00:00  kern  :alert :   SET =3D 0, FnV =3D 0
    2020-11-20 07:51:23.428000+00:00  kern  :alert :   EA =3D 0, S1PTW =3D 0
    2020-11-20 07:51:23.428000+00:00  kern  :alert : [ffdf800008607c38] add=
ress between user and kernel address ranges   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fb7758090300b2=
97dd8d90e
        new failure (last pass: v4.19.157-99-g8e0758d3e7f1)
        3 lines

    2020-11-20 07:51:23.428000+00:00  kern  :emerg : Process find (pid: 150=
6, stack limit =3D 0x(____ptrval____))
    2020-11-20 07:51:23.428000+00:00  kern  :emerg : Code: bad PC value   =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
panda                | arm   | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb77957aab638c128d8d8fd

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.158=
-7-geea4baa48b58/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.158=
-7-geea4baa48b58/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fb77957aab638c=
128d8d902
        failing since 6 days (last pass: v4.19.157-26-gd59f3161b3a0, first =
fail: v4.19.157-27-g5543cc2c41d55)
        2 lines

    2020-11-20 08:07:46.383000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb776b61d893d1f41d8d915

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.158=
-7-geea4baa48b58/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.158=
-7-geea4baa48b58/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb776b61d893d1f41d8d=
916
        failing since 6 days (last pass: v4.19.157-26-gd59f3161b3a0, first =
fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb776ee75317293c4d8d929

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.158=
-7-geea4baa48b58/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.158=
-7-geea4baa48b58/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb776ee75317293c4d8d=
92a
        failing since 6 days (last pass: v4.19.157-26-gd59f3161b3a0, first =
fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb777ab836f9d8376d8d921

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.158=
-7-geea4baa48b58/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.158=
-7-geea4baa48b58/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb777ab836f9d8376d8d=
922
        failing since 6 days (last pass: v4.19.157-26-gd59f3161b3a0, first =
fail: v4.19.157-27-g5543cc2c41d55) =

 =20
