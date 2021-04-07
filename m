Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8DFE357011
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 17:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353453AbhDGPWo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 11:22:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbhDGPWn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Apr 2021 11:22:43 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5174EC061756
        for <stable@vger.kernel.org>; Wed,  7 Apr 2021 08:22:33 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id t22so6162137pgu.0
        for <stable@vger.kernel.org>; Wed, 07 Apr 2021 08:22:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BVX0eOwt92Cbmu4IevsaOFzfllrDLs4nyUCYldNwGfU=;
        b=CWGeAMfpxOyS78vM7HOoINsu947+RGheynQGumKrgSY/nPPNzAwz2sY35+GU1M8ZT1
         I2PseaAnV5eAmRCmlhEe9J/nN6o79dErUU+ZAZielXvvuZz72YVPx5wKcWsyIcTk8MGP
         DTIWKuepDwOH8BnsuSDMo8PNo/5X8qCP0DsUyxkmynseOYDPlmDw9SEEjujR5Y57j+2m
         PjWb4xd/xFhGu3dzIhzMwBCPv8WlMG2DHOOQzOWNFamSfpQneP+4hWA15W6h5qTMdSZz
         VtZBAyHNZhnZTO2PZanD2g9UWRm9gLmwtWXfalHQQBRIR2ew1/xnBg1992n4iSa2shP8
         g0pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BVX0eOwt92Cbmu4IevsaOFzfllrDLs4nyUCYldNwGfU=;
        b=VkjUjMyssK2dqUczlhCFfWMjZkHm2Ch0REGVr9sY48Oyn3k9w2PSzblHZS6A9ZAOra
         lSyDWCVpUb2jAO8obkoygoJehFg65sfLixJ1uM7hVWVkyXlcaFDXv++snW/CQcid/nSC
         2tiXs9IepPyQNPvwTC9bL/be/fG4tFEyfg+Uz9naDcpOdEJ+KGgTBpxachkgGFo14BR8
         kvwkM++OOD0mtZbmZcX2pR5GJOSzbOkQYcoVDx8NRjFF/kdEo1xfDqu7GKPF8w2Fhc6K
         qitVTUKNmPhQ0r0yfPr4Dox8MtuZe7+q2cnuFqjDJbwF2u7oBnKjVzSDsTMcTm6J61LK
         xJPw==
X-Gm-Message-State: AOAM530W4Fi77VwEYtYstojFAQoNsyM7xVCCHoM/5XNSBjqK/n5VHIY7
        x4Ryfd/fEHFP+9rO8Wk6/VW0GMv9BGA7xkCd
X-Google-Smtp-Source: ABdhPJwjdLbLe4JYDj87PnUG7U9u7dBmMD6ABIs4LlprUmywwzUnoqw2fJtYJVIuTqnGiWo4Nt9uhg==
X-Received: by 2002:a05:6a00:1510:b029:221:cd7d:90d8 with SMTP id q16-20020a056a001510b0290221cd7d90d8mr3253385pfu.61.1617808952621;
        Wed, 07 Apr 2021 08:22:32 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d24sm5705820pjw.37.2021.04.07.08.22.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Apr 2021 08:22:32 -0700 (PDT)
Message-ID: <606dce38.1c69fb81.ffbe.ee59@mx.google.com>
Date:   Wed, 07 Apr 2021 08:22:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.264-35-gaf972d7e9b9a3
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 114 runs,
 5 regressions (v4.9.264-35-gaf972d7e9b9a3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 114 runs, 5 regressions (v4.9.264-35-gaf972d7=
e9b9a3)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.264-35-gaf972d7e9b9a3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.264-35-gaf972d7e9b9a3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      af972d7e9b9a3e05c151ba864c83696e7fd8adae =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/606d9c1a5e45f975aadac6d1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.264-3=
5-gaf972d7e9b9a3/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.264-3=
5-gaf972d7e9b9a3/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606d9c1a5e45f975aadac=
6d2
        failing since 144 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/606d9c165e45f975aadac6c0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.264-3=
5-gaf972d7e9b9a3/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.264-3=
5-gaf972d7e9b9a3/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606d9c165e45f975aadac=
6c1
        failing since 144 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/606d9e57bf0820b96fdac6b3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.264-3=
5-gaf972d7e9b9a3/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.264-3=
5-gaf972d7e9b9a3/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606d9e57bf0820b96fdac=
6b4
        failing since 144 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/606d9bb64d6bab853bdac6cb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.264-3=
5-gaf972d7e9b9a3/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.264-3=
5-gaf972d7e9b9a3/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606d9bb64d6bab853bdac=
6cc
        failing since 144 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/606da5b36e98998eb3dac6d8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.264-3=
5-gaf972d7e9b9a3/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.264-3=
5-gaf972d7e9b9a3/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606da5b36e98998eb3dac=
6d9
        failing since 144 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
