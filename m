Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 167DE2D653E
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 19:40:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390733AbgLJSiJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 13:38:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389746AbgLJSiD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Dec 2020 13:38:03 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 979A9C0613CF
        for <stable@vger.kernel.org>; Thu, 10 Dec 2020 10:37:23 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id p6so3216141plr.7
        for <stable@vger.kernel.org>; Thu, 10 Dec 2020 10:37:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vcIcVQtiJ4GbvdLxejXJMyaTMWMxDd/K1Qswkpx1qC0=;
        b=O5l2TrxZt7+O/OAlXE8wuVhruilsfpjQzW+DAGY3tCOD+ivfcW+oQr/4fxJ998O2+/
         uGSbS7/53fERke2OIXU9x5kZs2IEQRB3eNz1i6+KYqUv13mMi0QPYg5KYJkg9/mjRcTE
         OP44KE/yyt1sI2FaSua5XdFzPQvr4TmM232AlMhdbREfI+ONTuvMOuJ33TFGLnRSPb1f
         5I/AnSMtDh8r34Uncv1TWUcM7d0tF5spB899faRZqIoaU9wfzaKCEVwdTlfIAk44J/MI
         1HG51p0sbGk1u61Q1BOiXigsKMQYTJcy9Izlz+c61YdCn2neSIo+fEv0RalPY8KPRV2X
         Cvdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vcIcVQtiJ4GbvdLxejXJMyaTMWMxDd/K1Qswkpx1qC0=;
        b=c33qZYlM7DQ/zo5k/hUiH9LrWF5Re/Emnyee1MMymABGEITzoQg+Lq60Wk4mYQ8BAr
         UJXjyN9kXGlgcsBAFMpCQbOsPLTrvjKFHQDjXum4jbLsBpgZ9qUpKoUV/JPnbGPmdHIl
         +An4rbGZWzu+c1oeVguQN8vxuZIuduwjfapanVOXjz7ZHGMRxlxybARWKxkQ7furkaZd
         LsJw4JAq+cmDvqIsZM8l9XWIZdmXr7ClKHm9Y/s71lvw9u9d3cF65HgDGKUBCFGe+adX
         M0ESG+9VZXQ4A7HwNyahBXnOrioisI1xtmafdqbWD8RSwbsgplljxBSHYaeLFwsyuNYD
         MPnQ==
X-Gm-Message-State: AOAM532/8JoUBPv1bmx/cmCqsHkC9WNVEsWGZ8rBPNLEBVPaE0ZTQiKr
        CCkNGJLPgiV2NI39HdHrKraSfXUNAIdREw==
X-Google-Smtp-Source: ABdhPJwizRdx+LB9XX1IkMDUTYBWA3NRNCREr9FEqdl22oUppoXJ5sLnGTsvAHiI5i6gznY9rHBZnQ==
X-Received: by 2002:a17:902:a502:b029:da:f580:bc35 with SMTP id s2-20020a170902a502b02900daf580bc35mr7655469plq.60.1607625442811;
        Thu, 10 Dec 2020 10:37:22 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b10sm7464884pgh.15.2020.12.10.10.37.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Dec 2020 10:37:21 -0800 (PST)
Message-ID: <5fd26ae1.1c69fb81.f7e8d.e041@mx.google.com>
Date:   Thu, 10 Dec 2020 10:37:21 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.247-42-gf761790c11ce
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.9.y baseline: 101 runs,
 5 regressions (v4.9.247-42-gf761790c11ce)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 101 runs, 5 regressions (v4.9.247-42-gf7617=
90c11ce)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.247-42-gf761790c11ce/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.247-42-gf761790c11ce
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f761790c11ce1e7bdd36e0c039d2a49f64ffbe1b =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd23542bc2bb7e9c2c94cca

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.247=
-42-gf761790c11ce/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.247=
-42-gf761790c11ce/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fd23542bc2bb7e=
9c2c94ccf
        failing since 1 day (last pass: v4.9.247, first fail: v4.9.247-34-g=
5c4e61c1e935)
        2 lines

    2020-12-10 14:48:31.113000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/121
    2020-12-10 14:48:31.123000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd2313e826c51c349c94cdb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.247=
-42-gf761790c11ce/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.247=
-42-gf761790c11ce/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd2313e826c51c349c94=
cdc
        failing since 25 days (last pass: v4.9.243-17-g9c24315b745a0, first=
 fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd2313a826c51c349c94cd5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.247=
-42-gf761790c11ce/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.247=
-42-gf761790c11ce/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd2313a826c51c349c94=
cd6
        failing since 25 days (last pass: v4.9.243-17-g9c24315b745a0, first=
 fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd23136eef03841c0c94cdc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.247=
-42-gf761790c11ce/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.247=
-42-gf761790c11ce/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd23136eef03841c0c94=
cdd
        failing since 25 days (last pass: v4.9.243-17-g9c24315b745a0, first=
 fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd230ecb9f6e8668cc94cc8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.247=
-42-gf761790c11ce/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.247=
-42-gf761790c11ce/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd230ecb9f6e8668cc94=
cc9
        failing since 25 days (last pass: v4.9.243-17-g9c24315b745a0, first=
 fail: v4.9.243-26-g7b603f689c1c) =

 =20
