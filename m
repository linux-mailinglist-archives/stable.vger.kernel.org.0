Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7341044451E
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 17:00:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbhKCQDb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 12:03:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231787AbhKCQDa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Nov 2021 12:03:30 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4446C061714
        for <stable@vger.kernel.org>; Wed,  3 Nov 2021 09:00:53 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id y1so2743804plk.10
        for <stable@vger.kernel.org>; Wed, 03 Nov 2021 09:00:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=X5VkFzybBoM8Sq+fbnRgrqFsgr2iEb4k6ITpeGLJ7+s=;
        b=tNIiU1Aat2+4wQD6Xd1m1Ik7+q6uHT2Lquz1kxFNOaT35AhOelzdXIeQlRyvThjsNX
         2jUx1y5bCxBTvBLoUDJNRP9tVauRT7OnvbyKDIjjqa2g9idoJyMdjut7KCgsEtnzoHQS
         wk49ZtUk8pAJbgTJMRirY17Nrquxo2JZSQIjEy+IKLHngh9+SUoBuV0Ube+DVgzUxLBc
         Wde79X3YwU517CtKmCpDieVhzVVTi37igYVluk4+m2wJk09UEcggcAv7SW0JOZNaij4C
         w2I72wdHXjmftxRqunyq+k7F1IOjpBhrIvVad0ug2Wf715TyTqni3+8N3HPVEKk4GqMx
         zH4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=X5VkFzybBoM8Sq+fbnRgrqFsgr2iEb4k6ITpeGLJ7+s=;
        b=c5W/lH3vqGOxPDzpd77m3YUeR5Rc/SJPARfb9hh8KeCK74xWQjn5iml4ZmYaWfd7Nw
         4ZnGv+/JbsLHSQa+aX9bmAHrvueBirc2ZW/TaR4ZlwCtN9RaqdklPfrZqksErll7GUL+
         tLvXwfXa5Pnk8YNelL3F+JzEcUW+a8F1jac5o/rxFQpzZj9k7OO/Y/gx3j57UBHMQi95
         /YKY1Lhnr8YdR3PuUAgPcKvZuxtQ51o3maHJgt3a7pwK6pndt+yuBIaxap7c9ooCT0VY
         ODs9OxYsrJkaQrp39fh2xfAoZYVD3jY23xRCQsvmTeptuEF0LTzIIg94mQzaVgq61RDC
         yQvw==
X-Gm-Message-State: AOAM533qSWryqAwqk+2EYVixQoHAM+cCeucf68oUTZsrKXD1B4EEJXB3
        APHpo2gveMooAH8XX6eMP2lbYEuE96P7kiFJ
X-Google-Smtp-Source: ABdhPJxVR2bV6j7x8A5R64X5IEZ6CeXPq0UStF+7BcAQQUBp25QKFUK2ONH0C64/OiyWWYJ7dHZ+Ng==
X-Received: by 2002:a17:90a:6b0d:: with SMTP id v13mr15538229pjj.138.1635955252791;
        Wed, 03 Nov 2021 09:00:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g16sm3048010pfj.5.2021.11.03.09.00.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 09:00:52 -0700 (PDT)
Message-ID: <6182b234.1c69fb81.1423b.8f0b@mx.google.com>
Date:   Wed, 03 Nov 2021 09:00:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.291-1-gca04241b8259
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.4 baseline: 102 runs,
 2 regressions (v4.4.291-1-gca04241b8259)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 102 runs, 2 regressions (v4.4.291-1-gca04241b=
8259)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 2       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.291-1-gca04241b8259/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.291-1-gca04241b8259
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ca04241b82597a209e08914cb6a15d5258e950c0 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 2       =
   =


  Details:     https://kernelci.org/test/plan/id/618280cd2024ea83303358dc

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.291-1=
-gca04241b8259/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.291-1=
-gca04241b8259/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/618280ce2024ea83=
303358df
        new failure (last pass: v4.4.291-1-ge3e451067931)
        1 lines

    2021-11-03T12:29:48.088459  =

    2021-11-03T12:29:48.192430  / # #
    2021-11-03T12:29:48.193060  =

    2021-11-03T12:29:48.294413  / # #export SHELL=3D/bin/sh
    2021-11-03T12:29:48.294960  =

    2021-11-03T12:29:48.396184  / # export SHELL=3D/bin/sh. /lava-1020162/e=
nvironment
    2021-11-03T12:29:48.396621  =

    2021-11-03T12:29:48.497841  / # . /lava-1020162/environment/lava-102016=
2/bin/lava-test-runner /lava-1020162/0
    2021-11-03T12:29:48.499024  =

    2021-11-03T12:29:48.499900  / # /lava-1020162/bin/lava-test-runner /lav=
a-1020162/0 =

    ... (8 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/618280ce2024ea8=
3303358e1
        new failure (last pass: v4.4.291-1-ge3e451067931)
        29 lines

    2021-11-03T12:29:48.863580  [   49.235046] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-03T12:29:48.929553  kern  :emerg : Internal error: Oops - BUG: =
0 [#1] SMP ARM
    2021-11-03T12:29:48.935278  kern  :emerg : Process udevd (pid: 109, sta=
ck limit =3D 0xcb954218)
    2021-11-03T12:29:48.939716  kern  :emerg : Stack: (0xcb955cf8 to 0xcb95=
6000)
    2021-11-03T12:29:48.948214  kern  :emerg : 5ce0:                       =
                                bf02bdc4 60000013
    2021-11-03T12:29:48.956131  kern  :emerg : 5d00: bf02bdc8 c06a3554 0000=
0001 00000000 bf010250 00000002 60000093 00000002
    2021-11-03T12:29:48.968137  kern  :emerg : 5d20: ce343000 c06a52[   49.=
336364] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dli=
nes MEASUREMENT=3D29>   =

 =20
