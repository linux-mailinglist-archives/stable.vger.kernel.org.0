Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F351644AF50
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 15:18:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231250AbhKIOVC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 09:21:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbhKIOVC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Nov 2021 09:21:02 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5592AC061764
        for <stable@vger.kernel.org>; Tue,  9 Nov 2021 06:18:16 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id p18so21094428plf.13
        for <stable@vger.kernel.org>; Tue, 09 Nov 2021 06:18:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Hp1KQJ+b3W4t698jmyku/FCNKE8HuXGhwNa7rKGpxUA=;
        b=DqlvnNn54o62zM4O9Y+5SBE54slP618QmLd/DCQ65H+X5JssIYedQnjXSm1fxD6VEf
         rH15XpcMIEQLSsXqOVoj4yKGZkUFFvZQScnUNrDV1jj1Izodpl+T5gBPWpC0yhJ+aCL0
         3f+yhbR9aERlvg37G0CE5emCJELoreSa7Nct+clEP5GRU81cWFRYfklLV88kteqlmgvI
         LKGloKHAJ95yX4HlgzOvze5J6BXzF1WfsYJm+UKAjaqCasa2Bw/N60qdH1HkY/n31lej
         WkozGbJVdnu1/c7YdsLMpwNUrpfziIzx7aNbYKgxUKcq62SqLa5q/Gub74ZIOk4rZ3HH
         cwiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Hp1KQJ+b3W4t698jmyku/FCNKE8HuXGhwNa7rKGpxUA=;
        b=Ly3naOAfOyGn/Gh/+gkSLWm9YyL2prqpdybFfCcFdC1yYg0vIHBaS4pAgYaM82kGUY
         VgLlcpyAt/eSUYDunKBGqeuTyaXS2sEkkmOWzTHvPU14z9V9omk3Fx7WKnk6NHr0TUsw
         Wz33Bbzy9dHkiFCqdEGNVDASt9fmhN9VDQyqVt0bijG4AG//O0xDmbnvqpHglb+EXsXc
         JEYZe3ByO74wlMwP6iN0N106FHl6ooYrSe8D7VcnsdNlTdVF4AoxMopM2qWioUGteOJH
         1o9IKLKPgeTc+4XammYLdSjP8yp9Q+nNmA5AJ6KNywjs6/Xo7BSv7zMGEs+rfGQf2qEK
         W7Cw==
X-Gm-Message-State: AOAM530uxbzWgDn1rg8jMtr3iScI0irqEncWxhAUUN/q7jxxQeTnZ56Q
        NUClVgW4P+Zx0H8Wx//9fAjAUvxAB3HVgH6y
X-Google-Smtp-Source: ABdhPJw4qexjOgvl9HLLIBqnYaK2wJFqEY1FTY+91dRUjLZucQBA8dS6iM8y0bSknvFEXOquRHfapQ==
X-Received: by 2002:a17:90a:e7c4:: with SMTP id kb4mr7563390pjb.237.1636467495697;
        Tue, 09 Nov 2021 06:18:15 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a8sm4923501pgh.84.2021.11.09.06.18.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Nov 2021 06:18:15 -0800 (PST)
Message-ID: <618a8327.1c69fb81.720af.e028@mx.google.com>
Date:   Tue, 09 Nov 2021 06:18:15 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.291-7-gf3d4ec0d5ea8
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.4 baseline: 123 runs,
 1 regressions (v4.4.291-7-gf3d4ec0d5ea8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 123 runs, 1 regressions (v4.4.291-7-gf3d4ec0d=
5ea8)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.291-7-gf3d4ec0d5ea8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.291-7-gf3d4ec0d5ea8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f3d4ec0d5ea81ecaa48c794dfc7cfaecba2ef784 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/618a4bf087333ca2f13358eb

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.291-7=
-gf3d4ec0d5ea8/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.291-7=
-gf3d4ec0d5ea8/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/618a4bf087333ca=
2f13358ee
        failing since 2 days (last pass: v4.4.291-3-ge1223ca4fb61, first fa=
il: v4.4.291-3-g4b7696b55f5d)
        2 lines

    2021-11-09T10:22:19.741539  [   19.443878] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-09T10:22:19.783753  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/116
    2021-11-09T10:22:19.792795  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
