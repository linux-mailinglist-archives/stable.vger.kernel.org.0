Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C71BD49AD38
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 08:15:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442244AbiAYHLl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 02:11:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442494AbiAYHIu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 02:08:50 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28FA2C0612B1
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 21:58:13 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id q63so14200781pja.1
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 21:58:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WZD92bC94EW74qAOQ3Z36r/IRQfP57Jy4rUjTn/RCs4=;
        b=caQ5eidNpSxo+MxijupuMt6XDT4oekWAkrCrExgn8CPAs0PwzSg9ci0oMlGT9km46Y
         bvmII/92r6EmhvKIMLcpYRh7GfdhzLeL/boAssX+jCELleHCs1dEoEewYuHD0KP/0I9q
         U5rxxvEElqtDuGvxrHq0UhB33r8/asHqXtWdGM72XSxIXKbXk+jkFdPCMhAN0cao+gMA
         UwsAGJmXlRNjoZU+yOmZH9ym6PDW5KihxJe58psxA1avLsA/t/Tig64JeMKIQVLqoEcG
         RLSBg7yoG0SrVMS8Co2oi7R9KMI7G9pugzUMsJZyZmWwIELPB7Wm70mKxQ0Kwf7fsVsG
         /a4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WZD92bC94EW74qAOQ3Z36r/IRQfP57Jy4rUjTn/RCs4=;
        b=Otv2KmzfZ4Z7UG9p1Dbg6NNkCBzx7K8dZbKUyoxTOlnhTfXuCnnUL8G2oAJm/rf+iH
         GG+Ywe9KfN+YeOVLrHNbGIg6v7uTmw8WoF7wCQdBXWXyG/tld9Kb3JKYwOq+GNPvLHB5
         bMfDT0CdFdhv5Y+7lCIrqxwNX6eXjX9kUC83Xo6inCbKShuOoE7SswfotS8GkDwP8y/r
         3arBos65/EE/gtFpXL46mA0ttgh9KYhFu8lzHq5wD/FtsRhMLkh/jKveinDAYPRLBBD7
         jQ0jG4RCIcN7U1SkykfJ4YRtgFae5/QZpbjS5gHyH73SGBmPJGGFCdL9r6DWrlL5MK2o
         U7JA==
X-Gm-Message-State: AOAM532dC3sBhcYPLuQWz+YdCNHmjk1QKkiC5Zn+4A8PXobnzTeDW8im
        NPqA5K/6o+laDORAK42l8t82Ntj+A5RgNREE
X-Google-Smtp-Source: ABdhPJxCTf88lS9zY6m/NhbC5lkGhchtcCZhoAxC5uEVLiE9vfC1QEL78gcqKflabKhoNRTNnvAP0A==
X-Received: by 2002:a17:90b:2281:: with SMTP id kx1mr1971341pjb.60.1643090292464;
        Mon, 24 Jan 2022 21:58:12 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q9sm18066967pfj.113.2022.01.24.21.58.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 21:58:12 -0800 (PST)
Message-ID: <61ef9174.1c69fb81.df5ef.15a0@mx.google.com>
Date:   Mon, 24 Jan 2022 21:58:12 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.297-157-g670a9111c52f
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 111 runs,
 1 regressions (v4.9.297-157-g670a9111c52f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 111 runs, 1 regressions (v4.9.297-157-g670a91=
11c52f)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.297-157-g670a9111c52f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.297-157-g670a9111c52f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      670a9111c52f269745f0d50141c89d61df3bae8a =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61ef58553cd05130d2abbd1d

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.297-1=
57-g670a9111c52f/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.297-1=
57-g670a9111c52f/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61ef58553cd0513=
0d2abbd23
        failing since 0 day (last pass: v4.9.297-124-g1de5c6722df5, first f=
ail: v4.9.297-150-g86d4516a7d68)
        2 lines

    2022-01-25T01:54:09.111994  [   20.442443] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-25T01:54:09.162615  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/123
    2022-01-25T01:54:09.171985  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
