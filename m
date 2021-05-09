Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62F4E3776E6
	for <lists+stable@lfdr.de>; Sun,  9 May 2021 16:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbhEIOGA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 May 2021 10:06:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbhEIOGA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 May 2021 10:06:00 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02967C061573
        for <stable@vger.kernel.org>; Sun,  9 May 2021 07:04:56 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id c17so11836184pfn.6
        for <stable@vger.kernel.org>; Sun, 09 May 2021 07:04:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=MgIVQRjw6P8PpjIr6a2TYGWApTuK/DY/daorA3yxXX0=;
        b=1YUkc2+fWKUqMFLkLiy/gvfD/j8Oqz7+85OjBR51bDXACDPk1dM322Fg4T/GwG6KcF
         8cE+3Jp4zQUq0jeLVjMTWyRIHJ+JgVPEWxPm8TRctgF9J3D4CThNWBMr526NPUBv/aud
         Y4ymV3HIA8HJpnqiOfi/u4n16oZxW2/shepiYC8/2G/YnfIxexYyBS9NHQllfDzvhZKP
         lhUVI4Y8Rpw5TQsbFNR8hzTE0XPaHJzJFoqKWSqhE6uGVj8PAqAVcyG5bUvzO2Wn6bDW
         SEJr/RRWseHeWUbf7Eox/UuhPsXB2CTjsuzZ8cr1GVRvIInh0GAiABwl0cu49N3sOWet
         qY1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=MgIVQRjw6P8PpjIr6a2TYGWApTuK/DY/daorA3yxXX0=;
        b=UMwh85aneQT56oLXp1U8tdm9ijp9IwN7Gd20xbTxtzNTYATKCDPcggmfoNI7C+mRqW
         oBsLQdmYvMk6mVadNN+22VDLuHWJkYURRaOXm2B0REa99Vq57U19CpLWkENLsswQuwgW
         3DsGDrLb7fSmVSugweHXQwiZWyctXzAhSY1wiZL1WKgGbB/Z3Rfmk0sDBuGlmk6Bz4fE
         nRnvCXCjEYim6c3tw7Knqu65U2mOY1lWnxPa8Jzz+w4czFLZwL1aocgMPhRuJNiMaPoe
         Nj0yodonXcqEmXWMyZdpKhi8YypdUfaJz7JX+HYR4AP5WUE/Fv3ZdL8fiuFSygMgfZn3
         Y5QA==
X-Gm-Message-State: AOAM531tudcNoPQx25jviTYV4BTkhx/GqjA8EObxea7tySefptWherrm
        7JJZYxrETCp0EPuwrQv+6GtfRHCfDgAzX8mh
X-Google-Smtp-Source: ABdhPJykK3NVRmcYwlcKVaTWY77nMBOi+zqH2LW1Wre9I7m4QCdIrYmhzsxSHHwRLS1DQU4aDPerww==
X-Received: by 2002:aa7:86d3:0:b029:291:cb2d:f91d with SMTP id h19-20020aa786d30000b0290291cb2df91dmr20378586pfo.57.1620569096172;
        Sun, 09 May 2021 07:04:56 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x22sm8981222pfa.24.2021.05.09.07.04.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 May 2021 07:04:55 -0700 (PDT)
Message-ID: <6097ec07.1c69fb81.246bd.b877@mx.google.com>
Date:   Sun, 09 May 2021 07:04:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.268-50-g6fe0e181c8ae
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 114 runs,
 5 regressions (v4.9.268-50-g6fe0e181c8ae)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 114 runs, 5 regressions (v4.9.268-50-g6fe0e18=
1c8ae)

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
el/v4.9.268-50-g6fe0e181c8ae/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.268-50-g6fe0e181c8ae
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6fe0e181c8ae730d5b1a3c19337dd6f2c5640b4a =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6097b943e9a0e469666f5467

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-5=
0-g6fe0e181c8ae/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-5=
0-g6fe0e181c8ae/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6097b943e9a0e469666f5=
468
        failing since 176 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6097b8f1992e5284d86f5472

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-5=
0-g6fe0e181c8ae/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-5=
0-g6fe0e181c8ae/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6097b8f1992e5284d86f5=
473
        failing since 176 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6097b913f4cf1f9d126f548c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-5=
0-g6fe0e181c8ae/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-5=
0-g6fe0e181c8ae/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6097b913f4cf1f9d126f5=
48d
        failing since 176 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6097b95b94e28f3e536f5469

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-5=
0-g6fe0e181c8ae/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-5=
0-g6fe0e181c8ae/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6097b95b94e28f3e536f5=
46a
        failing since 176 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6097bf77ce68cd32576f5513

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-5=
0-g6fe0e181c8ae/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-5=
0-g6fe0e181c8ae/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6097bf77ce68cd32576f5=
514
        failing since 176 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
