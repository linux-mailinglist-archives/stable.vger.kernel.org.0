Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B002382794
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 10:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235577AbhEQI4p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 04:56:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232924AbhEQI4o (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 04:56:44 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFBEDC061573
        for <stable@vger.kernel.org>; Mon, 17 May 2021 01:55:26 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id gm21so3274689pjb.5
        for <stable@vger.kernel.org>; Mon, 17 May 2021 01:55:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0DFbAisWf0j220KNONu86ARIbkWhUbqD0K15QkstO6A=;
        b=O3KgD3H0RRdNNgLH+OUqS/EG61Okr6i14SYuyVMhbguP4wUO/ylHzFkxoUO1xfLk4y
         I95pYdG0uyuU+//hmOrO6eF2BDCJygiBia1SQmWLfhhgmy3Iyzv+EErJYq48HyyCb+Em
         2K3T5JCkW9aFfjdrM+Bbdx29CTgHbgwfLQhzi9AkG0Tamq/PRKEp5JRdr0InI5x6iFoA
         3mwk7VOt24l2k3XCYgWtXESoanzy5/4OUgfCs2DHfH3Jm9IqnU5ip5eUhQryEOkPfh7p
         jOws7wQ8tunUEGSS+0nhbyZeqs2owO5s3gXZyYeIpuwehD2fAf6xy6jPjnXw4La1AKvM
         9RLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0DFbAisWf0j220KNONu86ARIbkWhUbqD0K15QkstO6A=;
        b=WPRaxnDLlKQAes0a6aMqAse8eD7HT8T06xAo+4ylV4h1flo9sh2ib58nx2JJ44IjZp
         yuvjRmaChxg774NvTeA7ngWidiQm/apSivyoCarTbsbMH9VgP/RSfS7fvtnXavQA04Nl
         sHKRKbgPHPRq5iZ2G/4oVlnTxlhH2YEWF53IwtTexomlv1ifGV83mzc6U5Vy6fRBz9V4
         9GGFNsHfRhhY7TUZQD4snWwb97WIfQCbasCJL4OfxEicrAl+HRsPFP7l/Czosvgk/H48
         cew7z25NMVF6NFTuYFJPve+cAPscuUVvIOECBHVOBH735n1Eub31F22OOifNSEwRXSaG
         ALHg==
X-Gm-Message-State: AOAM533THN68RHQY1XVH1jUCfPS3Gls6GxQJIO31v7hNt+ruykWOzO/g
        bhJ2Hdma3mcy0tE47hInPjYSYHRUJ/tkpqgl
X-Google-Smtp-Source: ABdhPJyebyk/JZXAcGi+UaR5rHMGQWBhS9eq1v2i/NBXzY08Pd3ACucRg6Qwi8Iq3FylX/mvFFxfiw==
X-Received: by 2002:a17:902:7c8a:b029:e6:f010:a4f4 with SMTP id y10-20020a1709027c8ab02900e6f010a4f4mr59419541pll.17.1621241726114;
        Mon, 17 May 2021 01:55:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ca6sm14647144pjb.48.2021.05.17.01.55.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 01:55:25 -0700 (PDT)
Message-ID: <60a22f7d.1c69fb81.bba13.fee0@mx.google.com>
Date:   Mon, 17 May 2021 01:55:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.268-210-g87952f9d6ad5
X-Kernelci-Branch: queue/4.9
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 102 runs,
 4 regressions (v4.9.268-210-g87952f9d6ad5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 102 runs, 4 regressions (v4.9.268-210-g87952f=
9d6ad5)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.268-210-g87952f9d6ad5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.268-210-g87952f9d6ad5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      87952f9d6ad5e0c49c680d2e80dbd3bee59d1710 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60a1fd62dbc08597fab3afcd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
10-g87952f9d6ad5/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
10-g87952f9d6ad5/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a1fd62dbc08597fab3a=
fce
        failing since 184 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60a1fd5edbc08597fab3afca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
10-g87952f9d6ad5/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
10-g87952f9d6ad5/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a1fd5edbc08597fab3a=
fcb
        failing since 184 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60a1fd65c371f81ac7b3afa4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
10-g87952f9d6ad5/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
10-g87952f9d6ad5/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a1fd65c371f81ac7b3a=
fa5
        failing since 184 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60a1fd1d3bf1eb0e02b3afc5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
10-g87952f9d6ad5/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
10-g87952f9d6ad5/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a1fd1d3bf1eb0e02b3a=
fc6
        failing since 184 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
