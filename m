Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 083144A8F62
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:53:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233383AbiBCUwl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:52:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiBCUwk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:52:40 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCC15C061714
        for <stable@vger.kernel.org>; Thu,  3 Feb 2022 12:52:40 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id c9so3248228plg.11
        for <stable@vger.kernel.org>; Thu, 03 Feb 2022 12:52:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=r0qjNwjYbB8CZG2VrnGdwmG4sE+eZFqNq89osQnkFeM=;
        b=TEe/9RBJ36K8Iq4xRiTlrxkgAKluc55XHF7kDjZmsj15Oj/+2HSx88pztobaLr+JkB
         rh9f8F0UTEaPD+GQYTTqji6rd9AviN2vR8gqhiGrw+AL89gZ7mcDHHTvRqvcNojAIJj1
         1jtLuew9lCLO5OwfqsmLd9IptBuGgPkxFTwpkGYviXAzT7jUE979VxKC3vuNEUGMfxYf
         dOrjcljQy1QQwNs+R+h7WqF5my7KLrISlBKZW1nyigMu4KgmtLGNyb/jXRKwZqI74XoU
         rVDKuR7ZthMtvsOSOzxI9iSAdN+6BjxO0++10Fsuv0AKgaE0ngg8qnOVzuuYkwOXijCx
         8Gbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=r0qjNwjYbB8CZG2VrnGdwmG4sE+eZFqNq89osQnkFeM=;
        b=qhzmFT3N5ftiesIfQ0TTgw+gIUp2M/z0CB2NGH3e2KFbozRgVqsH/iQqn304H4NEyl
         UEn6ukPVSXmmiHKw6NbKzO3gmgCrT1iN4gueenTPTzSlcE96lTwF27u9vysxMvmQyL/e
         pbNDK9Q/kf4e5iWPbaX2ic9qyTWLi0LlxVKYKgZ6m4Xkekr+V713LUtGJ1QJBNGIhUaA
         i0XtelHw8w3zuXXqsYsyizbTIbynEfhPYbkBuMDwSmqkUV08pLfxOJlSBp6Lzelovk3c
         dsFnugppe19zjf5VjfihzjWJ/KJaG5YaqzrHmN88VvhhLrcekX0+FoW6GSasENVWfD+q
         AkqA==
X-Gm-Message-State: AOAM530Kz8lLAcdIP/GP76D3vQ8XCU3Uscw2J4QXmAQNwnT7DO4CZ7eE
        /XpQOuAbrrBeBd0MS1DS9ntJaFf2WMgBGfj/
X-Google-Smtp-Source: ABdhPJwfGLXzC2fFq4tPtgM3V87lKjyyqhEbKHZa2FFA1p1tee2M1+Us0Cag/a35QC3mz2/M8cYOxg==
X-Received: by 2002:a17:902:8490:: with SMTP id c16mr36976334plo.129.1643921560224;
        Thu, 03 Feb 2022 12:52:40 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g22sm27257807pfc.177.2022.02.03.12.52.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 12:52:39 -0800 (PST)
Message-ID: <61fc4097.1c69fb81.ae378.50cc@mx.google.com>
Date:   Thu, 03 Feb 2022 12:52:39 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.176-1-g5b3899c531c6
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 150 runs,
 4 regressions (v5.4.176-1-g5b3899c531c6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 150 runs, 4 regressions (v5.4.176-1-g5b3899c5=
31c6)

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
el/v5.4.176-1-g5b3899c531c6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.176-1-g5b3899c531c6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5b3899c531c6a94be7a1792da2c25b3e8a3ff0d4 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61fc0da7a08e1a63e15d6ef6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.176-1=
-g5b3899c531c6/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.176-1=
-g5b3899c531c6/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61fc0da7a08e1a63e15d6=
ef7
        failing since 49 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61fc0a372f23c98ca05d6eeb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.176-1=
-g5b3899c531c6/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-=
virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.176-1=
-g5b3899c531c6/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-=
virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61fc0a372f23c98ca05d6=
eec
        failing since 49 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61fc0da8a08e1a63e15d6ef9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.176-1=
-g5b3899c531c6/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.176-1=
-g5b3899c531c6/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61fc0da8a08e1a63e15d6=
efa
        failing since 49 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61fc0a382f23c98ca05d6eee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.176-1=
-g5b3899c531c6/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-=
virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.176-1=
-g5b3899c531c6/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-=
virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61fc0a382f23c98ca05d6=
eef
        failing since 49 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =20
