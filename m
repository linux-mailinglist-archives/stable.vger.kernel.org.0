Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBC9A444AA5
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 23:08:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbhKCWLX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 18:11:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbhKCWLX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Nov 2021 18:11:23 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17830C061714
        for <stable@vger.kernel.org>; Wed,  3 Nov 2021 15:08:46 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id f5so3568482pgc.12
        for <stable@vger.kernel.org>; Wed, 03 Nov 2021 15:08:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=OhkQrSSDovrV66l+9Kri36WvH9QwP84L+0k/tb8oFx8=;
        b=D3hajbLS8EryySGhVhOu2YgCQwdgcKnB1p1Bjsgc2VKaHbKvG0p1fomZ3cAfzFp5X8
         i4iNgNEBoBp4ciFJMM0RuVARGcNuoSj/YNsS3dixLcUbNa1q71E9cUBKpRYDwymzevAm
         d3vsiGz9++Bw1SSmYkn+UhMiAZ2K1pfAkKpWwYh8ieg+zHd9n1JU1H6TrE3d9yLKo5sd
         HPzml8ceGK3qXBhQWmGIcG0GWuc3rmLdpaO/2V4B0AUwHw476y/y6UmZeKRg6fuhqd3w
         lT5DQkqV4TJ1zTkiWB6MnVd0IUVmYEW10VxNP7iJszDtAT+VtDK5r2jUEHkuLQFzXM8b
         8B7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=OhkQrSSDovrV66l+9Kri36WvH9QwP84L+0k/tb8oFx8=;
        b=upJP/rR4Cl80uWeAzLQhCowKZ/qY2nypQg1KnfHoncbWXNIqFpLCsYRC1967A50/2G
         10QN8pCTDFWbt66SyundtaGey9QHCbb2sarXmyDVoW0acv+7iSu/q8Wij8uhSmEYDxdN
         M9fdnqa86ncYXR+kMiSFG1QOtdHsm+dWT/LtZWcvai11pie80ODPeYXyGMkNF7cKlW0m
         MfBrFZmfF0YOktGjw4gIZByMXuiRJU/vfeJVVfp9ywFqJSxnX9Tm+Ap30WASUEaDOavJ
         WH4euZT/pzoFwZH7Wa3KwXJpITYLiLgln6ZwSDK60mA24+6sagPF5wgS/1QFByrHaJnn
         m2CQ==
X-Gm-Message-State: AOAM533tibbFhIhgj7Z5Tkw3vq1BmRlPVcqGEWVu/EuRSZvnTjTsbB9/
        80KQEqDC46Byl9ywig+ZcFMH6eiK7hNfsF0+
X-Google-Smtp-Source: ABdhPJw4bWKj1sGrRi89DxYwqXJMgRm3uGgdoVMJEQ9JJCYBRX4i7NimjukA4hv9wnxLqYQeCBCV5Q==
X-Received: by 2002:aa7:8059:0:b0:47e:5de6:5bc7 with SMTP id y25-20020aa78059000000b0047e5de65bc7mr43949380pfm.78.1635977325299;
        Wed, 03 Nov 2021 15:08:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c4sm3579278pfl.53.2021.11.03.15.08.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 15:08:45 -0700 (PDT)
Message-ID: <6183086d.1c69fb81.be882.bb9e@mx.google.com>
Date:   Wed, 03 Nov 2021 15:08:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.289-1-g5a84ac4fcc6e
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 115 runs,
 1 regressions (v4.9.289-1-g5a84ac4fcc6e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 115 runs, 1 regressions (v4.9.289-1-g5a84ac4f=
cc6e)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.289-1-g5a84ac4fcc6e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.289-1-g5a84ac4fcc6e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5a84ac4fcc6ee8ab65f04812a3b07543b4c834b7 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6182d55031b99ddae33358e9

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.289-1=
-g5a84ac4fcc6e/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.289-1=
-g5a84ac4fcc6e/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6182d55031b99dd=
ae33358ec
        failing since 2 days (last pass: v4.9.288-20-g1a0db32ed119, first f=
ail: v4.9.288-20-g7720b834ad25)
        2 lines

    2021-11-03T18:30:19.822082  [   20.192230] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-03T18:30:19.864709  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/121
    2021-11-03T18:30:19.874058  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-11-03T18:30:19.890989  [   20.260803] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
