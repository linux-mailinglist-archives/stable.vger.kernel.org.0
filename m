Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6541D48CA69
	for <lists+stable@lfdr.de>; Wed, 12 Jan 2022 18:53:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344021AbiALRxN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jan 2022 12:53:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344090AbiALRxM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Jan 2022 12:53:12 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C3CDC06173F
        for <stable@vger.kernel.org>; Wed, 12 Jan 2022 09:53:12 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id y16-20020a17090a6c9000b001b13ffaa625so13659573pjj.2
        for <stable@vger.kernel.org>; Wed, 12 Jan 2022 09:53:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Zov2gt7L/leOgWk8W+XhTGPhVZYtOo9cDQn/0bmGPLQ=;
        b=nQ5ScZOr/4KFzWGWKNG2o4afyVTxS9wGGniML8RoZ+tOkGh9i/2O6fjaIc/uNcGdlh
         moAOKSleg0uDBw89qpDz3AqPqtg9P4gsXxROS8oKF8y8y3RGWannhFYQC++4mdRcF0RP
         ZhL3DIIED1D0RJ5l7YLhbrpHzDV3hNS9K7Ap5+PG3LrWNOAiTJ5W4ZYhFIt4Cy3W2BAW
         hWm965Ej44JnNChq+mCXFEwqf1+bKeoTp8EcB5IvW1qU+0BQcd+yX/i/PEMNgJ3lhfmQ
         Nq4rS8P77xhsIFHGHTlvpSDLrm++i/1i7lAshYJBhPttoDkNbkCiy3I1RXsmuNA7a2Ix
         Nifg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Zov2gt7L/leOgWk8W+XhTGPhVZYtOo9cDQn/0bmGPLQ=;
        b=Oq7u9BOPsywWlxNY2jY8vVRcSP+1WiRJuHT7lS43Nfrhva8Mje6NA8cuCH92u2LeJN
         uyv5wcAavlSXah1rURM+7PyYaPws7bDDkYA6IBWKyDM0Om9kzJTgzo7Smt+D9iYsU5NE
         XxkYRQFiW3LdiEBj01a1MMBotWCXaTBAnWGwYAUQoyz97lZu2aqeSQNALMPStBMs2erC
         XOtxVw8TNVOVsCkH861GBTQtirPsnEpmLBFvPmreN0X0Kk7xVMi6jwy5PPaOxgUvP9CW
         FbZxWGD8EJPVF02G0Ynjy7BoscrL+hj7PHVIs7tCF/QwDnJwVQo6zA1Hw/D/TOEFzLKd
         C4Pg==
X-Gm-Message-State: AOAM531FIdpiQJByex/eklxQSc9qwLiMG+t5MTyyix3UYKkqxDvPXC+V
        W8VFoSW43nSbE2gfXGTnxrOH87qwKwlzFOjw/30=
X-Google-Smtp-Source: ABdhPJxLPzfK0PyWwB5iIVKAKUCuqNLgzOuVnHOqRcgAUbx9S4bHtjfo91M5WgwM4KDl26AZWCW/wA==
X-Received: by 2002:a17:90b:3802:: with SMTP id mq2mr745860pjb.63.1642009991781;
        Wed, 12 Jan 2022 09:53:11 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s8sm230389pfu.190.2022.01.12.09.53.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jan 2022 09:53:11 -0800 (PST)
Message-ID: <61df1587.1c69fb81.5b622.0c41@mx.google.com>
Date:   Wed, 12 Jan 2022 09:53:11 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.225
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 171 runs, 1 regressions (v4.19.225)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 171 runs, 1 regressions (v4.19.225)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.225/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.225
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5e0cdb245b7c83cfa2939071bf0cb7a2ecd31abe =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61dedf2acd4df3bcbfef6785

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.225=
/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.225=
/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61dedf2acd4df3b=
cbfef6788
        new failure (last pass: v4.19.224-21-gaa8492ba4fad)
        2 lines

    2022-01-12T14:01:02.454278  <8>[   21.436035] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-12T14:01:02.498883  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/104
    2022-01-12T14:01:02.508326  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
