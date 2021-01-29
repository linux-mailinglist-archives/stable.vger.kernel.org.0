Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59F28308E97
	for <lists+stable@lfdr.de>; Fri, 29 Jan 2021 21:45:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232839AbhA2Ulh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jan 2021 15:41:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232808AbhA2Ulf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jan 2021 15:41:35 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6664C061573
        for <stable@vger.kernel.org>; Fri, 29 Jan 2021 12:40:55 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id m6so6970981pfk.1
        for <stable@vger.kernel.org>; Fri, 29 Jan 2021 12:40:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=goaqOaV+dNQLHaDC+3EztFmhaw4O3NPXfAEWkwVm0Pg=;
        b=GwgyqE+RBpcS9ypQh8yEL87cIxXPRP6KJtXeszFyQBsQW8iJf71gdueeqARjspwcg7
         IkR+BmTfgrq4qZQjh3CJWM2c6trMWkDb9+jsuL6nhB/Lkza3OiernrkUzbhVdGiCu9J2
         BAHBfs0KA9770VpYtoVzbO3QJ+YNHQYnVgFJSyJ/7EsadGyFmxPX5WPrSDOnMCLq7+Aj
         1xAHb06CJ6TPzjAMwJcbVr9zoyESPW6E6Dj7UMX3NP0a2zbcKH6d7clDB+rvu4Bs2iT3
         asEK0WehNb+D+u5+HqRRf5d28NUTycAOF6hdIv9AfSlzKEWGqXgOsMT06elkDUfeI8KG
         bNMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=goaqOaV+dNQLHaDC+3EztFmhaw4O3NPXfAEWkwVm0Pg=;
        b=ca/bX3LWijYWRyRbr74+Mv048Ol4iqqiJhgBUjhbJ/ksWxLg3ikXeQi8Oe1xs0HHIj
         92zmjcRxfLjmwmtIZNsjh211CGbBzvBMAWLXaTISxMgR7uiOM8GxTdmMYMKzc3t0sph+
         4Q77CEqWFNYgMmGrDJ/83asPXPM9e977qkLH768dQZUwJxc1ElFv/kV6PDp6Wvh3odTu
         4A5UYzIYb97ef2yQKJmkambxaOfbbGkPC1T1mzCg6BHD9FpoUtIIK/R2baKzoD6N5tTK
         snKnrm44TkKjn0l6gOFYTNh5SI/kNl7W+w4bd6fFZNvHxoneZkAqFWWsThzkALngGPLi
         P2AQ==
X-Gm-Message-State: AOAM531dkoAmMJrL2FkhR9EL9NizcJqHD0TpiuP8HXzMxSgF7yvFOKcE
        HHpIEfgu3gNTLSJ700jBML+/AvvAW+mnWA==
X-Google-Smtp-Source: ABdhPJz19j9GrnahM1mAJS11B6zirUDC6uX+UjZkYUlZzn0CGwxGwHTjp0Ccix7IwDFYqcKhU2YUsg==
X-Received: by 2002:a62:32c3:0:b029:1bc:7e0:ae66 with SMTP id y186-20020a6232c30000b02901bc07e0ae66mr6146811pfy.53.1611952854948;
        Fri, 29 Jan 2021 12:40:54 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x125sm9876235pfd.17.2021.01.29.12.40.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jan 2021 12:40:54 -0800 (PST)
Message-ID: <601472d6.1c69fb81.91ee1.84d2@mx.google.com>
Date:   Fri, 29 Jan 2021 12:40:54 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.171-26-g878798ccc2dbf
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 170 runs,
 6 regressions (v4.19.171-26-g878798ccc2dbf)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 170 runs, 6 regressions (v4.19.171-26-g87879=
8ccc2dbf)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.171-26-g878798ccc2dbf/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.171-26-g878798ccc2dbf
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      878798ccc2dbf0b0710d56b839f42cc6d962bd7f =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60143d725c455a8781d3dfda

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.171=
-26-g878798ccc2dbf/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.171=
-26-g878798ccc2dbf/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60143d725c455a8=
781d3dfdf
        failing since 12 days (last pass: v4.19.167-43-g7a15ea567512, first=
 fail: v4.19.167-55-gb4942424ad93)
        2 lines

    2021-01-29 16:53:01.892000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/102
    2021-01-29 16:53:01.902000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60143c3137a9e97b87d3dfcb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.171=
-26-g878798ccc2dbf/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.171=
-26-g878798ccc2dbf/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60143c3137a9e97b87d3d=
fcc
        failing since 76 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60143c589587b0710cd3dff3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.171=
-26-g878798ccc2dbf/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.171=
-26-g878798ccc2dbf/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60143c589587b0710cd3d=
ff4
        failing since 76 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60143c38df54424552d3dfd0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.171=
-26-g878798ccc2dbf/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.171=
-26-g878798ccc2dbf/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60143c38df54424552d3d=
fd1
        failing since 76 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60143bd4929ccd2376d3dfd7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.171=
-26-g878798ccc2dbf/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.171=
-26-g878798ccc2dbf/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60143bd4929ccd2376d3d=
fd8
        failing since 76 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60146ce6415aff2e2dd3dfeb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.171=
-26-g878798ccc2dbf/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.171=
-26-g878798ccc2dbf/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60146ce6415aff2e2dd3d=
fec
        failing since 76 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =20
