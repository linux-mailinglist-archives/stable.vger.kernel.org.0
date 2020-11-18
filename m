Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E9132B7BC9
	for <lists+stable@lfdr.de>; Wed, 18 Nov 2020 11:49:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726223AbgKRKs4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Nov 2020 05:48:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726077AbgKRKsz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Nov 2020 05:48:55 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99907C0613D4
        for <stable@vger.kernel.org>; Wed, 18 Nov 2020 02:48:55 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id 10so1179814pfp.5
        for <stable@vger.kernel.org>; Wed, 18 Nov 2020 02:48:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=z+QJDYUnWvwXmYla+bWfdSff5dfM7cP/cVtrhpych1c=;
        b=Eg1/6vnHIzPj9TE4biKSm9vlLAv+pPU7/AtE8u7U1hNxObVyxUC5/jLYafiZ2I7fN9
         WmaS3lNGjkTqwvAMZdvjUcezZRY5BRSyLnmptx75ECQci4OrxZYYdGZJyq7c8BD1qnnf
         +NcGR9rXjz5DqDybVc0xKBMGXYNRbbkHaFxofrKpatllUdrA3a3Kif0YY8GtDL1B0WvX
         6NdftMK25YaA3qMSzvdUFaxWT/IVr4uj2JRM5Cx5fl+/i8YIWYbaGUQnXzsewrYKJH+E
         96HvBUZrLc/BHhS8T+Ch+K6/8uJ7ce0Is8gYsYk8Nn8WYRYbefceTXARoiw2UZErtOx8
         LBbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=z+QJDYUnWvwXmYla+bWfdSff5dfM7cP/cVtrhpych1c=;
        b=HbMr+CUbLI7nmdYk+AzU4S8QsVy05wohSQrmQPIeRo1jN211VJyB1zrGbXdYhLrWK6
         ijVLW6ki/jfmooxrui5G6G16ipfLaks0SDTaTkLusixo/gp9Wic5ukGR016kER7/c+M1
         oHNCCjl2qDYfL1JTKIZNFaRM0PE6C33c4HSk6tAtaXauRIvTUj2TJIU83ND+q6ZvBprV
         J5kspS/VP5CjouuyXB5qOaWB/shw75V/+B7VDKf92RVLuN9guKFrFSg4Pqr2kB3bII+O
         ztqq7EAb+4V2LcgcYaYDuRBuAKdDCo5o24MsIWLLrAKyf9ZBKm4CREenLZCbV0x9gtif
         Mr1g==
X-Gm-Message-State: AOAM533y6WgJbpxY/0m6ebOSrSthX3cnGtYwaO1oGFAT5BO+rzbc566r
        1h/yuQWQ5Afaq3+etWhXhFirqXPnRQsGfQ==
X-Google-Smtp-Source: ABdhPJxCJArmDflzBmY2dI7WV1sQw+86+AalVVwCAzNll1rjggOVqrpSomRhb72wc/AvP43P//xJYg==
X-Received: by 2002:a63:4a15:: with SMTP id x21mr7605859pga.294.1605696534504;
        Wed, 18 Nov 2020 02:48:54 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p4sm2159960pjo.6.2020.11.18.02.48.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2020 02:48:53 -0800 (PST)
Message-ID: <5fb4fc15.1c69fb81.c279a.4122@mx.google.com>
Date:   Wed, 18 Nov 2020 02:48:53 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.243-65-g5c64a4febafe0
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y baseline: 127 runs,
 14 regressions (v4.4.243-65-g5c64a4febafe0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 127 runs, 14 regressions (v4.4.243-65-g5c64=
a4febafe0)

Regressions Summary
-------------------

platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
beagle-xm           | arm  | lab-baylibre    | gcc-8    | omap2plus_defconf=
ig | 2          =

panda               | arm  | lab-collabora   | gcc-8    | omap2plus_defconf=
ig | 1          =

qemu_arm-virt-gicv2 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv2 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv2 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv2 | arm  | lab-collabora   | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv2 | arm  | lab-linaro-lkft | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv3 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv3 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv3 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv3 | arm  | lab-collabora   | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv3 | arm  | lab-linaro-lkft | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_i386           | i386 | lab-baylibre    | gcc-8    | i386_defconfig   =
   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.243-65-g5c64a4febafe0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.243-65-g5c64a4febafe0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5c64a4febafe0af1834cf497df8985d917a94b05 =



Test Regressions
---------------- =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
beagle-xm           | arm  | lab-baylibre    | gcc-8    | omap2plus_defconf=
ig | 2          =


  Details:     https://kernelci.org/test/plan/id/5fb4ca48e8300a0960d8d91e

  Results:     2 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.243=
-65-g5c64a4febafe0/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.243=
-65-g5c64a4febafe0/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5fb4ca48e8300a09=
60d8d921
        failing since 6 days (last pass: v4.4.243, first fail: v4.4.243-14-=
gcb8e837cb602)
        1 lines

    2020-11-18 07:14:32.713000+00:00  Connected to omap3-beagle-xm console =
[channel connected] (~$quit to exit)
    2020-11-18 07:14:32.713000+00:00  (user:) is already connected
    2020-11-18 07:14:32.714000+00:00  (user:) is already connected
    2020-11-18 07:14:32.714000+00:00  (user:) is already connected
    2020-11-18 07:14:32.714000+00:00  (user:) is already connected
    2020-11-18 07:14:32.714000+00:00  (user:) is already connected
    2020-11-18 07:14:32.714000+00:00  (user:) is already connected
    2020-11-18 07:14:32.715000+00:00  (user:) is already connected
    2020-11-18 07:14:32.715000+00:00  (user:) is already connected
    2020-11-18 07:14:32.715000+00:00  (user:khilman) is already connected =

    ... (462 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fb4ca48e8300a0=
960d8d923
        failing since 6 days (last pass: v4.4.243, first fail: v4.4.243-14-=
gcb8e837cb602)
        28 lines

    2020-11-18 07:16:19.772000+00:00  kern  :emerg : Stack: (0xcb8efd10 to =
0xcb8f0000)
    2020-11-18 07:16:19.780000+00:00  kern  :emerg : fd00:                 =
                    bf02b8fc bf010b84 cb9f1a10 bf02b988
    2020-11-18 07:16:19.788000+00:00  kern  :emerg : fd20: cb9f1a10 bf2010a=
8 00000002 cbbc8010 cb9f1a10 bf250b54 cbcaa510 cbcaa510
    2020-11-18 07:16:19.796000+00:00  kern  :emerg : fd40: 00000000 0000000=
0 ce226930 c01fb390 ce226930 ce226930 c08596a8 00000001
    2020-11-18 07:16:19.805000+00:00  kern  :emerg : fd60: ce226930 cbcaa51=
0 cbc8e810 00000000 ce226930 c08596a8 00000001 c09632c0
    2020-11-18 07:16:19.813000+00:00  kern  :emerg : fd80: ffffffed bf254ff=
4 fffffdfb 00000028 00000001 c00ce2b4 bf255188 c040722c
    2020-11-18 07:16:19.821000+00:00  kern  :emerg : fda0: c09632c0 c120ea3=
0 bf254ff4 00000000 00000028 c0405700 c09632c0 c09632f4
    2020-11-18 07:16:19.829000+00:00  kern  :emerg : fdc0: bf254ff4 0000000=
0 00000000 c04058a8 00000000 bf254ff4 c040581c c0403bcc
    2020-11-18 07:16:19.837000+00:00  kern  :emerg : fde0: ce0c38a4 ce22091=
0 bf254ff4 cbca5640 c09ddb68 c0404d18 bf253b6c c0960460
    2020-11-18 07:16:19.845000+00:00  kern  :emerg : fe00: cbcb1b40 bf254ff=
4 c0960460 cbcb1b40 bf258000 c04062e0 c0960460 c0960460 =

    ... (16 line(s) more)  =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
panda               | arm  | lab-collabora   | gcc-8    | omap2plus_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb4ca2576d3aa5a69d8d92d

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.243=
-65-g5c64a4febafe0/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.243=
-65-g5c64a4febafe0/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fb4ca2576d3aa5=
a69d8d932
        new failure (last pass: v4.4.243-14-gcb8e837cb602)
        2 lines =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb4ca6c1182bf6783d8d90b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.243=
-65-g5c64a4febafe0/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.243=
-65-g5c64a4febafe0/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb4ca6c1182bf6783d8d=
90c
        failing since 3 days (last pass: v4.4.243-14-gcb8e837cb602, first f=
ail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv2 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb4ca631182bf6783d8d901

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.243=
-65-g5c64a4febafe0/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.243=
-65-g5c64a4febafe0/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb4ca631182bf6783d8d=
902
        failing since 3 days (last pass: v4.4.243-14-gcb8e837cb602, first f=
ail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv2 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb4ca979627afd0bfd8d92a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.243=
-65-g5c64a4febafe0/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.243=
-65-g5c64a4febafe0/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb4ca979627afd0bfd8d=
92b
        failing since 3 days (last pass: v4.4.243-14-gcb8e837cb602, first f=
ail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv2 | arm  | lab-collabora   | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb4d3f997c7587a09d8d932

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.243=
-65-g5c64a4febafe0/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.243=
-65-g5c64a4febafe0/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb4d3f997c7587a09d8d=
933
        failing since 3 days (last pass: v4.4.243-14-gcb8e837cb602, first f=
ail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv2 | arm  | lab-linaro-lkft | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb4def4a5dbe38222d8d907

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.243=
-65-g5c64a4febafe0/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.243=
-65-g5c64a4febafe0/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb4def4a5dbe38222d8d=
908
        failing since 3 days (last pass: v4.4.243-14-gcb8e837cb602, first f=
ail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv3 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb4ca6d7b81c450e7d8d8fd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.243=
-65-g5c64a4febafe0/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.243=
-65-g5c64a4febafe0/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb4ca6d7b81c450e7d8d=
8fe
        failing since 3 days (last pass: v4.4.243-14-gcb8e837cb602, first f=
ail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv3 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb4ca668fa8754fcad8d900

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.243=
-65-g5c64a4febafe0/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.243=
-65-g5c64a4febafe0/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb4ca668fa8754fcad8d=
901
        failing since 3 days (last pass: v4.4.243-14-gcb8e837cb602, first f=
ail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv3 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb4caa5cf1e2ea2e4d8d906

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.243=
-65-g5c64a4febafe0/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.243=
-65-g5c64a4febafe0/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb4caa5cf1e2ea2e4d8d=
907
        failing since 3 days (last pass: v4.4.243-14-gcb8e837cb602, first f=
ail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv3 | arm  | lab-collabora   | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb4d4691058af4598d8d933

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.243=
-65-g5c64a4febafe0/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.243=
-65-g5c64a4febafe0/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb4d4691058af4598d8d=
934
        failing since 3 days (last pass: v4.4.243-14-gcb8e837cb602, first f=
ail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv3 | arm  | lab-linaro-lkft | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb4df09a5dbe38222d8d923

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.243=
-65-g5c64a4febafe0/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.243=
-65-g5c64a4febafe0/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb4df09a5dbe38222d8d=
924
        failing since 3 days (last pass: v4.4.243-14-gcb8e837cb602, first f=
ail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_i386           | i386 | lab-baylibre    | gcc-8    | i386_defconfig   =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb4ca423b19a4cc23d8d990

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.243=
-65-g5c64a4febafe0/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i38=
6.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.243=
-65-g5c64a4febafe0/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i38=
6.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb4ca423b19a4cc23d8d=
991
        new failure (last pass: v4.4.243-20-g3c35b64319c2) =

 =20
