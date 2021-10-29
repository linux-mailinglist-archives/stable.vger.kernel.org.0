Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE33643FDB8
	for <lists+stable@lfdr.de>; Fri, 29 Oct 2021 16:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230521AbhJ2OCh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Oct 2021 10:02:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231669AbhJ2OCe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Oct 2021 10:02:34 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B13CC061570
        for <stable@vger.kernel.org>; Fri, 29 Oct 2021 06:59:58 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id in13so4913592pjb.1
        for <stable@vger.kernel.org>; Fri, 29 Oct 2021 06:59:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wCpy7CWJrykidsX8qZ7dnlXF9Om7lTOn+Sl6PKFv55E=;
        b=cy9XgsV5ZWq8x739c3vKyg2g6mHwcRmwASuOHoEOWi7bktqxdWmYZH9Ghv+kQ28/DZ
         Qpot5b0Jszr9rkhXh1c108sOVAJvM/VrYlYjLmmlfj+r+L30pPaSCEx+bdQo1jO9A0Gp
         WkjTzWVOBMlIom8ju02ejH7QOKMqV6GBLS7qlVl92CbFjbTJ/e0RkwwWsXmqTOcXfN0h
         A8KjKmgzQsoo+YomcRjg/Q/Y3+Dtt52fYs9TX2Pnn9ACRi5O/J/zGkvQQ98JitrE95Td
         JC5uxUcpb+Z1tXAv+YjevRjoGd7Jp4+1UZYd6QWKDmFCUSYyL5FDhNq4cPNCgU5FK9/i
         RqxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wCpy7CWJrykidsX8qZ7dnlXF9Om7lTOn+Sl6PKFv55E=;
        b=4IVjCyvMFjNF9sSShX8CUNH1pe6c/m6qc3xFYvRb/wZL6b55a3UOhSDAGSXj/rEdXs
         NKzotErV80JRIATBCN+y6Bwl6OGB7J4FALnUdAzGNFLWqIweYNjtjIrQUpXfvq4kzsFn
         ak4EETBXxPUb0Su9C3xTGD25QU1GPcP+ZkGBCk8x02654j95+A3yOUY+8WkU+rikIBoY
         6oVJmNXA80jPh/U7Mf4RxKRH0pTV73c9kyPg4p4unT6D4QZytdM6EWqnSKlHYF+esQW1
         7bKueHB2A9/6s9DiLGcipE3S9hPXqqaOijbphWa6wT5Nf8JXXdwu3nqMPv9F5gbxEqMW
         4EFw==
X-Gm-Message-State: AOAM531MSB51G9U3jBmcF65nCj0CIZ7HRRlSqCzA6EzONObvlDXDCzXI
        6XHF9nqqnGDvET1qCRLl1gN8avlpIjioXxQs
X-Google-Smtp-Source: ABdhPJyB23pUE4CEi82w1Q5SS4gS6xF93pCW71/uoYqNNpdyspZj+P7ELXq0C3p32f+m0Tak/tz3mQ==
X-Received: by 2002:a17:90b:4d0f:: with SMTP id mw15mr20085139pjb.207.1635515997628;
        Fri, 29 Oct 2021 06:59:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b18sm8040604pfl.24.2021.10.29.06.59.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Oct 2021 06:59:57 -0700 (PDT)
Message-ID: <617bfe5d.1c69fb81.34466.63c8@mx.google.com>
Date:   Fri, 29 Oct 2021 06:59:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.290-9-g7cba289fdf55
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.4 baseline: 85 runs,
 3 regressions (v4.4.290-9-g7cba289fdf55)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 85 runs, 3 regressions (v4.4.290-9-g7cba289fd=
f55)

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
el/v4.4.290-9-g7cba289fdf55/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.290-9-g7cba289fdf55
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7cba289fdf55937e06ef7adb38bedf8db54dc1ac =



Test Regressions
---------------- =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
beagle-xm | arm  | lab-baylibre  | gcc-10   | omap2plus_defconfig | 2      =
    =


  Details:     https://kernelci.org/test/plan/id/617bc6ec45fa041889335901

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.290-9=
-g7cba289fdf55/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.290-9=
-g7cba289fdf55/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/617bc6ec45fa0418=
89335904
        new failure (last pass: v4.4.290-4-gcc1528b708b2)
        1 lines

    2021-10-29T10:03:08.602399  / #
    2021-10-29T10:03:08.602928   #
    2021-10-29T10:03:08.705590  / # #
    2021-10-29T10:03:08.706096  =

    2021-10-29T10:03:08.807384  / # #export SHELL=3D/bin/sh
    2021-10-29T10:03:08.807696  =

    2021-10-29T10:03:08.908834  / # export SHELL=3D/bin/sh. /lava-1001777/e=
nvironment
    2021-10-29T10:03:08.909207  =

    2021-10-29T10:03:09.010351  / # . /lava-1001777/environment/lava-100177=
7/bin/lava-test-runner /lava-1001777/0
    2021-10-29T10:03:09.011250   =

    ... (9 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/617bc6ec45fa041=
889335906
        new failure (last pass: v4.4.290-4-gcc1528b708b2)
        29 lines

    2021-10-29T10:03:09.475235  [   49.388824] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-10-29T10:03:09.527578  kern  :emerg : Internal error: Oops - BUG: =
0 [#1] SMP ARM
    2021-10-29T10:03:09.533553  kern  :emerg : Process udevd (pid: 107, sta=
ck limit =3D 0xcb940218)
    2021-10-29T10:03:09.537800  kern  :emerg : Stack: (0xcb941cf8 to 0xcb94=
2000)
    2021-10-29T10:03:09.545994  kern  :emerg : 1ce0:                       =
                                bf02bdc4 60000013   =

 =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
panda     | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/617bc6e345fa0418893358f1

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.290-9=
-g7cba289fdf55/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.290-9=
-g7cba289fdf55/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/617bc6e345fa041=
8893358f4
        new failure (last pass: v4.4.290-4-gcc1528b708b2)
        2 lines

    2021-10-29T10:02:59.125844  [   18.987548] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-10-29T10:02:59.175479  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/113
    2021-10-29T10:02:59.184848  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
