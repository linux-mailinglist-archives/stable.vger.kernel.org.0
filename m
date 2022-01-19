Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF8394933C1
	for <lists+stable@lfdr.de>; Wed, 19 Jan 2022 04:49:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350917AbiASDs5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 22:48:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351348AbiASDsz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 22:48:55 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38D03C061574
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 19:48:55 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id i65so1276745pfc.9
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 19:48:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FFa7L+1j3Y7Ri55abMuw7w4bp+p4zG7nDfd0ZJB3gq4=;
        b=ONffnhdEDpEFBanWojCOGud/MXAEtBiiAr+vXNSl0VTZc+hfUX0d8+nyOmRt2E6h0M
         yTcvdoj8oBVr+7UVveCYIzYNqouWaas3vhb7OnYDnNyhXWwGSEjFuVEJlmZBUelZRmxy
         8vdx8jBnSELA6tcZzqiQeb+2r7kah9EHYYiT2o6cuxWjHHN4qycK6QCQNzmXtlzrFk7+
         3mtIrMESBePFx48KckX04ylO9z7pRTPKrNu/TkP+4liQiIATNjogPynCzq9f9rNujDW3
         0wD0on5VemXn3JR3foC2/FqSu3OlnWa6iVfabotna/JcRvEsk0C6ebrIPvDBIXiqUcP0
         SzHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FFa7L+1j3Y7Ri55abMuw7w4bp+p4zG7nDfd0ZJB3gq4=;
        b=cp7cZ0Gy/LfntDd8ay/QZ8r/OkqymMUYAefPMmP7q6PsmuR/A+sKJkzj/9VHD4iAeL
         tgKUWiwAUB3dSbDXvG/pCuRBJQ0od8ggi3HXrRBwzgWcYTiO0pbKtnDW1AMmkDB+N2OZ
         MhQ4mPlnDpOdodzWeUkCgzCnDNeC1sCql7h2KAUpaA3BKsA0bAYbMMYCZiGUPI+ZKhh2
         Zugl/ZQ2VEw+5saPKFJqHBI7wJF88QXPjdqomWoE0aDfpZH8pHkxCWi5HSDXcQJRZ1Kj
         OqkTsRAu7n5t1uEheUflJtwU6/XmE/dg0JJ563sYoVE1SuhIZgmZaWZrU+UqAERO86iZ
         jyQA==
X-Gm-Message-State: AOAM532/FHuyQoxUW4ZUtuSKbdRlGVW5gXeB055NymkixcYxsdPRiGTJ
        bGM9F29oOVxkryAXLOWpBBY+OUBN6s5Uxh1m
X-Google-Smtp-Source: ABdhPJwTv+SyqQVppGOB4BhSprEUKUe643twyWdJkMYjyX6rzqf7i/JU3z8d1gxYs6eDzJ50EFC+WQ==
X-Received: by 2002:a63:bf48:: with SMTP id i8mr25389633pgo.368.1642564134578;
        Tue, 18 Jan 2022 19:48:54 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y11sm19007615pfi.7.2022.01.18.19.48.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 19:48:54 -0800 (PST)
Message-ID: <61e78a26.1c69fb81.9eed4.43d9@mx.google.com>
Date:   Tue, 18 Jan 2022 19:48:54 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.299-9-gdb49fa813c04
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 98 runs,
 3 regressions (v4.4.299-9-gdb49fa813c04)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 98 runs, 3 regressions (v4.4.299-9-gdb49fa813=
c04)

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
el/v4.4.299-9-gdb49fa813c04/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.299-9-gdb49fa813c04
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      db49fa813c04eed3249f2cf736c389c25a661261 =



Test Regressions
---------------- =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
beagle-xm | arm  | lab-baylibre  | gcc-10   | omap2plus_defconfig | 2      =
    =


  Details:     https://kernelci.org/test/plan/id/61e7564459e92da3f6abbd1b

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.299-9=
-gdb49fa813c04/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.299-9=
-gdb49fa813c04/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/61e7564559e92da3=
f6abbd21
        new failure (last pass: v4.4.299-9-gd634fb6b6f52)
        1 lines

    2022-01-19T00:07:16.024016  / #
    2022-01-19T00:07:16.026330   #
    2022-01-19T00:07:16.134194  / # #
    2022-01-19T00:07:16.136207  =

    2022-01-19T00:07:16.239747  / # #export SHELL=3D/bin/sh
    2022-01-19T00:07:16.241190  =

    2022-01-19T00:07:16.343818  / # export SHELL=3D/bin/sh. /lava-1416229/e=
nvironment
    2022-01-19T00:07:16.345260  =

    2022-01-19T00:07:16.447880  / # . /lava-1416229/environment/lava-141622=
9/bin/lava-test-runner /lava-1416229/0
    2022-01-19T00:07:16.451507   =

    ... (9 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61e7564559e92da=
3f6abbd23
        new failure (last pass: v4.4.299-9-gd634fb6b6f52)
        29 lines

    2022-01-19T00:07:16.923268  [   49.500030] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-19T00:07:16.977132  kern  :emerg : Internal error: Oops - BUG: =
0 [#1] SMP ARM
    2022-01-19T00:07:16.982204  kern  :emerg : Process udevd (pid: 109, sta=
ck limit =3D 0xcb950218)
    2022-01-19T00:07:16.986815  kern  :emerg : Stack: (0xcb951cf8 to 0xcb95=
2000)
    2022-01-19T00:07:16.995062  kern  :emerg : 1ce0:                       =
                                bf02bdc4 60000013
    2022-01-19T00:07:17.007928  kern  :emerg : 1d00: bf02bdc8 c06a3cdc 0000=
0001 00[   49.582916] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Df=
ail UNITS=3Dlines MEASUREMENT=3D29>   =

 =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
panda     | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/61e7564789adf68b19abbd1d

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.299-9=
-gdb49fa813c04/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.299-9=
-gdb49fa813c04/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61e7564789adf68=
b19abbd23
        failing since 29 days (last pass: v4.4.295-12-gd8298cd08f0d, first =
fail: v4.4.295-23-gcec9bc2aa5d3)
        2 lines

    2022-01-19T00:07:16.238603  [   19.254089] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-19T00:07:16.288299  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/121
    2022-01-19T00:07:16.297060  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
