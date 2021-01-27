Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A526530612D
	for <lists+stable@lfdr.de>; Wed, 27 Jan 2021 17:43:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbhA0Qmw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jan 2021 11:42:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232005AbhA0Qma (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jan 2021 11:42:30 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62FDDC061573
        for <stable@vger.kernel.org>; Wed, 27 Jan 2021 08:41:44 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id i63so1539737pfg.7
        for <stable@vger.kernel.org>; Wed, 27 Jan 2021 08:41:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=sK62h1F/UpNK1Mdn4cS+EYHkBLlElo1QEnHtSNl+0oI=;
        b=xuYfaYWt37fX5PV731cNgOMge9mmlWsF1GaBv2HG1NsqKeeKnX+gGWj2pxf/XJwYco
         gwRDbLmlgqViAQ0uCHWA0u/VcXJ+viDPz6VxnafiHC8XDwm0M5xNW34j1w9OLIMW/NZ9
         Zb9owbGWJljYN5dQGsjMbBfiF8/KXNwfMKOKYm/FxghDzPkP/5t/bJ3qNblsgqArfHgC
         8q4amZXUkFFu5bu4OQYB5Jh2DWNpO/IrdiOCFEky0h7wGlGmO0aR4S3ecuOAbvflBc0e
         8H2hzGosOEklbzjKWQQAVKgymDVdFR+kTYg/tSVVhHhTEAwYVjQoWAciuW13mjes2NWf
         v/8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=sK62h1F/UpNK1Mdn4cS+EYHkBLlElo1QEnHtSNl+0oI=;
        b=BvABi8h5+t05kQsDorMG04eTTx/NfbGAOjtVe6YbV3wjNSmysFW9eO+96Vg3bO3pkS
         8+PjVBLaCkEVUyzJw/cGJwSu5Mu2bqsT/RA1fC4tE647O9r51F6OwRbLgGvV4+kvoHAO
         tSJDHqGhEKpCy5tDm4BM6UHoDS+VsFbOEP7KxNgtfedZFxEyaK//N/djjQUsATXiNxre
         fzEgP8kDbFdOoqP3f7jAOBoYMqL4aQYs/zk+S7su92riJ3GfptvtpZdVMm5N80t20eg0
         zluz64hb5nRsg9WPejxjTbk3zWJSrg8B6Ago8CXWbFBPqHvROtxN0Tcjt/SxbjFAVBb6
         BrGg==
X-Gm-Message-State: AOAM532dTAu0UzDt1vbQJp7cP6pHOhWmPxufMlCaWjSXSAiH+NLUPTW0
        Vd2P7SJ2o6zQPpyMCMnYZEigUWI4XNexvRnN
X-Google-Smtp-Source: ABdhPJxdOF/YqXv0Xd2ERvKlmugddWZw8EovrzGbC8a8ilWtsErmh1kfy9cl1MShYPYRvo+N+8DWvg==
X-Received: by 2002:a62:3386:0:b029:1ae:8580:99da with SMTP id z128-20020a6233860000b02901ae858099damr11352288pfz.61.1611765703551;
        Wed, 27 Jan 2021 08:41:43 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id br6sm2559611pjb.42.2021.01.27.08.41.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 08:41:42 -0800 (PST)
Message-ID: <601197c6.1c69fb81.1dc05.5a35@mx.google.com>
Date:   Wed, 27 Jan 2021 08:41:42 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.253-27-gfe01f478fe0f
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 119 runs,
 5 regressions (v4.9.253-27-gfe01f478fe0f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 119 runs, 5 regressions (v4.9.253-27-gfe01f47=
8fe0f)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.253-27-gfe01f478fe0f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.253-27-gfe01f478fe0f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fe01f478fe0fd894c30f689365e2ee4afcb41a1e =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60115ed3e8dea0fd0cd3dfe8

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.253-2=
7-gfe01f478fe0f/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.253-2=
7-gfe01f478fe0f/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60115ed3e8dea0f=
d0cd3dfed
        failing since 7 days (last pass: v4.9.252-14-g2e053b32fc97c, first =
fail: v4.9.252-22-g7930947a54962)
        2 lines

    2021-01-27 12:38:39.141000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, mmcqd/0/83
    2021-01-27 12:38:39.150000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-01-27 12:38:39.167000+00:00  [   20.524414] <LAVA_SIGNAL_TESTCASE =
TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60115d782aeb883e01d3dfdd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.253-2=
7-gfe01f478fe0f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.253-2=
7-gfe01f478fe0f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60115d782aeb883e01d3d=
fde
        failing since 74 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60115da293ab2126acd3dfe1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.253-2=
7-gfe01f478fe0f/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.253-2=
7-gfe01f478fe0f/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60115da293ab2126acd3d=
fe2
        failing since 74 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60115d7a49649911f2d3dfcd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.253-2=
7-gfe01f478fe0f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.253-2=
7-gfe01f478fe0f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60115d7a49649911f2d3d=
fce
        failing since 74 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60115d21f52486cdb9d3dfe3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.253-2=
7-gfe01f478fe0f/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.253-2=
7-gfe01f478fe0f/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60115d21f52486cdb9d3d=
fe4
        failing since 74 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =20
