Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32FA931AD9A
	for <lists+stable@lfdr.de>; Sat, 13 Feb 2021 19:55:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbhBMSya (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Feb 2021 13:54:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbhBMSy3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Feb 2021 13:54:29 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72F56C061574
        for <stable@vger.kernel.org>; Sat, 13 Feb 2021 10:53:49 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id m6so1697051pfk.1
        for <stable@vger.kernel.org>; Sat, 13 Feb 2021 10:53:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bzTlNT4SyHl0Pwf5xLWVs7q+ulO2knoTvdJrsjAqa1E=;
        b=AaDw+z6uTVzTTEf3qc/cv6RTLZ+HNTROMdd7sMWVVWMHjcTkQiGsgfnW9wAT22ikuX
         LUukCF+xlLOPPM9LuUaxKnYRk/9rSYB3Rn2+tZHzX4tVKAjVF9ky/IoKjLowwVf10GeD
         teAe4mF7/rzdE2jwSdLlmTsZCc5ZkRiz2308kEut22Bv0wnjXzUQGsbKgCdrbnkdVmPf
         HB4ybGUylyp2byc0MXXJScZZnbSK40ZZpyfWMqR7fG3WMEYjaYxMxIF0ebZ+8rib9vCo
         pp9JdAG31onfO+ZyhkX5JzZb0tfdZNXPP9+pWLR/WUj5R8k0JQYCoVTKJxW41P2C6g9j
         Z54A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bzTlNT4SyHl0Pwf5xLWVs7q+ulO2knoTvdJrsjAqa1E=;
        b=QFTK+AW4dGh+7+Vyolc8H7dHmPHYcFXL1F+4S8Yx0fBHgwec/bnTr4JFJA0RUdD+QT
         cXqT1cSK3AmbSLK9icYPHBEiAanY4KlR198eNeql1TOkzl0BJR9rRoHFpFc0Y3rG8qnM
         LGMnDqTEt4yQ1qGe+b4mihOWwpZOGP1bFNNLUIc6AzpLbLt46tdSbR8c+O8wlNiBqg5K
         f8skXjRO7VzfKP8e2MivQsi7vs/05gAoq4aMRffiMTsBYddki8NqGyWWcGN9RNnRefV4
         HYlx8XoK0l/Lr6IL7haFGKPSlQtqEXuoIZUm7XL8wSVompr0GrY1+NEoOwMpS0RI7Smc
         ttSg==
X-Gm-Message-State: AOAM531gPckuIuetKoPxVylJc8xZS4rYv6wdyuUdn819Omhev3K72kVi
        N20W8RPCTnzMaN4KErNkzuOKo374T0Kveg==
X-Google-Smtp-Source: ABdhPJzNfCu7CXz4Ynn1vjXDBIafShcf5xW4M/nbCYh6Beb1WUXGWlq5m0FWABVNbPtSlxtjkkej8g==
X-Received: by 2002:aa7:9197:0:b029:1d5:bc1b:ee79 with SMTP id x23-20020aa791970000b02901d5bc1bee79mr8488432pfa.38.1613242428547;
        Sat, 13 Feb 2021 10:53:48 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i7sm11560158pjs.1.2021.02.13.10.53.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Feb 2021 10:53:48 -0800 (PST)
Message-ID: <6028203c.1c69fb81.4d4dd.9566@mx.google.com>
Date:   Sat, 13 Feb 2021 10:53:48 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.176
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.19.y
Subject: stable/linux-4.19.y baseline: 78 runs, 1 regressions (v4.19.176)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y baseline: 78 runs, 1 regressions (v4.19.176)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.176/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.176
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      255b58a2b3af0baa0ee11507390349217b8b73b0 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6027ef1b238dd887a73abe6a

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.176/=
arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.176/=
arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6027ef1b238dd88=
7a73abe71
        failing since 24 days (last pass: v4.19.168, first fail: v4.19.169)
        2 lines

    2021-02-13 15:24:06.856000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/109
    2021-02-13 15:24:06.865000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
