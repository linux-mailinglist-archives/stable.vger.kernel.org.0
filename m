Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4BA14659F7
	for <lists+stable@lfdr.de>; Thu,  2 Dec 2021 00:48:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343941AbhLAXvu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Dec 2021 18:51:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353823AbhLAXvu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Dec 2021 18:51:50 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B68E9C061574
        for <stable@vger.kernel.org>; Wed,  1 Dec 2021 15:48:28 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id p18-20020a17090ad31200b001a78bb52876so1000351pju.3
        for <stable@vger.kernel.org>; Wed, 01 Dec 2021 15:48:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jiaPGOpmYUW4OUtpuFq3aRJDCn1y6ejE/6QtLzwnJ+Q=;
        b=FQnBqpRhqLSRxMmo1P4F0lp3CzCgeYTnwU3jTxqK5vc2s/nAYMZ12vrcXZjdQaKHQr
         ln6bp7zeKXGn02DpGbHafa8BDRMag+jM/2ae04w+XMoFMnYtzXvDkWW8EWUoYOYvpuIB
         FgI9FzFd3mAk/zGm6E3ho93C6RkhqgZj4WTrfk25a16VxeoRjbpQCmc79SccmiSq/37n
         JAjnfV7RUb/hj22Qrt7GO/7h9xoQ6xCEuxk3GL+9WakLk3VAfNfGQ23NVknZ+yp0WE6D
         +VvmgJu4zuUNlWxLv+sZaZN4B71oqsuBDXCHPjdxQVrxu8vBRXPbk5fTbLFYnzDLF6NA
         e6hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jiaPGOpmYUW4OUtpuFq3aRJDCn1y6ejE/6QtLzwnJ+Q=;
        b=CHBroRfJLr3WbU9jwmSaH5gca4BeQP61YItT3rC57GT5tYFTuQUeESueoP0FGkzZ6a
         SovTflvdQkTZIqanBy8GE/P3xO7iKr0DpxdYP6ubhRABOVQ0BpLGJ/DOMjMF5gjccwMW
         qn+BxeLVnPJ28kySgssTnuYuVtdJElHPk3HHOu3y+njA3FhfY5/7RCR28Oz9DmZOBiJa
         bfNWCunMv4VJ/K6BMe2fhBj8N7e11nPCeeKNPwtLh8fkHVLELCBvafx5oLWxxjCY4Kjl
         A3KjABYChPmolyB7Te4+y6UXsS9CLyQK5IiQ/EDj/zqJCEYO9mJkzQ2TNejm48yT5LGZ
         KUEQ==
X-Gm-Message-State: AOAM530vL3JOADcpexBd4bhAjo//73rKyaewHJr8rPFoPRdsJPI79FQR
        ltMHCzhnPHpkDRjFoYm4buAJeIxB1KVeTSWP
X-Google-Smtp-Source: ABdhPJz7Fd9VrZ58b+Ao9JzhBVJT3R7Q5zFMCqQzrunDU/lJYOIyMShuNZGavsy9V1CrN2Qu8ILnzg==
X-Received: by 2002:a17:902:d4c2:b0:142:76f:3200 with SMTP id o2-20020a170902d4c200b00142076f3200mr11039471plg.53.1638402508128;
        Wed, 01 Dec 2021 15:48:28 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 11sm910777pfl.41.2021.12.01.15.48.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 15:48:27 -0800 (PST)
Message-ID: <61a809cb.1c69fb81.865ac.4390@mx.google.com>
Date:   Wed, 01 Dec 2021 15:48:27 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.219
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y baseline: 81 runs, 1 regressions (v4.19.219)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 81 runs, 1 regressions (v4.19.219)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.219/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.219
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      24e6b4723c20c874840781dcd31e681502b8adca =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61a7d2177c25022bc01a9489

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
19/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
19/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61a7d2177c25022=
bc01a948c
        failing since 5 days (last pass: v4.19.217-321-g616d1abb62383, firs=
t fail: v4.19.218)
        2 lines

    2021-12-01T19:50:34.480126  <8>[   21.539733] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-01T19:50:34.528836  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/102
    2021-12-01T19:50:34.538261  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
