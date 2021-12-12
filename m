Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FDCC471E19
	for <lists+stable@lfdr.de>; Sun, 12 Dec 2021 22:47:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbhLLVrx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Dec 2021 16:47:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbhLLVrw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Dec 2021 16:47:52 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B929C06173F
        for <stable@vger.kernel.org>; Sun, 12 Dec 2021 13:47:52 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id 200so4057267pgg.3
        for <stable@vger.kernel.org>; Sun, 12 Dec 2021 13:47:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=p0Y1kPKyX1v2V0GSYhX3/+OjqyKS1BR63wkaErrpevs=;
        b=7F/lHUaUZZ8N6NAtaRYmjuf8IA3PudbkOmoGBgjYFgjclcoX39d7/mL+gc/b0Ru3bB
         bm8b7P+2lNv8Ngq4IHFgCN9VAktxXs0qFN44IK9d6K+88v6eGWcG40rWq+Erob85FIYH
         zrWLN+s7cUmcbPmcPGgnOSfwZQ9VyEjRK+mpeo7fQVcUaXnpP3V+lG/DZEOc5zqOrnen
         mgAJHJHaImzAPR6qZaWu86ciceEs7UXUmqCFvOCO3sdg5aIXZuxhMwrtTYA1kPeWJrrO
         YMThZphIayPfow1NjhTeDQT0wDMo1sB58RlWl3uPgFRBAKV7PnCdEqDin04lmug1PTSr
         j97w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=p0Y1kPKyX1v2V0GSYhX3/+OjqyKS1BR63wkaErrpevs=;
        b=dy0/zkMFBKfOKvYPYvaVDX8aoHPGXH6M3o6ka5pf4etWXkjWPgg1YPUBSNQJqwEOZ9
         +pO5/hKXDfA+OYNk48nFLIPBVH6eNwLotyIDm/xRR37KltLjo3KYIp+cKrqw3vRJ/lmD
         /Keaa3fuTFOQLmmqM2Gfz01t90int9jGPCIL9t7jGo3U2A+EVionp12WS4UymyksQxIF
         69YtW8ERSL0Tl/LD7e5ddem8zU2v8CFr5rdie3E48fjWJcjSgsIFUKB1P87SqzvC9Gvj
         j72MjLfVc873C5PaXGgUCo17GCO6cueMPMf06MZNF2fi4VzDWzrao4x+yxaUdY/kVZDh
         IKGQ==
X-Gm-Message-State: AOAM532yXZgcR4/BJsiI1vO+L8fXv+o923mAuhazTc0Mhb45GG7aKRJc
        zS08m1PioS8JYo3iS6EowqZxKr+PN+7awg9N
X-Google-Smtp-Source: ABdhPJwXfJtJLl3tm1kDV1WTbnubEAFNwwaJU5rkUlV/5nMpPPw9KHhahRKGvfxlbB5+iUnBpUjYLw==
X-Received: by 2002:a63:8c1b:: with SMTP id m27mr49346346pgd.399.1639345671735;
        Sun, 12 Dec 2021 13:47:51 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d23sm2513787pgm.37.2021.12.12.13.47.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Dec 2021 13:47:51 -0800 (PST)
Message-ID: <61b66e07.1c69fb81.23b68.7266@mx.google.com>
Date:   Sun, 12 Dec 2021 13:47:51 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.294-27-gf40112305aac
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.4 baseline: 93 runs,
 1 regressions (v4.4.294-27-gf40112305aac)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 93 runs, 1 regressions (v4.4.294-27-gf4011230=
5aac)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.294-27-gf40112305aac/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.294-27-gf40112305aac
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f40112305aaceb1d4fff7038095cfac020213f55 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61b6331629bf578c0639713d

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.294-2=
7-gf40112305aac/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.294-2=
7-gf40112305aac/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61b6331629bf578=
c06397140
        failing since 0 day (last pass: v4.4.294-9-gc0c2458dacd8, first fai=
l: v4.4.294-20-gc778b3c7e92d)
        2 lines

    2021-12-12T17:36:04.539783  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/127
    2021-12-12T17:36:04.549116  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
