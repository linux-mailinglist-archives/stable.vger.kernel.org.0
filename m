Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7CB02A0A0A
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 16:37:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgJ3Phm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Oct 2020 11:37:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbgJ3Phl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Oct 2020 11:37:41 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B14BDC0613CF
        for <stable@vger.kernel.org>; Fri, 30 Oct 2020 08:37:41 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id b3so5645229pfo.2
        for <stable@vger.kernel.org>; Fri, 30 Oct 2020 08:37:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=r9/ySKSK8zz3zokw5WuzYA4KqwUtBy+kTmOV4ySXNlg=;
        b=CqChE21yOeBeQ2iMPJtAph6B4TIXJkwF6wIEajfSlGJNGvH0MOei7REzOhw9xZ0a2t
         lO7cyZYbBHZAOSy8U3f4ZDp8ehK+pZiviJLqWsCvwWFLPadYMivYZTg0KoSUDbXOOV/7
         JkHtnTVpAzB1AocYwJbIZHK/n7WQ8TIaNg5gHaZXTQtSvGZdGHpgxb5yDVT7M4mVSj78
         Yox/gW7BLWPiEQ7E1p6oGgFqesqp9tPtYqbzITd4uMnUh8wKUvsweDmsabJUO+gnp0C2
         VYJ9fHdeFucIGnuCcrI8pxeWex2uGy9qjz64EY0ubPpErMnLpQwXBWf5z2nSeVBkUtY2
         mBww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=r9/ySKSK8zz3zokw5WuzYA4KqwUtBy+kTmOV4ySXNlg=;
        b=G5u6x++jfIS8HQa27VjPGqTfYcYRT0H6tD5xl82CjDzUrnOv7ZzRjDdxxw+g3tMSly
         PAgRJs8k5MYHPeZS9MMCVoxmPOImmGOb8P3nLbrvjY+yxnoeCiT0pSATv1BAYr/48R7v
         TswCVfoBZzhYfQO29uR9vkKRoQTrWHZk5t8y2Ir73opBgi0GMzY7UmDufmGtV2vzVgPb
         Y7Q66xTzU3L1bXTAfWxdNpdGepTqnIGDGXqtEizrfqTrSytpILuUvWYCfUPU4AT7kSSZ
         OcWq9R/d1iaXSMnl1Xh5ZiGK2aEBtnR3oQPMoEvipk1f17sDJqkgPBZy0MLLpVFjhOXj
         FM9A==
X-Gm-Message-State: AOAM532Qgo9Tm3cn0lzd30tigdwCAyT98/Y5h8w25NMZfRVmr1KIJKXe
        noSHlrsrohGMhecD2eEV1rzK3HqX6EYZ5w==
X-Google-Smtp-Source: ABdhPJyl15Z6smhcysQnbBt1AsqsmRZrZrxWlgV27/VcBT4dyJsMj1sku8B1bfQCdnR8E9LoaapeKA==
X-Received: by 2002:a17:90a:c588:: with SMTP id l8mr3360711pjt.205.1604072260996;
        Fri, 30 Oct 2020 08:37:40 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x7sm6543867pfr.61.2020.10.30.08.37.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 08:37:40 -0700 (PDT)
Message-ID: <5f9c3344.1c69fb81.f26d8.fb64@mx.google.com>
Date:   Fri, 30 Oct 2020 08:37:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.154
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.19.y
Subject: stable/linux-4.19.y baseline: 175 runs, 1 regressions (v4.19.154)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y baseline: 175 runs, 1 regressions (v4.19.154)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.154/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.154
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      f5d8eef067acee3fda37137f4a08c0d3f6427a8e =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/5f9bff8807d6439857381182

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.154/=
arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.154/=
arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f9bff8807d6439=
857381189
        failing since 15 days (last pass: v4.19.150, first fail: v4.19.151)
        2 lines =

 =20
