Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4BD334B955
	for <lists+stable@lfdr.de>; Sat, 27 Mar 2021 21:34:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbhC0UeQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 27 Mar 2021 16:34:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbhC0Udu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 27 Mar 2021 16:33:50 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DC69C0613B1
        for <stable@vger.kernel.org>; Sat, 27 Mar 2021 13:33:50 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id kk2-20020a17090b4a02b02900c777aa746fso4068420pjb.3
        for <stable@vger.kernel.org>; Sat, 27 Mar 2021 13:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gS3bB7EREGuDMl5+nxboHpg9mc+v7Jd9YL7F3rvJ7pw=;
        b=obeZlz05aVJoyxJt7gHNj+hjsgnV7tyoA9Pk8BDOyH58JV5oRo1jAacgWLiuu/+JzC
         igsp5bQTEMMgV5/bXjtdTONC99B8ZOh4UHO1TqdZPMYh0YvvyeiGex/l6kN7ry8ymSMO
         IVNDWdESrtfAEl9879E7vL/4T/Bi/iLB/MtOwOPDB6S3hKrC2+d5fAjI7Vtp51cM+oxW
         kqmk5N40RcmyJGjF+63566L2x5pWz8Jd9D+weZEQ3EWP8T6qzcMKeE0KTr8ngQXTHWPE
         1pn2wYNHmD1XOgW4yN21mwym35BPerygzdDrgD8/PU4lqpagO5IAkqqleopi/ZxXC8jZ
         69zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gS3bB7EREGuDMl5+nxboHpg9mc+v7Jd9YL7F3rvJ7pw=;
        b=bRPnbzC69tCMbrHXVFrXqgHXs5QmSgTxRv4cQ4OixUHm4is91+TQ4OgHosFL3CG5fS
         He6psfEWnklYCTVL0TDz990pUJuLZYne4c3HF6IxtJRfZn3czzlDITNPLn62v5EGbG+F
         p9E4FfuDNZSoLJujwWlit/c0Yo+4POV6tX2iN6Lt5cmVVK7qDXgcS8ZqhvOaodBnbpaj
         D6avLbz7FuNiCS55zV1K/Fb3MYRpZ30C1GXshjfAVH5t386g6wfhfnixxQSUY6ARGPSU
         pIYwTF++wuRZGGw/ZljtyohiwZK6NkgtQvlpGg/5wC0fOhKVJI3vwc5eh4vn6+GhR/vr
         MF9g==
X-Gm-Message-State: AOAM5302snZVBDfWopfPZN/VuXiS1H99CpjPPIgWDQp0//NFt7XPJAAj
        gg9OQ8N3hmgUXxpgC0e0gI1xVIGhVk63jw==
X-Google-Smtp-Source: ABdhPJyk+gQSqbl2moypjMxCG9rQl+bWP7slkFPiwWyES05esISCoSZaWrsj5mQK6UgxQ0vKCoxGBQ==
X-Received: by 2002:a17:902:9002:b029:e6:c95f:2a1d with SMTP id a2-20020a1709029002b02900e6c95f2a1dmr21573900plp.79.1616877229859;
        Sat, 27 Mar 2021 13:33:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 35sm11928208pgr.14.2021.03.27.13.33.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Mar 2021 13:33:49 -0700 (PDT)
Message-ID: <605f96ad.1c69fb81.ae544.d50c@mx.google.com>
Date:   Sat, 27 Mar 2021 13:33:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.263-20-g716fc4b191f2
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 87 runs,
 4 regressions (v4.9.263-20-g716fc4b191f2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 87 runs, 4 regressions (v4.9.263-20-g716fc4b1=
91f2)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.263-20-g716fc4b191f2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.263-20-g716fc4b191f2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      716fc4b191f249247214b4d6e96b86d0a1b94dd1 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/605f5c0383f3ea08bdaf02bd

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.263-2=
0-g716fc4b191f2/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.263-2=
0-g716fc4b191f2/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/605f5c0483f3ea0=
8bdaf02c4
        failing since 1 day (last pass: v4.9.262-25-g6d1519a62408, first fa=
il: v4.9.263-17-ga851361607f1)
        2 lines

    2021-03-27 16:23:27.604000+00:00  [   20.231994] usbcore: registered ne=
w interface driver smsc95xx
    2021-03-27 16:23:27.639000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/124
    2021-03-27 16:23:27.648000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/605f599f3e6c4caaa4af02b7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.263-2=
0-g716fc4b191f2/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.263-2=
0-g716fc4b191f2/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605f599f3e6c4caaa4af0=
2b8
        failing since 133 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/605f5991512819aa2faf02b7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.263-2=
0-g716fc4b191f2/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.263-2=
0-g716fc4b191f2/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605f5991512819aa2faf0=
2b8
        failing since 133 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/605f59397fe679c166af02cd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.263-2=
0-g716fc4b191f2/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.263-2=
0-g716fc4b191f2/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605f59397fe679c166af0=
2ce
        failing since 133 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
