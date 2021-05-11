Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A88A9379DF9
	for <lists+stable@lfdr.de>; Tue, 11 May 2021 05:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbhEKDz6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 23:55:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229465AbhEKDz6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 23:55:58 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2CE0C061574
        for <stable@vger.kernel.org>; Mon, 10 May 2021 20:54:51 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id t2-20020a17090ae502b029015b0fbfbc50so352073pjy.3
        for <stable@vger.kernel.org>; Mon, 10 May 2021 20:54:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=NCKPtGiBobiVk31EqthggvpQB5APwMLsnAjPe2mqULY=;
        b=CXtWu617t2TVRMws2cNtPp64VmtcZnVaAYKsjE31K+uwNsfYLMkpKf6RlX1a5SqmMN
         lsD9fhYtvWRLIJmGoZpLF4DqqqcxNla/AkwtCV9HWT7vAzCNf/yoOb6CB04fGJR82lB3
         RBqWpjSa7YKLxPKfyxglDuYw/QVGo7v+bnDNkZ4Gv6GvKOaI+xoSi7onUic73feyp0oW
         NqeVLHUtFL28O3d912S6qVavlCR6z8EhyUc652Vu8/fFbwcQwtZByUlkjDJGEtlAbR+Q
         /CZGW9OS+IaBYg0LvjQSDxpCc3G0RoQklOuvpsOtVzpJTtypqXPWDVaAoQA1CIiz6QYy
         DPXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=NCKPtGiBobiVk31EqthggvpQB5APwMLsnAjPe2mqULY=;
        b=ga3LiCUD3pvU0+RG9QmEdYPm0MZP5SWRrAI8zxcVF6kQy7XJf4cYSncVfSOfgYRJK9
         CN0MOGIe8Q5CcYEtbBCZT0RQeUeJ7Vt0Ka0INnmebBG3czCoJyk5hQ4OYQUxn8RReOf3
         mMjUbbwNTfvBWCME/OuyLL6NXoZNCCULTUTTgknT/CILDIvpfp5US9EyfrdNT8z8rquv
         zxJMgxU56T/DIYn3r/8F4pv9ctNVDbLFcA9HzjH48y64EHb8iqsaYajwKpdFuLbUFoBO
         eiFWiYqIobLRzVz8o+jfWWp9DbOGpVKG+qhndAE3WaklElCUiEeCZoHVQJJiWs3zq4Js
         xITQ==
X-Gm-Message-State: AOAM533yG0mv1T2NiVwFvDz6JMlfhZAl/MRTom/n/dVhJyMDOa517xpN
        KJq1HZ7KTuSNa7yi1E9mYuYNntS7MCy/CCna
X-Google-Smtp-Source: ABdhPJxWtY4HbX36FJPGfpRjYcMWG9lLRD0uy+2d6cL1ascj0cSYZhsvkdpOUtbuDXDN6QuoIbdekw==
X-Received: by 2002:a17:902:e891:b029:ee:fa93:9546 with SMTP id w17-20020a170902e891b02900eefa939546mr27691682plg.23.1620705291042;
        Mon, 10 May 2021 20:54:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g6sm12515592pfr.213.2021.05.10.20.54.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 20:54:50 -0700 (PDT)
Message-ID: <609a000a.1c69fb81.6c420.62a6@mx.google.com>
Date:   Mon, 10 May 2021 20:54:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.190-119-g5602d5adbd0a8
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 136 runs,
 4 regressions (v4.19.190-119-g5602d5adbd0a8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 136 runs, 4 regressions (v4.19.190-119-g5602=
d5adbd0a8)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.190-119-g5602d5adbd0a8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.190-119-g5602d5adbd0a8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5602d5adbd0a8700d63ab892a06fba68753abc90 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6099cada0b6722184f6f5492

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-119-g5602d5adbd0a8/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-119-g5602d5adbd0a8/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6099cada0b6722184f6f5=
493
        failing since 178 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6099cadb0b6722184f6f5496

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-119-g5602d5adbd0a8/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-119-g5602d5adbd0a8/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6099cadb0b6722184f6f5=
497
        failing since 178 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6099cadd15ca6d63c16f5478

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-119-g5602d5adbd0a8/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-119-g5602d5adbd0a8/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6099cadd15ca6d63c16f5=
479
        failing since 178 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6099ca67a2703273af6f5472

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-119-g5602d5adbd0a8/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-119-g5602d5adbd0a8/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6099ca67a2703273af6f5=
473
        failing since 178 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
