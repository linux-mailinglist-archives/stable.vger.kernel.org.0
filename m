Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BABD0488C5D
	for <lists+stable@lfdr.de>; Sun,  9 Jan 2022 21:49:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232169AbiAIUtF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jan 2022 15:49:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232045AbiAIUtF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Jan 2022 15:49:05 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 147A6C06173F
        for <stable@vger.kernel.org>; Sun,  9 Jan 2022 12:49:05 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id 78so990088pfu.10
        for <stable@vger.kernel.org>; Sun, 09 Jan 2022 12:49:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ed2hN4UigdzMEwFOHMO1Wo/gWPfFaJ55CQKuXAZm5kc=;
        b=KuC754mi0qSc2PXI55YNeKXvh70KBrxnfOz8McP3vTCMzVDvjy4bqwSPNoiq9fXTVz
         sKH5q/K7yO+LQQdQ28tu+9PajgoJOSOj/giPg+PTj5r3i8bZTZLW5S73X/vw+02Do5wp
         l2y1RIYG7RhGUkJRmQZkW3hrXcqtlNjkVoIkCrG77acaEd80AEFnY4kx0qYK382UTv0e
         kwIntsRUNCMo+1xUwWcqzK0gfXwTmrnaq+ZZFBJOeBAfxKQvsF7q6tJJnDEPGG6R85J7
         INvoBazJYzHMURM0DnN5RXMA0qp72Wqgy10RALHcrPH4Y1uk2WBeTFfuksGFeDY8W+gW
         Kb1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ed2hN4UigdzMEwFOHMO1Wo/gWPfFaJ55CQKuXAZm5kc=;
        b=QFMl+qhuTDhF0DACOH5FE6skhwFvZS17XTb/5e7ZhqRFAwaXAMJl+JvchiS3zDDOp4
         OfBhjqlh4brmK9khrLIQ0wjCkAF6++tMqr2s0DJSQGxWngjLndPZkvUqfLJozT0LVsqm
         UEBsbxUIZ5lG45/PELGS90geHZD6/NJQPZRrESHKXmSoBD1LZkmPnIt+M8rnk7pMEwr6
         LNoejdqdrCxL2pkOh4yOriA85D84U7oC3Q94LfUHx9rLrhan/XialWkMHHDYhmTdKpJJ
         KrXQrhj+oMhQ9fVYkWhNnWa/Wz9RjEhwdxkg5Zgw5esulUf3bfIZL8/hWD1VkbOMOQcM
         mD1A==
X-Gm-Message-State: AOAM533eU8l5RaXEeXQnvjHQmECSdsEeiqdOHx2mCOi8lmwLjDkVSNMM
        wEXSrOETXQM4S6h8hkHYLuS2oYNCigDVGUYD
X-Google-Smtp-Source: ABdhPJwJZhhn0jtUVEPCXM/SqcrpSm8wMEyzqnIXqA60ID0vHU8c5TtEYzmLSq6NnhTV89jARHml0A==
X-Received: by 2002:a63:d312:: with SMTP id b18mr65037618pgg.198.1641761344516;
        Sun, 09 Jan 2022 12:49:04 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l18sm6222668pjy.6.2022.01.09.12.49.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Jan 2022 12:49:04 -0800 (PST)
Message-ID: <61db4a40.1c69fb81.dd5a0.06b9@mx.google.com>
Date:   Sun, 09 Jan 2022 12:49:04 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.224-14-g70dbcce03da4
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 159 runs,
 1 regressions (v4.19.224-14-g70dbcce03da4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 159 runs, 1 regressions (v4.19.224-14-g70dbc=
ce03da4)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.224-14-g70dbcce03da4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.224-14-g70dbcce03da4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      70dbcce03da4a306c0aa83d6d70f79f79f8a24ad =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61db171e0bd32cb9d6ef6775

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.224=
-14-g70dbcce03da4/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.224=
-14-g70dbcce03da4/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61db171e0bd32cb=
9d6ef6778
        failing since 5 days (last pass: v4.19.223-16-ge86e6ad8a5c1, first =
fail: v4.19.223-27-g939eabea13d4)
        2 lines

    2022-01-09T17:10:38.446938  <8>[   21.547882] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-09T17:10:38.495645  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/104
    2022-01-09T17:10:38.504744  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
