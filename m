Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14E2D4A325C
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 23:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353378AbiA2Waj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 17:30:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353350AbiA2Wae (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 17:30:34 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71FF4C06173B
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 14:30:34 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id b1-20020a17090a990100b001b14bd47532so9948603pjp.0
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 14:30:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/FE7PHpPjUd1T3ZN5zPIhLlWAEKsXdhRnakSYpYzyYc=;
        b=P8QTzoC6Iyf7onjLrdP2Azm0s5J5ab3yWO1Zq1YNTrpjEPHHnXqhdx4H/hvNn3F8eA
         XNmp7jTXZTCFU4qrXlqsKCkNAgNWQAYReviIFj9wOvkq3v7EsbXUlfLC3MMieUtaNXOj
         08e44iw+zcCQ1RTWVBN1durtENhOgMl7uVN36LjNfloyTP6bo24RH+Id32qsNvYayWnA
         w6+2qFwqxmAtob+VYj8U8qz5fTW6P92BEnNauLRH2+SPVrp5qkmkuc5d5F78O9pSu3k/
         Y+RgRlwDabiDHuowf1y8eyB3JuDGe6hYGeM6UdKLwr0+w4nKndPYxy86//tweHdhhgYi
         +u1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/FE7PHpPjUd1T3ZN5zPIhLlWAEKsXdhRnakSYpYzyYc=;
        b=1pgHRQmnj0LRiMxRFkuhojcz/QUSNQcRZYOzXtOnUyWmkA2Ct5qV22LEGS1alCLXq/
         ggUKv3WUg6eDu5PIwUiHkH6zHp0rVGFUSCB4seVhIg66IcSd5WZtEFxYc58quILzH23g
         V6IFdmifTUQR8KAAiGXIBcyDObhXUBjZsZHMmRdJwiU4fTWsgV4XOOmgS72I82Syv/Qo
         m4P1GAzBUrzLEuTZjoqXtz3xCpGsoGPdAOnWub3aYjEb1aMwpfJhMKKxQTQjVgTbrYkL
         dHbfzaINr1BJrebGASGuGNnE4/4dw0wt4kUZmofxozK/GBddspM8UMxfX9pJscnFTyqx
         X8CA==
X-Gm-Message-State: AOAM530i0/vWkxA01vqp6m6cMRu2VY39yHanvpLyXcb1CT8aNbMwBpbw
        dL+aK4BADVDa6tFzhywwa8SB3Ln4sp94x1hd
X-Google-Smtp-Source: ABdhPJxw+Ta38+lsSXrJjtdXcA265F/zSRol/M2qu5uRlu0YOmmGVQqOUFHPCIAPeTEa0qxjP+2kxw==
X-Received: by 2002:a17:902:ab43:: with SMTP id ij3mr14810527plb.25.1643495433442;
        Sat, 29 Jan 2022 14:30:33 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o4sm23133991pgs.3.2022.01.29.14.30.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Jan 2022 14:30:33 -0800 (PST)
Message-ID: <61f5c009.1c69fb81.fa865.fc6f@mx.google.com>
Date:   Sat, 29 Jan 2022 14:30:33 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.264-16-gf2d433d52c2f
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 84 runs,
 1 regressions (v4.14.264-16-gf2d433d52c2f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 84 runs, 1 regressions (v4.14.264-16-gf2d433=
d52c2f)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.264-16-gf2d433d52c2f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.264-16-gf2d433d52c2f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f2d433d52c2f34220950e0ed142ae962ed8aa354 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61f585f9f9a6778cfcabbd25

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.264=
-16-gf2d433d52c2f/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.264=
-16-gf2d433d52c2f/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61f585f9f9a6778=
cfcabbd2b
        failing since 1 day (last pass: v4.14.262-183-ge251e7983f4f, first =
fail: v4.14.263-3-ga2d9e2bae197e)
        2 lines

    2022-01-29T18:22:30.257135  [   19.964752] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-29T18:22:30.300985  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, mmcqd/0/60
    2022-01-29T18:22:30.310514  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
