Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA03F38DECD
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 03:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232108AbhEXBLU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 May 2021 21:11:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232098AbhEXBLT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 May 2021 21:11:19 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9830C061574
        for <stable@vger.kernel.org>; Sun, 23 May 2021 18:09:52 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id o17-20020a17090a9f91b029015cef5b3c50so10291875pjp.4
        for <stable@vger.kernel.org>; Sun, 23 May 2021 18:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=paDcx1/7L4TrtEDO8x5l3XIicBzAmWPhMHf/DrBj+jk=;
        b=hYd/Yrq9NlvoMLz4fhYRueDmGorHpkBVg9+o0UpLgrpL/uPuQDv2I9E1o0CiwNc8dR
         2LXxhKwb0IBPbc9mUMYM0yAJ30APHaN0m58toOeH8gvVOrfV3JvdenI6+DIbEHW1idYe
         V/KRZiZdIz8WRXYIZFo7aInj1A1J2pgUPAZbZJpNXcQwO9LFrrhc/9n5H1+U5wl9+Lkb
         FRfTK3QnFQvHHYBFECrCv2mKdSobEvEP9k4MdfSeMnTV6MkMbhXtleSsp8RG+OWbyzsd
         Jt+Hv14B2Eq9nHmAXeK90a0xwE4YQ8/Fv+oj0+LrIRhMocQbend8snKt3IQN8Ht21LzE
         qGfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=paDcx1/7L4TrtEDO8x5l3XIicBzAmWPhMHf/DrBj+jk=;
        b=nKo3Lllcf/Ov787tjTCEjrKwHQrrTY3BB7sW0/tf1XwKemewSXkLRQpwcxwFOSCuTu
         gavUXLnmG4fYfEYANlkAxh86F0XN/ccM14WGEnpxSfjy1E6wq1z3gqwvU+NHXQi9FiCJ
         3ybS7BiEGVIsmjVvJt9xSMfVW2pyk9D9303KBVnGr7ctKjz9IaVB7SB/hacU6XZyme4s
         UTvCn216H6kuS951KBD0TtAKHkSL9RFKPSUoeIZuz0Dp7hMbx8fqVSdQse776Ejqpch8
         U3EWetgdDi68BN8yMPgjRNgPV1hqaF9leV+5Iu8C5lvUgdFoyTB32RZ+ssqW5xugJ9vc
         lhBw==
X-Gm-Message-State: AOAM533fupo6FftWEpOTeH/XdCjrrvjjNKlYLnxZF+TKuJJB7rJxnSnY
        MYhPM5Fy3L4aS/tZAaF0YjziAIC/Hy9uSfkt
X-Google-Smtp-Source: ABdhPJz2OxWrPt6wJ0POcZBOkCxUDglu1f800/E3zsYoOR0XoTEP63cQgpYu09HC7MD5EmFPVQbqXg==
X-Received: by 2002:a17:90a:8005:: with SMTP id b5mr22030577pjn.208.1621818591909;
        Sun, 23 May 2021 18:09:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c191sm9497676pfc.94.2021.05.23.18.09.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 18:09:51 -0700 (PDT)
Message-ID: <60aafcdf.1c69fb81.2d33e.0533@mx.google.com>
Date:   Sun, 23 May 2021 18:09:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.268-244-gadfb76bdfc13
X-Kernelci-Branch: queue/4.9
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 92 runs,
 5 regressions (v4.9.268-244-gadfb76bdfc13)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 92 runs, 5 regressions (v4.9.268-244-gadfb76b=
dfc13)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
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
el/v4.9.268-244-gadfb76bdfc13/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.268-244-gadfb76bdfc13
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      adfb76bdfc13049632402f0dcf3a1510dbc95bc0 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60aacb2e8e6a1e85e7b3afc2

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
44-gadfb76bdfc13/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
44-gadfb76bdfc13/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60aacb2e8e6a1e8=
5e7b3afc9
        failing since 1 day (last pass: v4.9.268-239-g6707ab3bcf1e, first f=
ail: v4.9.268-239-g7ec3767d9eb2)
        2 lines

    2021-05-23 21:37:45.525000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60aac94568f10cbe15b3af98

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
44-gadfb76bdfc13/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
44-gadfb76bdfc13/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60aac94568f10cbe15b3a=
f99
        failing since 190 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60aac9380047c4c5e1b3afb3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
44-gadfb76bdfc13/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
44-gadfb76bdfc13/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60aac9380047c4c5e1b3a=
fb4
        failing since 190 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60aac8f730bc3659d9b3afaf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
44-gadfb76bdfc13/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
44-gadfb76bdfc13/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60aac8f730bc3659d9b3a=
fb0
        failing since 190 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60aac8f1c9a9f7938ab3afb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
44-gadfb76bdfc13/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
44-gadfb76bdfc13/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60aac8f1c9a9f7938ab3a=
fba
        failing since 190 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
