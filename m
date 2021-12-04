Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B25C4683C6
	for <lists+stable@lfdr.de>; Sat,  4 Dec 2021 10:52:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384544AbhLDJ4F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Dec 2021 04:56:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384541AbhLDJ4D (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Dec 2021 04:56:03 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8059BC061751
        for <stable@vger.kernel.org>; Sat,  4 Dec 2021 01:52:38 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id u17so3769846plg.9
        for <stable@vger.kernel.org>; Sat, 04 Dec 2021 01:52:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=v7LJ6u0GLLh9NIhq38LgdA5ckwVXWdQCiN/m1GIaQWI=;
        b=VgLDPnfg6oqtxJgreJk1yARCFPtlQeDkd3fCX1mpPQxC2bR8GLfVQKoLggJTr40/Dk
         PfBru8ejVCisdZn0JPkbZkANnV/bRsf1dTf++LMOm0F8pO3+A6zYGGC/fyUl6ofEJlgt
         PqjtNZa4wdw0psyL5gerLfaK97mB/mOAHgSotjeZtxhI1sh2NWHGc8Q9H062flwLoi1S
         p+ddGanlEXmM0UAl3V528vR4dhMg4v4w2WmmfVan2OtRbZeCppU/7YnUp341CWa/+WqY
         bVxGM64yZhDT2po8dmuuQtQDRc5U+9P/UTQKw5WI357U5dYhh766KbLsy5jJYfU4hXq0
         5ftA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=v7LJ6u0GLLh9NIhq38LgdA5ckwVXWdQCiN/m1GIaQWI=;
        b=jUOSasVS8xVPayeZMaT38MFi/bA4MFozx4ApQXc87wopA2W/xJCJxwGytQ6N8OrADl
         TY4NEF/89zOK2mlhVflJK1371wCqsS3TaoIVrK7Q8upwqKWLLiDVgaRCsy5a5DsnviAw
         xURe8Kao0GKqNzov2xGurCrBaGSYqZWd8Wf/gCtOnEngXKp3PBqT4rFFt7SDT+7T4JLL
         T5eUZtkFuUlNhpBISOR2gyF/Cwwm/IGdbR2Pu913xqEmahfYSx637keRKRwwzmoBNZXn
         r/fQGm5XNLwbMXouipgHtQERXsxwQDFxU64sZAboQ2SL5X2r9v3nklGir4z5+mnT+SuZ
         P1BA==
X-Gm-Message-State: AOAM5301RUrnoEGT1PPbRcdFiWiRCchbbMaE66SGkyua9v+Z7hNhnr7j
        Z6ZjZU85XZgePnqxNBGkK2tiX+tDZhWptIAy
X-Google-Smtp-Source: ABdhPJxI0Vc2Kwi1sHhQ6LnULhqsr/1A3PXiGKbVUlUx57Lxa/hMz28VK2JV53Y751tFe0n1UGqBgw==
X-Received: by 2002:a17:90b:3b4c:: with SMTP id ot12mr21233419pjb.196.1638611557779;
        Sat, 04 Dec 2021 01:52:37 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p16sm6436174pfh.97.2021.12.04.01.52.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Dec 2021 01:52:37 -0800 (PST)
Message-ID: <61ab3a65.1c69fb81.5db29.2c08@mx.google.com>
Date:   Sat, 04 Dec 2021 01:52:37 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.293-40-gdfee1c23c5f0d
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.4 baseline: 91 runs,
 3 regressions (v4.4.293-40-gdfee1c23c5f0d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 91 runs, 3 regressions (v4.4.293-40-gdfee1c23=
c5f0d)

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
el/v4.4.293-40-gdfee1c23c5f0d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.293-40-gdfee1c23c5f0d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      dfee1c23c5f0d209911a196e2418317412cb50f2 =



Test Regressions
---------------- =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
beagle-xm | arm  | lab-baylibre  | gcc-10   | omap2plus_defconfig | 2      =
    =


  Details:     https://kernelci.org/test/plan/id/61ab04af544c67fbdd1a94bc

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.293-4=
0-gdfee1c23c5f0d/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.293-4=
0-gdfee1c23c5f0d/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/61ab04af544c67fb=
dd1a94bf
        new failure (last pass: v4.4.293-34-g00012cc3b7090)
        1 lines

    2021-12-04T06:03:08.949491  / # =

    2021-12-04T06:03:08.950155  #
    2021-12-04T06:03:09.053409  / # #
    2021-12-04T06:03:09.053987  =

    2021-12-04T06:03:09.155127  / # #export SHELL=3D/bin/sh
    2021-12-04T06:03:09.155574  =

    2021-12-04T06:03:09.256760  / # export SHELL=3D/bin/sh. /lava-1187895/e=
nvironment
    2021-12-04T06:03:09.257217  =

    2021-12-04T06:03:09.358410  / # . /lava-1187895/environment/lava-118789=
5/bin/lava-test-runner /lava-1187895/0
    2021-12-04T06:03:09.359556   =

    ... (9 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61ab04af544c67f=
bdd1a94c1
        new failure (last pass: v4.4.293-34-g00012cc3b7090)
        29 lines

    2021-12-04T06:03:09.721027  [   49.220001] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-04T06:03:09.786452  kern  :emerg : Internal error: Oops - BUG: =
0 [#1] SMP ARM
    2021-12-04T06:03:09.792472  kern  :emerg : Process udevd (pid: 105, sta=
ck limit =3D 0xcb8da218)
    2021-12-04T06:03:09.796840  kern  :emerg : Stack: (0xcb8dbcf8 to 0xcb8d=
c000)
    2021-12-04T06:03:09.805078  kern  :emerg : bce0:                       =
                                bf02bdc4 60000013
    2021-12-04T06:03:09.812974  kern  :emerg : bd00: bf02bdc8 c06a384c 0000=
0001 00000000 bf010250 00000002 60000093 00000002
    2021-12-04T06:03:09.823504  kern  :emerg : bd20:[   49.319580] <LAVA_SI=
GNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=
=3D29>   =

 =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
panda     | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/61ab04bf1bba97b0161a94a6

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.293-4=
0-gdfee1c23c5f0d/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.293-4=
0-gdfee1c23c5f0d/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61ab04bf1bba97b=
0161a94a9
        failing since 2 days (last pass: v4.4.293-33-g845bf34b777ca, first =
fail: v4.4.293-33-gfe2c5280cbbe0)
        2 lines

    2021-12-04T06:03:21.833729  [   19.440460] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-04T06:03:21.883399  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/110
    2021-12-04T06:03:21.892854  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
