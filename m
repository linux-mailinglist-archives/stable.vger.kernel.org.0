Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB35F32FB7A
	for <lists+stable@lfdr.de>; Sat,  6 Mar 2021 16:49:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbhCFPsi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Mar 2021 10:48:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231138AbhCFPsZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Mar 2021 10:48:25 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84FCCC06174A
        for <stable@vger.kernel.org>; Sat,  6 Mar 2021 07:48:25 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id j6so2884517plx.6
        for <stable@vger.kernel.org>; Sat, 06 Mar 2021 07:48:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=uLqn6RGbexlnmM+9wVM9nahq2kou3WUNXAE39vjAltk=;
        b=E0aUrKh21n+VFm2cRQLsZGOS3Auy6Wk+cOo5Y91gLLvbLO4QKT5b9s+OvZPDjUfOhz
         Z8easNXbqxSnSXWKOV4HbEr5i1AhUUZ9PXpGlWxLh5IG3nvuUr+9HY73FucM8BDdh66K
         W2/cFYutRByE7LdtKJRNyyRBaMQ2IZ1FHvHJ32T+hNQQpBlN5Oj+LsTRgVC9GoKHG/Bb
         0G460hZUqzJHLtRCpZaE6qQswknjkhbnryzHFR/vuclDU1mvTlKlsZxcveLX8EKqYJ04
         Brg5Zp8sy9UDF7ObYZeeU41fphqdYIx5Ke6MqUryhIkL/ELT+ia04y5je29sk6y+xOJQ
         bnbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=uLqn6RGbexlnmM+9wVM9nahq2kou3WUNXAE39vjAltk=;
        b=gU/QZIXE61JEPfCV+DLlEbz3OGJdwJyHY/ip0Db9JWEDzViqIyKRJ6nqXqKbNwI2Sr
         UePiyR5v39x/A8W6z/OUn+6KyA7TlQthj2MuNUwlNvnhwsNFaL1nLMIBpRpzqC4a1pgS
         LQx6WjIBp3kUfQSeSogaBFdgQuxVmknpaKdsXiV98zl4VM6klNKDNTEqAUe9sjmgo3nS
         3iOX1CGYaw3L8xTYSnZ1DcFEThitpxMEdDgZ6NtxHFtL6CLIdmH3FM+KAR43z0MGrJew
         pzNZuYhKCsLVdzrqMMPXYNXER5whYfahBXaq7pU0Akwg3rxv5jeGPPk3aW9idsCQVPi8
         3iCQ==
X-Gm-Message-State: AOAM533Dbw/NzMO/pGoePhf/aruQRbD7tPQQUnUYL5DhxsmdcyKW70Zt
        w2HWk7UkfzU6uWtkH5H4OBohR0KxPcUlFQ==
X-Google-Smtp-Source: ABdhPJzfgGUFoi6V8sod43IpqK1MToCkQLT6zn7ZR+hBemmdA92xkyVHrKulaiozpdowg1qZG7Z/eA==
X-Received: by 2002:a17:90a:f28e:: with SMTP id fs14mr15835474pjb.100.1615045704725;
        Sat, 06 Mar 2021 07:48:24 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s11sm6092732pfc.87.2021.03.06.07.48.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Mar 2021 07:48:24 -0800 (PST)
Message-ID: <6043a448.1c69fb81.f7a72.f667@mx.google.com>
Date:   Sat, 06 Mar 2021 07:48:24 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.102-72-gfa5a83a1f51b0
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 114 runs,
 4 regressions (v5.4.102-72-gfa5a83a1f51b0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 114 runs, 4 regressions (v5.4.102-72-gfa5a83a=
1f51b0)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.102-72-gfa5a83a1f51b0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.102-72-gfa5a83a1f51b0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fa5a83a1f51b0d7f091d4f22be6b6b6fc9823417 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604375610663287066addcc9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-7=
2-gfa5a83a1f51b0/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-7=
2-gfa5a83a1f51b0/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604375610663287066add=
cca
        failing since 112 days (last pass: v5.4.77-44-gce6b18c3a8969, first=
 fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6043784a316d9867c6addcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-7=
2-gfa5a83a1f51b0/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-7=
2-gfa5a83a1f51b0/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6043784a316d9867c6add=
cb2
        failing since 112 days (last pass: v5.4.77-44-gce6b18c3a8969, first=
 fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604371c368695972adaddcb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-7=
2-gfa5a83a1f51b0/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-7=
2-gfa5a83a1f51b0/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604371c368695972adadd=
cba
        failing since 112 days (last pass: v5.4.77-44-gce6b18c3a8969, first=
 fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604371c91c02f6a7daadddb8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-7=
2-gfa5a83a1f51b0/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-7=
2-gfa5a83a1f51b0/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604371c91c02f6a7daadd=
db9
        failing since 112 days (last pass: v5.4.77-44-gce6b18c3a8969, first=
 fail: v5.4.77-45-gfd610189f77e1) =

 =20
