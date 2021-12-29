Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FDBD48175C
	for <lists+stable@lfdr.de>; Wed, 29 Dec 2021 23:50:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232296AbhL2Wud (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Dec 2021 17:50:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230243AbhL2Wuc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Dec 2021 17:50:32 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77D47C061574
        for <stable@vger.kernel.org>; Wed, 29 Dec 2021 14:50:32 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id y16-20020a17090a6c9000b001b13ffaa625so25940844pjj.2
        for <stable@vger.kernel.org>; Wed, 29 Dec 2021 14:50:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JcNlDaVssxlbxkAazym4rzde3CGqiC+qaCZp5PkK4dk=;
        b=vmWO7O3s8ixam7cvG2cVkNNhG81hsKTQHpQaSmq59LFgdGVnn8WDgZLin2kAhCUjNV
         RDTJYdNi1HTe/bU5gEjOIOvKsjFG782IP2F6uDiMbA94syj8/GjA1Gev/vZUmMH0PK/D
         07SrPHAY8fLsdPxAQgblqNzwTW9AYczd40afiX98CjnsTXn2FJKL8eT8bKSS8X9X6l28
         eM+aUrKFEv/yhuX1F7HqCU/pw5pb8U62EHar5czrRkiw28Bp3aI8G/OeD9+j6acuJv4P
         IlVJpWNz11C5TaFZqqxcy7KZLHqiV2zfQH3GryAYZwkxM+IXEnW3fspvtirtpKgLY01l
         md0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JcNlDaVssxlbxkAazym4rzde3CGqiC+qaCZp5PkK4dk=;
        b=RfOOYTM78VevPaER2vfHHJzK3eL4tUEm/38mX84zjcYbrVroRTxc51pFeaAryrPwxi
         aKknkfvgCai87ig4nVendwZEq6hALk2AJAUp9aXE0Y5wuv/Jp8Znu/4HrTQukXuh5iA2
         RXUg0TfvvmUqtjFCz5T7hvmG8mHBPXJrLcIrrWeVCRZCp+SBFwuPMH2jw2BEuEJktw3P
         Mj1hWX8QteMX823q1Tq31281WSZicKZB7xQpZGADcWoFsMMyyhmVDPW9Wi0pPKqQhX32
         /+HBM9U/tCfVJW4/loDfaKBky4t/5kc+xu+ZbBvYH1jtFUULw/76JyYdvK+TzCbtmw81
         s6GA==
X-Gm-Message-State: AOAM531W/QkZMjuxNPlyJyAHEi5DKkcUyBSB4kSJG+JP2CkHVrwIGz4I
        jbuxYeMiblW0HAeq7T3DFM3fbQ9MqXAD2bji
X-Google-Smtp-Source: ABdhPJxLfGWnZL3l846cYLTOil68YPS7D+17dv/qPcqIrcqpXI9OX8Odx9WfU2HgvbK5pgyoWyt2Xw==
X-Received: by 2002:a17:903:234a:b0:148:a94a:7e3c with SMTP id c10-20020a170903234a00b00148a94a7e3cmr28976826plh.121.1640818231735;
        Wed, 29 Dec 2021 14:50:31 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x22sm18402742pjn.16.2021.12.29.14.50.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Dec 2021 14:50:31 -0800 (PST)
Message-ID: <61cce637.1c69fb81.1f756.3db1@mx.google.com>
Date:   Wed, 29 Dec 2021 14:50:31 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.222-40-g0c97a90a36d0
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 132 runs,
 1 regressions (v4.19.222-40-g0c97a90a36d0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 132 runs, 1 regressions (v4.19.222-40-g0c97a=
90a36d0)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.222-40-g0c97a90a36d0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.222-40-g0c97a90a36d0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0c97a90a36d0b44f3c8486080afd75a2b808139c =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61ccadbf238ee970b7ef6744

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.222=
-40-g0c97a90a36d0/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.222=
-40-g0c97a90a36d0/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61ccadbf238ee97=
0b7ef6747
        failing since 12 days (last pass: v4.19.221-9-ge98226372348, first =
fail: v4.19.221-9-gf48d5f004d75)
        2 lines

    2021-12-29T18:49:18.757336  <8>[   21.686737] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-29T18:49:18.801579  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/100
    2021-12-29T18:49:18.811266  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
