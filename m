Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22F5E462B03
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 04:23:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237827AbhK3D0V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 22:26:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232594AbhK3D0U (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 22:26:20 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D11AC061574
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 19:23:02 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id y14-20020a17090a2b4e00b001a5824f4918so17163098pjc.4
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 19:23:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/nCFTRC7PiV+6B/Dv7oxO89AtchGN51r+BV6ZhmmsDQ=;
        b=t2aQDQZWPz4/d7cQ3JzTjNRNP1lN56hawEaBwda5J+NOJu2NE0E2hKg6Si0imTS8si
         wdQbgWHqFns/BOnTn6iFSEfs7hFjGE75FmUN/bQgKE8nZVyGrR6MYv+IQphqW05i5F1H
         XCSamPG/CAxgSOGMexy+2Ux9kvP/M7u7ymYLadTIbbCQdcfB+bsIbChPbDUfe7fxbGkC
         W3UbrDEM//opXEb+s4oFDUqTtC4ETSolUJYkt0d31S1ggfZu/6uIZ0l0Lh4IwpUGaZ7P
         Fi1vZMSCGRQU8ZHJvt401bgBlvMOGRrVGUDPmtUbVMqJp1h61X4+x8muoXSEhvfZirEd
         NlSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/nCFTRC7PiV+6B/Dv7oxO89AtchGN51r+BV6ZhmmsDQ=;
        b=fZoU5eOnTGjhoC/1SnheHr7aTkBQ7Q1rvWwaaI0mVmTL3Ee9R4OsgIiS6pZCca+fgP
         SCtUS4XPdLyTmHHU1tFWB3ezE8cLbtP37oeTOpk9SmUtBhZ0QhRMMsmYBupYdGUWbSHU
         VQqfkl1BoyL52TPqknMLp/f1ky34+KgR6g06Z7cPKGYQrpW5/862V4upD+2FDlr8fSaQ
         ysINA6O0JHGH/QHGmey4LRSpMoXZ4oV1F3FdM6ZMw/p3PqEttIbfmdm3WZHV9Nwhqm/i
         6rYkfFn3V8tzOBM5X5JOqPuBvhw8XhyftFhpzFqVrEPDB2erJQMhaKKDiUOj2XvEFsCg
         GliQ==
X-Gm-Message-State: AOAM533GKLLN3dwlmT5vq4MOy6c+plbbswi2OjiJsx6o/9p1AGGLaaWE
        5xYqxzHjyPkZpF93PSpCsfntb0fX7SwTXMFx
X-Google-Smtp-Source: ABdhPJxYcGFZHXvnQQcR7mMi5p45oSpXhxmuB3VaBqqFcXmxFdU0dZ0iJaU6r44cYVcVOBh5/R+KTQ==
X-Received: by 2002:a17:90b:1d0f:: with SMTP id on15mr2762688pjb.144.1638242581988;
        Mon, 29 Nov 2021 19:23:01 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id nl16sm696779pjb.13.2021.11.29.19.23.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 19:23:01 -0800 (PST)
Message-ID: <61a59915.1c69fb81.a92b6.30be@mx.google.com>
Date:   Mon, 29 Nov 2021 19:23:01 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.256-69-g5ac6c9b22d133
Subject: stable-rc/linux-4.14.y baseline: 94 runs,
 2 regressions (v4.14.256-69-g5ac6c9b22d133)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 94 runs, 2 regressions (v4.14.256-69-g5ac6=
c9b22d133)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig    | 1          =

panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.256-69-g5ac6c9b22d133/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.256-69-g5ac6c9b22d133
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5ac6c9b22d13374b471b6c01f8af76540fa84b3b =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig    | 1          =


  Details:     https://kernelci.org/test/plan/id/61a568472fa49a742a18f6c7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
56-69-g5ac6c9b22d133/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-=
minnowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
56-69-g5ac6c9b22d133/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-=
minnowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61a568472fa49a742a18f=
6c8
        new failure (last pass: v4.14.256-14-g15bd9ff94e6de) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61a565b408408a5e2018f6da

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
56-69-g5ac6c9b22d133/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-=
panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
56-69-g5ac6c9b22d133/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-=
panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61a565b408408a5=
e2018f6e0
        failing since 4 days (last pass: v4.14.255-251-gf86517f95e30b, firs=
t fail: v4.14.255-249-g84f842ef3cc1)
        2 lines

    2021-11-29T23:43:27.695098  [   20.198669] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-29T23:43:27.735929  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/105
    2021-11-29T23:43:27.744753  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
