Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D0F944758E
	for <lists+stable@lfdr.de>; Sun,  7 Nov 2021 21:10:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbhKGUNd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Nov 2021 15:13:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbhKGUNd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Nov 2021 15:13:33 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D653C061570
        for <stable@vger.kernel.org>; Sun,  7 Nov 2021 12:10:50 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id gn3so6627598pjb.0
        for <stable@vger.kernel.org>; Sun, 07 Nov 2021 12:10:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Fa0CLiG57i1cY5PKbDPpAsYEvr0gWIwgp1291pGP1yA=;
        b=rrM2nzmHAIjKf7Ih+wyC2GDjlja9He7S/J7ZtnBfHkZVmXSmagcIDZDxyZ+9qN53sV
         19DtO3jN/7Y8tfVFDLjRzsXqpdY2d4pYN2ipcy8LXT0IEJDup5BeliYIedjZo54nKPpw
         41ZPzaKRmokyqAlBs7wc7+xC7SSR0m3NeUTmn8f3rCS4yhmgsGcxuCKFbbQaVeY7bALz
         vhCgTlUCK1e3+dKxGSvR5dsNoEuxmvp2oxCnJNHgeJRIUiDWnCC85hwrnBiLZf1YWWF9
         ItgvpdU83rxQEZEO9DJv3ax3wUMK3Hy9Qqx8zCyDjpV/dEXzgPXEoIENejC3honcRqgH
         mMDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Fa0CLiG57i1cY5PKbDPpAsYEvr0gWIwgp1291pGP1yA=;
        b=JGg9qNWKCxyomotY0F6nuBw3f7Q2s4LuM/rRJ9/uG3fmmKrKPbejqpceETd1+L3sc2
         wZz0+UQ5ZFVhdNepkdGJ3ry+xbf/iXZq1t29oFw/XviCksGA2BAdreA8g1bD+6odyAZU
         sRaLKyL0yTp+tthyhFk9ScIbDndMY9azryoIACwcZcIhfDatIsbDStoHjVLJlnMH2pbQ
         3dYnXmmzEzM1i2M7vLgUG+w2h2PS3GyFWbhdw0PpDUDARkcMI7UkPfet12M5Q1hHwgWq
         xxmmrd/u4quHZ893O7rYt+gQEIjvopHW+ZQH5Rfm5nFXHOpZxu8Vn2SHoh9kRRsVTazz
         N2BQ==
X-Gm-Message-State: AOAM532lwCCV8vcCZzJoG6V9g9bg2pUjlgh8NQ6ms01I8ufxPUq05sux
        UVetD5MVBEWPeI9C/EfKP2aqqa6uu5d4VEpM
X-Google-Smtp-Source: ABdhPJyyhtU+ou5pWBaBaeTIY1D7LCHioc2wWWY3cObwhZOISeW6dcJ7EgpTq2cVJ+DDImeYCAZslQ==
X-Received: by 2002:a17:902:7c88:b0:142:5f2f:182a with SMTP id y8-20020a1709027c8800b001425f2f182amr11843179pll.72.1636315849502;
        Sun, 07 Nov 2021 12:10:49 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n20sm10427394pgc.10.2021.11.07.12.10.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Nov 2021 12:10:49 -0800 (PST)
Message-ID: <618832c9.1c69fb81.8a00.09f7@mx.google.com>
Date:   Sun, 07 Nov 2021 12:10:49 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.291-3-g649c83e80d3e
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.4 baseline: 109 runs,
 2 regressions (v4.4.291-3-g649c83e80d3e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 109 runs, 2 regressions (v4.4.291-3-g649c83e8=
0d3e)

Regressions Summary
-------------------

platform    | arch | lab           | compiler | defconfig           | regre=
ssions
------------+------+---------------+----------+---------------------+------=
------
i945gsex-qs | i386 | lab-clabbe    | gcc-10   | i386_defconfig      | 1    =
      =

panda       | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.291-3-g649c83e80d3e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.291-3-g649c83e80d3e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      649c83e80d3e46c816e88e0598eafbe4472ac7bc =



Test Regressions
---------------- =



platform    | arch | lab           | compiler | defconfig           | regre=
ssions
------------+------+---------------+----------+---------------------+------=
------
i945gsex-qs | i386 | lab-clabbe    | gcc-10   | i386_defconfig      | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/6187f8f01e518d31b43358e2

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.291-3=
-g649c83e80d3e/i386/i386_defconfig/gcc-10/lab-clabbe/baseline-i945gsex-qs.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.291-3=
-g649c83e80d3e/i386/i386_defconfig/gcc-10/lab-clabbe/baseline-i945gsex-qs.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6187f8f01e518d3=
1b43358e7
        new failure (last pass: v4.4.291-3-g4b7696b55f5d)
        1 lines

    2021-11-07T16:03:38.489437  kern  :emerg : do_IRQ: 0.236 No irq handler=
 for vector
    2021-11-07T16:03:38.498469  [   11.861297] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>   =

 =



platform    | arch | lab           | compiler | defconfig           | regre=
ssions
------------+------+---------------+----------+---------------------+------=
------
panda       | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/6187f7dc5f74c271cd3358f7

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.291-3=
-g649c83e80d3e/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.291-3=
-g649c83e80d3e/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6187f7dc5f74c27=
1cd3358fa
        failing since 1 day (last pass: v4.4.291-3-ge1223ca4fb61, first fai=
l: v4.4.291-3-g4b7696b55f5d)
        2 lines

    2021-11-07T15:59:04.495910  [   19.408996] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-07T15:59:04.546856  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/117
    2021-11-07T15:59:04.556270  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
