Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01E1C460EAC
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 07:09:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239218AbhK2GMl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 01:12:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233561AbhK2GKl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 01:10:41 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40114C061574
        for <stable@vger.kernel.org>; Sun, 28 Nov 2021 22:07:24 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id fv9-20020a17090b0e8900b001a6a5ab1392so13245948pjb.1
        for <stable@vger.kernel.org>; Sun, 28 Nov 2021 22:07:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=en3vZhHeBRNy4FGoveTZgPdGo/PoeUAiBhqRUy5bbxk=;
        b=poDULw4YmhEDg3aJKZNA2ccnY1qWkY7syVEtwd52Bh3HAx1Sd8moj1vyJd/b1eqW9A
         mmJAl0UTFlEocJgmtqZEKII2c174LlduuB1aWBJpWLmX43vLhnDtODV4gmJEki1UrvJg
         2IBsoxdojzX4yg6vlRd1vyOtywRdepylzwQwyj2bUrwUgpvdZ8p9pvtnksoafop4s0lD
         IFjeNCYHvYy7LbWHlu0IzIK4SANNddn78cR62GetaGcF07sNmsk3+e3IHxxmRbOoOQ//
         Ld3WYp7ZPAuJfCge+ZFlV5m1ZVd/TDnI8FL3wiLYzNbuAyLk9iGv7qiVZkeoffAVb4UP
         S/Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=en3vZhHeBRNy4FGoveTZgPdGo/PoeUAiBhqRUy5bbxk=;
        b=KuRHZKiftEOcr+ZcI2zkUD7Lv5eKSUTYWL83QVCG/TLn2CFjlb9YQNWu0K+ay6xU9r
         iB3ewbGlHb263um/gYOeaEzPzOfcRTJGM/CHClj4J6uLvc2vpZ5jicBVJ9ZTO9p6yvVu
         5ItvIQNV21wjHO9g/EM0xD776j8r/dMLptWtg0djpJsmcGdA78nu3NnOB4L3BgbVQ4gZ
         E3BAqXbv8wsR5N94jEfwMCA2+QEa9ghyJq1Kw33fccu8+fe+69W1QyCR7XDJfsnIMs89
         zQOSSQGSqaqHmW75Al0V8MEdGiFfIGWdnAehr9d2zDv5V7QmLkNQEmONA4UnMUviOg5Y
         glSw==
X-Gm-Message-State: AOAM531bD261V0rf9PxOK/ocOkbloL1zeGYs0qqrlb/38RmilDu8+dYp
        YQK8oO4vuvOVBQp7x9a9XK3psJQK9MxUPGtf
X-Google-Smtp-Source: ABdhPJxZlLw9RH0OdU7Glb56nvIDHOEJnTDuB62/FVpSRM2Tft/mb9g3RR2hBPDUQGx/YutApINWTQ==
X-Received: by 2002:a17:90a:1bc5:: with SMTP id r5mr35992427pjr.90.1638166043629;
        Sun, 28 Nov 2021 22:07:23 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id lw1sm17953215pjb.38.2021.11.28.22.07.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Nov 2021 22:07:23 -0800 (PST)
Message-ID: <61a46e1b.1c69fb81.408d5.e347@mx.google.com>
Date:   Sun, 28 Nov 2021 22:07:23 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.293-17-g9e5bba8753862
Subject: stable-rc/queue/4.4 baseline: 109 runs,
 1 regressions (v4.4.293-17-g9e5bba8753862)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 109 runs, 1 regressions (v4.4.293-17-g9e5bba8=
753862)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.293-17-g9e5bba8753862/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.293-17-g9e5bba8753862
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9e5bba8753862639365c238be018d3f6bd60b07f =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61a433dc0d6c82c59018f6ef

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.293-1=
7-g9e5bba8753862/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.293-1=
7-g9e5bba8753862/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61a433dc0d6c82c=
59018f6f5
        failing since 3 days (last pass: v4.4.292-160-geb7fba21283a, first =
fail: v4.4.292-160-g4d766382518e6)
        2 lines

    2021-11-29T01:58:33.460631  [   19.209625] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-29T01:58:33.511530  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/121
    2021-11-29T01:58:33.520822  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
