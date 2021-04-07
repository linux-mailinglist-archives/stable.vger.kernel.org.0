Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 337B0357266
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 18:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347826AbhDGQvS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 12:51:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235801AbhDGQvR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Apr 2021 12:51:17 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FD41C061756
        for <stable@vger.kernel.org>; Wed,  7 Apr 2021 09:51:07 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id ay2so9648410plb.3
        for <stable@vger.kernel.org>; Wed, 07 Apr 2021 09:51:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZiTDoSsv8AhSZccYwxujQAMsBTrFC7AECzmOESloik0=;
        b=VfwzJaACs+B5GjUUHkNV4OVFY4sX0G19VFLekVfNBXWj3jWU3Ar2HBakjQTAIVcdlC
         O9vqh4qkq8x2kxG2zsQQrdb/I3+dYvqbh+krPmMAIfZ/orJ48bCWpvjA0FuIHbGQewyU
         AZOJpV9/IAagfdKCHigtwf1n/B36BQ5XcwhHWSkOppDgLl3lSteW8p/JecuzK3aPFUTY
         ftdogl2iLOJMyXuycE6c4wDQ/c6lFlyyLGZMVR0jJ3iQ6hv+BsC1J0oEPQUkeB+X+HG/
         0Rl60DZGbm/CzAe/qWnAk7c8gqb8Q19mzsgRxuAG4yZB3hrNIRsQdqcRgVgLdFleQuCu
         X8fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZiTDoSsv8AhSZccYwxujQAMsBTrFC7AECzmOESloik0=;
        b=Av+DQiEc4PBO2PzmidLZWLXntIZ5Fj846CxyuhGMw52DF1xkFa6MdaWPHpcWoJRy2e
         lgrT2rr/ZJsD7CA+z25Ph4TIpjfjS+FoUN7PbpDise1rW/tYTpIT6rT+O8yxEqHAyao3
         B6W1RBe2Ue44O2ILrca+sd8rJTCMqIZWWagJbKhRm0od1DIMKDWOCGwq+2FYeSG4Vr/N
         OoOH4l330227AM6IcaWzirrwYvqVhuUva+tF11WRwaRE/UUkuFvZ6w6ssn/4XBV1+v1B
         FikBBc0o7YJI/R4C//SE8JoxcdaozIVHopWUrulkR9M4IUImnQpDEVR9wQO2afIzYjFt
         b3yg==
X-Gm-Message-State: AOAM531ov77qwwYZStCxepgn2XlRjs/DaWBU8kgfqWgQRVOj1+SlI8De
        Vbb5TmFY4XXMM6RkM/onX/fogWw7UJNLRkRm
X-Google-Smtp-Source: ABdhPJxrWGRNfH5xsezjQml0hRzDGVq7opUtHqHBpU42NbRBoz3wOCKEO0+IOks/ShW/Jg7yCTQI0A==
X-Received: by 2002:a17:90a:bb0c:: with SMTP id u12mr4208368pjr.234.1617814266521;
        Wed, 07 Apr 2021 09:51:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k17sm21660529pfa.68.2021.04.07.09.51.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Apr 2021 09:51:06 -0700 (PDT)
Message-ID: <606de2fa.1c69fb81.66b5c.6585@mx.google.com>
Date:   Wed, 07 Apr 2021 09:51:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.184-56-gfcf30cfb5ee40
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 127 runs,
 5 regressions (v4.19.184-56-gfcf30cfb5ee40)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 127 runs, 5 regressions (v4.19.184-56-gfcf30=
cfb5ee40)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.184-56-gfcf30cfb5ee40/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.184-56-gfcf30cfb5ee40
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fcf30cfb5ee40b5d457a392faf70715fbc4241d3 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/606da590ef86a951ffdac6c1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.184=
-56-gfcf30cfb5ee40/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.184=
-56-gfcf30cfb5ee40/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606da590ef86a951ffdac=
6c2
        failing since 144 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/606da58fef86a951ffdac6be

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.184=
-56-gfcf30cfb5ee40/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.184=
-56-gfcf30cfb5ee40/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606da58fef86a951ffdac=
6bf
        failing since 144 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/606da59bef86a951ffdac6c7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.184=
-56-gfcf30cfb5ee40/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.184=
-56-gfcf30cfb5ee40/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606da59bef86a951ffdac=
6c8
        failing since 144 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/606da527098eebab91dac6cb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.184=
-56-gfcf30cfb5ee40/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.184=
-56-gfcf30cfb5ee40/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606da527098eebab91dac=
6cc
        failing since 144 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/606da6670e5d806b93dac6b4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.184=
-56-gfcf30cfb5ee40/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.184=
-56-gfcf30cfb5ee40/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606da6670e5d806b93dac=
6b5
        failing since 144 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
