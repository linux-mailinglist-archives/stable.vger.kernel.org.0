Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9242AE72B
	for <lists+stable@lfdr.de>; Wed, 11 Nov 2020 04:44:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725870AbgKKDoy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 22:44:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbgKKDor (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Nov 2020 22:44:47 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C55CC0613D1
        for <stable@vger.kernel.org>; Tue, 10 Nov 2020 19:44:47 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id h6so591150pgk.4
        for <stable@vger.kernel.org>; Tue, 10 Nov 2020 19:44:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=yyw0PWCJzJwceCXshcMzjk6EKsDy1jtYPb6S52F1L78=;
        b=VlPFzWXxuIGgYjRghVJo5IiM5IGN6qC1nBV7YaNTCPf2v9hO+HM7wvCC+eHPlOWRic
         HmrmYN6EDEveTEbc44WYLy72IciSwx8SzwZDDqinNobJcscdF5fNd9M4jO9z6Y/bN6wU
         hbBO8UQ6tjBB1GodcAV5nxy8cXR9QaYmmxGf7MGSPCCCUtT+STCbP16TrqufV+kwdYp6
         pfpC6fKBpNX+iV8XLZGurNh8JsA+JgHeKssn/fIC7qVcJAZtjl7XKJDYD3u3Nlbf9Xt5
         eefyxib112X3m9B0ZNZfB9vuMVLhsK5PG71gQrcIGXOL4pYwKBEqXHqNs6zXRxudPwO4
         8r2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=yyw0PWCJzJwceCXshcMzjk6EKsDy1jtYPb6S52F1L78=;
        b=uc6MxQTr0ac2cm28qsKPXlbDD4jIv3Uw+NKHCNEf65vHIkWqCae/pU7D06fTjDdkhK
         V0sfd/1mxG0QHczytkiPFMWeFG/YsLFL5GsOsTH0xQO4y1lMzJKdAmszUV2RnWh0QhNM
         Ljh36otXtRhV6lu7bn0ANBmHleGK6+pNSKlB+t0rde+QSiRjfv6RM2cyrNF7EbxOuVpX
         u6jLP4LQ2rmNA2zxQWbW4c7ZDhA1IA86Hf4R2dMvBQSPpRvSTgDNUhts+soXTNJtB7ey
         Lj6ZTIqnbjC4NrOGwYc/umgN5ZXH4Hhu5qcefZb4D4DPH/Z04jCB6NM4qmGdAguVyX61
         sd+g==
X-Gm-Message-State: AOAM531Z9Z7Tydl7mjJeGYBa5EyoApULpEIgNS2vHOjK1s/3MS+4echM
        bxTvhowFDPsp5Ar2Sa4x7afJMNFN3NZRmA==
X-Google-Smtp-Source: ABdhPJyMfECpQWADlD+NWNJa4iWOjkimjSt9U3NXLosG8pPrDyFa+L9PBZT1gOwaD0T8/PIsFceLmw==
X-Received: by 2002:a62:d459:0:b029:18b:12eb:7755 with SMTP id u25-20020a62d4590000b029018b12eb7755mr21094616pfl.79.1605066286415;
        Tue, 10 Nov 2020 19:44:46 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d10sm435676pgk.74.2020.11.10.19.44.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2020 19:44:45 -0800 (PST)
Message-ID: <5fab5e2d.1c69fb81.aec0e.1b1c@mx.google.com>
Date:   Tue, 10 Nov 2020 19:44:45 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
X-Kernelci-Kernel: v4.9.243-16-ge1f04844753a
Subject: stable-rc/queue/4.9 baseline: 134 runs,
 1 regressions (v4.9.243-16-ge1f04844753a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 134 runs, 1 regressions (v4.9.243-16-ge1f0484=
4753a)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.243-16-ge1f04844753a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.243-16-ge1f04844753a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e1f04844753a2ae4ab872ae9c1ec484d1434dd82 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/5fab2c7db133e31abddb8876

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.243-1=
6-ge1f04844753a/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.243-1=
6-ge1f04844753a/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fab2c7db133e31=
abddb887b
        failing since 0 day (last pass: v4.9.242-17-g4a0d38d66d3e, first fa=
il: v4.9.242-1-g113d25b242da)
        2 lines =

 =20
