Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6075A2AE3F0
	for <lists+stable@lfdr.de>; Wed, 11 Nov 2020 00:22:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727018AbgKJXWe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 18:22:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726737AbgKJXWe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Nov 2020 18:22:34 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C57FC0613D1
        for <stable@vger.kernel.org>; Tue, 10 Nov 2020 15:22:34 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id i13so55427pgm.9
        for <stable@vger.kernel.org>; Tue, 10 Nov 2020 15:22:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tqt3cxYVKnn1MCaUtp9zo5RaQmROYwstxA6Pt8h07P4=;
        b=qybn8hE6Ev7FVcosE3e5t0kx5/b1RSnMHpIkovgMex8O3VV3VJk6L4nuqaBrEGy8os
         gAAO8M+CBpRnduqeR5j0sl/uRnqitUKnhU1BpEBepoJGueaLoIvftQ5x6LC4gdiTc7SQ
         4AQlFy0Lj3ZeiQtyStFkmNLg1/VlqmF7nDD4WDMQ/i48Jma86vTR45QxReE47r3N1jVh
         PcLWkcNR6NkPUey3TQ8Cgon5Ax+ZHB41wyGi4Q6IXZBk9KDIIrNjs9N8L94ZgI3GLccw
         HbE3EXfXMkAEzi1SyuFmczQyjyRvoqL2zZfuMphwYt4GSaL/ucaiQpe+3HlZmS4lyFpV
         +etA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tqt3cxYVKnn1MCaUtp9zo5RaQmROYwstxA6Pt8h07P4=;
        b=eUAxAlEBEGpOI17oW6Yfy5LFpKU5APCqhn45ybd4ifwRWovqCHd/IE0uYlv5l9vh+b
         y+X/Wm2fuEs1XVledhfNcTi0gL2Qy9MR+xIpSimHCC03aYm47i2AFX9USh/kFUWDyHVY
         3SUQuVqBkmqGox7oOPxuKnrgqC8X2RAK7bxA7BHstc6+B898uA0iGI/0JCS9bw1oYERB
         FygmNi2Vted2xONDknupLf3BUdk0YoUn4bXf8hEAb4NKXOxCRKMlG6xgKh5UPbbKnnDK
         jIvjh8hXtN9aaS1UPdPmXUoM2MtFEbDpdX5mOdvaW+uJm6bp9c3YU5wYclRQkwh2XIon
         f7wA==
X-Gm-Message-State: AOAM532vvQDhEvRbzMhlMxH7yLpyb2J1FQTu84xoZglAluWEtWea3/Do
        c0ya+vmT05wrEVfMoj6A1q78pnUn/DpdxQ==
X-Google-Smtp-Source: ABdhPJybBi/UN3x8KTQNKtoeiQSeyMJsu6ppRlf/f043nKtR9qurOdIZqp80pGnpggJzuDWcWJJAqw==
X-Received: by 2002:a62:8709:0:b029:18b:23db:7712 with SMTP id i9-20020a6287090000b029018b23db7712mr20322752pfe.66.1605050553298;
        Tue, 10 Nov 2020 15:22:33 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h10sm68425pjk.52.2020.11.10.15.22.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2020 15:22:32 -0800 (PST)
Message-ID: <5fab20b8.1c69fb81.1f270.04de@mx.google.com>
Date:   Tue, 10 Nov 2020 15:22:32 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
X-Kernelci-Kernel: v4.4.242-13-g4252bfe26b94
Subject: stable-rc/queue/4.4 baseline: 102 runs,
 2 regressions (v4.4.242-13-g4252bfe26b94)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 102 runs, 2 regressions (v4.4.242-13-g4252bfe=
26b94)

Regressions Summary
-------------------

platform    | arch   | lab           | compiler | defconfig           | reg=
ressions
------------+--------+---------------+----------+---------------------+----=
--------
panda       | arm    | lab-collabora | gcc-8    | omap2plus_defconfig | 1  =
        =

qemu_x86_64 | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig    | 1  =
        =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.242-13-g4252bfe26b94/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.242-13-g4252bfe26b94
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4252bfe26b941fb8554363374fe9b8f63e56cc92 =



Test Regressions
---------------- =



platform    | arch   | lab           | compiler | defconfig           | reg=
ressions
------------+--------+---------------+----------+---------------------+----=
--------
panda       | arm    | lab-collabora | gcc-8    | omap2plus_defconfig | 1  =
        =


  Details:     https://kernelci.org/test/plan/id/5faaedebd7060ecf92db8871

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.242-1=
3-g4252bfe26b94/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.242-1=
3-g4252bfe26b94/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5faaedecd7060ec=
f92db8876
        failing since 1 day (last pass: v4.4.241-86-g2fa33648e935, first fa=
il: v4.4.241-86-gdeb6172daf90)
        2 lines =

 =



platform    | arch   | lab           | compiler | defconfig           | reg=
ressions
------------+--------+---------------+----------+---------------------+----=
--------
qemu_x86_64 | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig    | 1  =
        =


  Details:     https://kernelci.org/test/plan/id/5faaf01d60f6a8c417db8853

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.242-1=
3-g4252bfe26b94/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x8=
6_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.242-1=
3-g4252bfe26b94/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x8=
6_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5faaf01d60f6a8c417db8=
854
        new failure (last pass: v4.4.241-86-gdeb6172daf90) =

 =20
