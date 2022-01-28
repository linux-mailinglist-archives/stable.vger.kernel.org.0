Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C285F49FB62
	for <lists+stable@lfdr.de>; Fri, 28 Jan 2022 15:11:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344122AbiA1OLT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jan 2022 09:11:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235281AbiA1OLS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jan 2022 09:11:18 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97109C061714
        for <stable@vger.kernel.org>; Fri, 28 Jan 2022 06:11:18 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id o64so6601095pjo.2
        for <stable@vger.kernel.org>; Fri, 28 Jan 2022 06:11:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FskTcEeL9xQi2ZZn7EcjBwqdLQfI5IIJ6WdgrqxCJ80=;
        b=e5LYFfs10MPkoobw6xajAKs1X/cJan702Dw2gfMyuIgxdpivMYpyBQQvgMsER4Xxvc
         I4yyBksWJhPReGKsnDHLMd2vUhOCQSSCeq+H+MIsDW4ndGUAfzCcjlASNJMeoP6y7cT1
         nP7XLJc6Ju66ufoHeyJOGXfWTpmn1erXN648kOA7LSliApsaUr/3YmvYoKdBgleyCHRX
         oXfcJjKaquB9ID35xrVmXRLXmGw22QPc9IzwkMZ5oaSnhDTMudoTCQt/LILNSJB4mtoY
         X/rhjfCKB7m6g1ax5eEm+eD08fWt0m+8Q3Qt3F+E0ix7rwonwrE2fBpWXW8uLtkBV1cK
         UNsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FskTcEeL9xQi2ZZn7EcjBwqdLQfI5IIJ6WdgrqxCJ80=;
        b=s2/auUSUax0ngVVy5glT21DneIwz8pSgBGQL2a3e/NpkMDtD4QnHw5InJIS6OW1b/e
         6sFGTu4iA8+Pn4empyz+tjkPT0NKxQdfDS7THes6gVEkb7i5MpF/Zr1aCGJTYd3oXNzo
         QUuaf9bfLncYguPdW7gJobFRbSojJ0vrZODhd4bPQ3G80OP6LMwqj0ZG7WFliYRM5RTZ
         1o65w0lBCuDDIlw0MxBmqv8/ObleGie2wtiH6fq6NhzrdbdxZme7zYAZ0oTxgUr9jmKl
         phElYDnlJs7ERJhEsGeNUBEo1Odk5pFbtRwUuK8z5XdAGmwdhmuV4BsyafXSasx6QKDs
         RMrg==
X-Gm-Message-State: AOAM533IXdrLISDwqLOghyv/WKKIdJ0u6cdMkMFa5G3yTpwcNw9EfdVR
        siWLn6UjFJ8KCbUc5VYUyhjKAfUOJocAdyPI
X-Google-Smtp-Source: ABdhPJxPwhcbTOhO3lMR4tzP2KJz/8qLMLkVO1/njtxZXdLj0YNJ9SdBM/TGagnQEcOFvAiiqYls4A==
X-Received: by 2002:a17:90b:1647:: with SMTP id il7mr12157601pjb.119.1643379077831;
        Fri, 28 Jan 2022 06:11:17 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c2sm22463883pgi.55.2022.01.28.06.11.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 06:11:17 -0800 (PST)
Message-ID: <61f3f985.1c69fb81.bb667.d9af@mx.google.com>
Date:   Fri, 28 Jan 2022 06:11:17 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.300-1-gf72eb9d3ea7d
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 88 runs,
 3 regressions (v4.4.300-1-gf72eb9d3ea7d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 88 runs, 3 regressions (v4.4.300-1-gf72eb9d3e=
a7d)

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
el/v4.4.300-1-gf72eb9d3ea7d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.300-1-gf72eb9d3ea7d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f72eb9d3ea7de2add4527dcc2bc51fc9715f15fd =



Test Regressions
---------------- =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
beagle-xm | arm  | lab-baylibre  | gcc-10   | omap2plus_defconfig | 2      =
    =


  Details:     https://kernelci.org/test/plan/id/61f3c0f6109853bfa7abbd13

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.300-1=
-gf72eb9d3ea7d/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.300-1=
-gf72eb9d3ea7d/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/61f3c0f6109853bf=
a7abbd19
        failing since 1 day (last pass: v4.4.299-113-g69586d700c98, first f=
ail: v4.4.299-113-g0e155d64d107)
        1 lines

    2022-01-28T10:09:40.300074  / # =

    2022-01-28T10:09:40.300606  #
    2022-01-28T10:09:40.403307  / # #
    2022-01-28T10:09:40.403891  =

    2022-01-28T10:09:40.505151  / # #export SHELL=3D/bin/sh
    2022-01-28T10:09:40.505457  =

    2022-01-28T10:09:40.606572  / # export SHELL=3D/bin/sh. /lava-1462704/e=
nvironment
    2022-01-28T10:09:40.606873  =

    2022-01-28T10:09:40.707994  / # . /lava-1462704/environment/lava-146270=
4/bin/lava-test-runner /lava-1462704/0
    2022-01-28T10:09:40.708846   =

    ... (9 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61f3c0f6109853b=
fa7abbd1b
        failing since 1 day (last pass: v4.4.299-113-g69586d700c98, first f=
ail: v4.4.299-113-g0e155d64d107)
        29 lines

    2022-01-28T10:09:41.224995  kern  :emerg : Internal error: Oops - BUG: =
0 [#1] SMP ARM
    2022-01-28T10:09:41.230909  kern  :emerg : Process udevd (pid: 106, sta=
ck limit =3D 0xcb924218)
    2022-01-28T10:09:41.235162  kern  :emerg : Stack: (0xcb925cf8 to 0xcb92=
6000)
    2022-01-28T10:09:41.243443  kern  :emerg : 5ce0:                       =
                                bf02bdc4 60000013
    2022-01-28T10:09:41.255408  kern  :emerg : 5d00: bf02bdc8 c06a[   49.48=
3154] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dline=
s MEASUREMENT=3D29>   =

 =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
panda     | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/61f3c104a63fbbc050abbd1d

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.300-1=
-gf72eb9d3ea7d/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.300-1=
-gf72eb9d3ea7d/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61f3c104a63fbbc=
050abbd23
        failing since 0 day (last pass: v4.4.299-113-g0e155d64d107, first f=
ail: v4.4.300-1-g5b4f04e1d4173)
        2 lines

    2022-01-28T10:10:00.171703  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, kworker/0:0/4
    2022-01-28T10:10:00.181023  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2022-01-28T10:10:00.198872  [   19.351745] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
