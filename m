Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1308045CB77
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 18:53:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349945AbhKXR4m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 12:56:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350045AbhKXR4f (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 12:56:35 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E479C06174A
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 09:53:25 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id cq22-20020a17090af99600b001a9550a17a5so5677391pjb.2
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 09:53:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RdLBfw+EF/iD1K1ZApHQ6AfIs78+S6WGtxrQ1hMlVz0=;
        b=qKbeLm3YYxTuZJmior04gyWPSxdigra7PqyixMsyWXzQIHNAxAM74EraySFKGOTpt8
         kJg3tO/XLzg4cRT9ORj9ClwbT2D1OYOJYu7ITG1/oJs4iaehEk86IYtT4hX12/AoW3c/
         7yn54g86qgi+xvAwgmQr6ub8v9Uxl+bZQ1a+k7+lvlPAKaSMlJVBIllQoAblh0zRavoL
         jofnbNGrH8RjrKv/5LzBvtyMEXGjsQhg7aJsINk+G01FQgi90Qc8zeH4fL5gz1MmAAO4
         2g0GhqrMqqTNlnBO3paAvZcP93Wk6OjKUr59idZqoj4CjEWHOT+eNWi/aNYW75SwvI1m
         1heA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RdLBfw+EF/iD1K1ZApHQ6AfIs78+S6WGtxrQ1hMlVz0=;
        b=J7Kluysxwn2aAaYcmfkNazA8LrRJc9+JO00fzNupXFgrs8G/7ib+ywIlAxMMFIB4EQ
         lEcYFRWnXOfU5my54zdL9ximEhAHSnll4jBMHZ3vzhaajC7n1ONgSqqErWjSqbQl4wx6
         0mG/+dHPjn6dSTMbfG7b84z5J9xkAQvboYDbNROH2HZB3Y9O+oUcgmYWDg8xZBF9KGZJ
         FTKbJK+IQmQyzctfW6pvn3YLR2AYpaB0uyG1km5HTWKWLXvJurr5Ko6jrM6yUdRboSRM
         wXrihVFZNkgnwwq6W59kMyyjaj59BIWXYq41fX6NAppFQhBwI1FyHVoist9vNnbtmP3j
         2frQ==
X-Gm-Message-State: AOAM533TaTGkc4uhXBBfwFTrl5ro6DNM4bfFvKxa/vFvXsP5rEwSPzi/
        oiO9LrWwBL7QcUQIbSje8e74xEcd4EMlNi95l64=
X-Google-Smtp-Source: ABdhPJy/wMIXRJZ3TWYBHXXMZ7LtSdyAdf3p2L8ZEf7OpC8NxD4gVjHUIiN1uMcmj+pZNUhkk8PMuA==
X-Received: by 2002:a17:903:22c4:b0:141:deda:a744 with SMTP id y4-20020a17090322c400b00141dedaa744mr20709149plg.25.1637776404683;
        Wed, 24 Nov 2021 09:53:24 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p128sm347028pfg.125.2021.11.24.09.53.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 09:53:24 -0800 (PST)
Message-ID: <619e7c14.1c69fb81.370e0.1292@mx.google.com>
Date:   Wed, 24 Nov 2021 09:53:24 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.290-208-gb2ae18f41670
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y baseline: 112 runs,
 2 regressions (v4.9.290-208-gb2ae18f41670)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 112 runs, 2 regressions (v4.9.290-208-gb2ae=
18f41670)

Regressions Summary
-------------------

platform         | arch   | lab           | compiler | defconfig           =
         | regressions
-----------------+--------+---------------+----------+---------------------=
---------+------------
panda            | arm    | lab-collabora | gcc-10   | omap2plus_defconfig =
         | 1          =

qemu_x86_64-uefi | x86_64 | lab-broonie   | gcc-10   | x86_64_defcon...6-ch=
romebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.290-208-gb2ae18f41670/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.290-208-gb2ae18f41670
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b2ae18f41670cfeb4c9800347ee78bcd9eb295e1 =



Test Regressions
---------------- =



platform         | arch   | lab           | compiler | defconfig           =
         | regressions
-----------------+--------+---------------+----------+---------------------=
---------+------------
panda            | arm    | lab-collabora | gcc-10   | omap2plus_defconfig =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/619e423d2794499fbbf2efac

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.290=
-208-gb2ae18f41670/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.290=
-208-gb2ae18f41670/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619e423d2794499=
fbbf2efaf
        failing since 11 days (last pass: v4.9.289-23-g6ecf94b5fd89, first =
fail: v4.9.290)
        2 lines

    2021-11-24T13:46:19.618417  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/123
    2021-11-24T13:46:19.627512  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform         | arch   | lab           | compiler | defconfig           =
         | regressions
-----------------+--------+---------------+----------+---------------------=
---------+------------
qemu_x86_64-uefi | x86_64 | lab-broonie   | gcc-10   | x86_64_defcon...6-ch=
romebook | 1          =


  Details:     https://kernelci.org/test/plan/id/619e42f36cad496c30f2efbe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.290=
-208-gb2ae18f41670/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-brooni=
e/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.290=
-208-gb2ae18f41670/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-brooni=
e/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/619e42f36cad496c30f2e=
fbf
        new failure (last pass: v4.9.290-205-gd6aa2271168c) =

 =20
