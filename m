Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2D3E36C7D5
	for <lists+stable@lfdr.de>; Tue, 27 Apr 2021 16:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236173AbhD0Ohb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Apr 2021 10:37:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236144AbhD0Oha (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Apr 2021 10:37:30 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2CC9C061574
        for <stable@vger.kernel.org>; Tue, 27 Apr 2021 07:36:47 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id u14-20020a17090a1f0eb029014e38011b09so7316874pja.5
        for <stable@vger.kernel.org>; Tue, 27 Apr 2021 07:36:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9mlY6FGEvBtn48t6wGX+akG0rQ09T4/jfLt4P9ypSu8=;
        b=zLV3hZNbVfK4vgMze+rFdAfGYUU7S20akMfHm8VJ12kcsoKzaIqTinPd972z6ViMNN
         azNqsz78kYZSXWlKjxC/G6ZThTi62gyctPnqwcBy8sJhkD8+57RJBz6tNSvPMRCDkGMj
         EBMGwllbAStAQVLjDcW8e5/bjyfihQv+YjbFrG7m/ktpG+ffK3groeEsbEXYmoRQzgbC
         4mKMQO+ARUNf4CwJN2HL70HAN67dc5F6Wdj0xN7mYAj57f8dxyJTPNMbOtVfhlbpJLtp
         vWOqm3r2LpxXZ5XzW/OGQmBO71FodkJh5z/HgSf/P+xxMWQ54wCV7F14/DGapRdJL0c6
         5FiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9mlY6FGEvBtn48t6wGX+akG0rQ09T4/jfLt4P9ypSu8=;
        b=Fa814jSdMcUzytcaBhPb04ivtWyKSG7G2CKAUhPBYML2UTsItKVQ0RVsVVXTby85ys
         lcks6Ra3ku6tbDeqVsjPl/E3uUrQ5rD52btoNWpJst/tK1YimMsqROT3yrSOB7hEJoxr
         vyz2+jCU2pJHGpZPKMt0TH9k9nYwp4Mh2yqac0dhe0NAoobMIrabYXxStcqnj/SOoLdR
         ew5zO0u6WmBqZ3NcEp2upp64LGQ8baGQURgepCRlZngVd4C6XGH9SCBs04ZCsLKdDiYW
         JixmsodR0RAlCCw3uHGCw/9CBveDgkY+UewNDXNTDyL5wBg8AsdCK/ElRj4DbdUESjg7
         pCog==
X-Gm-Message-State: AOAM533teo8yKn8FEGDJe2b/6KEvxjs5TfVR7XyCf2AeusF84g0IdLsw
        YyYcCrLPl0OJSAbMtTpvwqiEASvU/rthQwdG
X-Google-Smtp-Source: ABdhPJyLGaZVGO//eiNqyBDE7MRS3xbUKXShjuLvlXUh0AZwxGPHZF/UAXyT5WAjPjGBip4EzoKISA==
X-Received: by 2002:a17:90a:5304:: with SMTP id x4mr26659010pjh.221.1619534207107;
        Tue, 27 Apr 2021 07:36:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h3sm2869735pfo.155.2021.04.27.07.36.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Apr 2021 07:36:46 -0700 (PDT)
Message-ID: <6088217e.1c69fb81.753ed.87e1@mx.google.com>
Date:   Tue, 27 Apr 2021 07:36:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.231-51-gd9347e37683c0
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 112 runs,
 4 regressions (v4.14.231-51-gd9347e37683c0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 112 runs, 4 regressions (v4.14.231-51-gd9347=
e37683c0)

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

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.231-51-gd9347e37683c0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.231-51-gd9347e37683c0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d9347e37683c002c712b578b2e0984ffd077be62 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6087ed2161b30700a39b7816

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-51-gd9347e37683c0/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-51-gd9347e37683c0/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6087ed2161b30700a39b7=
817
        failing since 164 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6087ed0e61b30700a39b77ad

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-51-gd9347e37683c0/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-51-gd9347e37683c0/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6087ed0e61b30700a39b7=
7ae
        failing since 164 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6087ed1561b30700a39b7800

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-51-gd9347e37683c0/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-51-gd9347e37683c0/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6087ed1561b30700a39b7=
801
        failing since 164 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6087eccf6d6f1edecc9b77a0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-51-gd9347e37683c0/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-51-gd9347e37683c0/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6087eccf6d6f1edecc9b7=
7a1
        failing since 164 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =20
