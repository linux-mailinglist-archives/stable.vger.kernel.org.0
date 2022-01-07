Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA046487A30
	for <lists+stable@lfdr.de>; Fri,  7 Jan 2022 17:15:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239870AbiAGQPd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jan 2022 11:15:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239828AbiAGQPc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Jan 2022 11:15:32 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D6A0C061574
        for <stable@vger.kernel.org>; Fri,  7 Jan 2022 08:15:32 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id c9-20020a17090a1d0900b001b2b54bd6c5so12441846pjd.1
        for <stable@vger.kernel.org>; Fri, 07 Jan 2022 08:15:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8t4z8JrWSZHGIlr3GCato5zIQZmPJl6yF4bpfZLHn+o=;
        b=kEkZo/SNm7xJiCIRxSfczg9SgY0wVSDgfgc2Kelc4ubza8IeLDQ53PSODV3AQVod79
         MyWnJYldeJjbW7bedAlZwOJ3Mt2JJmcH9hgud7nIJAEh3bvoiDwS4bd6nPcEvBB080Ay
         Kkf5bAqBu9LR0ll0S06nKwmd8wQb/AiYkbMLyCwXhtchoCBRCUefZjYwHEk/D4x1qRnA
         G4+fGmDEKkkMmC0KFb8F1BMR1O4xzfz/zt+tgkYPuMftHS8jyoYVH9euERbgeISx89Kz
         OoVBgfS5W5f/qWynSnobe95sJVx7c375O/mUzPFQD8aGSDF1GkSOxUgaxPYoczK0gun7
         LS6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8t4z8JrWSZHGIlr3GCato5zIQZmPJl6yF4bpfZLHn+o=;
        b=mEME6Qv+wP/T9RXv+EbID2zFDTIfp55WddHBwtT2snL9gidKqEp4P96jgZkOaVgx9p
         53kizFgUW8XGC/NBgFuvX3CiXl1HxMXs9/qibe1J6rUL4NWEitfe+BkUupaZXvDQ/Ule
         IQePNMsKS37rLOjV5YoJmZOV8BSMht0Wo1iUXZZ6fpXDfvj7+pWjpBGRcR+wWA9u0pyQ
         tRg/yd13qIewRe1kLJ3NTUW+MMER4NMZyn1aJ6IsQ360SEWd3MMeRYrkXzu7wDHBCO1L
         MzEdokzmsvlX/B1IEMd3Gfh8jdgDQnKMWanQ1PBAPmk1ZoAHLYW8nKiWfSCrUwzYWqAu
         nZpg==
X-Gm-Message-State: AOAM531P4L+Jq5hZt6eE5gMd223/RBJqh+iqzJs+g1cYzxIfFmONw0Uh
        SYmfDONZO/j/M68/HHTM9y32NsYe9eArjWWe
X-Google-Smtp-Source: ABdhPJwXvCCj1UMMp8/X/f8elCJTqTpyEPiQITdT/tloyRassXn92h9FDLjty7JK9UptB6QqBEz+UQ==
X-Received: by 2002:a17:90a:ad94:: with SMTP id s20mr15679172pjq.222.1641572131878;
        Fri, 07 Jan 2022 08:15:31 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y129sm6008383pfy.164.2022.01.07.08.15.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jan 2022 08:15:31 -0800 (PST)
Message-ID: <61d86723.1c69fb81.fc637.f537@mx.google.com>
Date:   Fri, 07 Jan 2022 08:15:31 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.298-2-g9bc9238e5056
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 115 runs,
 3 regressions (v4.4.298-2-g9bc9238e5056)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 115 runs, 3 regressions (v4.4.298-2-g9bc9238e=
5056)

Regressions Summary
-------------------

platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
beagle-xm | arm  | lab-baylibre  | gcc-10   | omap2plus_defconfig | 2      =
    =

panda     | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.298-2-g9bc9238e5056/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.298-2-g9bc9238e5056
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9bc9238e5056e4fafe602195ab521ddcf23be096 =



Test Regressions
---------------- =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
beagle-xm | arm  | lab-baylibre  | gcc-10   | omap2plus_defconfig | 2      =
    =


  Details:     https://kernelci.org/test/plan/id/61d836a19d1fd38d5eef6742

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.298-2=
-g9bc9238e5056/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.298-2=
-g9bc9238e5056/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/61d836a19d1fd38d=
5eef6745
        new failure (last pass: v4.4.298-2-g5f49da71474a)
        1 lines

    2022-01-07T12:48:13.950488  =

    2022-01-07T12:48:14.054496  / # #
    2022-01-07T12:48:14.055129  =

    2022-01-07T12:48:14.156509  / # #export SHELL=3D/bin/sh
    2022-01-07T12:48:14.156915  =

    2022-01-07T12:48:14.258092  / # export SHELL=3D/bin/sh. /lava-1363778/e=
nvironment
    2022-01-07T12:48:14.258535  =

    2022-01-07T12:48:14.359742  / # . /lava-1363778/environment/lava-136377=
8/bin/lava-test-runner /lava-1363778/0
    2022-01-07T12:48:14.360900  =

    2022-01-07T12:48:14.361742  / # /lava-1363778/bin/lava-test-runner /lav=
a-1363778/0 =

    ... (9 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61d836a19d1fd38=
d5eef6747
        new failure (last pass: v4.4.298-2-g5f49da71474a)
        29 lines

    2022-01-07T12:48:14.825479  [   49.517089] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-07T12:48:14.879133  kern  :emerg : Internal error: Oops - BUG: =
0 [#1] SMP ARM
    2022-01-07T12:48:14.885352  kern  :emerg : Process udevd (pid: 105, sta=
ck limit =3D 0xcb92a218)
    2022-01-07T12:48:14.889354  kern  :emerg : Stack: (0xcb92bcf8 to 0xcb92=
c000)
    2022-01-07T12:48:14.897584  kern  :emerg : bce0:                       =
                                bf02bdc4 60000013
    2022-01-07T12:48:14.910927  kern  :emerg : bd00: bf02bdc8 c06a3cdc 0000=
0001 00[   49.598571] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Df=
ail UNITS=3Dlines MEASUREMENT=3D29>   =

 =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
panda     | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/61d835c7544b9dece6ef6761

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.298-2=
-g9bc9238e5056/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.298-2=
-g9bc9238e5056/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61d835c7544b9de=
ce6ef6764
        failing since 17 days (last pass: v4.4.295-12-gd8298cd08f0d, first =
fail: v4.4.295-23-gcec9bc2aa5d3)
        2 lines

    2022-01-07T12:44:36.956752  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, klogd/99
    2022-01-07T12:44:36.965741  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
