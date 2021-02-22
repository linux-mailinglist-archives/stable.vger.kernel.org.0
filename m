Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD70C321A52
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 15:30:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231955AbhBVOZo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 09:25:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232606AbhBVOXz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Feb 2021 09:23:55 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE6D8C06174A
        for <stable@vger.kernel.org>; Mon, 22 Feb 2021 06:23:14 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id 75so10285517pgf.13
        for <stable@vger.kernel.org>; Mon, 22 Feb 2021 06:23:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8HN7UESFCuyAul+X1CnJdAwHqMrTao/AA7FxTixwqHI=;
        b=ULv67r9ZkqUbXv8K2te2RW1ra8blQzlZum/N9WDD/crr9dDpHmR/t3jDqoQcFTyE8s
         2WrLeVnK7a9Qwhjy18w9dACt3UULVGamys10ncqDGr3uTwdlvxgpGvlrScKAYVQEnFNo
         gbJPAk0M8AOPrgdnNxJI9lFxSAZhQ233dSlvevstwTyKKWDlZYRTOMQ+xAuljmp/mg00
         vBwEVEBfgrRf+3Uyt6hJIykbOs7wHRzVQ6If4YSi21ehc53HDIDeB3C+kZDMAgkSbuS/
         rUqW8V9DIyVsauIpSkfpuirqAubQwol8nSQjt8BbdbcuwWTX51Yy9fAGeG5u/0rEYWmZ
         aRLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8HN7UESFCuyAul+X1CnJdAwHqMrTao/AA7FxTixwqHI=;
        b=nVYJZC4YYxcQTQBqKdHw1oiwbP4kDDboBosAYseaUfU3vkA6smxAc2QxnOavgCd3hM
         Aa3M2Zyb4wKFEILFa8oTz30t6qhW/wFKx1Jj+tQIVyq1qh1XuPgQg70uYbMo+6JS2lmo
         oMMghC3hJDMBNMGEYc5ByNqqf/fUodqs5K2SnsBqd3h7m3bxzr0+0Y9JmHC/VkbQxggi
         Yo2rAWDveQ4s+m3jFN1pwX9e9aVkTZC6oamggzF6bL8VhLBuSjIoiFTxvt52Ek59aUj4
         rtlISp1Y+j1U60lWZDGXrSjkR3tgQFdRvKUAi6D/mjkKxNW5zXF2yDVaV+N9gEXNDapu
         vuPA==
X-Gm-Message-State: AOAM5319Qh22jnQZy+5wjhi0zzBa1iLnZDJmdnBTuKGHAxdoIdf6TG9d
        F7MOKSWRYiXmcK6pHW7iMvnEc4CKwOs97g==
X-Google-Smtp-Source: ABdhPJzD/JCViDr+CHfu4KmWTO/vwTyUAOODUkZRdtmG2gH99WcHVNxKJ3ZtpcWcZTTF2XcKyT3xwQ==
X-Received: by 2002:a65:4c43:: with SMTP id l3mr19949052pgr.327.1614003793904;
        Mon, 22 Feb 2021 06:23:13 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id gj12sm1657394pjb.25.2021.02.22.06.23.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 06:23:13 -0800 (PST)
Message-ID: <6033be51.1c69fb81.c58e.2bb9@mx.google.com>
Date:   Mon, 22 Feb 2021 06:23:13 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.257-47-gbb4595d8d8db
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 55 runs,
 1 regressions (v4.9.257-47-gbb4595d8d8db)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 55 runs, 1 regressions (v4.9.257-47-gbb4595d8=
d8db)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.257-47-gbb4595d8d8db/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.257-47-gbb4595d8d8db
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bb4595d8d8dbcbc52099ae9d649ab51200c27b8c =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/603389dc8ded3f284eaddcce

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.257-4=
7-gbb4595d8d8db/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.257-4=
7-gbb4595d8d8db/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/603389dc8ded3f2=
84eaddcd3
        new failure (last pass: v4.9.257-38-g1731f253f5cd)
        2 lines

    2021-02-22 10:39:16.303000+00:00  [   20.481506] usbcore: registered ne=
w interface driver smsc95xx
    2021-02-22 10:39:16.350000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/125
    2021-02-22 10:39:16.360000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
