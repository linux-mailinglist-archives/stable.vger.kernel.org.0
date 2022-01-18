Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 779D64929D3
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 16:45:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345985AbiARPoz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 10:44:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346080AbiARPoy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 10:44:54 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CE60C061574
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 07:44:54 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id p125so3228640pga.2
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 07:44:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4h+3aSM4Z386v43J47nWLR8fyBc7YModZs2gTwluoZo=;
        b=IO6TdECZdrUAGGndi+rVy7V0KxFv6vHv4LO3C3KE18to+b3mDtR6CsvWUhZeRnl7UV
         ilnI0NLVVfQlW2tGQsIPYwpQvzmVVdsrebWRsjCtztDoCQqk+5lx08MMROlV2nSRLBfU
         NoLpEOIUrrKW4wjW48+KfCmjsPKPHEoC5wLD0XDDMX/e9CYlZ0Srao3Nc/9f0bswOxBO
         0jrYXJsjE+IDf4r23SBfreBnrQ99kpesQq+z9TPSORteQ0YOuTQ/5ZgtWMf2YnLiGrF5
         9sZ5dZSt89uhCL/u1ECA11UGwVll79aVh8XLpEeaNEg0UQNwgUni/OwsQE6w0tSJbgXB
         FZ5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4h+3aSM4Z386v43J47nWLR8fyBc7YModZs2gTwluoZo=;
        b=IPblMMGl/8vYCy85ayUzi3mSsAgy5sXyOdvUkXncPAuSayFOR6DyPP8A1g/vRm012q
         V4R4m71196R5/5TazPo8Gi7K6uA4kVACxlT4cpq1RS1EN34uQRH1NTMKopkleLZatyOZ
         auE+QaDnjxLE+b/CpN6aHRjOV481n/NVfz/nTT+kpbTD84w6hmr3RjPqSgU5s4l966tq
         ncq/hWw93wer35wMst439YUmMNVLacRIXp+6WMsQiJvTDkczATPS8BKrdouMxnPeDRVA
         LJpq0s8ytrKxexWwkSOk3JlxRfmwgtk4ArZkB+FjO+ojgWi0IfDlw/KTr3+0EcLNOEAP
         ljHA==
X-Gm-Message-State: AOAM532OuXZEfsct8Sjt6aGFmlQVl8qMHlFzLpnue37lObrNdoXq1A6b
        yErCDlUuHCIsNdBLRHLPfoxZ+ILSpWveHl7Z
X-Google-Smtp-Source: ABdhPJxMG8sRQAsZJFbRsY3bTqmLwwroy6oo5bTbfYFaHNj4qkOfljtLHaJeBoZxEOShYeoo3wADtQ==
X-Received: by 2002:a65:4cc2:: with SMTP id n2mr18298536pgt.535.1642520693514;
        Tue, 18 Jan 2022 07:44:53 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id pi10sm3526364pjb.36.2022.01.18.07.44.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 07:44:53 -0800 (PST)
Message-ID: <61e6e075.1c69fb81.a792.864d@mx.google.com>
Date:   Tue, 18 Jan 2022 07:44:53 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.299-9-gd634fb6b6f52
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 121 runs,
 1 regressions (v4.4.299-9-gd634fb6b6f52)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 121 runs, 1 regressions (v4.4.299-9-gd634fb6b=
6f52)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.299-9-gd634fb6b6f52/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.299-9-gd634fb6b6f52
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d634fb6b6f521c483a5ef3e793bd5050c48377c8 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61e6aac854ddf9f7a4ef674d

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.299-9=
-gd634fb6b6f52/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.299-9=
-gd634fb6b6f52/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61e6aac854ddf9f=
7a4ef6750
        failing since 28 days (last pass: v4.4.295-12-gd8298cd08f0d, first =
fail: v4.4.295-23-gcec9bc2aa5d3)
        2 lines

    2022-01-18T11:55:34.020374  [   19.211151] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-18T11:55:34.072895  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/122
    2022-01-18T11:55:34.081854  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
