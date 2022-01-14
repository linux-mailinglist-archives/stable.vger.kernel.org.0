Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DEEA48EE24
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 17:32:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbiANQcG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 11:32:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbiANQcG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 11:32:06 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0F2DC061574
        for <stable@vger.kernel.org>; Fri, 14 Jan 2022 08:32:05 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id a1-20020a17090a688100b001b3fd52338eso13480296pjd.1
        for <stable@vger.kernel.org>; Fri, 14 Jan 2022 08:32:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZnUHjGPl1/Q4mAmAPBABb5RzQ+QmRIBTvMI78EHhl7Q=;
        b=YTcXVzCPdypSXJn2DImb7YdKzi2uB9cbs9GVHxAiH2vDgFuaL5homji5LwLX6vWH3m
         rm9UPOVlIV9Y3YGD14piCea3JuMwyaszIGKk825j1uzjSATOqrsJM3mCJIPnGBWJG2s8
         c5H1RyonV0EEbFZIdCKGcvirJUlsghjUePz3zplWoE98dHBjr07qiov+SUJkcsWil/JS
         +QBebx8bV/95wuVtmmk4zQ5DOATLwcLHvUM4M0KazMya8e7sKL6fB0WQYYt90oEurf6f
         CGjnFzsP0GX91rivmsP2mXERpBbZwMyqVfLY8VqNbX4hqfSVj7W3j0B155j4tnJtqbkw
         zITQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZnUHjGPl1/Q4mAmAPBABb5RzQ+QmRIBTvMI78EHhl7Q=;
        b=W/WVaq3BHdUCQwWt7IKizqx1P95W0d6BeM3CS+YUf2J6difsSsR4DYRtWAnap4ALDH
         g7dmzAt6hjr8voIMyqWjZ1fb0QXWmk2sX4fQPv7K/iiWcF8nrKr5xoFc/JuNHCHHPEuT
         CiwnQO6ajLndsV+LLUAI9QCBRKO08Rm6M704pMo+cGdpKMuw/dbAEk80X0V2dOfvlCgR
         GpGKxt7ufjPqCP+zkc3Te6+Vqqo/JblzkXNx1L6nc0ZIqOwxQXcegnF9BYwqnU3b+PsL
         fh6x7yGRH5wk/xoAwSH9wDUnwMYHLkUp+uvh/880qOoa5zaEm0pTFitjXQUKaJg0kXdA
         sitw==
X-Gm-Message-State: AOAM530aYP4GoC3EhszrxAyWotpHic4AWoD2PFfcDCKbI9iyaS7Qt7R2
        qj10NjO7LeqlQhJQeqYn3f2sgWhUH4RGLtIb
X-Google-Smtp-Source: ABdhPJwCDJyltk1/uWuMkvpbQN311EE/HKn/yruWY5Gl5raklp4hWufajEoVDRJM9l7zEXwBvtIoPQ==
X-Received: by 2002:a17:902:7c0b:b0:149:711b:2588 with SMTP id x11-20020a1709027c0b00b00149711b2588mr10109620pll.65.1642177925385;
        Fri, 14 Jan 2022 08:32:05 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t6sm5118323pgk.31.2022.01.14.08.32.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 08:32:05 -0800 (PST)
Message-ID: <61e1a585.1c69fb81.d37c3.e42d@mx.google.com>
Date:   Fri, 14 Jan 2022 08:32:05 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.297-10-g025a0022d327
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 109 runs,
 1 regressions (v4.9.297-10-g025a0022d327)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 109 runs, 1 regressions (v4.9.297-10-g025a002=
2d327)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.297-10-g025a0022d327/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.297-10-g025a0022d327
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      025a0022d32719a1cf030232d3f29b57b6a2a65a =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61e1718043d5fe2854ef675f

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.297-1=
0-g025a0022d327/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.297-1=
0-g025a0022d327/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61e1718043d5fe2=
854ef6762
        failing since 2 days (last pass: v4.9.296-21-ga5ed12cbefc0, first f=
ail: v4.9.296-21-gd19aa36b7387)
        2 lines

    2022-01-14T12:49:47.475542  [   20.119903] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-14T12:49:47.526540  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, mmcqd/0/83
    2022-01-14T12:49:47.535521  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
