Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B26E139A5DF
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 18:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbhFCQkx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 12:40:53 -0400
Received: from mail-pj1-f48.google.com ([209.85.216.48]:46728 "EHLO
        mail-pj1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbhFCQkx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Jun 2021 12:40:53 -0400
Received: by mail-pj1-f48.google.com with SMTP id pi6-20020a17090b1e46b029015cec51d7cdso4185359pjb.5
        for <stable@vger.kernel.org>; Thu, 03 Jun 2021 09:38:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=s1U6X3VwNCQaxHhgz8tiH40z3vzwu/o6O4b7PWdE+1U=;
        b=NL+3qOnXLbrClGB3f4Gvc6VhIdL3n7EdUIgUcq6eAKIy+dtjWetYX1bJ7rrt9TktEh
         8ntuDNYjE5LconbldRbOIPHNdPWxbxgLxW4Z07DN/4zEeTm+a4Y9vOnRMFVBOizhyKgD
         v/0TKUG9Nc8lJXjGJOowE6sxdGBpYYNCK5d/eLPMv76frPMD/5bSLr1qQkRQ02ei13K/
         8z0QUqacv/dwmzvQTgVNrSXooGeEuRnb16pO0wZAi/wp8eYHjtXBrsIlorrHdaH9S7iG
         e5sUl477XpfrBSIuK5k508HnOtdwaDzCFUHboovWXasMIcJB1XQmlw2XKak9tAXoJZUc
         O1qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=s1U6X3VwNCQaxHhgz8tiH40z3vzwu/o6O4b7PWdE+1U=;
        b=EThna3zeApD+v/Ubgn7KrGBqLH9y79xh1hS/AELAr1z0SyiE+cl1HMzM4P6Fk2VGoq
         1lCsAj5J3Kc+C7kyZKacAHz2uCaINPsnVb85fjUdt4sZzmhIQnfHRh98LrK3Vs46SOl4
         JE2hY/qjrgvYqMBBTq98KN4V/TZkXxGGqAF9Xpvgm3dCZrG7vxl7zq8b1Tan8gNXBlrS
         UzvqRw6qWZc5hEOU8m8j9RT+XoOuaMywP7eM/6f0GdvmzL09pJh4vQGf/P+15XjMVKjf
         uqTrjP8mBjgkor4xaCMSq55dMJCuSbYjovsSY6Vnq0El/7s+OYasiuPFN5c1nOuqZlco
         O62g==
X-Gm-Message-State: AOAM531tGYPVaRwTODjMw/foQRjvyhIuL3WlRf+IHLtuRbPpZ7ZQLM+P
        PD+NulRkPzvzt/YH3MWfSIkncurO5XlGMQ==
X-Google-Smtp-Source: ABdhPJxvyg9DUCU0yahjN0MHk2GX/8rWVO59dc4OkFC0lps0sDjamtjeT6yzjoGo4/j0F01UnVd5VA==
X-Received: by 2002:a17:90a:b782:: with SMTP id m2mr3909149pjr.147.1622738274771;
        Thu, 03 Jun 2021 09:37:54 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d15sm2705529pfd.35.2021.06.03.09.37.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 09:37:54 -0700 (PDT)
Message-ID: <60b90562.1c69fb81.23995.88c9@mx.google.com>
Date:   Thu, 03 Jun 2021 09:37:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.193
X-Kernelci-Branch: queue/4.19
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 140 runs, 4 regressions (v4.19.193)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 140 runs, 4 regressions (v4.19.193)

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
nel/v4.19.193/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.193
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1722257b8ececec9b3b83a8b14058f8209d78071 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60b8c951f488ff0151b3afad

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.193=
/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.193=
/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b8c951f488ff0151b3a=
fae
        failing since 201 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60b8c96071019053c7b3af97

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.193=
/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.193=
/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b8c96071019053c7b3a=
f98
        failing since 201 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60b8c94026606dda06b3af98

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.193=
/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.193=
/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b8c94026606dda06b3a=
f99
        failing since 201 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60b8d202d066c40ad7b3afb2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.193=
/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.193=
/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b8d202d066c40ad7b3a=
fb3
        failing since 201 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
