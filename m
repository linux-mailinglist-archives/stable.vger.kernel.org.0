Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADCC9470A55
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 20:24:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242813AbhLJT1n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 14:27:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242801AbhLJT1n (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 14:27:43 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 751EBC061746
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 11:24:07 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id v23so7497535pjr.5
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 11:24:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=plnjI2wlKDLz5Szsorpmq6cBUzCaSyhRcPOZOczo0Jw=;
        b=Ets/ftARLLFqFiARoGYOBDFG4keH0+MGmNV6UItqUzvMtkt4Io5bvIAVGu2QoLpaJX
         UmhHAyeFAMWkRKBmvnx/y5fvkbmK3i3KKrMESse2TvLwLW78xGL+IsTi5jm/dtxoKNkl
         nKoypd/twJMKG2E0RbpBpzyz6Z9MvRn8WtJTtoP4JZSXzq/dTzMae6IKrqtY1rSWAXJ5
         vhln8jGXIOI5NYtNOnzulVwmIuKJ033riEaoInF4U8wgThYqHWx05f2uEzLtGoFq/K6p
         TbE0ssrdrC4JzDzadmJjBMX4ktSacyysbvAcLFTLfHSilDbZ1mre+Xl2puCHQMn3GY8N
         yOeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=plnjI2wlKDLz5Szsorpmq6cBUzCaSyhRcPOZOczo0Jw=;
        b=lgOAUqUssM1Y8AyTMo6Xfg6aoDR4GI70zK3npLIC6LOWO9isTgJb79pLVvy8AhJCPj
         9RQCFWR7ACPWJaUtiRBwfMVN7heuyChKy39/jOUFalj3kseC+RK1DsbGagUgWNEVL4Ju
         FWOkEiIpeYBi2wdhtCph/3l4qgPSyQV5ImUxsPQbW6PBsvS3MgTUCz0YGfzj2tkY9juU
         9mT2PvL/HnZc5acR5WQ9AAZxCnrpxL1hPAxqzaDO05oOhjfv6j1OTt8a+fvhZn0pd5ww
         JD7jS4lPdGO8vypK52xdWLGyXAB7GW7sCGlEQnAAdC1koqLAaOp4Lg+OSt1+/gQgHJfp
         MN9Q==
X-Gm-Message-State: AOAM533AoROgvLu+tOMB4ulfHB1f4sGU+iyBIgjEbLL7GYI43rTRi806
        UHpS45TfcHkIpfLgwDrFQXfM4GRl3R6gH8og
X-Google-Smtp-Source: ABdhPJwfN4/2j2vJ1VUp2w3fglyFviHU7uae3nPiYYsIrciWPTvrvdvQ5b6+uRop+gfNJipTyDydGA==
X-Received: by 2002:a17:902:d505:b0:141:f5f7:848e with SMTP id b5-20020a170902d50500b00141f5f7848emr78107323plg.72.1639164246762;
        Fri, 10 Dec 2021 11:24:06 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id lx15sm3952240pjb.44.2021.12.10.11.24.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 11:24:06 -0800 (PST)
Message-ID: <61b3a956.1c69fb81.7f2e3.b217@mx.google.com>
Date:   Fri, 10 Dec 2021 11:24:06 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.294-8-g82596861969b
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.4 baseline: 104 runs,
 2 regressions (v4.4.294-8-g82596861969b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 104 runs, 2 regressions (v4.4.294-8-g82596861=
969b)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig          | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.294-8-g82596861969b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.294-8-g82596861969b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      82596861969be9429b2b3e63c47cc97a41d53885 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61b36ec4184895a27c397132

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.294-8=
-g82596861969b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/=
baseline-minnowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.294-8=
-g82596861969b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/=
baseline-minnowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b36ec4184895a27c397=
133
        new failure (last pass: v4.4.293-60-g41e24375b1d1) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/61b372a5b1c82eb097397120

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.294-8=
-g82596861969b/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.294-8=
-g82596861969b/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61b372a5b1c82eb=
097397123
        failing since 3 days (last pass: v4.4.293-52-g4bb83d906425, first f=
ail: v4.4.293-52-g43d995ef586d)
        2 lines

    2021-12-10T15:30:34.112323  [   19.169311] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-10T15:30:34.162529  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/122
    2021-12-10T15:30:34.171867  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-12-10T15:30:34.191962  [   19.250732] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
