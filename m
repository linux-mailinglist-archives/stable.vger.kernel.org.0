Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 750E82A90E4
	for <lists+stable@lfdr.de>; Fri,  6 Nov 2020 09:02:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726543AbgKFICG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Nov 2020 03:02:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726419AbgKFICG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Nov 2020 03:02:06 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07A05C0613CF
        for <stable@vger.kernel.org>; Fri,  6 Nov 2020 00:02:05 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id 10so590800pfp.5
        for <stable@vger.kernel.org>; Fri, 06 Nov 2020 00:02:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JScKkUSi6OZ1lWCcCPYIAnWqSbwJfyQ1W07i5d0dRLw=;
        b=wnY5ZpvbTRnxD+BXc9H1i0ia9UZjSyWSj4E/1Iu3HdseOaXK+AMdq1vEAmVW1p29qV
         K+6Ir/w2pKmBSUFJMqVvi5JhvIago7RqguwW/1d+1+t0rwuMawUg6Us2nr8ddErE+VsY
         eLx1RiY7oNxDfGW7mMCwWhyVykMACI12OC+Pg4BzjWVgQIaQadWsn/YGMVHP6qq0GsFY
         DPViW2RCX6N57KTELy7+lWbQGqA606wcxF/hNnICctujDWJecREiP6UDUG5hpaJiy8+5
         jjuaBhSEnhC4CfudNifi8WHkjARMY/SlRHABu8aB8DOqXmoOPOcHgBjmJWNCOPlQr1Xm
         6T5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JScKkUSi6OZ1lWCcCPYIAnWqSbwJfyQ1W07i5d0dRLw=;
        b=cBzAAgag/4O2mhBqwHZ/s7q/x1+xlyxLwF9lBenN0gPdRbUk/fBrG+Ua45qmYsOzi3
         xY+Gp0BPDrHe2KE4pwizLfLvg/OnVvmx5uEU86IN2RYK87hGCUUxvTFQkiqkBhJDr59z
         /Q6yycOf0Q7U4qhlPMp7add7wkWSywyQD65qpVmuUC4npe58C0iqeH4YSXUYfDT08i2i
         l4OeROZvJBIGHhi+cMO9ZhtGMs1aekghYZCvZftC/6cbOCvfif1GUG/NapjH+/NXbeUJ
         VGj8UNsLwapwLFAWmSiqtjgFm/3e92m5kgSsrjIVxWX9K+Z87V9BD1VnT8MErI6SzLsX
         s50Q==
X-Gm-Message-State: AOAM530P1wS2ZJSAg2Jp+o4iAIfPjyRH6R84TSRO/DNFkLYHyzxT6Ytg
        6y2WGKG2FP1pxkitvQsniVjxNTBWjsLqTA==
X-Google-Smtp-Source: ABdhPJxwLV1/Sc5dJsmYXHGQtpoK/rtE5O5c/0giFq3BjAy4sagEJTGpvN3A5JVx3gnBPJppWSOB0A==
X-Received: by 2002:a17:90a:f3d1:: with SMTP id ha17mr1265504pjb.164.1604649724352;
        Fri, 06 Nov 2020 00:02:04 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 38sm745523pgx.43.2020.11.06.00.02.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2020 00:02:03 -0800 (PST)
Message-ID: <5fa502fb.1c69fb81.1a608.136d@mx.google.com>
Date:   Fri, 06 Nov 2020 00:02:03 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.155-1-g2163cd4d4b588
Subject: stable-rc/queue/4.19 baseline: 179 runs,
 1 regressions (v4.19.155-1-g2163cd4d4b588)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 179 runs, 1 regressions (v4.19.155-1-g2163cd=
4d4b588)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig      | regressions
----------+------+--------------+----------+----------------+------------
qemu_i386 | i386 | lab-baylibre | gcc-8    | i386_defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.155-1-g2163cd4d4b588/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.155-1-g2163cd4d4b588
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2163cd4d4b5885ded0d54bae506f96d6bda5c925 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig      | regressions
----------+------+--------------+----------+----------------+------------
qemu_i386 | i386 | lab-baylibre | gcc-8    | i386_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fa4c80ce92cc58a93db887b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.155=
-1-g2163cd4d4b588/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.155=
-1-g2163cd4d4b588/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa4c80ce92cc58a93db8=
87c
        new failure (last pass: v4.19.155-1-g14d558cc8860) =

 =20
