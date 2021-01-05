Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D7422EB0E2
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 18:04:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730151AbhAERDR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 12:03:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729656AbhAERDR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jan 2021 12:03:17 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEC68C061795
        for <stable@vger.kernel.org>; Tue,  5 Jan 2021 09:02:36 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id 30so243701pgr.6
        for <stable@vger.kernel.org>; Tue, 05 Jan 2021 09:02:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=w6bQq8DIXp0IriyMQ2+6Bgc3RqtaDjiJI3WVeOndWCY=;
        b=TzDiRKPQKyreSIyHMJ6HPCyTGwuJQvx8AGRRm68ExCUh4utS0MSMUgXDzn58Yejdlz
         KE3g12flWNJupYWD6+uwDTrCeWAmht+glC2zBYUHqsPg+USQsLuLWwijH5wdsfXFJifS
         HCvDCodlR3B0k1CWz95IR9vDPuIFzFEr8JW+gCpn1ERS2dqLo+8F914VRhSrb0Rjefos
         ZIq3q4atuHd9M6iXi4jNOr0zUjYFJfSMoyYXMJbr+yUlpM601/jEIG+JymU1pl6qzvrW
         /BkcBSlh+lbl68+f0l6TWvyMMDuaHVUwJ/qL+WVLRkNwgNRZTnA/6RY5O1ifONgUbFoE
         SHKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=w6bQq8DIXp0IriyMQ2+6Bgc3RqtaDjiJI3WVeOndWCY=;
        b=Xt1JUmRkXmVaxr83565F9k6yKihUETKboYGrC1F7IFT17/cIvAFfMCQukggMwzZPaW
         2cDt9yJMcgrJjxcuSkqJVvF7lNzvrI2t52RTJIwxjBuvrO7MS1679MfgNS7Jz1dUp5SM
         qNk/ES4EwqyCyFhZRXibAuJmTnLgAxmEPM1wgtkoHJ0RnmfGTmq8jqYEIKne7M7QcHUq
         htQf3UOGRr3YVaLl0qE+h0YMeiIwYHBax1gqpzoVp5+OHPdAR5WdcfQSc/y6sX98KIjv
         ykAHgCtWmO4/9foSlVNOAXf3jDs/Y2khKKw2pgb6GqnCd0Gist0IKF1XO0YFF5ShYQC+
         f2tg==
X-Gm-Message-State: AOAM530ov6xJeDEzvbo4eMfv97yBZLUncgUEp78z7NSXMpxOVuGSmJEr
        lHdqE/mrDNQ98fodjCWFwBuybP7WDWnN9w==
X-Google-Smtp-Source: ABdhPJyG8jxE8dsnvHRE5pmkACTwE2b0l3sQeY4i85zTKUkm3Oz0kJlww2DHNM6bJYHI1u4CaqQLNw==
X-Received: by 2002:a63:dc06:: with SMTP id s6mr278038pgg.358.1609866155942;
        Tue, 05 Jan 2021 09:02:35 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r123sm189006pfr.68.2021.01.05.09.02.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jan 2021 09:02:35 -0800 (PST)
Message-ID: <5ff49bab.1c69fb81.a9644.075b@mx.google.com>
Date:   Tue, 05 Jan 2021 09:02:35 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.164-29-g4c0bb8a87fa6b
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 172 runs,
 5 regressions (v4.19.164-29-g4c0bb8a87fa6b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 172 runs, 5 regressions (v4.19.164-29-g4c0bb=
8a87fa6b)

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
nel/v4.19.164-29-g4c0bb8a87fa6b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.164-29-g4c0bb8a87fa6b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4c0bb8a87fa6b5f3431a6e8ae66d421466a40f2d =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff467324e774a7732c94cec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.164=
-29-g4c0bb8a87fa6b/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.164=
-29-g4c0bb8a87fa6b/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff467324e774a7732c94=
ced
        failing since 52 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff4673bcc415c5b02c94cd3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.164=
-29-g4c0bb8a87fa6b/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.164=
-29-g4c0bb8a87fa6b/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff4673bcc415c5b02c94=
cd4
        failing since 52 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff4675be3599133e0c94cc2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.164=
-29-g4c0bb8a87fa6b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.164=
-29-g4c0bb8a87fa6b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff4675be3599133e0c94=
cc3
        failing since 52 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff46743d40eedbe9fc94cd7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.164=
-29-g4c0bb8a87fa6b/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.164=
-29-g4c0bb8a87fa6b/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff46743d40eedbe9fc94=
cd8
        failing since 52 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff472c2f2048abfb3c94cc3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.164=
-29-g4c0bb8a87fa6b/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.164=
-29-g4c0bb8a87fa6b/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff472c2f2048abfb3c94=
cc4
        failing since 52 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =20
