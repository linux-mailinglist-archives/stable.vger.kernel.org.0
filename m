Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 696D7355D10
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 22:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245473AbhDFUoU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 16:44:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347211AbhDFUoT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Apr 2021 16:44:19 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0078CC061756
        for <stable@vger.kernel.org>; Tue,  6 Apr 2021 13:44:10 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id l1so8165877plg.12
        for <stable@vger.kernel.org>; Tue, 06 Apr 2021 13:44:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TQJSZKvvInRahIXqnhXk7Vz5BNxfev/6ASc3EYzqbPA=;
        b=bXYabgJ7MV/n6HO6y9UKqDnlDL/UMnu/GVp+9tDUuv1xzF0tFgKx+aQv3kkmHV6TFI
         rLiDpsnr9uDsjjlFVDuF/GabwXNPvKWGzvZfCcjiUkftTkX9j4mzpJ1zw4Ru1e8JI+Q9
         LeSGUcNnt+h/ul7v2mo00WxSwC4hTLhlR9JxVKxjNRILNHOFSWQFC0HDDOmQTajUxFQE
         a7wqmqrfc7JyplCEPKurcstn+DfKk6OdiKH6WxgrpSeafMvKrvoZFLfflLShBpQvI7bj
         WIuJ27caNKvvoUXYzZykli70S2wHCIB9/OY2YtTVP5eCn9hsI7SsNhO0mfzkeGjD2nl0
         G1lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TQJSZKvvInRahIXqnhXk7Vz5BNxfev/6ASc3EYzqbPA=;
        b=QR1U/OQUGrYv59Y4lubBh6EsEqgsErMN6t0p95nMf7VF6jdN4ZV9YLBFn5IXmjTmCd
         w92eJdWGKRqMczZEtGBYEbV1gR/pJx/YEQR5pJuEAPzoHk+MHJ3dhlKCvyDWy+t5sXrm
         KC7E7ZcIFQN47ZrdXY3GFaOFDK8/avz4nid6OSO33ewloTj9cf238+u/Tsb/VB/f6rBT
         n3w9JiDSOT22Qj32xMUSJpc/f07153ccQZi/qytW2HWDprMu2t/SaRAj3uY0GTmJIvbs
         Y5SgNkQ+P1hfnwkqRcNhURRPUO888aDtcpZ/ZGJvXa4OnoLNFWjZZIGUhaZm0DA7jJSN
         vhIA==
X-Gm-Message-State: AOAM533wA1znmgb0+4Zmp0Lk5yy13p5DAU6cB96IU5/c6NCcrDwu9eTM
        80zQhHnTpyeIgXTDXUnKLAIkytGDKuoNWA==
X-Google-Smtp-Source: ABdhPJzYptMixukbOagOqMMJo4yzv3tbWuekrak1q5DaD91edi3ZuBkIsRogyIu37RYWdlHMG6Wtlg==
X-Received: by 2002:a17:90a:1509:: with SMTP id l9mr3150pja.163.1617741850289;
        Tue, 06 Apr 2021 13:44:10 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a15sm3074942pjs.47.2021.04.06.13.44.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 13:44:10 -0700 (PDT)
Message-ID: <606cc81a.1c69fb81.ef403.8b48@mx.google.com>
Date:   Tue, 06 Apr 2021 13:44:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.264-35-g1ffb19313be9
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 97 runs,
 5 regressions (v4.9.264-35-g1ffb19313be9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 97 runs, 5 regressions (v4.9.264-35-g1ffb1931=
3be9)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.264-35-g1ffb19313be9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.264-35-g1ffb19313be9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1ffb19313be9928a46c6f8b29d75dfc4b27ea526 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/606c9418ee962a3d9bdac6f4

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.264-3=
5-g1ffb19313be9/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.264-3=
5-g1ffb19313be9/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/606c9418ee962a3=
d9bdac6fb
        failing since 0 day (last pass: v4.9.264-24-g1d82835a5e4b, first fa=
il: v4.9.264-35-g9e8200f3a1d22)
        2 lines

    2021-04-06 17:02:12.405000+00:00  [   20.380126] smsc95xx 3-1.1:1.0 eth=
0: register 'smsc95xx' at usb-4a064c00.ehci-1.1, smsc95xx USB 2.0 Ethernet,=
 46:3b:c7:e8:d9:3e
    2021-04-06 17:02:12.412000+00:00  [   20.392791] usbcore: registered ne=
w interface driver smsc95xx
    2021-04-06 17:02:12.454000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/123
    2021-04-06 17:02:12.463000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-04-06 17:02:12.479000+00:00  [   20.456756] <LAVA_SIGNAL_TESTCASE =
TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/606c91055927f1e631dac6c3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.264-3=
5-g1ffb19313be9/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.264-3=
5-g1ffb19313be9/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606c91055927f1e631dac=
6c4
        failing since 143 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/606c9111fe3b829fbddac6c2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.264-3=
5-g1ffb19313be9/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.264-3=
5-g1ffb19313be9/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606c9111fe3b829fbddac=
6c3
        failing since 143 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/606c90b093cd2eb6c0dac6c9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.264-3=
5-g1ffb19313be9/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.264-3=
5-g1ffb19313be9/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606c90b093cd2eb6c0dac=
6ca
        failing since 143 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/606c90b553488a068fdac6d0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.264-3=
5-g1ffb19313be9/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.264-3=
5-g1ffb19313be9/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606c90b553488a068fdac=
6d1
        failing since 143 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
