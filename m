Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A85F467CDC
	for <lists+stable@lfdr.de>; Fri,  3 Dec 2021 18:51:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380165AbhLCRzB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Dec 2021 12:55:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380318AbhLCRy5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Dec 2021 12:54:57 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 042EBC061751
        for <stable@vger.kernel.org>; Fri,  3 Dec 2021 09:51:33 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id gx15-20020a17090b124f00b001a695f3734aso3164057pjb.0
        for <stable@vger.kernel.org>; Fri, 03 Dec 2021 09:51:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=lW96BAajrXzMCI1bZzfb8vx1ZK1ZjQV1igfxSt7HWIE=;
        b=fJzldZv7rSlCZZN8ae2w9OMch3DWdSsmg+8ivkL/0PbGWDQYBbIEM+4QmKvKSHf/Kh
         kESIUxErnyPYZOSBUoQifSowTkgVmEBVT/fKhXlCjmbvebza4IHgWIjp+ueITzTUhj5T
         zki05Xxo4Ju+tcZGP0A9oXhs51Pw8tuLHZhhWVgFw7yGMfHflpY39XHzPol1AQc+XHK0
         ZgDW+pt5FEL8mtAyTMi3CZUMwHRir3d/QiPDjpxEeXP1/Vd7Gha3bq+NNMXZMD/CIGfW
         ULzAWNd+DnDdUbr3+/xHqf+0n0Oz6Dmxf2Y7TQ9p33VedeWTKLptd/YLVJD2n7MYACBP
         QisQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=lW96BAajrXzMCI1bZzfb8vx1ZK1ZjQV1igfxSt7HWIE=;
        b=1Hq8uwskCINLrmajhkP4qLjM+i+j3EMGL8ZeXTBzwiz0X5OW2Onu15Cuu6jydRIpvn
         ammURn38VCXa53BdNyahQkEpwMFM6dvBaTos4t5iQTFeLpSKKxYaUbk9VXpX3BexraKS
         2NAE0llsJLrBDNqIlVlrlhqemQ92CI35IlaCum6NNYpA9Z/UJjFwXyiskupS5N77D647
         uNPNcG8rnSboe3PNA6HyKy8GiftKlfPzbel4Ng9wGK/oZIa7HhRHBpyslCceGFT7TurI
         tpwqJ7DL5lYBG25CAJxqufTS5QPIbKTcEHuc3m5IWG5xTemRMZmLaRwo7JEQclDv9WRO
         ZQ7g==
X-Gm-Message-State: AOAM5309t8geA7UH8UDgJiQLAK8MAIcFP5LmH8I/xYLdc7QNff2xW15y
        i4wjSaLZxgqk7sew1V8t003T2Hl05TqbVQSU
X-Google-Smtp-Source: ABdhPJzNgFhObLlYmaqVMoCZPMjWxoXazfSoEs0scLKjgi4MyQOm0oAJcQ56gA0XVV3MNTi5P6TwrQ==
X-Received: by 2002:a17:90b:4c8c:: with SMTP id my12mr15552497pjb.157.1638553892390;
        Fri, 03 Dec 2021 09:51:32 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b15sm3972815pfv.48.2021.12.03.09.51.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Dec 2021 09:51:31 -0800 (PST)
Message-ID: <61aa5923.1c69fb81.3ec17.baed@mx.google.com>
Date:   Fri, 03 Dec 2021 09:51:31 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.291-39-g5f41460f8385f
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 111 runs,
 1 regressions (v4.9.291-39-g5f41460f8385f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 111 runs, 1 regressions (v4.9.291-39-g5f41460=
f8385f)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.291-39-g5f41460f8385f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.291-39-g5f41460f8385f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5f41460f8385f27a5692b03f51a943537277b19c =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61aa1fed7ab1ccfb591a94af

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.291-3=
9-g5f41460f8385f/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.291-3=
9-g5f41460f8385f/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61aa1fed7ab1ccf=
b591a94b2
        failing since 0 day (last pass: v4.9.291-38-gec9fdd0edb0ff, first f=
ail: v4.9.291-39-g8da2d5e984a85)
        2 lines

    2021-12-03T13:47:06.027118  [   20.400878] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-03T13:47:06.069932  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/126
    2021-12-03T13:47:06.079698  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
