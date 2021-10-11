Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C158429785
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 21:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234580AbhJKTYx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 15:24:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234363AbhJKTYx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Oct 2021 15:24:53 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29BA4C061570
        for <stable@vger.kernel.org>; Mon, 11 Oct 2021 12:22:53 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id t11so11934621plq.11
        for <stable@vger.kernel.org>; Mon, 11 Oct 2021 12:22:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZOf/sAWEPzroSlJBKdojopB4WMke4RMtTJOnIoBdwbE=;
        b=m+Z90IHETKrruQTZ+M7oUV080yVTHMCoSHiH2eYP41kRaguAgJ6eRxt2m2dzhNmhWu
         HYxsjAICPDx7GakJOy19cgnMuKFZL+IrJwmoKcYio/XCW7xAyyIzL1BZceCtbEA4NGB3
         RlG1+iFUYVbKzES/fnL/19TJnh2DZVttG4qjH29BtA9vAxlIuJFDT1SeUusyDGWklvHL
         FoF5T3D8z/MorY4DGRB3zu4sxgIb172tw5y3hB48TaiqmaHe7lDp6CfJjUprQSSs/q4C
         q48eGwc93QJL5C8vu3J2gLEOqT12aKJ98dJDiGc9lPBnrOh3XX637CA32D9tkzqlJCEa
         UNtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZOf/sAWEPzroSlJBKdojopB4WMke4RMtTJOnIoBdwbE=;
        b=m5ByGVklSHn/J+j0CIyn1jzbbyODJTE4nszXhND65td72dSHOeKja5s/W9T39/hJyc
         BQoRHMm7hUD/7i+ylmDS3JTS/IOz2c55CWto/hsaJzuhGnVCSBdGBONTDCKXJBajp3f8
         DGidF0gdDRMD5Ops7TWAd+UwCVGuRDWqD79rBynnkGmTmFnFYkPeynKFLKn/uTyetMRD
         kE/Rb4Ok6vrO1EVAvSZhKFTtropTGbUwXxbRp6B+mfvNAd8oadCSlosTtSGeIm+nCnoH
         M++U5j+1SGm4k/NDoAXA4AyScEPwQwKBxFnj9MU4RXpWM/bkmySPiZUnWgCQLEhrX3xN
         eYfA==
X-Gm-Message-State: AOAM531kbA4dx6I7ayQ00Vg3HTeI4zW+Z9EQKmejLGQoL8YeTox3Zzyu
        DbhvmhbdUkc9EVTggPn98TWY9Q6In5vXe0kV
X-Google-Smtp-Source: ABdhPJyl02U5i64Z62KMNeBN6WSn5xTdW1GtK2rZHJhMZTvpumxKxsbaLZ8Am5/VCGmHtQKYIYR0MQ==
X-Received: by 2002:a17:90a:5583:: with SMTP id c3mr873915pji.133.1633980172473;
        Mon, 11 Oct 2021 12:22:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 73sm8630300pfv.125.2021.10.11.12.22.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Oct 2021 12:22:52 -0700 (PDT)
Message-ID: <61648f0c.1c69fb81.9883f.7d41@mx.google.com>
Date:   Mon, 11 Oct 2021 12:22:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.286-19-gdc8e8487f027
Subject: stable-rc/queue/4.9 baseline: 98 runs,
 4 regressions (v4.9.286-19-gdc8e8487f027)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 98 runs, 4 regressions (v4.9.286-19-gdc8e8487=
f027)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.286-19-gdc8e8487f027/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.286-19-gdc8e8487f027
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      dc8e8487f0272f3c6c3985a15596f58b7a79e9cb =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/616449226e756117cd90dc9a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.286-1=
9-gdc8e8487f027/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.286-1=
9-gdc8e8487f027/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616449226e756117cd90d=
c9b
        failing since 331 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61644927c86a102e3890dc94

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.286-1=
9-gdc8e8487f027/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.286-1=
9-gdc8e8487f027/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61644927c86a102e3890d=
c95
        failing since 331 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/616449166e756117cd90dc93

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.286-1=
9-gdc8e8487f027/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.286-1=
9-gdc8e8487f027/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616449166e756117cd90d=
c94
        failing since 331 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/616448d734202aa73a90dc9b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.286-1=
9-gdc8e8487f027/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.286-1=
9-gdc8e8487f027/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616448d734202aa73a90d=
c9c
        failing since 331 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
