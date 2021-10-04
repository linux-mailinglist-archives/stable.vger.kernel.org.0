Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3565420491
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 03:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbhJDBCe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Oct 2021 21:02:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230508AbhJDBCd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 Oct 2021 21:02:33 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FC35C0613EC
        for <stable@vger.kernel.org>; Sun,  3 Oct 2021 18:00:45 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id a73so12034654pge.0
        for <stable@vger.kernel.org>; Sun, 03 Oct 2021 18:00:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+aWkKdj9//NfiY/wnbaGVZH+D0PxXDe9cwecCj51oPI=;
        b=fjAPM18yYVHg/Wa8cjfOMMpMXsagu0VbndOfahts0Om+IBUg61ePjuAcYjGCCtGecy
         ZIgDm1Y2yXEC5uQGMWG/438Ii+sWT2wcrHJaQzwejDfZjXb2iN60OlaC3oOcCV/XOuAM
         aNraRGmFRO9FYDwpWAO9khJYC97Za86xGlgRkbonGuyRbsP1fjbjrRdSFnnYMWDNM7/l
         PAJNdaVGS+e+1JeWTbL62dqtt/naHcdNyVdoW5fqQ2guXphsmM6eQFjU5Ztt4pvQKaDy
         gF8OkwSvkGAZw1fA+LiyNeT7gYYgQFr0kh9IqARCMRa3lM6zDkXmSZIMg6kZPAnCRUa0
         5UXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+aWkKdj9//NfiY/wnbaGVZH+D0PxXDe9cwecCj51oPI=;
        b=zLsX0Ggjr0QlvJpIn2wK7MP6oJYBzQlcF1A40e8Kasct32Pr5AREOgCwqA+nVA6A8p
         INogGuKoFrfTxppQ5S0hN6gFmx7Xn4gcq2RdnyLfzyXzTfUtWSsNmDbqnhrMsIOA7LDj
         GGmjuw+uGN0g/e51cY5mrJ3J6b1Y2WO94HZ5Izhh1Dd+NQlxFiSw7yiC+Zw72SaMGHo9
         Ilrcyj32paCN/U7scFyE8QWnT7sKY0XY+66i8ByBfvnXdu1dkO3JfF9E4473dKEP+x3f
         S2ejagEPJFf2A8OeakSSV9M1MgQqIMA2ICTLgOkXoiXxVHyh85blOgD3xoKNd3/5daCD
         jSVw==
X-Gm-Message-State: AOAM5303w81ot66Kh1ilUJezK8EZgLbKmpZouOqENHHvFdECe8R7MCtK
        POlytR4e5g0qQzEs56zgf+Re0cpIdAMi22m0
X-Google-Smtp-Source: ABdhPJwSrwfCdmOIS8vFeg7zlXSXocCXnnkQqQ6Fa23e/s/S5ykxXkHqRRt+cfrUs0G99ux+mkGPEA==
X-Received: by 2002:a63:4f57:: with SMTP id p23mr4577168pgl.376.1633309244524;
        Sun, 03 Oct 2021 18:00:44 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v11sm10826355pjs.40.2021.10.03.18.00.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Oct 2021 18:00:43 -0700 (PDT)
Message-ID: <615a523b.1c69fb81.d6052.0b9c@mx.google.com>
Date:   Sun, 03 Oct 2021 18:00:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.285-26-g619fe28a2992
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 50 runs,
 1 regressions (v4.4.285-26-g619fe28a2992)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 50 runs, 1 regressions (v4.4.285-26-g619fe28a=
2992)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.285-26-g619fe28a2992/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.285-26-g619fe28a2992
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      619fe28a29926c18095ccad109244cfa58c9261b =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/615a1b415d5d6f6cee99a2e6

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.285-2=
6-g619fe28a2992/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.285-2=
6-g619fe28a2992/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/615a1b415d5d6f6=
cee99a2ec
        failing since 3 days (last pass: v4.4.285-24-gad37b725027a, first f=
ail: v4.4.285-24-gf1d8da39d755)
        2 lines

    2021-10-03T21:05:49.204348  [   19.152160] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-10-03T21:05:49.256223  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, klogd/99
    2021-10-03T21:05:49.265263  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
26c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
