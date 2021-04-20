Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 131B1365918
	for <lists+stable@lfdr.de>; Tue, 20 Apr 2021 14:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232226AbhDTMk1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Apr 2021 08:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232216AbhDTMk0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Apr 2021 08:40:26 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AAD0C06174A
        for <stable@vger.kernel.org>; Tue, 20 Apr 2021 05:39:55 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id y22-20020a17090a8b16b0290150ae1a6d2bso3451206pjn.0
        for <stable@vger.kernel.org>; Tue, 20 Apr 2021 05:39:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=eSNZB1pb32eepQ8mbIG70uAD3lt2EUpuQFOZeCFEPbg=;
        b=UwoZbg7WQCim6D/HBBMZF3nrkf1ZvlyaaHmYogrOvk3sRr0f39PeMfUJiLgp7aj/Op
         FdQ4SOyBry3DDTp2wdWN6aIxlOT/l9pQyJtpkyfZXPWtK49s375mLavrevspSKmLWx1P
         6XsAhZ4dGrnC97Oy1/o55W48N0vSlRYrZwNMA7+MSdIXKVd9uyzHKWuyBQWfykQNEhIT
         68B5RLLA400uPZqOt5DkIXK6WZt0oQmfEkmcikb8jkrj1oxuE5JUTghHdAPDOYLvUHPK
         m0bRz7coSi7r5Eh6rQEKCYCsfDskTORxsjWY1A0xwOxOS7ZA6X1f0Wx1Unqqy1QFC/6R
         uM9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=eSNZB1pb32eepQ8mbIG70uAD3lt2EUpuQFOZeCFEPbg=;
        b=DchZVtU7ACH/CYDpDYeADUVy9w8kQtCigfsR9/Q2hvmaKuQSH81xrb+CdpcpeqTOo/
         lU8aLm5C5vgy9P8k7q4JGlnTw6xauSJTlPSZ7DMKwHRoxjhMccRMoC49Em2+fNIKJhC3
         2GKdsVzARItOSDS2YMmbVpVrCtbxks56+X8KEXRL1ahuoSkgHzo/K3QzJlo8eMDsoTKK
         vEl3kzCjIT0D3gw7+RvJmrwa/Dqq8IYfm1jadURalMuKfvft1D5Y5xF5hnaS3MT1dNeu
         gzdrFQbwPfCvUE1E7OTP4RLnaSVW4gI3QNEFQh3COP0i4hnsnbOqkvR9ffSsT3SKzogl
         Tr8w==
X-Gm-Message-State: AOAM5323s1WC2J7sRDznmBHbh3Oz+Epn2sdco8/ksMnBSOWKHP6atnxy
        UGq3jxpwfwn2EXwRAp/Rx+FtvybgBBFtOoBM
X-Google-Smtp-Source: ABdhPJx0Hkun04Rf6/89qEOkXOZmSQLgKJzeWIvcW3z0Vy7cpZFD8eNzLkyLcMFbYLTIaGJdcBXi/g==
X-Received: by 2002:a17:90b:238d:: with SMTP id mr13mr4864525pjb.23.1618922394665;
        Tue, 20 Apr 2021 05:39:54 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o9sm16748165pfh.217.2021.04.20.05.39.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 05:39:54 -0700 (PDT)
Message-ID: <607ecb9a.1c69fb81.3552a.a4b3@mx.google.com>
Date:   Tue, 20 Apr 2021 05:39:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.231-34-g0c727f7ac0aa5
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 110 runs,
 5 regressions (v4.14.231-34-g0c727f7ac0aa5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 110 runs, 5 regressions (v4.14.231-34-g0c727=
f7ac0aa5)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.231-34-g0c727f7ac0aa5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.231-34-g0c727f7ac0aa5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0c727f7ac0aa50cafb7635c6713ba30eb7720203 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/607e97d21ce0a469219b77a7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-34-g0c727f7ac0aa5/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-34-g0c727f7ac0aa5/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607e97d21ce0a469219b7=
7a8
        failing since 157 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/607e97b7f1e29c44dc9b77fc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-34-g0c727f7ac0aa5/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-34-g0c727f7ac0aa5/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607e97b7f1e29c44dc9b7=
7fd
        failing since 157 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/607e98984c1caffe899b77ae

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-34-g0c727f7ac0aa5/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-34-g0c727f7ac0aa5/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607e98984c1caffe899b7=
7af
        failing since 157 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/607e975c7007c46d569b77b9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-34-g0c727f7ac0aa5/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-34-g0c727f7ac0aa5/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607e975c7007c46d569b7=
7ba
        failing since 157 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/607e97349ecb57b9279b77ac

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-34-g0c727f7ac0aa5/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-34-g0c727f7ac0aa5/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607e97349ecb57b9279b7=
7ad
        failing since 157 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =20
