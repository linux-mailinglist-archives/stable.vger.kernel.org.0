Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35E6C3196CB
	for <lists+stable@lfdr.de>; Fri, 12 Feb 2021 00:42:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbhBKXmG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 18:42:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbhBKXmA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Feb 2021 18:42:00 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66689C061574
        for <stable@vger.kernel.org>; Thu, 11 Feb 2021 15:41:20 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id w18so4709240pfu.9
        for <stable@vger.kernel.org>; Thu, 11 Feb 2021 15:41:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=X88KZMZuI855S/ccPu1CX46SwaS42bBy3p6IaWkPmqs=;
        b=WStU+jSZjkyG1d2Dlijz6CSC39xvt4R98svWWDrjiZblUO+4y3VfIouTihbySAEswR
         MULDvZoxBMWW81wcit/KDShcfqbzRdaL3nO+u9bfaPLzpmEGagDQ5p0p5qoWEzo/n9gd
         kXgRgj3Mj6+NU1+MABeUTgCLr0FEsl7bFck2SaesRIjQNRnXV3XTtsZhd/aBTp92nuNV
         adYIn6at4vVEegw6pzRG+i4v0H3L6CiNQr5qYKjEHKk/JnxybJymS+vdbuEdP1MJvmIS
         LRrEyrySYfbDMgt8ZzGikKwG/SToJJ54v/2TNyWGz4UyvSl6l3o/1kkv7P1njNRGif5h
         q5lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=X88KZMZuI855S/ccPu1CX46SwaS42bBy3p6IaWkPmqs=;
        b=Dt9Q1cY+U81oqSscvkPSfUnmVr6WbeFBNZBrX9OfMVdlYZAY7k1BhIWOWJv9ibnu8f
         vU5zdPk+B54wtC3X1AWy8sYAxCxKhGN4MBJq3un9EkgHeZ5y+x8gN4nmLhU20GUpiLiu
         9r8FxUksOIUX+ugf2OktHRV+DYa5X7FL+iNfnyb3wK3sTTUgeig0cBNbq9JCpsAbpOVq
         GP2ckyhq9fT/WbzweAPK3RFaZ8A+JOg9OdyqQbFA2rRDWKuOvE9ybpoLDfKVEiuvTPWe
         qKwjLCR3F7ycHJE58zroCMgKWrPgybVMzA5Xhh7vqQtMhHLtLKU5CelF2Lqkz6WvIRUz
         nCBw==
X-Gm-Message-State: AOAM530H2e0+CRuoLOTajP6scNXefZmxJ5yiEXb9xCZwYj2Y8QqmOzKp
        gsQtToGfaMMHOM/w5x3KjHri5Mo1Jb4xiQ==
X-Google-Smtp-Source: ABdhPJxv2m0YlyZLtDxbmIRrEGanSXIijGKdwn6aY3NJN0ELe9SJxH9G3HjS5uK+AZFep52aT0rlyw==
X-Received: by 2002:aa7:92d9:0:b029:1bb:b6de:c872 with SMTP id k25-20020aa792d90000b02901bbb6dec872mr411779pfa.68.1613086879142;
        Thu, 11 Feb 2021 15:41:19 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f18sm5908998pjq.53.2021.02.11.15.41.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 15:41:18 -0800 (PST)
Message-ID: <6025c09e.1c69fb81.b22fa.dbe7@mx.google.com>
Date:   Thu, 11 Feb 2021 15:41:18 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.257-18-g64a10bf91886
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 24 runs,
 2 regressions (v4.9.257-18-g64a10bf91886)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 24 runs, 2 regressions (v4.9.257-18-g64a10bf9=
1886)

Regressions Summary
-------------------

platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
meson-gxbb-p200 | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
1          =

panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.257-18-g64a10bf91886/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.257-18-g64a10bf91886
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      64a10bf91886fca160f1a3db1acff2735d5ce163 =



Test Regressions
---------------- =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
meson-gxbb-p200 | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
1          =


  Details:     https://kernelci.org/test/plan/id/60259070bea92116773abe77

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.257-1=
8-g64a10bf91886/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.257-1=
8-g64a10bf91886/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60259070bea92116773ab=
e78
        new failure (last pass: v4.9.257-18-g5fd67f7a65f98) =

 =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/60258eefb650c42bf43abe89

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.257-1=
8-g64a10bf91886/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.257-1=
8-g64a10bf91886/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60258eefb650c42=
bf43abe90
        failing since 0 day (last pass: v4.9.257-12-g43f72a47dfce5, first f=
ail: v4.9.257-18-g5fd67f7a65f98)
        2 lines

    2021-02-11 20:09:16.001000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/125
    2021-02-11 20:09:16.010000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
