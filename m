Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD43C45B30F
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 05:20:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233993AbhKXEXp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 23:23:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230442AbhKXEXn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Nov 2021 23:23:43 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68CBEC061574
        for <stable@vger.kernel.org>; Tue, 23 Nov 2021 20:20:33 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id c4so1445259pfj.2
        for <stable@vger.kernel.org>; Tue, 23 Nov 2021 20:20:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=EY/T4yR3hDjG+za2RIcug77OrhMEiXALRHj1K9bnQSs=;
        b=PcABm/C5IilTGSlrvahRZoGnEi9jYD9OODQp5MfSnsbAU5cgPhcGeZV3Yyk0cGctZ/
         +ro2O/HSLuN8WYOojMEDbg2JXidOc9Fd1Za5/qLw9fcUcgbAg/vhQ6Mmu0OZGHuOnofz
         IVoV/ANad/NycKvLJyeXB0WZ5TKti2BT+sXB4TdGS1QGEtpkyh0ybneKQH7pFW1NOYxy
         L+IE0/Lc3P95k6SdauFLD7al6wdjvij2EmEniEoqzqDwcEr9glnfWq3QN1/3pjY2fops
         Bu+3T/W0RXs7m5bX5I1hE5Mgzi5mfN/qCiI3nP67OLiPZxSgqdt4gDZ6wxLK6a9Pnrpw
         fndg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=EY/T4yR3hDjG+za2RIcug77OrhMEiXALRHj1K9bnQSs=;
        b=FAeJkz1Nj13VVXDMYldMYBZ6+ZJZjzjeIQThbXInJLbwsU2C6bWGJTZIgvbjAwQrld
         L6lAHRjkW3YhDjiYt0hiYyI9i6ulXPunAdp5R21oqT89MGKhMD2ZNqDsoslH1BQf9zKE
         +OpcVGH5x4dBS1h7AjNVpL6dve3O5LYD/lNThsd3ofIO3KlydHqP9kcFwohfoF5adH2Q
         m3Q6aL+vBGHIle9WT88arzyYZueZcqk9xZE+27bMqLMwhuLH1WM1iteMyFErW2M7mwSD
         u9r7t8CKQXKxIe1n/PSrFSxJUE0PBxM86/cgAv/rCUgxf6XPyTzBbp2/booePOgD21oj
         +aFw==
X-Gm-Message-State: AOAM533efakA5UvDNPqFr9JnMFlJEXsp7ZdP7QplEqEK+QpL543mYhXQ
        WgkVr5O4XA5ts4f5GQE4xpoDRUhX/PQGawk9
X-Google-Smtp-Source: ABdhPJz3ehxyQY7AcpJWPQiXACDjQAoBkgSnBZF4CxvwfW0Xrjk9v2PYqeapkyHYRHRefRuPKac9/Q==
X-Received: by 2002:a63:1515:: with SMTP id v21mr5897565pgl.258.1637727632683;
        Tue, 23 Nov 2021 20:20:32 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f2sm14922834pfe.132.2021.11.23.20.20.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 20:20:32 -0800 (PST)
Message-ID: <619dbd90.1c69fb81.6c1a8.a439@mx.google.com>
Date:   Tue, 23 Nov 2021 20:20:32 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.292-160-g9fe7a24760bc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y baseline: 104 runs,
 4 regressions (v4.4.292-160-g9fe7a24760bc)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 104 runs, 4 regressions (v4.4.292-160-g9fe7=
a24760bc)

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

qemu_i386 | i386 | lab-broonie   | gcc-10   | i386_defconfig      | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.292-160-g9fe7a24760bc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.292-160-g9fe7a24760bc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9fe7a24760bcd751891ae9029f78475757d8c107 =



Test Regressions
---------------- =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
beagle-xm | arm  | lab-baylibre  | gcc-10   | omap2plus_defconfig | 2      =
    =


  Details:     https://kernelci.org/test/plan/id/619d85ba9ae281e549f2efbc

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.292=
-160-g9fe7a24760bc/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.292=
-160-g9fe7a24760bc/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/619d85ba9ae281e5=
49f2efbf
        new failure (last pass: v4.4.292-160-g4ba1793245b0)
        1 lines

    2021-11-24T00:22:02.903144  / # =

    2021-11-24T00:22:02.904032  #
    2021-11-24T00:22:03.007866  / # #
    2021-11-24T00:22:03.008567  =

    2021-11-24T00:22:03.110102  / # #export SHELL=3D/bin/sh
    2021-11-24T00:22:03.110584  =

    2021-11-24T00:22:03.211923  / # export SHELL=3D/bin/sh. /lava-1131865/e=
nvironment
    2021-11-24T00:22:03.212425  =

    2021-11-24T00:22:03.313814  / # . /lava-1131865/environment/lava-113186=
5/bin/lava-test-runner /lava-1131865/0
    2021-11-24T00:22:03.315111   =

    ... (9 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619d85ba9ae281e=
549f2efc1
        new failure (last pass: v4.4.292-160-g4ba1793245b0)
        29 lines

    2021-11-24T00:22:03.779367  [   49.484710] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-24T00:22:03.830884  kern  :emerg : Internal error: Oops - BUG: =
0 [#1] SMP ARM
    2021-11-24T00:22:03.836761  kern  :emerg : Process udevd (pid: 111, sta=
ck limit =3D 0xcb990218)
    2021-11-24T00:22:03.841071  kern  :emerg : Stack: (0xcb991cf8 to 0xcb99=
2000)
    2021-11-24T00:22:03.849229  kern  :emerg : 1ce0:                       =
                                bf02bdc4 60000013   =

 =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
panda     | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/619d85aea66ada6d67f2efbf

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.292=
-160-g9fe7a24760bc/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.292=
-160-g9fe7a24760bc/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619d85aea66ada6=
d67f2efc2
        failing since 0 day (last pass: v4.4.292, first fail: v4.4.292-160-=
g4ba1793245b0)
        2 lines

    2021-11-24T00:21:44.733827  [   19.117492] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-24T00:21:44.776127  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/117
    2021-11-24T00:21:44.786715  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
qemu_i386 | i386 | lab-broonie   | gcc-10   | i386_defconfig      | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/619d96f7b5918d7a42f2efd1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.292=
-160-g9fe7a24760bc/i386/i386_defconfig/gcc-10/lab-broonie/baseline-qemu_i38=
6.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.292=
-160-g9fe7a24760bc/i386/i386_defconfig/gcc-10/lab-broonie/baseline-qemu_i38=
6.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/619d96f7b5918d7a42f2e=
fd2
        new failure (last pass: v4.4.292-160-g4ba1793245b0) =

 =20
