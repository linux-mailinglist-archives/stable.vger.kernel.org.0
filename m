Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1601445CBD
	for <lists+stable@lfdr.de>; Fri,  5 Nov 2021 00:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231148AbhKDXmy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 19:42:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbhKDXmx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Nov 2021 19:42:53 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50E3BC061714
        for <stable@vger.kernel.org>; Thu,  4 Nov 2021 16:40:15 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id t11so9852019plq.11
        for <stable@vger.kernel.org>; Thu, 04 Nov 2021 16:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=x61tLjxZI//ZLDm4GGSlwSRZ6gBxKssgFlplfcSNXVY=;
        b=xC/Pe7k+g76JIOSLbR49UJHNgCRrXMMhFozxkpAxkcMUglhb2x55Lnez2FRwM90smr
         XMJfxJe/Cxqp9gg9hgarilf/HzoS9xA0lQ2mundDb2XAGEUraxlRFgTPoC/Rmef40u64
         NebXSUw76ea5krHWkDIymfVtmHpx0MWDgiLUcii5yB09UNHJaiU2ZZcmgGL1sIOHOGZj
         5e7zcJOXOfP5opWmLcIIkIZfSz5kqfEOHuVKj5IwQ/gHfZ321GhEwuCejPovhaNX8uja
         PCZjZYMChd+7MHQS31x4RkhfNv4qk21lkNIf7FHZjRvT9uXGMW8QT7Q5aDRnNB2Kgwge
         5VMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=x61tLjxZI//ZLDm4GGSlwSRZ6gBxKssgFlplfcSNXVY=;
        b=ocO+jXkm9UsIiDLBuHjBxf3cPwI+cBi0+74edRTTEXr9gecu3Lv+i8c/zAJN1Lp/PF
         UPmlwU7Ec+y7DVTp+nt8QxJvgE87y8ya50NbZYq5R9iYdN9ohc7uTZLGnErNZ3eRUG/R
         DmvXg23TItFgNEQMGxn9sBWZ4vvcPeo9UgJnzhblC5PomgHF7BxXjeSV3zX4vVeL8vX3
         A4NO1kVEBFxiKyQkbnNe3QmymqNxGosLeRxdoIgcz2pxr8rDZf7oIuEsTeoT5ye5Gs8q
         TnTgrurT/x2orFAJzQLpE/RuWIw0pwxDE0EoMTlIPRi6/EzW+PPfjan8BPis1OPQw1ZP
         QGHQ==
X-Gm-Message-State: AOAM5317pUeekcN3QA2mc/DLnlwGBsjBTFbmry4NWkROmhPu3bOj6h0L
        V5rSJRaCs45jUcK7XkIfpLQ9/l1wKGkb2l7V
X-Google-Smtp-Source: ABdhPJyVZTbyDa/zg5iQlQIh3j4PeDW1eLWJFq0EqKvEcmTmwGSg+klhYXGV/34c/uUKEojLU45T8A==
X-Received: by 2002:a17:90a:65c7:: with SMTP id i7mr25386425pjs.192.1636069214547;
        Thu, 04 Nov 2021 16:40:14 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y15sm4652069pgo.75.2021.11.04.16.40.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 16:40:14 -0700 (PDT)
Message-ID: <61846f5e.1c69fb81.8215b.fa92@mx.google.com>
Date:   Thu, 04 Nov 2021 16:40:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.289-4-gf4a63e128939
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 110 runs,
 1 regressions (v4.9.289-4-gf4a63e128939)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 110 runs, 1 regressions (v4.9.289-4-gf4a63e12=
8939)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.289-4-gf4a63e128939/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.289-4-gf4a63e128939
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f4a63e1289395378f3fbf08050813ebefd59fe85 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61843d6c361a7463fe3358dc

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.289-4=
-gf4a63e128939/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.289-4=
-gf4a63e128939/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61843d6c361a746=
3fe3358df
        failing since 3 days (last pass: v4.9.288-20-g1a0db32ed119, first f=
ail: v4.9.288-20-g7720b834ad25)
        2 lines

    2021-11-04T20:06:51.518568  [   20.775482] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-04T20:06:51.562022  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/122
    2021-11-04T20:06:51.571040  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
