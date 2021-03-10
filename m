Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B42813346DF
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 19:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233514AbhCJSeM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 13:34:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232790AbhCJSeK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 13:34:10 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C96DCC061760
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 10:34:10 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id w7so5420473pll.8
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 10:34:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rxBewOCr/Eomz8RwdMrkdouBAPfe6DVqX72n17GoSGY=;
        b=r69PtFARf1Q+b8srShCKno75B5oJHSy7/OutbtAyXUdEKFe8r1yTJM+OgD3OiOVYgd
         hyDJS58MvHxknc4L9OlBG3WsKfsoLR8Tsaw8NQ88SgAdVBwZ2CJ6nmxI/jh85LoQsEzV
         LF0lIr1Gbz6VYl6ojnSgTS6gnFWx2HjNMX74h2Fpo7ZKmObZ6YtmFUe8gYV15tPPZUeD
         0ysNa64LGbRqjVou+yxf3XuZqAtDZAE/XFSC6sQIcsvCpR1BZ7e+mexUH+Jwolm6l3N6
         4CeS7U4jtPmrd+gkohSzUo/G2vV6K+jOcAhcGibTFaBkf5txCSw6drMYhDH3GHisAxl1
         /tMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rxBewOCr/Eomz8RwdMrkdouBAPfe6DVqX72n17GoSGY=;
        b=H9L1HLte5JWkU0h99mcs0wu80DCdhkXBQGT1p4Ezkek+96EYu7Klq0NuISD/RI+CZY
         E5v/9jFC7rt/pNtT3X2WgdSq2Td+x7c4YRndEsLbYFlicdSGnbNZJQkCC33NBvFVNYAa
         HienqJBODEoQ7EMLQgDCM4UE0zXBY237ilgjtaU0M5OmJcc6WFFW9fTuPIxZPy4rmswu
         jgNsoIa95anNr7fyo/LmcSG9fqO2F7Zy9Q+snHIkJQOXDQ7qS+ag95neuyIOYsVT/UEJ
         M1ffKgGvyup+0pkV1Zxl8zzrz1SKIHWKMg3F8/PLREx3l1pHPLAw21a/1JjKQKWLKRlQ
         41sw==
X-Gm-Message-State: AOAM532npfRzlHxUwTFTiQgHJeXyNohTz7NEFLd1cz1fT0GYpTOI+fu4
        a/NqEHVkhQyE60Sb7hY1+Dq8OcTFGsNtx82g
X-Google-Smtp-Source: ABdhPJxPy4g2CQmD6uZKlg5oXycLYfsycLJach7CCptBM+5Ye0A+WWTA2BNLeAQchX4wt6wBInx4gg==
X-Received: by 2002:a17:90a:4603:: with SMTP id w3mr4970822pjg.125.1615401250150;
        Wed, 10 Mar 2021 10:34:10 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r186sm205579pfr.124.2021.03.10.10.34.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 10:34:09 -0800 (PST)
Message-ID: <60491121.1c69fb81.84080.0b5f@mx.google.com>
Date:   Wed, 10 Mar 2021 10:34:09 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.224-20-g23c40a6cdbfe
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 80 runs,
 4 regressions (v4.14.224-20-g23c40a6cdbfe)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 80 runs, 4 regressions (v4.14.224-20-g23c40a=
6cdbfe)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.224-20-g23c40a6cdbfe/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.224-20-g23c40a6cdbfe
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      23c40a6cdbfe00b2b187285ff100fe426b5b565e =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6048d9eabf7a232e30addcba

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.224=
-20-g23c40a6cdbfe/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.224=
-20-g23c40a6cdbfe/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6048d9eabf7a232=
e30addcbf
        new failure (last pass: v4.14.224-6-g893f1fb0db77b)
        2 lines

    2021-03-10 14:38:30.517000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-03-10 14:38:30.532000+00:00  [   20.707336] <LAVA_SIGNAL_TESTCASE =
TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6048d776f2fbedcd4aaddcbf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.224=
-20-g23c40a6cdbfe/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.224=
-20-g23c40a6cdbfe/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6048d776f2fbedcd4aadd=
cc0
        failing since 116 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6048d7d332e98113f5addcd3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.224=
-20-g23c40a6cdbfe/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.224=
-20-g23c40a6cdbfe/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6048d7d332e98113f5add=
cd4
        failing since 116 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6048d5cfad608e259eadddbe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.224=
-20-g23c40a6cdbfe/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.224=
-20-g23c40a6cdbfe/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6048d5cfad608e259eadd=
dbf
        failing since 116 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =20
