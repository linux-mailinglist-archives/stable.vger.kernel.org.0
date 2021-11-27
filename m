Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB7A4600F1
	for <lists+stable@lfdr.de>; Sat, 27 Nov 2021 19:35:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355905AbhK0SiZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 27 Nov 2021 13:38:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244099AbhK0SgZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 27 Nov 2021 13:36:25 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EDE7C06173E
        for <stable@vger.kernel.org>; Sat, 27 Nov 2021 10:33:10 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id b13so8899142plg.2
        for <stable@vger.kernel.org>; Sat, 27 Nov 2021 10:33:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=q7x+lRuDdTJCVO3X6aSonFp2OXaByplE0RKTTTYwiT8=;
        b=k0a3g4yUWQL2k9LyB4KXwwsuk04j04Y4LDsUfh/ij4ZVbjCmwYzIuB23c7ZPjCr2xe
         hbaSHVmwskDyIxbgOImbi+8SSjDwaliD9z9PKCitoX38V6S7fc+nz8uXATnEusAFa+dk
         /X9hoo5NGKryy199Z8emN9CPGToOm8jxoJ4H6AhWgqK5Fjk6iRvyvmw3OBoUReWg19+a
         YQc5jEuSO5FDUjQfdpTwSe7PDu0ekQiT/7jrPF+utBmh7n8nOhqNPivhVUvhl9uRCjh0
         FQ02UrLCbryuKGSNtZ8vwNCQD4Dey6iKFrP2CjVRveNGvkxAudjwCUFwH4Nx77JiHLBd
         01ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=q7x+lRuDdTJCVO3X6aSonFp2OXaByplE0RKTTTYwiT8=;
        b=LtsPq/5lmEt9jyUHCgCHkmiszsCG3G+IzIOD9ZdyRCIHu9JFD/sdeU8y3cuM+EAnid
         q1VKRdBZKS6TF/xSsSxelNWDn5SApc+0eEKCA5lL0WmBFqOYzI9dhKqNkNB3arnc8ic3
         W8YFvvuGT08tFiq8v2iggPWvadIU3c9sWuCSookEdTazyWFDE6YXOPRzjcROtyxRioD8
         7VwOLL9dgJkgeapxiROUOGMkih19yi7dVrTK/xD3lmc73gBHNFZxwAbTD/6YPm+Wm9HC
         SxZSmkXdkaSCP793HLkwJwt15FrUW8g6KNsCQn/AFDB9mqE4Ew6+B9k3eoMdKLdsrOYY
         6nxQ==
X-Gm-Message-State: AOAM533wbZtPNM3geu561q3wfCTGrsaD+SBb5j7efkCTFCMmutXu6sFU
        gaXLMgXVWeDr1QpI689s8BRQLpXAK+UWEt53
X-Google-Smtp-Source: ABdhPJzySKy+h2otaxlgiTciY4b5zX6/hy6nGUz8Lx7Vkr3nsNM0cholF9HUb4sTmM/39uT3LtEaMw==
X-Received: by 2002:a17:903:22c6:b0:141:fac1:b722 with SMTP id y6-20020a17090322c600b00141fac1b722mr48020304plg.23.1638037989301;
        Sat, 27 Nov 2021 10:33:09 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c18sm11805795pfl.201.2021.11.27.10.33.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Nov 2021 10:33:09 -0800 (PST)
Message-ID: <61a279e5.1c69fb81.281d0.fbbc@mx.google.com>
Date:   Sat, 27 Nov 2021 10:33:09 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.218-11-g683be722a3e85
Subject: stable-rc/queue/4.19 baseline: 131 runs,
 1 regressions (v4.19.218-11-g683be722a3e85)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 131 runs, 1 regressions (v4.19.218-11-g683be=
722a3e85)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.218-11-g683be722a3e85/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.218-11-g683be722a3e85
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      683be722a3e85708d6ba8619d138457311779fff =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61a240e3b0f20a964918f6dc

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.218=
-11-g683be722a3e85/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.218=
-11-g683be722a3e85/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61a240e3b0f20a9=
64918f6e2
        failing since 2 days (last pass: v4.19.217-320-gdc7db2be81d5, first=
 fail: v4.19.217-320-ge8717633e0ba)
        2 lines

    2021-11-27T14:29:40.027773  <8>[   21.305816] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-27T14:29:40.072355  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/110
    2021-11-27T14:29:40.081707  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-11-27T14:29:40.095906  <8>[   21.375122] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
