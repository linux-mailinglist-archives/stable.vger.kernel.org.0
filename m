Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 447B54627B8
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 00:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233572AbhK2XJS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 18:09:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236782AbhK2XId (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 18:08:33 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4730C08EA4D
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 11:40:16 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id nh10-20020a17090b364a00b001a69adad5ebso15148563pjb.2
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 11:40:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=k08JwS6RomgX7xo7L5Gk96mpGTjCApGiHB/epck55LM=;
        b=ZgP91efLW1MRkClezUZEkx5Keld5Ilm+ZCf+To3a2fRcWe862yKQQgS+sqG8dV+CYy
         PLJ02FEM4L2Ym2TCdYwxWgBHz/9SkWiyn5IWl/mw/0jaebtP7OT3Vvqtd154Fgx3nJsS
         +lbyCnM6LBt/js+PbgnOW7WlpzfE8nVsex4CG67I0l23HmbU1+YoX5grEyPRHv6Bezir
         iF4OKA8WSrd3+Y7ZfFBLSZvoPFbE6mtk0OnVfnjOKllZO9TIBqzoETfGSZg63aKijkGJ
         cJjBvsPdGA0PVRoI18N/dU8Dj2LSu+ACrjgqrdEWtZH5yGROvdud0xrZxBf+iNIQ6OeC
         jFRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=k08JwS6RomgX7xo7L5Gk96mpGTjCApGiHB/epck55LM=;
        b=DyhhlyB4bhml/yq091zr6g/ImQ4AQSRnsonJ574zWQ6ATuagyR8EENzCySQVrJeulW
         hl+sjDghc4htKeGhw3i0QzgBAsEOEwE1JjOuqGsP5Iky1dgc51Zf1SbrGLUK5VyYkQY0
         62i3f0DWgmO6Kus3qlUVuu5o+5nYtyi3Ct7Mob1VkJG4yIvVXaox7kBFi2WpegxZfFft
         LB97bfKj3UYrdcm6qFN7fCpJ7IDjwvqH+q5VMY1cS77SHpWmNHySbBHFV8i/Uj4K8bEr
         LsmzRHWJKLSdSoADZZkOImVvumE+pvNHR9h8wyBmDRexth77+hgf+i0dHcO3tHUVJ0EJ
         MLQA==
X-Gm-Message-State: AOAM532s2b1aeZH4bC8UFU4UF2iiybAzwlqVmDr81L8FFqbT1AUGS/Zy
        CX0SZoH14JJiqU0ML3PnSBpf3yKedFxli/1Y
X-Google-Smtp-Source: ABdhPJxyOhE/m3rcjUHc+kFPMu1x4Z0FCmcVexp57ZYXE/E06JosN2NtFTObriz1I51+fTp3r5r8uw==
X-Received: by 2002:a17:902:e781:b0:143:d589:1d0b with SMTP id cp1-20020a170902e78100b00143d5891d0bmr61790239plb.31.1638214816102;
        Mon, 29 Nov 2021 11:40:16 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u30sm12572096pgo.60.2021.11.29.11.40.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 11:40:15 -0800 (PST)
Message-ID: <61a52c9f.1c69fb81.6e063.2468@mx.google.com>
Date:   Mon, 29 Nov 2021 11:40:15 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.256-58-gc48ae6ddf3bc2
Subject: stable-rc/queue/4.14 baseline: 115 runs,
 1 regressions (v4.14.256-58-gc48ae6ddf3bc2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 115 runs, 1 regressions (v4.14.256-58-gc48ae=
6ddf3bc2)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.256-58-gc48ae6ddf3bc2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.256-58-gc48ae6ddf3bc2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c48ae6ddf3bc2fceb706ddb7e780d63f76e549d5 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61a4f6cff9bb6c91da18f766

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.256=
-58-gc48ae6ddf3bc2/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.256=
-58-gc48ae6ddf3bc2/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61a4f6cff9bb6c9=
1da18f76c
        failing since 0 day (last pass: v4.14.256-28-g54e5647834e42, first =
fail: v4.14.256-28-gb75fc63979563)
        2 lines

    2021-11-29T15:50:20.797894  [   19.986114] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-29T15:50:20.838883  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/103
    2021-11-29T15:50:20.848818  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
