Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CFED3D06DC
	for <lists+stable@lfdr.de>; Wed, 21 Jul 2021 05:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230429AbhGUCUu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 22:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbhGUCUi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Jul 2021 22:20:38 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC96CC061574
        for <stable@vger.kernel.org>; Tue, 20 Jul 2021 20:01:15 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id o201so1173013pfd.1
        for <stable@vger.kernel.org>; Tue, 20 Jul 2021 20:01:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qzRheJ1yd/T051y6G6TL1D1h4cWfihRMTspMAPR++FI=;
        b=sqn8jgdY9dm5X0mZlp9+bfvHtz/uTFpQ57xBohLwV4a4JX1VYaiimz5t7mNst+zJ7e
         /laRn9/TD9IyBqS1stFu0IdsvGXisb1MCCt986Je4GNbeIlLl0if+zRyDG35lqXmmc0y
         qGNFSX8hfzeI9lbnKTvco920diSkk+2mmXr2zppLyJoKJ4L6oFWJEYEN89/qbOpUPI1r
         aa7GKkWeyr7thtI2Gy5cCx9eJQ/a77vfONqswF18BYfOk2BCYsQztkZTIQ8C+0VxDMks
         e8anBGAJMdS76i2Sz8jZwZ7s9RZTS8uGHEdD89/HgXl1yYInSlOJY/KghuYkbn00J676
         2sVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qzRheJ1yd/T051y6G6TL1D1h4cWfihRMTspMAPR++FI=;
        b=aCbSh3YaYpfTXJ7b3dKCcmRqroVQ0KziUqtGMNEe+FAxoihzQ1Sqk0wWVJRgrRNWX9
         X8KaNCzd72+84PWR+9KxjMVu2G9HvXHDLQ3rLOt0axWBDp+HdlofUv65rU5EAdiidXHI
         jZjCEue2MSMA1LT356WfMBiEKQBj1MWVmXWdENOiKGHehpa36pAB7N+osyLb3lFhHPQL
         GGYil9yOphKW4OCIO2u7zvGVra9qui3sdqB48h/JIu2+6XL+tNj4oyZgXJs1OooOWsyD
         3NjhE0HtkxummsOhcbivYwMne6no7VyFbXemtXUuxSbrQ4DI9t3NO4Tlbx+/sZ9EXnL4
         RZsg==
X-Gm-Message-State: AOAM532lEx4uheZi+I+k3+49dVvjVFo1mos8fKWJO8M2+eX0tfLACYYD
        /4tDtVVYHTa8BS0bmP2D2S/uKpS3avt13N+i
X-Google-Smtp-Source: ABdhPJyylGrGlbYA2ymaNSzFm9orYlCYnS11OH5WZjs9wGYOX88IHSqUb4YOEF3OoHcf3VLL/LC8XA==
X-Received: by 2002:aa7:8696:0:b029:32a:75ef:8f6c with SMTP id d22-20020aa786960000b029032a75ef8f6cmr34478122pfo.69.1626836475055;
        Tue, 20 Jul 2021 20:01:15 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a21sm4145824pjq.2.2021.07.20.20.01.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jul 2021 20:01:14 -0700 (PDT)
Message-ID: <60f78dfa.1c69fb81.1f144.e6d1@mx.google.com>
Date:   Tue, 20 Jul 2021 20:01:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.13
X-Kernelci-Kernel: v5.13.3-350-g04f08469f404
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.13 baseline: 148 runs,
 4 regressions (v5.13.3-350-g04f08469f404)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 148 runs, 4 regressions (v5.13.3-350-g04f084=
69f404)

Regressions Summary
-------------------

platform  | arch   | lab          | compiler | defconfig                   =
 | regressions
----------+--------+--------------+----------+-----------------------------=
-+------------
beagle-xm | arm    | lab-baylibre | gcc-8    | multi_v7_defconfig          =
 | 1          =

beagle-xm | arm    | lab-baylibre | gcc-8    | omap2plus_defconfig         =
 | 1          =

d2500cc   | x86_64 | lab-clabbe   | gcc-8    | x86_64_defconfig            =
 | 1          =

d2500cc   | x86_64 | lab-clabbe   | gcc-8    | x86_64_defcon...6-chromebook=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.3-350-g04f08469f404/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.3-350-g04f08469f404
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      04f08469f4043127c84dd4657ee9897ce1ebb60a =



Test Regressions
---------------- =



platform  | arch   | lab          | compiler | defconfig                   =
 | regressions
----------+--------+--------------+----------+-----------------------------=
-+------------
beagle-xm | arm    | lab-baylibre | gcc-8    | multi_v7_defconfig          =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60f75b57fbfd6541df85c265

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.3-3=
50-g04f08469f404/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.3-3=
50-g04f08469f404/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f75b57fbfd6541df85c=
266
        new failure (last pass: v5.13.3-349-g948be23c1d3d3) =

 =



platform  | arch   | lab          | compiler | defconfig                   =
 | regressions
----------+--------+--------------+----------+-----------------------------=
-+------------
beagle-xm | arm    | lab-baylibre | gcc-8    | omap2plus_defconfig         =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60f75e14c2b800de2885c276

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.3-3=
50-g04f08469f404/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.3-3=
50-g04f08469f404/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f75e14c2b800de2885c=
277
        failing since 6 days (last pass: v5.13.1-804-gbeca113be88f, first f=
ail: v5.13.1-802-gbf2d96d8a7b0) =

 =



platform  | arch   | lab          | compiler | defconfig                   =
 | regressions
----------+--------+--------------+----------+-----------------------------=
-+------------
d2500cc   | x86_64 | lab-clabbe   | gcc-8    | x86_64_defconfig            =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60f753dd205e439b5d85c272

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.3-3=
50-g04f08469f404/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.3-3=
50-g04f08469f404/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f753dd205e439b5d85c=
273
        failing since 9 days (last pass: v5.13.1, first fail: v5.13.1-782-g=
e04a16db1cc5) =

 =



platform  | arch   | lab          | compiler | defconfig                   =
 | regressions
----------+--------+--------------+----------+-----------------------------=
-+------------
d2500cc   | x86_64 | lab-clabbe   | gcc-8    | x86_64_defcon...6-chromebook=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60f7556dc4a0f2ad5285c2d8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.3-3=
50-g04f08469f404/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/ba=
seline-d2500cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.3-3=
50-g04f08469f404/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/ba=
seline-d2500cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f7556dc4a0f2ad5285c=
2d9
        failing since 9 days (last pass: v5.13.1, first fail: v5.13.1-782-g=
e04a16db1cc5) =

 =20
