Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE61E466BC4
	for <lists+stable@lfdr.de>; Thu,  2 Dec 2021 22:52:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242696AbhLBVzl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Dec 2021 16:55:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243478AbhLBVzl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Dec 2021 16:55:41 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D9F7C06174A
        for <stable@vger.kernel.org>; Thu,  2 Dec 2021 13:52:18 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id j11so1097865pgs.2
        for <stable@vger.kernel.org>; Thu, 02 Dec 2021 13:52:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=uHiDY6fvBtymLfGr149NsLb25dYA08W8YOcnj4Uli6g=;
        b=4SmKMe0qdAdm0R0r3NPOeVOSTyokbNb3zatlqjnkw1m9ewKX/StuCZimn/SLFv6/zQ
         r5LfirbKnN/RGhyAOZ9U/soIV1bJXijoRbiKYALEw1b6hDH4V9Y1Hhxu9BPicQJM1aL1
         Ong+2A6j6n6NARQ+f2kQ1adKOvTH6AfZDnZ1rsUOYTTAbB9M8c343gxym83/mETItqJI
         Lm8pAfgadI2YBaiRcVV7Tjtv10zJ4vN/vd5bj3DJLHX3a+2NG8RURPzPLUhHluGKckMD
         /JxCQmj59P9qTy9aU9UH4+l/uEbu5JfDW6HaarM5hlO+wf4LTHXCW3ClpcKMyquhWPDt
         Vkhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=uHiDY6fvBtymLfGr149NsLb25dYA08W8YOcnj4Uli6g=;
        b=JprNQFwegyFv/4WfbDC6k/ZwLjHY0pV/Gbycn7J5cSCpjLuM81efl9mzG2KPiK0ZyT
         T10jPZsWHCkpGMzyePB8HbSFpMLWEhZ4VON8BQ1VVwr/kPlJxCrZwQcs4A6xoEYr+07f
         BUGfkMYeTW3rovlOzCt+oiKC6ZUQ16Pq/e5Kbb947KZ+3ZuOGS4gyfKA9R9BICM9UOOx
         RpEemeMPyGyVpFKtOtF0S+QthybKln55QI6Mdsqc69RzMIvHSZ5c4+TM0Fb8iP0fYJeC
         HmtEbkymlHdLbP0a8IpzBg7b8IuMLeyqB4ChbAhoZAZ7OE6U1ncJSPvhf62vxatwY90b
         kCZQ==
X-Gm-Message-State: AOAM5304Eaza7pAUCNegl9hOuyc0dIoQFUwDYm3YXhF22P5rH0ebnrh+
        DQaSWefXE9WRN8PnSivcmEEz7+1Tk+uzd6x9
X-Google-Smtp-Source: ABdhPJy12Th/mTjfuvGpJZcm/j7KQHK1EnhU4AczRdpqrW3qyoxVq2NAuMa38hw5PoDLpxFgkimtxQ==
X-Received: by 2002:a65:408c:: with SMTP id t12mr1432329pgp.262.1638481937811;
        Thu, 02 Dec 2021 13:52:17 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z16sm514837pgl.29.2021.12.02.13.52.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 13:52:17 -0800 (PST)
Message-ID: <61a94011.1c69fb81.623e1.23e8@mx.google.com>
Date:   Thu, 02 Dec 2021 13:52:17 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.293-34-g2a1dc898fe8fd
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.4 baseline: 68 runs,
 1 regressions (v4.4.293-34-g2a1dc898fe8fd)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 68 runs, 1 regressions (v4.4.293-34-g2a1dc898=
fe8fd)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.293-34-g2a1dc898fe8fd/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.293-34-g2a1dc898fe8fd
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2a1dc898fe8fd2efcf2f81ca39504ec771cfca62 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61a909d31caafa47d81a948a

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.293-3=
4-g2a1dc898fe8fd/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.293-3=
4-g2a1dc898fe8fd/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61a909d31caafa4=
7d81a948d
        failing since 1 day (last pass: v4.4.293-33-g845bf34b777ca, first f=
ail: v4.4.293-33-gfe2c5280cbbe0)
        2 lines

    2021-12-02T18:00:30.061548  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/120
    2021-12-02T18:00:30.070852  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
