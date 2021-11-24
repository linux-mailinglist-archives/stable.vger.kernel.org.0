Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 629F645B09F
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 01:16:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbhKXATS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 19:19:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbhKXATS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Nov 2021 19:19:18 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2BBEC061574
        for <stable@vger.kernel.org>; Tue, 23 Nov 2021 16:16:09 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id y8so428729plg.1
        for <stable@vger.kernel.org>; Tue, 23 Nov 2021 16:16:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jXo2XgpWTDQ33U1xzyRMBM2rgVNZP51at3LBAIeKmJQ=;
        b=DGxDJalnp4zqOpKuLoDBCOah+m5A/0UhQ/qC7gmSN2NqE+8tfRZphNByovhCl8u89Z
         XrkrJpgw/2wHXhnAlT3v9f/hXoUBu6zdLjQaHl1Y4bU7BHe8INoP9EbGudKrMfDbd+gA
         YcgQALN32f70TSFSmaZdixhqx2pXWEjcaRtYDpLRhL7Po99e1aQB3snoThzGUwqmx6z7
         XyVgZ4Kvqho+pDSza6jgjDpMHZ8UFpW9X7FNAKfU4jafsIu1zdoIgJ6P7nRhiMTIIxTL
         y465XFCrXuo64eTXG81xF+e7utYGVZG6RAGsKVKRaLYT1Ry78ccASLq/ITYLSpYro6FD
         cxQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jXo2XgpWTDQ33U1xzyRMBM2rgVNZP51at3LBAIeKmJQ=;
        b=UIqp+mt5CB8yhqAYVRvyt4rdPhr87kVaCE66sgHK7UIsPAgt2kvSbmt2nbTsDKQLL6
         PP2KWCZhwd6l9VQuHiE8aBFbRUpOwA74rQDiBak2z9mQehu+uZNFvBHJ2ii4VKZ/Jx9G
         h0KNnyKKKoG2wuNllFKUR0Nsfj/NpnEyofcTpnedrCAn9AAiqb+Z08uGP4MU+Q9bs76Q
         +iebAFLoibRvwAvlIurQBLCklD0r2fMLFgKLkPrK9kGJA/uSF3kJeXo42ftM7bCnsId7
         qNg67kJUclabnLsokvCU1f5sB4M4RUfeRnzu7+raNdQSQBVrLnaO9ImZ/r7C8MjVnvEj
         selA==
X-Gm-Message-State: AOAM531toqpfom8cEeF68troVQdu8AlBC54cxMwSLkYE15isDqc4L7Bu
        kgZ+mMjPaprsxXGY+VvQI4BI+lY8taLCisgV
X-Google-Smtp-Source: ABdhPJx+q5QaowcACqh743REuQrH33aW3S6r1vU1jR6qAvfifLB/mdriJo4GSWnaws0Uhl38Uzohqg==
X-Received: by 2002:a17:90b:1806:: with SMTP id lw6mr2230345pjb.53.1637712969220;
        Tue, 23 Nov 2021 16:16:09 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k2sm15761405pfc.9.2021.11.23.16.16.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 16:16:09 -0800 (PST)
Message-ID: <619d8449.1c69fb81.3722f.b680@mx.google.com>
Date:   Tue, 23 Nov 2021 16:16:09 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.290-204-g6644175930559
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 112 runs,
 1 regressions (v4.9.290-204-g6644175930559)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 112 runs, 1 regressions (v4.9.290-204-g664417=
5930559)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.290-204-g6644175930559/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.290-204-g6644175930559
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6644175930559e5d5e2db0902ad371882f4b75d4 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/619d4b92bfda2f35bbf2efd5

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.290-2=
04-g6644175930559/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.290-2=
04-g6644175930559/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619d4b92bfda2f3=
5bbf2efd8
        new failure (last pass: v4.9.290-204-g0f8512aac86d)
        2 lines

    2021-11-23T20:13:51.247403  [   20.383514] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-23T20:13:51.291359  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, kworker/0:1/19
    2021-11-23T20:13:51.300592  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
