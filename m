Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D88A945D47B
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 07:01:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346379AbhKYGEl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 01:04:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244197AbhKYGCl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Nov 2021 01:02:41 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C996C061758
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 21:57:55 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id j6-20020a17090a588600b001a78a5ce46aso6966198pji.0
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 21:57:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Bnkqpp9c/UAHHfwzusV1yEnIvvbus51d8ppq4vw+EqQ=;
        b=aT10mCQnU88VKLcO7DUrOOXApEeUUE364LbAbnNVbAEltlyPEkevbGDGV6CliBCPSW
         8WNuDc6tV6rWeD2HfALT3nuBCxbNrNP1Ccm7cOM7uGq8bZfF01gjvJBrAV2h4JDZ9Gkr
         BajzdOlsTQ5aYrwSUz+6f5zjPy98APGGNacN3cCVauJkr8u4GOEYkesfD8rrKIcdnikf
         RFFjBP4DFtuJZDPY9DxuU4c0HPAFyKLh+NkADfvfrFGyvTbgmWgD4gZp1NrkdaspeT63
         ovfF4wwpnyUKFoIJQBIYwvPA8DdnqZ2Cpfb4VCyTvJUtKt5tjqYMsD2hcCCUwNwuzhRR
         3ACg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Bnkqpp9c/UAHHfwzusV1yEnIvvbus51d8ppq4vw+EqQ=;
        b=NwnLAb6pAcq0445Ty3oiGHFAbNoSbx9MLKgE3xgV0BugWXENetmS/QzEWMgnoIYe3q
         k8Dsth3UQ5lZIcZBu7BVNgv/54qRpS3nv6PhKtQABQD3UeoapxQKqmw7fdWma4xKc+e6
         hIoxGq9U8sJgKo7x5cUcEI5HgwHzVDCbt4NAuYSLivDJkjcSHheVybblakG1kVON/UO8
         R5QnHUOxaIovf2aQNE2+PVWGOxUBIu6Q7NWzsVVxmubYi7CBae1O4iZ2kUFkRXujY0Aj
         KSnI1SO5CQoRhy/ns98usFrvzbKG16Iie4bohtE++CkU9puUAZn11R0DrOqzzY6AaBZo
         CUEA==
X-Gm-Message-State: AOAM530IEYeO/ObTB0bJZRihCt1xwADyFzXBUuzMvgq5BxyMn5M6/nz/
        YK0pA5uRQbPSAWTdBfGhU6ZCLNwrn/yXvpfpbtw=
X-Google-Smtp-Source: ABdhPJwF1QZInjCCAx5bFU0IyiX5PbyXm6EPylqMgE/HQViGFbQLiLz2rSX5NqxE/GUt3nofZxQzsg==
X-Received: by 2002:a17:90b:314e:: with SMTP id ip14mr4306292pjb.130.1637819874589;
        Wed, 24 Nov 2021 21:57:54 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id il7sm1476275pjb.54.2021.11.24.21.57.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 21:57:54 -0800 (PST)
Message-ID: <619f25e2.1c69fb81.a4961.4d7f@mx.google.com>
Date:   Wed, 24 Nov 2021 21:57:54 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.292-160-g3bcaf797d523e
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.4 baseline: 83 runs,
 3 regressions (v4.4.292-160-g3bcaf797d523e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 83 runs, 3 regressions (v4.4.292-160-g3bcaf79=
7d523e)

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
el/v4.4.292-160-g3bcaf797d523e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.292-160-g3bcaf797d523e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3bcaf797d523e576355acb552e8e9e6b321b626a =



Test Regressions
---------------- =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
beagle-xm | arm  | lab-baylibre  | gcc-10   | omap2plus_defconfig | 2      =
    =


  Details:     https://kernelci.org/test/plan/id/619eecb6f77bb8ef88f2efb7

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.292-1=
60-g3bcaf797d523e/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.292-1=
60-g3bcaf797d523e/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/619eecb6f77bb8ef=
88f2efba
        new failure (last pass: v4.4.292-160-ga0e342c5dc0e)
        1 lines

    2021-11-25T01:53:39.953294  / # =

    2021-11-25T01:53:39.954146  #
    2021-11-25T01:53:40.057898  / # #
    2021-11-25T01:53:40.058751  =

    2021-11-25T01:53:40.160230  / # #export SHELL=3D/bin/sh
    2021-11-25T01:53:40.160689  =

    2021-11-25T01:53:40.262027  / # export SHELL=3D/bin/sh. /lava-1140393/e=
nvironment
    2021-11-25T01:53:40.262527  =

    2021-11-25T01:53:40.363975  / # . /lava-1140393/environment/lava-114039=
3/bin/lava-test-runner /lava-1140393/0
    2021-11-25T01:53:40.365234   =

    ... (9 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619eecb6f77bb8e=
f88f2efbc
        new failure (last pass: v4.4.292-160-ga0e342c5dc0e)
        29 lines

    2021-11-25T01:53:40.825517  [   49.424499] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-25T01:53:40.889283  kern  :emerg : Internal error: Oops - BUG: =
0 [#1] SMP ARM
    2021-11-25T01:53:40.895400  kern  :emerg : Process udevd (pid: 105, sta=
ck limit =3D 0xcb8e2218)
    2021-11-25T01:53:40.899573  kern  :emerg : Stack: (0xcb8e3cf8 to 0xcb8e=
4000)
    2021-11-25T01:53:40.907586  kern  :emerg : 3ce0:                       =
                                bf02bdc4 60000013   =

 =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
panda     | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/619f25782bddd54bf3f2efc0

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.292-1=
60-g3bcaf797d523e/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.292-1=
60-g3bcaf797d523e/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619f25782bddd54=
bf3f2efc3
        failing since 0 day (last pass: v4.4.292-161-g719b6ae9e13f, first f=
ail: v4.4.292-160-ga0e342c5dc0e)
        2 lines

    2021-11-25T05:55:37.655126  [   19.018646] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-25T05:55:37.698908  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/121
    2021-11-25T05:55:37.708448  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-11-25T05:55:37.723379  [   19.089599] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
