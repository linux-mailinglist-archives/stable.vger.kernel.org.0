Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B88DF458623
	for <lists+stable@lfdr.de>; Sun, 21 Nov 2021 20:27:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235293AbhKUTaq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Nov 2021 14:30:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235179AbhKUTap (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Nov 2021 14:30:45 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B78C5C061574
        for <stable@vger.kernel.org>; Sun, 21 Nov 2021 11:27:40 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id 206so8351289pgb.4
        for <stable@vger.kernel.org>; Sun, 21 Nov 2021 11:27:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IgSocVvQEj9ksj3OuGc2MDTzUL3bya46EGslivZOqZ0=;
        b=OLjFLdI4z7xyzLRHvPeMzHmjfH10aKEA4lrXCBVoI82R+5CwiEf9emzqVVXY+Aicbi
         3+EaNvRr/W7Rpzk6XcAroeiNZqUwzDirM91pWrVkZPuzXm1WCCstbz/hcrv/Wr+H+PD8
         TeryO9EGD0ZX6nyHPH36flhKFGInHWEqEWaQy0Msnn3461rG9/McFCWSuhWCH4xflk8O
         WQoWDtjTNizLuQ/vqICXvZDMK2MFHr0tXolEmWH8yRut8HUHU3wRw2YCSCSoyl983hVm
         kJox1Y0RBArKKDttYr9C+nhRLDMegC7AnIwJ1LSAjxRueI01s8iMeGu8teljAKXy33Co
         pH1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IgSocVvQEj9ksj3OuGc2MDTzUL3bya46EGslivZOqZ0=;
        b=fIYTvvj8Ujxqgd9m6RXAJZJUZOFBXAjemfTzvObD46uMN/JsG6+eSY+44d2smV01RK
         9dmLbQJgVh1z8cb4t+ZGmjltdvx9Utg+XKfUMqG19+coBjGnmXRECrSr8fphdL7STi36
         53kJPZMbfAt0jMt5ipUkidiMxKvoHPn4s6JGG74umkXOTlMwjLrCcXoBgb5vEIFVzs6c
         Z817Nf6ISDOz2Vh4MuHyh2X22tTnn141zLGddgIxgvUgn9VZsute/HhihlNGr9/PB5RB
         SJ2RG/pW1hdYMvqghXNb4KqNDB2GrfKoq/tIicQI+ehus9368qtgGkXdWpakGhZ0Kw7K
         F/Xg==
X-Gm-Message-State: AOAM531zqMcdh2cOxY4ip9rTCEOIB/LplYDPX2stGQjcPCJvdgdtc54J
        Wa+nMYrn3Cy4RDpTENSIf5DTciw7eCOR6aHP
X-Google-Smtp-Source: ABdhPJx1xDImAC/cp29unmQodJVSF8UwkVB534/qa4HKBPYgubiQ43fr7jlrsT4oH7EZ0A8C61X1Qg==
X-Received: by 2002:a63:cf06:: with SMTP id j6mr29545271pgg.100.1637522860076;
        Sun, 21 Nov 2021 11:27:40 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g7sm6390336pfv.159.2021.11.21.11.27.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Nov 2021 11:27:39 -0800 (PST)
Message-ID: <619a9dab.1c69fb81.9925e.2cb9@mx.google.com>
Date:   Sun, 21 Nov 2021 11:27:39 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.290-161-g71211c0fc2c9
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 132 runs,
 1 regressions (v4.9.290-161-g71211c0fc2c9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 132 runs, 1 regressions (v4.9.290-161-g71211c=
0fc2c9)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.290-161-g71211c0fc2c9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.290-161-g71211c0fc2c9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      71211c0fc2c9e24c5aec443e6e8eb1b4b40ec02a =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/619a63e3ee94ad37a8e55203

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.290-1=
61-g71211c0fc2c9/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.290-1=
61-g71211c0fc2c9/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619a63e3ee94ad3=
7a8e55209
        failing since 0 day (last pass: v4.9.290-161-ge496b1c75ac2, first f=
ail: v4.9.290-161-g520a4edb46f8)
        2 lines

    2021-11-21T15:20:44.418055  [   20.139129] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-21T15:20:44.461389  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/122
    2021-11-21T15:20:44.470438  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
