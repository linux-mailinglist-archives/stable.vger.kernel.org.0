Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48C9F470685
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 17:58:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240768AbhLJRBg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 12:01:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240761AbhLJRBf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 12:01:35 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7090C061746
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 08:58:00 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id 132so717170pgd.1
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 08:58:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ahEVsvBaXSchz/e0dxiaE9IkmmOY1rMniDSmoh2qruw=;
        b=oq99mRUjS3/Ck0vwSPNBmfMMjxmt6BztX3c2ePiMJjglzbOCnthCcKr8d4lPKjcmxC
         IH7DElVZ/+RsavWh6yjyIDLYHzsuVFS6lCj78uMMffOr33PUPDrwJwR87P9ag1E1Xt9r
         DjI5nIJNzPhrUzBMYxiPrYe0cOMqnYrsqSlax/z0s90aakacUc/KyVJ2krOfrKDQpOqr
         6jicN/ToFXhOPSYxVmidZHJQ1UBqY4SxBPALbtaHfyrsYQ25htLV8TAR7wls3d6sqqtG
         +iKMKPuc/SdRXT/cu2DjY67qdOBVRrQbLb8k8OkTW4xHD2+T3A5p8DqqHMk5JDZMPyse
         bALw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ahEVsvBaXSchz/e0dxiaE9IkmmOY1rMniDSmoh2qruw=;
        b=zDyTB4EbIYBytHXPhDzBTQm8uinGJQIxnMHPft7TxAWarv9FGCZg8aOSf/2CWcGtTe
         GgWNra7pvSvZZGZfk4168L8sYbWIfWavM/sMGUFIxLFZLj8Q45873O+J8KQPHVIJuZiW
         KlOtBJX4BRrYvCbDsAXvRS7id50ASlSgTco20AdujdBUgaLUySfiVa57+0HIjc9brv3x
         zG+Mk1QOiuYUQJ+JH8yNkR8JB1km3y0Z2gjTdKoIhmf6OdcttAXXQdE7xo7ihyEn6JJi
         vakyUhZkQt8eQS63pdSJ96CDql2O1ixcT6o8x/Zx4hNbOObPBr/ygJuYjy576x09X92e
         mXzA==
X-Gm-Message-State: AOAM530yvqB1cLhU3Pv/S6EB4QHwGPxquDri8//p5QdRO+ftsKuiq3zS
        x01Nn5cMzmOjHs6IAZhhG4ACmdpLUtY2AZVV
X-Google-Smtp-Source: ABdhPJzDoWQ6wqjwirV8qipldHDCY8aU8bR+cNh8i9CV2jqe+Yoqf+O9sA3qDxIEHaQ87g9NfXZ6TA==
X-Received: by 2002:a63:d854:: with SMTP id k20mr39581995pgj.574.1639155480136;
        Fri, 10 Dec 2021 08:58:00 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id mv22sm3243675pjb.36.2021.12.10.08.57.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 08:57:59 -0800 (PST)
Message-ID: <61b38717.1c69fb81.77657.957e@mx.google.com>
Date:   Fri, 10 Dec 2021 08:57:59 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.257
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y baseline: 148 runs, 1 regressions (v4.14.257)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 148 runs, 1 regressions (v4.14.257)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.257/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.257
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c01d4d1b885d96a7c8c27d629abeb918ca897dbe =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61b34c948af3ef318a397135

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
57/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
57/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61b34c948af3ef3=
18a397138
        failing since 14 days (last pass: v4.14.255-251-gf86517f95e30b, fir=
st fail: v4.14.255-249-g84f842ef3cc1)
        2 lines

    2021-12-10T12:47:59.249493  [   20.105041] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-10T12:47:59.295256  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/95
    2021-12-10T12:47:59.305262  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
