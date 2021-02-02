Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4239C30CD4D
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 21:51:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233312AbhBBUuf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 15:50:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233209AbhBBUud (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Feb 2021 15:50:33 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD23DC061573
        for <stable@vger.kernel.org>; Tue,  2 Feb 2021 12:49:53 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id o63so15676318pgo.6
        for <stable@vger.kernel.org>; Tue, 02 Feb 2021 12:49:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RyOYnT+5BaUf2ZnPRN27Uacv2ho1IRnBb6TKWNk4haw=;
        b=ByQLmtl2Tev2Tiocdk1GZXIm2qqLuGhf6TBQt7HqB22On3eob42IUDnfrL1iYJZVYm
         7yjpDdTY7w5wEP8ELtthevdYiB2xV2bB3B1pnWFbhOWigQ+aAgr2uZe0j6Z+aUndoBs9
         dGAEJK9LqlYcVfIKKh8cXyYNzzooIQlFJZGgSPNTrC9LAmiq/uo05rqzsLMPTTn+Mmfe
         Vpyf0wHmyyKwK5RoOSGL/dYcoTQ9qXlYVjrX053N8nN5KYRsvwpFXRF3eIWcpNA2djRS
         gYVNQVltf5sQLGNyor/3hYxLnYKiHW7HDQS+ooALLKEioHVXEoF1zm3cAb3TpiUKIOWU
         WwNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RyOYnT+5BaUf2ZnPRN27Uacv2ho1IRnBb6TKWNk4haw=;
        b=gi4AmHbMRu4RjyLFH5tlKthkEUaDgQo5ar5SUjeTcHPXl/8s+m09Soj3zMli1aJ4Kk
         YFbWGFHi2lQyYAuAkxG84V03WOk0WigG9UeUIC+D6wkM4JpEQZrHWp3hcG4l1S83oOVT
         zw8JRliSHvE2qL3+oiDKbefkBHbOpIOrJ5e7h3pcIq6Ls/KTQazeAAdYPt0KFx4k/199
         SIHTMBjX9JkFx8SeqtjxFNtGe3r+poFIdXLXUNL+ZdduQo+cjVwC6t1UFTxpljAoKE5T
         pSMaTgROb+5lHuA8YlKqzUTdKe9sfi9UF07fcaYM8a1he1UeI+LhtSmxImp00k9ZTMIZ
         JAtg==
X-Gm-Message-State: AOAM533eN7C6M0+N0jazcSdbgXKr8Ivr+KF+qi/qvSWVHL2t0XSVg+5v
        /Oy2OBFVYgUxmKOsz+Afy8NqRHQSjLcYLg==
X-Google-Smtp-Source: ABdhPJyHcyFreeY/oDOqIV83lJ1qw5rWBORtEjkEbDaRZ0MZ0lWC7BM7IgaBvoR2G3WHq9zXm46s5g==
X-Received: by 2002:a62:a204:0:b029:1c3:fb27:16f3 with SMTP id m4-20020a62a2040000b02901c3fb2716f3mr22896608pff.61.1612298992777;
        Tue, 02 Feb 2021 12:49:52 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id lw4sm2748409pjb.16.2021.02.02.12.49.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 12:49:52 -0800 (PST)
Message-ID: <6019baf0.1c69fb81.99789.5f4a@mx.google.com>
Date:   Tue, 02 Feb 2021 12:49:52 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.254-32-ge997477de456
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 125 runs,
 6 regressions (v4.9.254-32-ge997477de456)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 125 runs, 6 regressions (v4.9.254-32-ge997477=
de456)

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

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.254-32-ge997477de456/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.254-32-ge997477de456
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e997477de4567360c8b3ee81ab813a43b9d2a593 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6019837a97f03a94013abe62

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.254-3=
2-ge997477de456/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.254-3=
2-ge997477de456/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6019837a97f03a9=
4013abe69
        failing since 2 days (last pass: v4.9.253-30-g6cb2db3a6d706, first =
fail: v4.9.254-3-g1ef1a4ed104f)
        2 lines

    2021-02-02 16:53:10.908000+00:00  [   20.548522] usbcore: registered ne=
w interface driver smsc95xx
    2021-02-02 16:53:10.946000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/124
    2021-02-02 16:53:10.955000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-02-02 16:53:10.971000+00:00  [   20.608642] <LAVA_SIGNAL_TESTCASE =
TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6019812b07afad2b6e3abe68

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.254-3=
2-ge997477de456/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.254-3=
2-ge997477de456/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6019812b07afad2b6e3ab=
e69
        failing since 80 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60198131d6057ed98b3abe62

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.254-3=
2-ge997477de456/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.254-3=
2-ge997477de456/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60198131d6057ed98b3ab=
e63
        failing since 80 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/601981211b83768b923abe68

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.254-3=
2-ge997477de456/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.254-3=
2-ge997477de456/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601981211b83768b923ab=
e69
        failing since 80 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/601980ee2cd82d1deb3abe66

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.254-3=
2-ge997477de456/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.254-3=
2-ge997477de456/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601980ee2cd82d1deb3ab=
e67
        failing since 80 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6019ae6687d426853b3abe89

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.254-3=
2-ge997477de456/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.254-3=
2-ge997477de456/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6019ae6687d426853b3ab=
e8a
        failing since 80 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =20
