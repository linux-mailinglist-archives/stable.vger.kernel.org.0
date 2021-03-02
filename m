Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4F232AECA
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235832AbhCCAF4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:05:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347775AbhCBF7H (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 00:59:07 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AABF9C061756
        for <stable@vger.kernel.org>; Mon,  1 Mar 2021 21:58:26 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id e9so11386114plh.3
        for <stable@vger.kernel.org>; Mon, 01 Mar 2021 21:58:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8vsyxD20RnFkUdzPfUA1c3Cl6RFyT7FbCfS4ggxJiNE=;
        b=qm5odc6M6Pd3mr/+bEnQfSEYkH+GerA/K15Jn9QO8LMkS6Zz3NDGeKUHTajut3quKh
         eTrmoqmCdIWw6yum9met4eW/Cqnen2W8EX2lWjruCfMkn44VLHlyCN9vXRgSK2Lk7V1c
         +TfQ0MA1ztusSECxUhvp5WIuFeGlTzkt2ioUBloNORcwyd0JWSNWwHTx9ExnpJ7ML/H0
         lNUR3C2BZdVXeFnSoXPU2BiH5gaQ6l98qdaHODt9mntU6GK0Jh0g7NhwLHAzWCqsrCZ1
         wtn9mZ3Wf0amcAohvoBFaAOm05c+4Q+eWw3c1wT/dTxFE0KeTPQTOP1vW+k8iP1c0VhF
         ksCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8vsyxD20RnFkUdzPfUA1c3Cl6RFyT7FbCfS4ggxJiNE=;
        b=dq0i8vGhx1BiJ+aQBpZ9n0UHsriFMQpyfRGvItpaPddc0bLn/FnsP24K3+Z2HYA+YJ
         CuzPxRrmyhWRS8o5EHmuKhBfoo1z6vknz95/Bd+c5N5BufghOGkhzhCDWHxOSqi5Floa
         WLzOjev4gTSBBMOhNbnplXX9/0FYcSvAz6ZmomsKQzvcdTTIdD9CZlTQ6W+g8gA3TleP
         SrcouvuOLqTQPM42bAI5cDcl+9m4GVOw23bzlwII+S2G6II7v+tZ9ImHCP1XJvk3DT0B
         g950BK1y07xr17nD8xuwHGoXvKTVLW+pkQ7PGbcRvCB+awTJ7HdovUGJTwBOiu5H9qOs
         8q8w==
X-Gm-Message-State: AOAM5302JDr0yL+HEe9O+DX1JonLT/brUK2d/LQSC7IpJ+RciPz5p6sp
        gVqmmFXX4TG2SXAB++qIX9+5VWFRQ3zujg==
X-Google-Smtp-Source: ABdhPJw99MF1hVgfXlCTt1LBeJ4juEI1m1Gv/Efhn1SE1ZDy14VH+WdNEDHV9e3EsFWMDR8Bl2xT9g==
X-Received: by 2002:a17:90b:1649:: with SMTP id il9mr2597267pjb.62.1614664706043;
        Mon, 01 Mar 2021 21:58:26 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y4sm5285704pgq.32.2021.03.01.21.58.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 21:58:25 -0800 (PST)
Message-ID: <603dd401.1c69fb81.dd61d.ca9b@mx.google.com>
Date:   Mon, 01 Mar 2021 21:58:25 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.258-134-g2d3a1aa101bd1
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 64 runs,
 1 regressions (v4.9.258-134-g2d3a1aa101bd1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 64 runs, 1 regressions (v4.9.258-134-g2d3a1aa=
101bd1)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.258-134-g2d3a1aa101bd1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.258-134-g2d3a1aa101bd1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2d3a1aa101bd17b0d366f3b58e5bd3d27683d8ca =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/603da266e651a6e797addcbb

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.258-1=
34-g2d3a1aa101bd1/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.258-1=
34-g2d3a1aa101bd1/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/603da266e651a6e=
797addcc0
        failing since 0 day (last pass: v4.9.258-12-g80c6cbdf1f84, first fa=
il: v4.9.258-88-g9173936eb9805)
        2 lines

    2021-03-02 02:26:42.570000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-03-02 02:26:42.586000+00:00  [   20.678436] <LAVA_SIGNAL_TESTCASE =
TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
