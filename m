Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 952B0468CD5
	for <lists+stable@lfdr.de>; Sun,  5 Dec 2021 19:35:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235229AbhLESjO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Dec 2021 13:39:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232377AbhLESjO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Dec 2021 13:39:14 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 378D8C061714
        for <stable@vger.kernel.org>; Sun,  5 Dec 2021 10:35:47 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id k4so5622736plx.8
        for <stable@vger.kernel.org>; Sun, 05 Dec 2021 10:35:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IeFzCmkSjatDUZPAxGLl4+/20LqMxvNCs4O6EOemKQs=;
        b=XvZAT73HJTLsyJOAXETyrbNaEPL6hJc+Zge6rSw4U+W+dlGHZ9p7lhDHfx1/BiKENL
         v3+KExF3I1CRgffnvaj0OOLiw7esiC10p8Y9VdFGYVFCgUsWu9OLwTKLW5PumLH5x7u/
         sLDceLh7Va/l07Pi8fADtGMneQVuZh5qZvEEykXpjETZivhftTJ6nINr8INjwl50S21o
         dp8onLtMgC0Woru8GFVQettk69lx5YoNFdU8oucItqfumjuA5QV93pPJzko5j3zDtUGw
         6tIdgb+KsC5ynOYPhbmwyUqmjDL1RF/mLafUq8UtbN9VnLJIRbxUllKaG/7Jz+3L+Dqx
         nMoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IeFzCmkSjatDUZPAxGLl4+/20LqMxvNCs4O6EOemKQs=;
        b=LR6emJ17rax1nFyLbMKpNzWQpT/UZ67yRbNMzHdmCnQaJjwEN3znH02r7dlaCtZ5Hg
         5L2/8dww4C8j/YtktJKyuJqnsedYxvS7VUdknSCNiT33Tn08YfeF5mLwDX2Q1ucxhSdH
         QqOsXGwdY68f5IgRBwSkKbHdunOXJSULFdFXEhRiSBlTTFI+AAjNHuds1SBeFcrG47L1
         bx08zEZf4hVtBVSYQd6R+BOcpWHkpe+CnJCRG65dD787Qmmi0QdFHpMouiQpMfyu4rxd
         LEduCNBNZb7/8v4ru0IZQfmiy2kKEoaBUBvSTFyPzx+eguuykM5eKkwtx5arx7Da3Zum
         jOqw==
X-Gm-Message-State: AOAM533eXE2atSJi4cEivAghkNTMdQ1i4SoFZifsVQQJGPJcfNxFF1th
        5HfwINvvbudz2QUChKBC5HMc61NIjLQVuTVJ
X-Google-Smtp-Source: ABdhPJxoBpHNUGu2PQZGDEyTTgHnsPeyMrJrw3B+iepn44QrruKGwXI3+JLh0r0pqnCd8gOMrBvgQA==
X-Received: by 2002:a17:902:eec5:b0:143:982a:85c with SMTP id h5-20020a170902eec500b00143982a085cmr37980186plb.66.1638729346632;
        Sun, 05 Dec 2021 10:35:46 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w19sm7515862pjh.10.2021.12.05.10.35.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Dec 2021 10:35:46 -0800 (PST)
Message-ID: <61ad0682.1c69fb81.ca092.6770@mx.google.com>
Date:   Sun, 05 Dec 2021 10:35:46 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.219-29-g2fef2d4c5d510
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 145 runs,
 1 regressions (v4.19.219-29-g2fef2d4c5d510)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 145 runs, 1 regressions (v4.19.219-29-g2fef2=
d4c5d510)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.219-29-g2fef2d4c5d510/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.219-29-g2fef2d4c5d510
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2fef2d4c5d510fa12f300e70095806f3f924d75a =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61accdb1f5f67d82a11a9493

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.219=
-29-g2fef2d4c5d510/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.219=
-29-g2fef2d4c5d510/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61accdb1f5f67d8=
2a11a9496
        failing since 2 days (last pass: v4.19.219-3-g91f80b6b7a49a, first =
fail: v4.19.219-3-g04afdf3600b5e)
        2 lines

    2021-12-05T14:33:00.795683  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/100
    2021-12-05T14:33:00.805098  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
