Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F81D47D94F
	for <lists+stable@lfdr.de>; Wed, 22 Dec 2021 23:33:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbhLVWdW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Dec 2021 17:33:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbhLVWdV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Dec 2021 17:33:21 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EC7BC061574
        for <stable@vger.kernel.org>; Wed, 22 Dec 2021 14:33:21 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id w7so2357429plp.13
        for <stable@vger.kernel.org>; Wed, 22 Dec 2021 14:33:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=t4ma3wuAYN3GJZpI/R77rv756YdkhufUhL4yW9Ydywc=;
        b=WNqUwDDhq34NZy9dq0HRvHB1aJFwpLwXD5CK2/2sylYiobeG1L3WWAE5k58QnXjKa+
         WTw3QNpZb8IAVVUn3oYbXeVEu7eq6PC7E/GbUa8EGbxXKTzyRmiTDjxRhqQ+64Mg+y1w
         78/juQUY8v+w3cJXcEyH4/iVZZujrkQi+kz2aQhfS7esJi5kRVbraCyprWSEnYCafNbY
         jD1CHFa8SlRm9wp5+6Yot76gG4LDeH9an0NoBy71kPgmjtch3uxgxjXsKD+EYsR/ttve
         9x9IYtht8WxGpT11w8dWWcPiPx1ee9VEoLZJV7IlKfzcA4V9yqdG6SOw4xI4QAT0r+Y6
         NFnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=t4ma3wuAYN3GJZpI/R77rv756YdkhufUhL4yW9Ydywc=;
        b=V9eD3vWSGmaKnF4N895+kGD1c1k9aA7TKIs3Biax8x4cXQaQUHX65mgPYXDyTErpY7
         76HOkKqzgs63bK+qGAkCfZ8VhC4+9ewKy9+1ITXn7YXgzj5KO0JpkQyuiFhqCTl78UxD
         2mm1toKWINqqSz5tvoyPpcw8vvrsvdsvOOzYUNpblrvXzmrfUEfbSYkQK63UV8IrrQt1
         mGCavPMRKKZUjb6J/CbDRHhy34oBvjiy0xgDsqyZaw4LnjrpdJiwreAod1IvJe4BuV13
         6cLna+yhganh5vh67j/R0le8gI+kBP02z8m/QpXZ654jILFMPumYVFcYb/VxtDTAXjPv
         5TTQ==
X-Gm-Message-State: AOAM532Qh1QdRFzBmCVzYaSSWcTh/s8c1altMhs8WKAqcMO1BZU1xp5q
        bHuk/JbIyTJZ8tnnInSLQ7ndbeLD7+kL4uov9zg=
X-Google-Smtp-Source: ABdhPJxfgzq4BlFMJL3Mdc5XUZZl0ncut4st0tWwgU1iQ/B59vHHQm1xJzx/agAtZmSxglCGpmLbIw==
X-Received: by 2002:a17:90b:3e8e:: with SMTP id rj14mr906421pjb.195.1640212400548;
        Wed, 22 Dec 2021 14:33:20 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k3sm2910079pgq.54.2021.12.22.14.33.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Dec 2021 14:33:20 -0800 (PST)
Message-ID: <61c3a7b0.1c69fb81.c525.882d@mx.google.com>
Date:   Wed, 22 Dec 2021 14:33:20 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.259
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y baseline: 146 runs, 1 regressions (v4.14.259)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 146 runs, 1 regressions (v4.14.259)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.259/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.259
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8ee0807eedf3bc60c8a47a7dd95387102bcfd063 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61c36f6f35ad1c3a3d397152

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
59/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
59/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61c36f6f35ad1c3=
a3d397155
        new failure (last pass: v4.14.258-46-g5b3e273408e5)
        2 lines

    2021-12-22T18:32:57.702454  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/100
    2021-12-22T18:32:57.711635  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-12-22T18:32:57.727656  [   20.111999] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
