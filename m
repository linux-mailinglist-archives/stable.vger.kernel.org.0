Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D92DB36AE88
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232406AbhDZHpd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:45:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232362AbhDZHn6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Apr 2021 03:43:58 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB8B3C061763
        for <stable@vger.kernel.org>; Mon, 26 Apr 2021 00:42:46 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id s20so12632154plr.13
        for <stable@vger.kernel.org>; Mon, 26 Apr 2021 00:42:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hYN6BqIaXSfHnDl2MHc/KIUd8MUx5VO69D0ZZ94iGqM=;
        b=zMYTHjYvPT4duI4IlwKZJ02/1nOfBbg0Y0K//KVWgWBucA06Bh6ivuEOKymq+dVzU4
         oDxiQCt1KMmGJNguUBUP3YgTL8cQfyd5UMJBq7iVGtoB3Na5T/DY/lbzTL52xA7BbIiO
         +OHcPtjykURvYHiqa+IWeGV+4KQRS6m7YdfF2VJHechYQNNc5L5TrCixZp3hIJwosasS
         LX/9WmvWSxPaKy51u8jYb41JqEd5B1mSWRgK6SW9YXqMUA+Bw3jUYQmFZSb9Gxb75ZvV
         4lqBYJYBTPmZrn+zWRdt2CH09S+CGjOTlqIS0KpkJKPvxEPv9tiGQpdraYQ7O4DbbCKs
         yOSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hYN6BqIaXSfHnDl2MHc/KIUd8MUx5VO69D0ZZ94iGqM=;
        b=OgAOuM1QyaZCpZUdOeo0+y1jEUwV1xPr04rm1/R2J+p5Fezr21sXUqMQN68qaIbc/O
         0f3bZC/FaFhAW5bupuJsatFBPQ48BYc7HaU6pVXh2LF2Fxo8ituxdTk7jgARafROKHbG
         RcVIw6yYfdDJOJXP3s43JxMHWPYsgpLMCHdJJgmvrFcrsuSaxRIa1ntxq85YGXYo5ksJ
         +xGW/3rr4DDNvXR/xIt60fINCR9YaIsmLgXRZks9bkMDskykTsG3MdukIDqLfuGFQ8Fd
         Y7sWsx2bT5I4H2/KNOfKhU/mjwP793fYD7kOGGijYI+rPObT3hAYU7MXUF62Fjcd+Cov
         yVOg==
X-Gm-Message-State: AOAM5327/Jv1eyxAYTFiLRbbMGFr1w8RFZWuopIxrSYPt2zPG6fgwRs9
        k0VrouG7lgYqSpT/NtxqLnj736PuGCZCYvnB
X-Google-Smtp-Source: ABdhPJyAxQn7qbCCR/++ZvQ2oGeLriVGP+diQRmXPbDE9/DKl1ux5eRaLASFCcSLCfSKl5U4+NIToQ==
X-Received: by 2002:a17:902:b08f:b029:ec:c8f6:9f16 with SMTP id p15-20020a170902b08fb02900ecc8f69f16mr17558336plr.11.1619422965982;
        Mon, 26 Apr 2021 00:42:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c16sm10479693pgl.79.2021.04.26.00.42.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 00:42:45 -0700 (PDT)
Message-ID: <60866ef5.1c69fb81.ea5e3.f382@mx.google.com>
Date:   Mon, 26 Apr 2021 00:42:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.267-36-gb1279fb6ec7a1
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 115 runs,
 5 regressions (v4.9.267-36-gb1279fb6ec7a1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 115 runs, 5 regressions (v4.9.267-36-gb1279fb=
6ec7a1)

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
el/v4.9.267-36-gb1279fb6ec7a1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.267-36-gb1279fb6ec7a1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b1279fb6ec7a10970d01f0ddbcaff215a621b770 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/608639357a0208ff589b77b1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-3=
6-gb1279fb6ec7a1/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-3=
6-gb1279fb6ec7a1/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/608639357a0208ff589b7=
7b2
        failing since 163 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/608639257a0208ff589b7795

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-3=
6-gb1279fb6ec7a1/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-3=
6-gb1279fb6ec7a1/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/608639257a0208ff589b7=
796
        failing since 163 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/608639207dab0952bd9b77cd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-3=
6-gb1279fb6ec7a1/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-3=
6-gb1279fb6ec7a1/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/608639207dab0952bd9b7=
7ce
        failing since 163 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6086545d3a9791c3069b7796

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-3=
6-gb1279fb6ec7a1/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-3=
6-gb1279fb6ec7a1/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6086545d3a9791c3069b7=
797
        failing since 163 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60863eda73b4928d0d9b7797

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-3=
6-gb1279fb6ec7a1/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-3=
6-gb1279fb6ec7a1/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60863eda73b4928d0d9b7=
798
        failing since 163 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
