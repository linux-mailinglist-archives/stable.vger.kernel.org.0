Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD7F48EF03
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 18:09:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243712AbiANRJY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 12:09:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243689AbiANRJY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 12:09:24 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14A68C061574
        for <stable@vger.kernel.org>; Fri, 14 Jan 2022 09:09:23 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id n16-20020a17090a091000b001b46196d572so748589pjn.5
        for <stable@vger.kernel.org>; Fri, 14 Jan 2022 09:09:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=AgD5N2FHeLGGylQ6UMFfHvGbOVKjNxRNAC5Rbn4VJdo=;
        b=IuPxvO6fJZEszVRyM8u8u/uWEECyYbLDYPSU3B4+V+174UhHNm8UZ6HWp684u1yFkP
         5qkNY9gBAdULBAb6gJe+WhVxqwGfaKGp3MiUz2CSgHJt9KNhhqhaA0LkJvZsR1Cr2/u2
         md2jDLOinyN+Wh4ND20GmkNUfqsSqFiCC7qLe/pfbWVnTR4R2ezz0tb1BoyQ0Z3OCOG6
         Do7jQ0VFnre4tPHM9ZUUK2jCiA+DbpF+/iIw25l7+bmC3PK8efzjxHEIiqfPWu5vrbgX
         ppIBKfog0IEMqIp6+U/+9uV9dZWE77FHo/c3ahKU2LhPuZMgHlAiKnaZaGJ2XGgMpwwA
         BgRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=AgD5N2FHeLGGylQ6UMFfHvGbOVKjNxRNAC5Rbn4VJdo=;
        b=42zsyz2119mviGMT8ZkcNkCpMK5mBxo3TX0MUPBcu1lFIGe+vP6Sjx/cE/sKKKNMvh
         phYR3rXzN98kNzSH4Z1YP3uXRfLojx9yu4QgDfazfIGr8zhuH8TAakfig4wWsFDXREkb
         KlwXBYkvIxqWOvf/eJnoYKm5ArDW9txFOiBTQy8TTRZpcU1jcx/mVc0C9301+cvXknCU
         uxtmIk1Fke8hhtBau0fRDrM1wUYZzM/BMY/C4n2nx5+cFhNXObIokpxrwG/SfuOTuVX+
         5hMUjdQsxMulWNXnpCusTwMDEqbR2Son2190fAslHqNfnqJW56N2OY5IOCjbZDbc3tN3
         Wlww==
X-Gm-Message-State: AOAM5300mFLNgK/hAUj1F8eoUVMWUzzaCC9mJPDc7BjK21mrJP7+vdZp
        nLxWrMsztsz2m+Z33GOahp21J6oJZ4qOiinK
X-Google-Smtp-Source: ABdhPJyC0PH2I3uCP+gBr38nq55gZsPS7IXCppDXdUCORkQSC7mS+OmeBeCOCozUiX7+4jz+j+CAcQ==
X-Received: by 2002:a17:90b:1b0d:: with SMTP id nu13mr1224940pjb.172.1642180163028;
        Fri, 14 Jan 2022 09:09:23 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d10sm5274427pgu.8.2022.01.14.09.09.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 09:09:22 -0800 (PST)
Message-ID: <61e1ae42.1c69fb81.1def8.ec03@mx.google.com>
Date:   Fri, 14 Jan 2022 09:09:22 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.171-18-g3dee1d55db13
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 148 runs,
 4 regressions (v5.4.171-18-g3dee1d55db13)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 148 runs, 4 regressions (v5.4.171-18-g3dee1d5=
5db13)

Regressions Summary
-------------------

platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.171-18-g3dee1d55db13/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.171-18-g3dee1d55db13
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3dee1d55db130e4746ce2d5a0796672646a8934f =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e17b084f9dd5c739ef6752

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-1=
8-g3dee1d55db13/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-1=
8-g3dee1d55db13/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e17b084f9dd5c739ef6=
753
        failing since 29 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e17b072f660ffe10ef6742

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-1=
8-g3dee1d55db13/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-1=
8-g3dee1d55db13/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e17b072f660ffe10ef6=
743
        failing since 29 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e17b07ccb6b94e22ef6750

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-1=
8-g3dee1d55db13/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-1=
8-g3dee1d55db13/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e17b07ccb6b94e22ef6=
751
        failing since 29 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e17b05ccb6b94e22ef674d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-1=
8-g3dee1d55db13/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-1=
8-g3dee1d55db13/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e17b05ccb6b94e22ef6=
74e
        failing since 29 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =20
