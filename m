Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E33B72DFF92
	for <lists+stable@lfdr.de>; Mon, 21 Dec 2020 19:21:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbgLUSVG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Dec 2020 13:21:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbgLUSVG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Dec 2020 13:21:06 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AE97C0613D3
        for <stable@vger.kernel.org>; Mon, 21 Dec 2020 10:20:25 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id b8so6047218plx.0
        for <stable@vger.kernel.org>; Mon, 21 Dec 2020 10:20:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=UVM6eCxS7wruNypNftEOnPpI+z504Hu73XhPrr9Hz5w=;
        b=vIiUCCVOHwU70lyZAxET6UudRTD6zgUoEZWPQ8fXxatWV94b+DdGFS+eJwX/ZhS2dB
         aD1qHFHjLD3luGiFLxVwXgAZfI0FUTs6mimYzRKoKOFK9BedSodYaGNXsFTJVgCVM1yv
         R7dom4murMzE9/h/+Go5tRjsohnVSdCwFj9GM0CegKAiiYOTlb79118jvBs6XDwDUJqT
         QFiauWkX4ZifJupb5pfH+dE0NcXi+9OwnPfmfvitGEYb8b6W3vX+ROkkUCJYQvhnKWeN
         VkCxFLXFQAWYv3BG6CajxaqS5A51c/h4IHQP3pv2Ybla/B9sSo+b3Lo0af9BckdG1e6d
         cK5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=UVM6eCxS7wruNypNftEOnPpI+z504Hu73XhPrr9Hz5w=;
        b=s40mRnuOJYI/trWr32L/FgT7aXsxoaQTCKF2dsdH0hJn2EbYsd6ir9k7Gz5QeoUd5P
         FsMuo4b4be+Ja4b4A3rHbYjYnSrHnjMWq9wiwwZoxWhRWHhEDlOh/tex68CCU8s8K1yJ
         pMNeZIfKfl8RdoiQSy1pPJ4gBn7VmX/rWut3DFhQtvbjVv0SIvF6N7rJDCZJr7UI42HV
         1Q4VyhmR1gkU32xpyFaP0kywwzNX/q6jh8Gs5/y92QSuOCBR/66p5H9MVwF/IYDniexg
         zOPNQzz0x3kw24zP0mr/AD9wwSitQSt6Ei6P/gtOBz3uQ0F/YGLzcLbEjm4QkPFrr8IX
         6AxA==
X-Gm-Message-State: AOAM530mSkG6gCHxthYeo4FEPQ/wSpQAGkBJaJcX5N6L77xrlB8ZI945
        qV9GdCRVmKW0BY9ujDu1kfetY0MRdNCKOQ==
X-Google-Smtp-Source: ABdhPJxyZAFPYhDaXMNezWgR0Pp+uGzYmvgfIPPBLnAhcZj1/39TPOMozc6CVJrgoIdCazzp93NDZQ==
X-Received: by 2002:a17:90a:dc18:: with SMTP id i24mr18534073pjv.118.1608574824865;
        Mon, 21 Dec 2020 10:20:24 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w2sm17425217pfj.110.2020.12.21.10.20.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Dec 2020 10:20:24 -0800 (PST)
Message-ID: <5fe0e768.1c69fb81.59873.2660@mx.google.com>
Date:   Mon, 21 Dec 2020 10:20:24 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.163-54-ga9af879616f0
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 144 runs,
 5 regressions (v4.19.163-54-ga9af879616f0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 144 runs, 5 regressions (v4.19.163-54-ga9af8=
79616f0)

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

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =

rk3288-veyron-jaq    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.163-54-ga9af879616f0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.163-54-ga9af879616f0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a9af879616f0a4b3eaded9172e72b5fb3f27bfe0 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe0b5b85ac6bde0d7c94cc4

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-54-ga9af879616f0/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-54-ga9af879616f0/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fe0b5b85ac6bde=
0d7c94cc9
        new failure (last pass: v4.19.163-54-gea2d5223aced)
        2 lines =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe0b2b5785ddee542c94e0c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-54-ga9af879616f0/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-54-ga9af879616f0/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe0b2b5785ddee542c94=
e0d
        failing since 37 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe0b2dbc0cc938d87c94cd8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-54-ga9af879616f0/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-54-ga9af879616f0/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe0b2dbc0cc938d87c94=
cd9
        failing since 37 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe0b45c81527e0b21c94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-54-ga9af879616f0/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-54-ga9af879616f0/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe0b45c81527e0b21c94=
cba
        failing since 37 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
rk3288-veyron-jaq    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe0b5162e42c7d5fac94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-54-ga9af879616f0/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-54-ga9af879616f0/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe0b5162e42c7d5fac94=
cba
        new failure (last pass: v4.19.163-54-gea2d5223aced) =

 =20
