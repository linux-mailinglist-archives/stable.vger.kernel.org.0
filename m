Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E72563182AF
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 01:40:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbhBKAk1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 19:40:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbhBKAk1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Feb 2021 19:40:27 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28975C06174A
        for <stable@vger.kernel.org>; Wed, 10 Feb 2021 16:39:47 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id s15so2227833plr.9
        for <stable@vger.kernel.org>; Wed, 10 Feb 2021 16:39:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=uRy5B4JpCR46FeM+9np/TBQhKn4GOftMeU83Z3wenmg=;
        b=MuF9tstiv5TJkCtGIc8fAEjGLSB8xwERHVbDRsFh8P6873J2yI+Z8qrBNd/YAY9ouc
         ZsL8hOVK68u6gvFhl923bRGxOwO0QIb/z9K9I6ROnmsbkamHqIBpm8urlVd9yyVkvO0f
         GbW86UVD6mF6IhcrvwjQAJJbowBh4gUG4NRw8nl0FeBPuvtDlymzb6hmpvKhOGVfynpM
         b13EZYaECe+gwa0PO8BNlxwt9AvGeyxre7FfIINYAgl1Rphj3/5PLprVPx0JOkA76kXq
         J9oWH9ZxOvNkljyizQRzEPor88Y7ekumzwL0p4ilqiqKujz4q+oES72aNyxttC7zEHDY
         rcJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=uRy5B4JpCR46FeM+9np/TBQhKn4GOftMeU83Z3wenmg=;
        b=grVKZ6FqiZbZzVlUmeNdd6vDiQt//+n5LJC1WpwK0u30XratP5Th+oq1dkVi54XVZO
         yJe2LV2pPuodPq5M5FJacOtmdaPyklAMZxDs3mWMPZFmFD3ZH/FO7eDLEA97cFwcTDuK
         l3GhT9Bw2y9Mcwzp0eSHiZ1qgTMu4/twDXzEVtULcDZJVvHnl7r6rORquB7U/kS9yxWw
         BbMOWECLc4++VgSPeoYMwuiX1gzH9FQmJ/268Pkev1ci+Xyts+u6BoUaPOWtuOpPI7f2
         B7qiko+2j6x/vBaqUCByak6gvhTJIjcF/luEPA5UUD0Zm71vQxpRm7KVpS7kISD00VJX
         RbQA==
X-Gm-Message-State: AOAM533Lr4PWXluh0+G6izAzZwMh+MkFgKZMV/b49cQb3tPI8vRphMYB
        mCnrZ5V3sd/DqRa3Zw/ttXedrTz/aGjVrg==
X-Google-Smtp-Source: ABdhPJy/6natHTiLtpIMWC+LDPwItPvxT/sc4cvifQX/7SPmvSJoDZRjNqgH/IZkzHD2V7cZY08cvw==
X-Received: by 2002:a17:90a:f182:: with SMTP id bv2mr1525148pjb.47.1613003984536;
        Wed, 10 Feb 2021 16:39:44 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m5sm3399269pgj.11.2021.02.10.16.39.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 16:39:43 -0800 (PST)
Message-ID: <60247ccf.1c69fb81.d21eb.81c6@mx.google.com>
Date:   Wed, 10 Feb 2021 16:39:43 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.175-18-gfec73bfa6244
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 76 runs,
 1 regressions (v4.19.175-18-gfec73bfa6244)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 76 runs, 1 regressions (v4.19.175-18-gfec73b=
fa6244)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.175-18-gfec73bfa6244/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.175-18-gfec73bfa6244
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fec73bfa6244151568edfb918b648616f0febda6 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/60244aa6ace6418c513abe67

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.175=
-18-gfec73bfa6244/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.175=
-18-gfec73bfa6244/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60244aa6ace6418=
c513abe6e
        failing since 2 days (last pass: v4.19.174-3-g9df30fc2980a, first f=
ail: v4.19.174-9-g72c4313237ab0)
        2 lines

    2021-02-10 21:05:37.894000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-02-10 21:05:37.912000+00:00  <8>[   22.919067] <LAVA_SIGNAL_TESTCA=
SE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
