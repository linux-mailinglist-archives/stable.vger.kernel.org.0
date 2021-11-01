Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5CC5442393
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 23:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232296AbhKAWuJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 18:50:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231701AbhKAWuI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Nov 2021 18:50:08 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21082C061714
        for <stable@vger.kernel.org>; Mon,  1 Nov 2021 15:47:35 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id g11so6359722pfv.7
        for <stable@vger.kernel.org>; Mon, 01 Nov 2021 15:47:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=geqHnwOD4Fc4wYQDvuNC+lUSRUINGLuGxhLtHmhHBss=;
        b=NJJBEFwz4/L2HE67PQun6GaPpKGmM6P0luBQ701Wq4YQQp/sOjByx4v/vjQszYDZnV
         /1E/kNJidJ73GLL5odjTbeOR+ozitKLdC5XIi/tzV716zLh+ZlSquPPuMgkRI3J/qHyI
         u4zsb428jgYLIvV8Jkvtrmzh14Vu6h6E24iM3rNM0e4d6r8Zp4dItKssuNKfD/ABdl+0
         k8vpwK/nccPHbcCKecJSADTptkq+MtmtT16hPC/SyRXqbVwgUhWaCnAcxrJurx9uzKIf
         jQp7fMnIqH39/XsJr3gPe+Q2N48vTP3MoIUR+t9mf8///DYRyDnNIo03HYQXq31485jq
         DtMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=geqHnwOD4Fc4wYQDvuNC+lUSRUINGLuGxhLtHmhHBss=;
        b=g42MiKQJ1oAgDX4V+nYt97xbVew0+r7YTo6y5mki3zecdbCIsm0/x45ETnVZQVDpcd
         xsuxlWs4A+QPDP7IZRM4Ij9Yt4P6slYTy5xD0GoxDWB7LeywNvhfYDULOkGjIgrs8K+v
         r+IFrFiRRYEnASb0FG+4Owfmtk8X4nIU4H/qExZ/Wplozy4WD8WWtTQjB2xZQkk3QPOI
         /FXmp0Bpx0XVDcGsETHm71jKLwucTf2T0qJV8IqR4lRE+Xe2GCqOpaYh+qLu9DKeV0am
         pRpLEJWVs3ZTrlCI8hhgUsh/kn4fFF+4FPSNCCrHTsQefi8WzpJwmy2b+qlbR0zZ+QBH
         xL3g==
X-Gm-Message-State: AOAM532hVpaY6YCmC+uq3ah0ZU5qHcnTTs0ejiAWTtWaDs/1Vi1rZucl
        Qic78jn6jzovNgS65RBnQubFkGj2HGtLoRhj
X-Google-Smtp-Source: ABdhPJw9sM2aSTGbCHxXLO0etav4dCniWbcRU31iiP6K9eO0vO/ew9YxgHI+uCrg7fN/hVnTdPQ78w==
X-Received: by 2002:a63:7749:: with SMTP id s70mr10903499pgc.143.1635806854536;
        Mon, 01 Nov 2021 15:47:34 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k5sm18169988pfc.111.2021.11.01.15.47.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 15:47:34 -0700 (PDT)
Message-ID: <61806e86.1c69fb81.31e08.19fe@mx.google.com>
Date:   Mon, 01 Nov 2021 15:47:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.253-25-g1f0d67fb71eb
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 115 runs,
 1 regressions (v4.14.253-25-g1f0d67fb71eb)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 115 runs, 1 regressions (v4.14.253-25-g1f0d6=
7fb71eb)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.253-25-g1f0d67fb71eb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.253-25-g1f0d67fb71eb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1f0d67fb71ebd101b83db975f3dd098f8bda5103 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61803a0aeee660572133591f

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.253=
-25-g1f0d67fb71eb/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.253=
-25-g1f0d67fb71eb/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61803a0aeee6605=
721335922
        new failure (last pass: v4.14.253-25-gdab8da72f4d9)
        2 lines

    2021-11-01T19:03:21.432720  [   19.971679] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-01T19:03:21.476500  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, swapper/0/0
    2021-11-01T19:03:21.486092  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
