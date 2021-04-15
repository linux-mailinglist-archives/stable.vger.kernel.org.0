Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00AB0361224
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 20:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234273AbhDOSeG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 14:34:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234101AbhDOSeF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Apr 2021 14:34:05 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E70FEC061574
        for <stable@vger.kernel.org>; Thu, 15 Apr 2021 11:33:41 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id m18so10362181plc.13
        for <stable@vger.kernel.org>; Thu, 15 Apr 2021 11:33:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=aRVK1FIUcF7XCpNAd1hDdck+KOItJ9F7K5oOVgDpbEI=;
        b=xjhl5teEVGBjokMpeotD1/0RytZOgdyLybl05RaYNesWDvdiNnOPTX6WdhO53Y3uDv
         YJ+RVk6GZP7S7LQN51EXZKf0Nqt8YEJHFYVwW2BGnoZTclvB1Vf+oIpLNvRyQ8rF40Ay
         Ktz4hVJJ7e013jzJYPwwNAkbevvaJ+8YaKibI6hLfAN5tja6rk9X+o1lpaAp9tbf6jMc
         P3AjvYF6v6VVI5uzZEZY2kPAWB/Mj+UUyU3wZ59F+1XUZEDUFMwlsCZukhgh4CgVydf2
         Ca49EDJ4lYrF+m9V2MPy99clwCeN7vZoeX78IyBt5VLjWStEdytoOWoeOIU/pNQ753jc
         NVHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=aRVK1FIUcF7XCpNAd1hDdck+KOItJ9F7K5oOVgDpbEI=;
        b=TSTyzPwwHqPODETjZBMLmWfcFmocdg9LEbjP9SNYrkFsKG4ecu+xQpDl8A3lVrmzQ9
         OPt44Tr/uIgJR+S0CiC9nYXeQA9b+XRkg5eMhTv+zHg8e4ZTwmuDMAibFpaveZFtilx+
         zk42QzIPMvkhwQQOB0MMVIi+dzQ2sbv097lx+H2lbuPWax5Go3vpfHKHtzAngf4f40wT
         e7DyylN+c0diopMqTNiBoMEM0FKMLdefI4xlJTagp93xoYX8JI54WAaXGHFYzGCwG499
         b8TKYU9W89hXl6BvKbhT1CseieZgzOdi/V7H9VMOKY11WsOK7ecSUnb7RsvX+vuV2dTp
         Q7Wg==
X-Gm-Message-State: AOAM530SOn53xxHwnAKkGyS5OhZDUs5GSlr/mmyXrPi4fWRi4lCpXWi6
        G08txYpy/nK9tDLIvayXDI2c4NxErmmc2BVr
X-Google-Smtp-Source: ABdhPJwy/g5kCeQ0i6QoBNiXP5jpJHRFk0+e91bHq3VJMeMOhCPdEXUSCsIDU+15QHcKSoT09Tfj0w==
X-Received: by 2002:a17:90a:a389:: with SMTP id x9mr5246930pjp.232.1618511621341;
        Thu, 15 Apr 2021 11:33:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id fa6sm3085869pjb.2.2021.04.15.11.33.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 11:33:41 -0700 (PDT)
Message-ID: <60788705.1c69fb81.6a6ec.8804@mx.google.com>
Date:   Thu, 15 Apr 2021 11:33:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.187-10-g087007f5c2a98
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 140 runs,
 4 regressions (v4.19.187-10-g087007f5c2a98)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 140 runs, 4 regressions (v4.19.187-10-g08700=
7f5c2a98)

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
nel/v4.19.187-10-g087007f5c2a98/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.187-10-g087007f5c2a98
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      087007f5c2a98dd127dbeded6eb6b906a98f47a6 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60784f09911fd6cc70dac6b6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.187=
-10-g087007f5c2a98/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.187=
-10-g087007f5c2a98/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60784f09911fd6cc70dac=
6b7
        failing since 152 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60784f1740519da518dac6d3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.187=
-10-g087007f5c2a98/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.187=
-10-g087007f5c2a98/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60784f1740519da518dac=
6d4
        failing since 152 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60784f1540519da518dac6cd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.187=
-10-g087007f5c2a98/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.187=
-10-g087007f5c2a98/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60784f1540519da518dac=
6ce
        failing since 152 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60784ec0dd503f6e3bdac6d2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.187=
-10-g087007f5c2a98/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.187=
-10-g087007f5c2a98/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60784ec0dd503f6e3bdac=
6d3
        failing since 152 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
