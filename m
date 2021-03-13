Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CCB5339C30
	for <lists+stable@lfdr.de>; Sat, 13 Mar 2021 06:41:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230380AbhCMFke (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Mar 2021 00:40:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbhCMFkR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Mar 2021 00:40:17 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B80EC061574
        for <stable@vger.kernel.org>; Fri, 12 Mar 2021 21:40:17 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id cl21-20020a17090af695b02900c61ac0f0e9so151099pjb.1
        for <stable@vger.kernel.org>; Fri, 12 Mar 2021 21:40:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=J3COEjAE/ebOkQks5vpKRyqyaVNkOw0t+ccBkcm6ND0=;
        b=qLYhRSI5EkWOLqys79K6mM5qllE0Zun2BAO4GPZZkKS7Ael6w4j4XNmE5dQw52tLNm
         ANEMkP7VQR9JUU8P/bN6wB+BrL0CFSj0fxa9jAXQNaoyAeZiT/Cbn40Yw1wnTxvEQIBd
         YutAsQXDSPxke31ckcB2jUhZgJ1unibEHBJVGm7wO6jQYNny3Flor1739L2Y2EMGvfSC
         1c1/RDICQ0F2dyFbdNSLBIKVakEdLSd6coXt51wbDLIBCwvSADHFBJm0r3YkwkBFvMlm
         pBhSTldXJkhMFmuoQdBIN52CnuP3lQ/qo0Z37C8YuSsGp/UMLstVEkQltTXzr20g79GJ
         4Q+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=J3COEjAE/ebOkQks5vpKRyqyaVNkOw0t+ccBkcm6ND0=;
        b=lbGjt+vjkW76huSBdgZtFzss1mFY5kLWFDzno9nXcXffpJlW3mI9Jp1PBasI5q4spz
         69wwtNZaJOQhTYrB8yOuTmkeEuL43RpuLKYr0rJU1nbBZDpUV7ZZVyA7PZcjvHRCIfZe
         Yd/G4jymJs5frj9ZUhT8SDtERY6KUoivHDuNjqsdruji3N9xKAXicmDowT2Y98R9hWyG
         FQ5B3nYVAnBo0AYxeplQ4pqYpP/gjuLbpW4vGnupf8SkeQrBZoqndYRAsIuyOWLiuelQ
         k4KsbftaEOxnQVnMZpEa2gjiyQeVZSd/XUVhUsgwAI42PbhLRQyfqcZjew0dTkqvLNgs
         aauA==
X-Gm-Message-State: AOAM5312YH1fWW39kyWA2hozNmC1qUAkZFrFtWcst71Jyjx20yFo8WgD
        XA8nz2NVpBmxP0/anXs3JChlVdKCtNMuhw==
X-Google-Smtp-Source: ABdhPJwyTdZAIdzbg/hQoMbIGjY+po8nvQLTVprH658J7cfnE9CRhgzbSMKnEgenuolUwmMkzroW9A==
X-Received: by 2002:a17:90a:f40c:: with SMTP id ch12mr1952251pjb.176.1615614016539;
        Fri, 12 Mar 2021 21:40:16 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w28sm6876840pfi.119.2021.03.12.21.40.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 21:40:16 -0800 (PST)
Message-ID: <604c5040.1c69fb81.80efe.2f12@mx.google.com>
Date:   Fri, 12 Mar 2021 21:40:16 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.180-41-g25e4295fb935
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 106 runs,
 5 regressions (v4.19.180-41-g25e4295fb935)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 106 runs, 5 regressions (v4.19.180-41-g25e42=
95fb935)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.180-41-g25e4295fb935/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.180-41-g25e4295fb935
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      25e4295fb935ee0c9a882f9dfbae03dfeb490521 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604c19cc97ec169a36addcb4

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-41-g25e4295fb935/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-41-g25e4295fb935/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/604c19cc97ec169=
a36addcb9
        failing since 0 day (last pass: v4.19.180-18-g4334f738815bb, first =
fail: v4.19.180-40-g3f0127cea9d86)
        2 lines

    2021-03-13 01:47:51.684000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/109
    2021-03-13 01:47:51.693000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-03-13 01:47:51.707000+00:00  <8>[   22.821197] <LAVA_SIGNAL_TESTCA=
SE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604c161fbb50b71adfaddcc9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-41-g25e4295fb935/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-41-g25e4295fb935/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604c161fbb50b71adfadd=
cca
        failing since 119 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604c168202ed7d0c0caddd16

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-41-g25e4295fb935/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-41-g25e4295fb935/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604c168202ed7d0c0cadd=
d17
        failing since 119 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604c15c26cdd918b3baddccd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-41-g25e4295fb935/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-41-g25e4295fb935/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604c15c26cdd918b3badd=
cce
        failing since 119 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604c15d0a394527d5daddcb4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-41-g25e4295fb935/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-41-g25e4295fb935/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604c15d0a394527d5dadd=
cb5
        failing since 119 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
