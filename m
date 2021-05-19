Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C662C388763
	for <lists+stable@lfdr.de>; Wed, 19 May 2021 08:13:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231532AbhESGOs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 May 2021 02:14:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231191AbhESGOs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 May 2021 02:14:48 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74BAAC06175F
        for <stable@vger.kernel.org>; Tue, 18 May 2021 23:13:28 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id gm21so6776618pjb.5
        for <stable@vger.kernel.org>; Tue, 18 May 2021 23:13:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=MJOBrB6x/AWzDsBNR+vT5eHAtiG2KyJ2PH4MRSHiQiE=;
        b=XOO6h3r3byYKOCq3Uc7zJR+U7jXUIwVt9NkMmdNp9zThllj4B/n6uqjGM9Z+I+IQ8p
         Z/+JA4tUYPvwtoFZ4MK+GWLe7nUN1Fak15+UUZopO6zgOzsxeo7cLU5DFmOFbVEc4MHU
         3l6sGUdxhXKkvtQmy1OUmy216iwCx69KYpgjSf1cLAXWwjuoEE0z5aWroySX7/AgzOSp
         cU1nCZPIOYlOVzUcYaByi0FzinY7SWKgiFmI56N4J+m4VqmRQZCcJyz3L7fqn8Ovza2Y
         DBrFj9NoAzueYMOIj594e53wRZC97NJ3OnAN4mrLLb2zU+z0JWyeTn+wRXAahWT3K3QM
         FDyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=MJOBrB6x/AWzDsBNR+vT5eHAtiG2KyJ2PH4MRSHiQiE=;
        b=HxfOU78kKa/XhOyjQPiJTBSCvTHVKuqdu5ot4i9rKMYUoczYGZNJ486X1V+jbNZ7/0
         3tfnHBvsotL5JD7rVjNTMXyU6N45wOwG5oXrOVUljFTrUaaU7v2fZlml6+9h8SYfkcoe
         4VBSmqIgQqQ9a7arFVFfphjGLrFTmrdXPzmOHSdG71WNulIGKcKOpYDkQ1DqnkukX7Z6
         O6rcE8M96bq0h5RqMPy1ESAJ4c9PGaSjol6b72uk7hRv57SBfnWiaE4mSa39QfNY5vvd
         Do6dBN2MbI5E/rwsCc0H7XVmnrAqN5hno4e1V055RxTSKFN86jnzuiLyEZZ37VQwi/H/
         wObA==
X-Gm-Message-State: AOAM531GjceJP2up0bdnenY/ubA2I/B4tNHFemfQ0IlCHbpEX/lJmndy
        Yuh3Smekk0z63BXYvCkEoK5dSrW+km6fa0cx
X-Google-Smtp-Source: ABdhPJxBwH64OY8i208x6OdunUJhRUDWK1aIkZnCmvncCGZc1agoYEqz8HcAeDiriNLr7VDsEbtDVg==
X-Received: by 2002:a17:902:ba8a:b029:ec:b04c:451d with SMTP id k10-20020a170902ba8ab02900ecb04c451dmr8897285pls.67.1621404807803;
        Tue, 18 May 2021 23:13:27 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t22sm3366055pjr.43.2021.05.18.23.13.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 23:13:27 -0700 (PDT)
Message-ID: <60a4ac87.1c69fb81.29168.cb35@mx.google.com>
Date:   Tue, 18 May 2021 23:13:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.37-289-g6deaf6c7d6e4
X-Kernelci-Branch: queue/5.10
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 160 runs,
 3 regressions (v5.10.37-289-g6deaf6c7d6e4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 160 runs, 3 regressions (v5.10.37-289-g6deaf=
6c7d6e4)

Regressions Summary
-------------------

platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
bcm2837-rpi-3-b-32       | arm  | lab-baylibre | gcc-8    | bcm2835_defconf=
ig  | 1          =

imx6q-var-dt6customboard | arm  | lab-baylibre | gcc-8    | multi_v7_defcon=
fig | 2          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.37-289-g6deaf6c7d6e4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.37-289-g6deaf6c7d6e4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6deaf6c7d6e4d7545b8a6b11133ee12429131d26 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
bcm2837-rpi-3-b-32       | arm  | lab-baylibre | gcc-8    | bcm2835_defconf=
ig  | 1          =


  Details:     https://kernelci.org/test/plan/id/60a4799cb3a8fe369db3afa7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.37-=
289-g6deaf6c7d6e4/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.37-=
289-g6deaf6c7d6e4/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a4799cb3a8fe369db3a=
fa8
        failing since 1 day (last pass: v5.10.37-289-gf12d611314b3, first f=
ail: v5.10.37-289-g371f71e1d51b) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
imx6q-var-dt6customboard | arm  | lab-baylibre | gcc-8    | multi_v7_defcon=
fig | 2          =


  Details:     https://kernelci.org/test/plan/id/60a47bb4126a7230a0b3af98

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.37-=
289-g6deaf6c7d6e4/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-=
var-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.37-=
289-g6deaf6c7d6e4/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-=
var-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/60a47bb4126a723=
0a0b3af9e
        new failure (last pass: v5.10.37-289-g371f71e1d51b)
        4 lines

    2021-05-19 02:41:45.344000+00:00  kern  :alert : Unhandled fault: align=
ment exception (0x001) at 0xcec60217
    2021-05-19 02:41:45.344000+00:00  kern  :alert : pgd =3D (ptrval)
    2021-05-19 02:41:45.345000+00:00  kern  :alert : [<8>[   42.592090] <LA=
VA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASURE=
MENT=3D4>
    2021-05-19 02:41:45.345000+00:00  cec60217] *pgd=3D1ec1141e(bad)   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60a47bb4126a723=
0a0b3af9f
        new failure (last pass: v5.10.37-289-g371f71e1d51b)
        26 lines

    2021-05-19 02:41:45.397000+00:00  kern  :emerg : Process kworker/1:2 (p=
id: 80, stack limit =3D 0x(ptrval))
    2021-05-19 02:41:45.397000+00:00  kern  :emerg : Stack: (0xc356beb0 to<=
8>[   42.638252] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail U=
NITS=3Dlines MEASUREMENT=3D26>
    2021-05-19 02:41:45.397000+00:00   0xc356c000)
    2021-05-19 02:41:45.398000+00:00  kern  :emerg : bea0<8>[   42.649856] =
<LAVA_SIGNAL_ENDRUN 0_dmesg 348446_1.5.2.4.1>
    2021-05-19 02:41:45.398000+00:00  :                                    =
 00000000 00000000 c356a000 cec60217   =

 =20
