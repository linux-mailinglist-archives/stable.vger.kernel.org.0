Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8DF835C457
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 12:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238968AbhDLKt3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 06:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237929AbhDLKt2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Apr 2021 06:49:28 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C847AC061574
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 03:49:09 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d8so6138171plh.11
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 03:49:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=y0jyELxx2d0xz6CuK4BkH5xO6Q3IGwjzIuYA3uRrvNU=;
        b=jxCh5iBupkb3HgrnvIME9NJUisFmOtfT55iCZHawczWZN8V1pkjhSltp5DqagpUAu8
         XVJ9/n0BSO0kXkveazF30761oJHNc+1I2tJ9XUpaMMfs923IUAwV8TByLsIlM+uqno0X
         3E+8PSVKG3NIu5dWqsQDusH+N6VdrtnkgYzoIK3eJ8qAwQk1cOsT0SeXCM04/esDKms9
         wO7afKcFgd5FIDNzlbTBooMxRaf9cCEKKXSSPra0PdaxhpgTKORa1UkhimCJbX23I3i6
         +evsrmIpA/nwsP+2f1T9edvVsLFU4i0IeLK7EWBZJjmM2sXI+uW2yjWIARTB7OgCSrgF
         NzbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=y0jyELxx2d0xz6CuK4BkH5xO6Q3IGwjzIuYA3uRrvNU=;
        b=LWcgTMRmCoZRkY/KmCSAbnfBfh1y6c2WUSAZ79462U08j6ynHoazSK8AHP/cx1V8wy
         te1AYcUrMbcVKetblD03PSw6jBjoJ5RzktJcAkciDqfsGDAviqmwxAsJtlckLdpRaYe+
         7sB2C6S2w4tkPOk2BGtha4/Cmu9APTOnEajKgpGUQWTPE4DTl02/iH4/WOlGUhWYbgHf
         D93RJGfMGay37pc8CzODjmSnMLx+dqoGjTi2c1fSUxFpaxTpF0VHh2nfNy9IivtIitj0
         auNhkY5uo9YbPMRB+sqEcTNPb8fupmQFV1ffLecEIy8byuIiags5PZNK6IdZNEkb+W2Q
         tt0w==
X-Gm-Message-State: AOAM531xMh3ZV5La08uYU7tK9yox1Syjq5Yys++0/5wLjXwnXO3rUH/Z
        VFbA/2rlbcBv4OKlyDynfl/XkSAHYViC+LFx
X-Google-Smtp-Source: ABdhPJxhgoKQsENawL5dXrI5c2AbEvuA1RK/NnY8lzwwqaaJufQkqQuk7K0rvBkYRWU7R6DqhKI6Vg==
X-Received: by 2002:a17:90b:344f:: with SMTP id lj15mr27294946pjb.98.1618224549194;
        Mon, 12 Apr 2021 03:49:09 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i14sm11143432pgk.77.2021.04.12.03.49.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 03:49:08 -0700 (PDT)
Message-ID: <607425a4.1c69fb81.903cb.a982@mx.google.com>
Date:   Mon, 12 Apr 2021 03:49:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.266-25-g4d32a2aabc058
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 96 runs,
 4 regressions (v4.9.266-25-g4d32a2aabc058)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 96 runs, 4 regressions (v4.9.266-25-g4d32a2aa=
bc058)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.266-25-g4d32a2aabc058/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.266-25-g4d32a2aabc058
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4d32a2aabc0583ab3345ce786b01f9a3728ffffd =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6073eca4c10646aa49dac6cc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-2=
5-g4d32a2aabc058/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-2=
5-g4d32a2aabc058/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6073eca4c10646aa49dac=
6cd
        failing since 149 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6073ec905939a036f5dac6ea

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-2=
5-g4d32a2aabc058/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-2=
5-g4d32a2aabc058/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6073ec905939a036f5dac=
6eb
        failing since 149 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6073ec3b3325a1965bdac6c5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-2=
5-g4d32a2aabc058/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-2=
5-g4d32a2aabc058/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6073ec3b3325a1965bdac=
6c6
        failing since 149 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6073ec50280ae80df3dac6ce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-2=
5-g4d32a2aabc058/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-2=
5-g4d32a2aabc058/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6073ec50280ae80df3dac=
6cf
        failing since 149 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
