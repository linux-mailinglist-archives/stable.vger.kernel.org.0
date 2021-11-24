Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE2445CA90
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 18:03:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243100AbhKXRGL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 12:06:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241709AbhKXRGL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 12:06:11 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65A1DC061574
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 09:03:01 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id w33-20020a17090a6ba400b001a722a06212so4644406pjj.0
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 09:03:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZKkimpAPLpuo/zBqejVJVHTYQmr20H0ZVXRtEscQEnA=;
        b=wNJhqjtIVNTWXdrAqcMOoLPDfor8KH3cDFPRhqz8NU/hape5NOiFFkQB7bouY5LISJ
         Br8+W8k+Zm0AbunFISxpYVlQZieD7fFe6luhOW1D4FL8+ALzp9oxvMx1FR44GTJY+N49
         fCHQp2XONH51l30Zqm4CDpBzrN7o0E3LuhRAYpImv5BMhN/jVHOAK6zFx2ayFp8BQlhm
         K4R8d7ccuE+z58ViZ0+Z0mJIio0RBsmqo12PN/bjUymO3l9DRa+PMYG/yGM1/J+Jmspz
         SUK6ZiD6uvLM53Ap3EnpLYMQPiDD8zbPY70zdPKnuEpyZUpxJJDLTOKVeNf61DANmIBh
         GhPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZKkimpAPLpuo/zBqejVJVHTYQmr20H0ZVXRtEscQEnA=;
        b=n/4BJBvmqcc5Hn88yyXUDPkxRXg9lOZP7SLJgUdaws4tdMlUHBRjqnJRuJyJalpq1S
         eQs3Gg6DlUNEst3hjBasBe4pFsOM/GuGHnxeyA/BYWrVZLtDynjTdSnDPc52SKV7au4x
         J82GteHyBi0IvjYsUTaRi02cMCjBgKOTjZCJYWd1I4gJ6lOpi+5WOKURFN5IMiwkY8Bi
         oDSaYukMEkT5PwEJG1G/8DB5LU9e7gG76qF9ODayNxTbSQ6nr9LUvOtahFKY1Om8cK0t
         pXHMojdY+21QM8qL9nGjhN6PiEuFgTeU/sIAumqAGgc0dBtJUsd7Jeo45kKBeeH685e0
         4t+Q==
X-Gm-Message-State: AOAM530HfjnM2fsbvcUFaGzwiCw7pPhUB32sXBOgmKiPmSxJC8MqQEOP
        zA94QG16zPpTWslsRmK0V3r+et5OtH2qxosy7ss=
X-Google-Smtp-Source: ABdhPJzTtF/LNEAfUGpXkraL0wm2HJ7KKypkQ39+gX34LyNevXhCTy227KHuuC9p7dFV2ZOgpX3g5w==
X-Received: by 2002:a17:90b:3b8d:: with SMTP id pc13mr10767322pjb.112.1637773380674;
        Wed, 24 Nov 2021 09:03:00 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 95sm255268pjo.2.2021.11.24.09.03.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 09:03:00 -0800 (PST)
Message-ID: <619e7044.1c69fb81.5f3f0.0c6d@mx.google.com>
Date:   Wed, 24 Nov 2021 09:03:00 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.292-162-g1b443c26f69b9
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.4 baseline: 40 runs,
 3 regressions (v4.4.292-162-g1b443c26f69b9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 40 runs, 3 regressions (v4.4.292-162-g1b443c2=
6f69b9)

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
el/v4.4.292-162-g1b443c26f69b9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.292-162-g1b443c26f69b9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1b443c26f69b92f69ca368a4a690872277f1c9b2 =



Test Regressions
---------------- =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
beagle-xm | arm  | lab-baylibre  | gcc-10   | omap2plus_defconfig | 2      =
    =


  Details:     https://kernelci.org/test/plan/id/619e368702aa296524f2efeb

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.292-1=
62-g1b443c26f69b9/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.292-1=
62-g1b443c26f69b9/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/619e368802aa2965=
24f2efee
        failing since 0 day (last pass: v4.4.292-159-ga5eb1696f0eda, first =
fail: v4.4.292-159-g6fb3dd7395527)
        1 lines

    2021-11-24T12:56:19.559514  / #
    2021-11-24T12:56:19.560175   #
    2021-11-24T12:56:19.662924  / # #
    2021-11-24T12:56:19.663461  =

    2021-11-24T12:56:19.764750  / # #export SHELL=3D/bin/sh
    2021-11-24T12:56:19.765069  =

    2021-11-24T12:56:19.866199  / # export SHELL=3D/bin/sh. /lava-1135248/e=
nvironment
    2021-11-24T12:56:19.866513  =

    2021-11-24T12:56:19.967653  / # . /lava-1135248/environment/lava-113524=
8/bin/lava-test-runner /lava-1135248/0
    2021-11-24T12:56:19.968508   =

    ... (10 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619e368802aa296=
524f2eff0
        failing since 0 day (last pass: v4.4.292-159-ga5eb1696f0eda, first =
fail: v4.4.292-159-g6fb3dd7395527)
        29 lines

    2021-11-24T12:56:20.430276  [   49.369201] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-24T12:56:20.482383  kern  :emerg : Internal error: Oops - BUG: =
0 [#1] SMP ARM
    2021-11-24T12:56:20.488174  kern  :emerg : Process udevd (pid: 107, sta=
ck limit =3D 0xcb900218)
    2021-11-24T12:56:20.492652  kern  :emerg : Stack: (0xcb901cf8 to 0xcb90=
2000)
    2021-11-24T12:56:20.500873  kern  :emerg : 1ce0:                       =
                                bf02bdc4 60000013
    2021-11-24T12:56:20.513988  kern  :emerg : 1d00: bf02bdc8 c06a3614 0000=
0001 00[   49.449707] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Df=
ail UNITS=3Dlines MEASUREMENT=3D29>   =

 =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
panda     | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/619e366f02aa296524f2efa1

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.292-1=
62-g1b443c26f69b9/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.292-1=
62-g1b443c26f69b9/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619e366f02aa296=
524f2efa4
        failing since 2 days (last pass: v4.4.292-116-gc13aef2ca259, first =
fail: v4.4.292-140-g1794f2b1b0d51)
        2 lines

    2021-11-24T12:56:07.584028  [   19.379669] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-24T12:56:07.614492  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/119
    2021-11-24T12:56:07.623675  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
