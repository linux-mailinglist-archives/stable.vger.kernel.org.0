Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60C5845B104
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 02:11:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232772AbhKXBOj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 20:14:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231518AbhKXBOg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Nov 2021 20:14:36 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8AA6C061574
        for <stable@vger.kernel.org>; Tue, 23 Nov 2021 17:11:27 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id nh10-20020a17090b364a00b001a69adad5ebso994037pjb.2
        for <stable@vger.kernel.org>; Tue, 23 Nov 2021 17:11:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hUrRF6Zlh4s5sfFjrOj/Omepm6PSRm8/3d77wAJXBOA=;
        b=4RSxiJ2fGex+F8Kzv31W9g+1k5Yf8HU+lg8mTlcGrU3ROjTRjqGgcq7jUr0O1O9iox
         0imo9MDotmPKGDZUzl6dCVqH1yhwwNISYtmu5XZ11NFs1YbEeaeIBPDPwn3/to5es+ly
         XIu/grydwzyP73A8rv3cJDVUArRovrgiJoxGaW+RQ5S/JGvFiJ9Tr0sRal9zlM02fiR1
         VqRS/0t8k0GTMH3itB0TMl52OsCrrNOGY0Hf/997YeLskCL6TMsVZsYOSvTs4qtwzlGr
         PE9g6UjxID+JjVzDQwspSngtB1Zg26tiFxx4EgFjwvdVqVSQpiMTGgJ+qa/gE0EJeVFq
         mvqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hUrRF6Zlh4s5sfFjrOj/Omepm6PSRm8/3d77wAJXBOA=;
        b=CvsVUWU2KkJ6iR5DiBtKVOofkgPTkax8TbsG55RhP+6Z83krG/FiAGldgONZ2UQAun
         z6GYW5TtMv7Qu+/UEvC0Wlqm5X3b0XcfBmZJ3PVFWgfNSIkkurwetGWvA58Cg3Fc7fn0
         hywLRJ6iwRzF7W+crZTnTBjY2fXAIxrJORaz7XT3E/ffvuuBhfWpiM3R0sIp8BGom8Cg
         /szrQwAGSXpr5oaUQXDgw2jq/6zYQCNKmWMAVNxtbCja/M3UU4FVZTIDdSMhCVc5qIPC
         UEXahgNEaj5drrZ5hilkR1kGz3+dnI08+J9QWrt5pjVLgkdsGrP3kjX6Et4mAMAeuBmG
         J1OQ==
X-Gm-Message-State: AOAM531EwMxTTHnn9Tt2awgkrVLbxnv9EESe0IIBLoKEXndfnCEdQU9m
        97z97FnFTCbq0ufXX/3AGgxZHvoMKBDolTZQ
X-Google-Smtp-Source: ABdhPJxxudaPwUHYPOSi0R7KX6Ny7vzU35hUOg1D6cE6gMvsfuleb8MxZp7bxTPkQuhRla/K+RK0TA==
X-Received: by 2002:a17:90a:909:: with SMTP id n9mr2741536pjn.1.1637716287235;
        Tue, 23 Nov 2021 17:11:27 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w17sm13584051pfu.58.2021.11.23.17.11.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 17:11:26 -0800 (PST)
Message-ID: <619d913e.1c69fb81.44755.7366@mx.google.com>
Date:   Tue, 23 Nov 2021 17:11:26 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.292-159-g6fb3dd7395527
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.4 baseline: 107 runs,
 3 regressions (v4.4.292-159-g6fb3dd7395527)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 107 runs, 3 regressions (v4.4.292-159-g6fb3dd=
7395527)

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
el/v4.4.292-159-g6fb3dd7395527/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.292-159-g6fb3dd7395527
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6fb3dd7395527989a7335426812b1166c1c1f32e =



Test Regressions
---------------- =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
beagle-xm | arm  | lab-baylibre  | gcc-10   | omap2plus_defconfig | 2      =
    =


  Details:     https://kernelci.org/test/plan/id/619d593cb55fb4ab11f2efb5

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.292-1=
59-g6fb3dd7395527/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.292-1=
59-g6fb3dd7395527/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/619d593cb55fb4ab=
11f2efb8
        new failure (last pass: v4.4.292-159-ga5eb1696f0eda)
        1 lines

    2021-11-23T21:12:11.761830  / #
    2021-11-23T21:12:11.762909   #
    2021-11-23T21:12:11.867469  / # #
    2021-11-23T21:12:11.868392  =

    2021-11-23T21:12:11.970204  / # #export SHELL=3D/bin/sh
    2021-11-23T21:12:11.970786  =

    2021-11-23T21:12:12.072300  / # export SHELL=3D/bin/sh. /lava-1130506/e=
nvironment
    2021-11-23T21:12:12.073048  =

    2021-11-23T21:12:12.174582  / # . /lava-1130506/environment/lava-113050=
6/bin/lava-test-runner /lava-1130506/0
    2021-11-23T21:12:12.176205   =

    ... (9 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619d593cb55fb4a=
b11f2efba
        new failure (last pass: v4.4.292-159-ga5eb1696f0eda)
        29 lines

    2021-11-23T21:12:12.538332  [   49.210754] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-23T21:12:12.604648  kern  :emerg : Internal error: Oops - BUG: =
0 [#1] SMP ARM
    2021-11-23T21:12:12.610407  kern  :emerg : Process udevd (pid: 115, sta=
ck limit =3D 0xcba30218)
    2021-11-23T21:12:12.614886  kern  :emerg : Stack: (0xcba31cf8 to 0xcba3=
2000)
    2021-11-23T21:12:12.622977  kern  :emerg : 1ce0:                       =
                                bf02bdc4 60000013
    2021-11-23T21:12:12.631244  kern  :emerg : 1d00: bf02bdc8 c06a3614 0000=
0001 00000000 bf010250 00000002 60000093 00000002   =

 =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
panda     | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/619d58a2460c6dd7d1f2efbe

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.292-1=
59-g6fb3dd7395527/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.292-1=
59-g6fb3dd7395527/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619d58a2460c6dd=
7d1f2efc1
        failing since 1 day (last pass: v4.4.292-116-gc13aef2ca259, first f=
ail: v4.4.292-140-g1794f2b1b0d51)
        2 lines

    2021-11-23T21:09:40.614483  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/117
    2021-11-23T21:09:40.623655  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
