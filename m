Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23C4B2A87B4
	for <lists+stable@lfdr.de>; Thu,  5 Nov 2020 21:07:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbgKEUH0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 15:07:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726214AbgKEUHZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Nov 2020 15:07:25 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3E65C0613CF
        for <stable@vger.kernel.org>; Thu,  5 Nov 2020 12:07:25 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id z1so1305138plo.12
        for <stable@vger.kernel.org>; Thu, 05 Nov 2020 12:07:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ywPmJyJXl5IXCzmDS3TGajEqsk1j6eUfm1QEOarkOuw=;
        b=HdqpqVC9/zMA028NzAiI9Tn3BDdhgTVAdhejUnCY7hn5hCXd/eUed1TDCdU9fuhzre
         ZkZnx5wo5mHGdyZSiUkSKKOV9rl0/SLCfC9L8FDaqmPoMbB8skBb7fVr4qrijqchUa5+
         RrRImuEdsn+F/C0P6zqxPpcwIucfidb7Go2RnASkoO8/JDEE952sOg6LiIhDcdhUVuIW
         7AkJPOVuNsqJP2ZOT1hb/WWkYJNsYjn8krxunHnwrBZz5PC7tNpDWYdAtIApFsVfSgXz
         OBbp8tYF0DYICSx7elYMxV2lwJyxbFI7iy++TrQf5fVv+kH8Tynp5i+qI99IBH2BLdmk
         lZ1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ywPmJyJXl5IXCzmDS3TGajEqsk1j6eUfm1QEOarkOuw=;
        b=IIC8Vpt5QAI3eGi3ce6AZvwkf658Wd1yHenVpGwB89JcUf7SejBnwUGiqqrmhPXCyL
         i6vF2hWWeCj7Bl7e2J8Ypsb/HAfIcqrBgKT07oImerfRPn+tICJ7FuKT27JKJ/Y2xDb+
         Ao0QavarjJcV3fr46LoKr+Emc/x5PGnAqBR0kwa5mKnk5LAK/Qx2350loCFhNiszp8Xg
         7TzwJ0+G60g9C0wg6HFSjk5TrHEKcCPkoUEHcXZmV9vNjeQApwnk7L8SyNBDY5q0tVx+
         7OlDO5akSMW6kAoav2pSNZQbe5TLpQ9o+MAvchkdbvSfGRi+dHAOVlM7d6fqG2BOWk3I
         zhOg==
X-Gm-Message-State: AOAM531Xd3HquvOXGlfxSgVDEKz5riVfaCqDWexC90yG+XCcKdAmQHEj
        LmGeg0e9EcgM9OylHj138aPZfa9To/AzYw==
X-Google-Smtp-Source: ABdhPJzAgp9hjABBFQ/C8cKTrJ/P8axhQRYvV9bYexUSUjSI2xBt8iKgjmewptFBNStpRoC/LT7KtA==
X-Received: by 2002:a17:902:724b:b029:d5:a5e2:51c4 with SMTP id c11-20020a170902724bb02900d5a5e251c4mr3728693pll.80.1604606845080;
        Thu, 05 Nov 2020 12:07:25 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j184sm3969320pfg.207.2020.11.05.12.07.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 12:07:24 -0800 (PST)
Message-ID: <5fa45b7c.1c69fb81.d31e2.788e@mx.google.com>
Date:   Thu, 05 Nov 2020 12:07:24 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
X-Kernelci-Kernel: v4.9.241-91-g43a1fc0c8f46
Subject: stable-rc/queue/4.9 baseline: 150 runs,
 4 regressions (v4.9.241-91-g43a1fc0c8f46)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 150 runs, 4 regressions (v4.9.241-91-g43a1fc0=
c8f46)

Regressions Summary
-------------------

platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
at91-sama5d4_xplained | arm  | lab-baylibre  | gcc-8    | sama5_defconfig  =
   | 1          =

panda                 | arm  | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 1          =

qemu_i386             | i386 | lab-baylibre  | gcc-8    | i386_defconfig   =
   | 1          =

qemu_i386-uefi        | i386 | lab-baylibre  | gcc-8    | i386_defconfig   =
   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.241-91-g43a1fc0c8f46/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.241-91-g43a1fc0c8f46
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      43a1fc0c8f465c858ef6e98a89661164638b7311 =



Test Regressions
---------------- =



platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
at91-sama5d4_xplained | arm  | lab-baylibre  | gcc-8    | sama5_defconfig  =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fa4279fb87457f7b7db8880

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-9=
1-g43a1fc0c8f46/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d=
4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-9=
1-g43a1fc0c8f46/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d=
4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa4279fb87457f7b7db8=
881
        failing since 7 days (last pass: v4.9.240-139-gd719c4ad8056, first =
fail: v4.9.240-139-g65bd9a74252c) =

 =



platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
panda                 | arm  | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fa427035556fb1f5ddb8853

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-9=
1-g43a1fc0c8f46/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-9=
1-g43a1fc0c8f46/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fa427035556fb1=
f5ddb8858
        failing since 0 day (last pass: v4.9.241-91-g303dfca2bd68, first fa=
il: v4.9.241-91-g387309f11ff9)
        2 lines =

 =



platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
qemu_i386             | i386 | lab-baylibre  | gcc-8    | i386_defconfig   =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fa425b7f12737d336db889b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-9=
1-g43a1fc0c8f46/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-9=
1-g43a1fc0c8f46/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa425b7f12737d336db8=
89c
        new failure (last pass: v4.9.241-91-g387309f11ff9) =

 =



platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
qemu_i386-uefi        | i386 | lab-baylibre  | gcc-8    | i386_defconfig   =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fa425b9221e9a3a25db8853

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-9=
1-g43a1fc0c8f46/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-u=
efi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-9=
1-g43a1fc0c8f46/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-u=
efi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa425b9221e9a3a25db8=
854
        new failure (last pass: v4.9.241-91-g387309f11ff9) =

 =20
