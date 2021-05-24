Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01D0638E6B3
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 14:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232888AbhEXMhK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 08:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232855AbhEXMhC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 May 2021 08:37:02 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEAD2C061574
        for <stable@vger.kernel.org>; Mon, 24 May 2021 05:35:33 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id 6so19980445pgk.5
        for <stable@vger.kernel.org>; Mon, 24 May 2021 05:35:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=g4UguekAWRUSOR0vL6BqSmY2Kgsi1ipcRbVDtjzneo0=;
        b=UlifsO3bm9XUfNr/CiC2ODolxTCXoGG+tUoXbHZl1BYxsemhWS2D3s0Tg8FtVpgaJY
         o1dNFovLltKIrVSOoftKXXpyhz7yA05jiA5TUT1r769K9ukwibv1aq81bs6Ncxdv8jrM
         b827t87qam+TbqExL9s0ekSFnNXgLm59wR1ILanCXoJeoKHIVYktNoindDgwi8wMuugH
         Q/IYTJaebR7bhtWGniBCQ2jctD5oMxf3CLMOC50MpDBuvt7Ej4GN3OzGwqfc/mtTBNZd
         PNsvcYEfCk8R5NRUoIfsiDZubJiZjPkSjMar8iEuwBftR6GI91rGwYEbuB/vy/7WyaO5
         YlYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=g4UguekAWRUSOR0vL6BqSmY2Kgsi1ipcRbVDtjzneo0=;
        b=RqJn8E7BOCRnE48L/mpTilDy3mgLRgpfKqGyV0sx80lxuvbjLpFV7X+BpYu9vLZy7x
         McPpAbBUjA3dicoHCdUK1zm4yJnq/yiCwkzW39u6MWyebKVNcRRF9jumougT0l9IDarC
         VqkSzCftsTUWesy9Q1aNijG1mibn9dImEMx+SFNPFD4z8Lq58N6FGthLJvc8gHe/6eVD
         txRiDn/6nBRacLGH1TH77OOla8PNypR5huqGpc7fnLj7VsbSsogvFUUvJQPMN/A/bcZu
         7Uy13EW+3+AD2wlyoaEAAh14Oon1sfV3wM/Sx/QqJEAhK+WaI0sjZurj5oXAdPlR7K3F
         94lg==
X-Gm-Message-State: AOAM531iepXba/0zy/WuT7KmOUYH1pRT/mVxG8kSJj6GqENJXKp7JdY4
        ET1b75ZNdkG6N+CMHW5XQPyWeqZju+UkAdue
X-Google-Smtp-Source: ABdhPJzbS2gkWuJ7imbuO/3qxixpHFqRZO22TjayxOBS3GlEujs8oxc4kKFkh1MTcAEhfGiHet5+VQ==
X-Received: by 2002:a63:1161:: with SMTP id 33mr13297114pgr.270.1621859733116;
        Mon, 24 May 2021 05:35:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w8sm12077794pgf.81.2021.05.24.05.35.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 05:35:32 -0700 (PDT)
Message-ID: <60ab9d94.1c69fb81.f7620.78f9@mx.google.com>
Date:   Mon, 24 May 2021 05:35:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.268-239-g7ec3767d9eb2
X-Kernelci-Branch: queue/4.9
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 68 runs,
 5 regressions (v4.9.268-239-g7ec3767d9eb2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 68 runs, 5 regressions (v4.9.268-239-g7ec3767=
d9eb2)

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
el/v4.9.268-239-g7ec3767d9eb2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.268-239-g7ec3767d9eb2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7ec3767d9eb2bdc749d6ef78129c4ef9d1a0802f =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60a8ecd0ff3b8c4fe8b3afa9

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
39-g7ec3767d9eb2/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
39-g7ec3767d9eb2/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60a8ecd0ff3b8c4=
fe8b3afb0
        new failure (last pass: v4.9.268-239-g6707ab3bcf1e)
        2 lines

    2021-05-22 11:36:44.548000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-05-22 11:36:44.563000+00:00  [   20.802642] <LAVA_SIGNAL_TESTCASE =
TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60a8ebdb8a4dc83d55b3afb8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
39-g7ec3767d9eb2/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
39-g7ec3767d9eb2/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a8ebdb8a4dc83d55b3a=
fb9
        failing since 189 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60a8ec3b3e1ce3d675b3afd3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
39-g7ec3767d9eb2/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
39-g7ec3767d9eb2/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a8ec3b3e1ce3d675b3a=
fd4
        failing since 189 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60a8eb88d8cf7b1dd0b3afa0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
39-g7ec3767d9eb2/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
39-g7ec3767d9eb2/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a8eb88d8cf7b1dd0b3a=
fa1
        failing since 189 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60a911a1fbc542b47eb3afd2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
39-g7ec3767d9eb2/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
39-g7ec3767d9eb2/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a911a1fbc542b47eb3a=
fd3
        failing since 189 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
