Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ABCA2B29D3
	for <lists+stable@lfdr.de>; Sat, 14 Nov 2020 01:25:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726172AbgKNAYU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Nov 2020 19:24:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbgKNAYS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Nov 2020 19:24:18 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15B2CC0613D1
        for <stable@vger.kernel.org>; Fri, 13 Nov 2020 16:24:17 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id j19so1619575pgg.5
        for <stable@vger.kernel.org>; Fri, 13 Nov 2020 16:24:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vC7R8pqf2SGY16nzGjOQNLCsxKFkDHTrxPgr+T89amY=;
        b=l1lekxe6SSSz+o5+sRNXCe8T4rybLF6ZsWLF544TBrXWUSP3rUPp4uiowF2H5JRtIV
         Ol1LwtUYwCrYmi1GObS1guEedwYZAYWlJPwYPLmSDZHYiDzXzy03Gp2a/FjvsI5PTUX+
         cUvxn3WKhyLs/dnN/r8SOWhRxLNcARLFBtcK5Hp0e26If7i12TtSlnMQvKbAJJBxjITM
         1TOdu9EU+/mplHvoXxtY+MLD5Rc43Fwk6y8bcst+mn7vQUgDNZZHmpjLDQQtVQA9YioE
         LBYGChVU8eR0+uS6EQfg4kbK8l+HU2X7uKZ6bEpDNkiO36N8fUvyZsTRWg/1LV6kpKYd
         qyKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vC7R8pqf2SGY16nzGjOQNLCsxKFkDHTrxPgr+T89amY=;
        b=tYjPXYp6dhbR1KDqUn77+yL1C99rzOlAXdWTfdY5NSfNhx1KGY5eKaQ7TtNiCwxkwJ
         twtcSD9f4Jz5Hws/yOvxkhTFkc/w4xuBdOB6IMVPtCbVoig47XvGsS4C+Lo0p4Pmg+OC
         d4/BKFImKIcNHK5QYT11PPrR25vLK22//0a05yylq0iVMikcFfvb6SnjP9YRz1oFZN/6
         TinMMeRkM6n/QgLm7PXpuy3q/sdCYHi47t5DbYskYRDLaTtmYhsjFT59x95Lg1Idf8EL
         fm+3AEMx3AQbRt02ajlISCZaQglP1XOKuC5Sfzbdq01rTgZ6z4+LLJiNmVTyms2kxhDC
         F8dw==
X-Gm-Message-State: AOAM532Ei9L3UFKwRWSHX7I3eg9/iUUTkzcu7/nhX1lGASD2ZD1KCA2a
        3avCwLmYo1XneYzhXdT8/y8OdHNp4dqVHQ==
X-Google-Smtp-Source: ABdhPJxSK5ALVAg5Q3hCg7G5Q78asBJJnSI+pjduzMA4fszZzZjSHgB8V7ZgdOa/tMlXSb/uvgwTKQ==
X-Received: by 2002:aa7:9acd:0:b029:18b:bda:9a0d with SMTP id x13-20020aa79acd0000b029018b0bda9a0dmr4241371pfp.10.1605313456156;
        Fri, 13 Nov 2020 16:24:16 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h4sm9995398pgc.13.2020.11.13.16.24.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 16:24:15 -0800 (PST)
Message-ID: <5faf23af.1c69fb81.295de.4dc7@mx.google.com>
Date:   Fri, 13 Nov 2020 16:24:15 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.157-27-g5543cc2c41d55
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 141 runs,
 8 regressions (v4.19.157-27-g5543cc2c41d55)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 141 runs, 8 regressions (v4.19.157-27-g5543c=
c2c41d55)

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

qemu_i386            | i386 | lab-baylibre    | gcc-8    | i386_defconfig  =
    | 1          =

qemu_i386-uefi       | i386 | lab-collabora   | gcc-8    | i386_defconfig  =
    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.157-27-g5543cc2c41d55/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.157-27-g5543cc2c41d55
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5543cc2c41d5519dd290750ce274caf4dd651e1f =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5faeea87d1401e5d2279b8ad

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.157=
-27-g5543cc2c41d55/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.157=
-27-g5543cc2c41d55/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5faeea87d1401e5=
d2279b8b4
        new failure (last pass: v4.19.157-26-gd59f3161b3a0)
        2 lines =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5faeea1f5c1ff8057879b8a2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.157=
-27-g5543cc2c41d55/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.157=
-27-g5543cc2c41d55/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5faeea1f5c1ff8057879b=
8a3
        new failure (last pass: v4.19.157-26-gd59f3161b3a0) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5faee9ff465aeb36a179b8a5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.157=
-27-g5543cc2c41d55/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.157=
-27-g5543cc2c41d55/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5faee9ff465aeb36a179b=
8a6
        new failure (last pass: v4.19.157-26-gd59f3161b3a0) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5faee9de3a71555c9279b89a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.157=
-27-g5543cc2c41d55/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.157=
-27-g5543cc2c41d55/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5faee9de3a71555c9279b=
89b
        new failure (last pass: v4.19.157-26-gd59f3161b3a0) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5faee9a07d64893ccc79b89a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.157=
-27-g5543cc2c41d55/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.157=
-27-g5543cc2c41d55/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5faee9a07d64893ccc79b=
89b
        new failure (last pass: v4.19.157-26-gd59f3161b3a0) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5faee9b4bf9bdfd8de79b8ab

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.157=
-27-g5543cc2c41d55/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.157=
-27-g5543cc2c41d55/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5faee9b4bf9bdfd8de79b=
8ac
        new failure (last pass: v4.19.157-26-gd59f3161b3a0) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_i386            | i386 | lab-baylibre    | gcc-8    | i386_defconfig  =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5faee9b97d64893ccc79b8ad

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.157=
-27-g5543cc2c41d55/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i38=
6.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.157=
-27-g5543cc2c41d55/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i38=
6.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5faee9b97d64893ccc79b=
8ae
        new failure (last pass: v4.19.157-26-gd59f3161b3a0) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_i386-uefi       | i386 | lab-collabora   | gcc-8    | i386_defconfig  =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5faee99ac11cc5717279b903

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.157=
-27-g5543cc2c41d55/i386/i386_defconfig/gcc-8/lab-collabora/baseline-qemu_i3=
86-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.157=
-27-g5543cc2c41d55/i386/i386_defconfig/gcc-8/lab-collabora/baseline-qemu_i3=
86-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5faee99ac11cc5717279b=
904
        new failure (last pass: v4.19.157-26-gd59f3161b3a0) =

 =20
